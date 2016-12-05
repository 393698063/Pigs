//
//  CHCPGCountOffViewController.m
//  Pigs
//
//  Created by HEcom on 16/7/22.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size

#import "CHCPGCountOffViewController.h"
#import "DateFomatterTool.h"
#import "CHCSqliteManager.h"
#import "CHCPGUserDataSycnViewController.h"
#import "CHCInputValidUtil.h"
#import "CHCPGCountPigVO.h"
#import "SynchronzeDef.h"
#import "CHCPGGoldManager.h"
#import "AppDelegate.h"
#import "CHCPGCountHistoryDiaryViewController.h"

@interface CHCPGCountOffViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *iSowField;
@property (weak, nonatomic) IBOutlet UITextField *iPigLittleField;
@property (weak, nonatomic) IBOutlet UITextField *iPigFatField;
@property (weak, nonatomic) IBOutlet UITextField *iPigDeathField;
@property (weak, nonatomic) IBOutlet UITextField *iPigAddField;
@property (weak, nonatomic) IBOutlet UITextField *iPigFodderField;
@property (weak, nonatomic) IBOutlet UIButton *iRightButton;
@property (weak, nonatomic) IBOutlet UIButton *iSubmitButton;
@property (weak, nonatomic) IBOutlet UIScrollView *iScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iScrollBotConstraint;
@property (nonatomic, weak) UIView * iFirstResponderView;
@property (nonatomic, strong) CHCPGCountOffController * iController;
@property (nonatomic, strong) NSNumber * iDate;
@property (nonatomic, strong) NSNumber * icountMid;
@property (nonatomic, strong) NSNumber * icountId;
@end

@implementation CHCPGCountOffViewController
@dynamic iController;
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"日记";
}
- (BOOL)isNeedNoticeForKeyboard
{
  return YES;
}
- (instancetype)initWithDate:(NSNumber *)date
{
  if (self = [super init]) {
    self.iDate = date;
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  if (self.iDate)
  {
    self.iRightButton.hidden = YES;
    self.iSubmitButton.hidden = YES;
    self.iPigAddField.userInteractionEnabled = NO;
    self.iPigDeathField.userInteractionEnabled = NO;
    self.iPigFatField.userInteractionEnabled = NO;
    self.iPigFodderField.userInteractionEnabled = NO;
    self.iPigLittleField.userInteractionEnabled = NO;
    self.iSowField.userInteractionEnabled = NO;
    NSString * dateStr = [DateFomatterTool getDateStringFromTimeStamp:self.iDate.longLongValue WithDateFormat:@"YYYY-MM-dd"];
    self.iNavBar.topItem.title = dateStr;
  }
  [self createInitialView];
}
- (void)createInitialView
{
  NSArray * dataAry = nil;
  if (!self.iDate)
  {
    dataAry = [self.iController readOneDayData:[NSDate date]];
    NSArray * historyAry = [self.iController readSomeHistorySimpleDiaar];
    if (historyAry.count == 0) {
      self.iRightButton.hidden = YES;
    }
  }
  else
  {
    NSDate * date = [DateFomatterTool getDateFromTimeStampWithTimeStamp:[self.iDate longLongValue]];
    dataAry = [self.iController readOneDayData:date];
  }
  if (dataAry.count != 0) {
    NSDictionary * dataDic = [dataAry firstObject];
    self.icountMid = [dataDic objectForKey:@"mid"];
    self.icountId = [dataDic objectForKey:@"id"];
    CHCPGCountPigVO * countVo = [[CHCPGCountPigVO alloc] initWithDic:dataDic];
    self.iSowField.text = [NSString stringWithFormat:@"%@",countVo.pigSowStock];
    self.iPigLittleField.text = [NSString stringWithFormat:@"%@",countVo.pigLittleStock];
    self.iPigFatField.text = [NSString stringWithFormat:@"%@",countVo.pigFatStock];
    self.iPigDeathField.text = [NSString stringWithFormat:@"%@",countVo.pigDeath];
    self.iPigAddField.text = [NSString stringWithFormat:@"%@",countVo.pigAdd];
    self.iPigFodderField.text = [NSString stringWithFormat:@"%@",countVo.fodder];
  }
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
  BOOL rtn = YES;
  if (![string isEqualToString:@""]) {
    rtn = [CHCInputValidUtil checkInteger:string];
  }
  return rtn;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
  self.iFirstResponderView = textField;
}
- (void)textFieldDidChange:(UITextField *)textField
{
  if (textField.text.length > 6)
  {
    textField.text = [textField.text substringToIndex:6];
  }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [textField removeTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
#pragma mark - keyboardNotice
- (void)keyboard:(CGRect)aKeyboardFrame beingShow:(BOOL)isShowing
{
  if (isShowing)
  {
    self.iScrollBotConstraint.constant = aKeyboardFrame.size.height;
    CGRect responderFrame = [self.view convertRect:self.iFirstResponderView.frame fromView:self.iFirstResponderView.superview];
    if (responderFrame.origin.y > aKeyboardFrame.origin.y - 40) {
      self.iScrollView.contentOffset = CGPointMake(0, responderFrame.origin.y - aKeyboardFrame.origin.y + 40);
    }
  }
  else
  {
    self.iScrollBotConstraint.constant = 49;
  }
}

- (IBAction)submitAction:(id)sender
{
  __weak typeof(self)wSelf = self;
  BOOL sowFlag = self.iSowField.text.length;
  BOOL littleFlag = self.iPigLittleField.text.length;
  BOOL fatFlag = self.iPigFatField.text.length;
  BOOL deathFlag = self.iPigDeathField.text.length;
  BOOL addFlag = self.iPigAddField.text.length;
  BOOL fodderFlag = self.iPigFodderField.text.length;
  if (!(sowFlag || littleFlag || fatFlag || deathFlag || addFlag || fodderFlag))
  {
    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:@"请至少记录一项"
                                                withIconImageName:nil];
    return;
  }
  CHCPGCountPigVO * countVo = [[CHCPGCountPigVO alloc] init];
  countVo.pigSowStock = @([self.iSowField.text integerValue]);
  countVo.pigLittleStock = @([self.iPigLittleField.text integerValue]);
  countVo.pigFatStock = @([self.iPigFatField.text integerValue]);
  countVo.pigAdd = @([self.iPigAddField.text integerValue]);
  countVo.pigDeath = @([self.iPigDeathField.text integerValue]);
  countVo.fodder = @([self.iPigFodderField.text integerValue]);
  
  NSDictionary * countDic = [countVo fillVoDictionary];
  NSMutableDictionary * mCountDic = [NSMutableDictionary dictionaryWithDictionary:countDic];
  if (self.icountMid) {
    [mCountDic setObject:self.icountMid forKey:@"mid"];
    [mCountDic setObject:self.icountId forKey:@"id"];
  }
  [self.iController saveCountPigData:mCountDic tableName:HCPG_SimpDiaryTable];
  
  [[CHCPGGoldManager sharedCHCPGGoldManager] showGoldGifWithType:EHCGoldCount
                                                     compeletion:^(BOOL compeleted, NSString *aDesc)
   {
     [wSelf.navigationController popViewControllerAnimated:YES];
   }];
  CHCPGUserDataSycnViewController *simpleDiaryUpLoad= ((AppDelegate *)([UIApplication sharedApplication].delegate)).iUserDataSyncController;
  [simpleDiaryUpLoad uploadSimplDiaryCompletion:^(BOOL isSucceed, NSString *aDes)
   {
    if (isSucceed) {
      
    }else{
      //
    }
  }];

  
}

- (IBAction)historyDiaryAction:(id)sender
{
  CHCPGCountHistoryDiaryViewController * hvc = [[CHCPGCountHistoryDiaryViewController alloc] init];
  [self.navigationController pushViewController:hvc animated:YES];
}

- (IBAction)leftAction:(id)sender
{
  [self.view endEditing:YES];
  if (self.iDate)
  {
    [self.navigationController popViewControllerAnimated:YES];
    return;
  }
  CGFloat version = [[[UIDevice currentDevice] systemVersion] floatValue];
  if (version < 8.0)
  {
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                     message:@"您确定放弃录入的数据？"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles:@"确定", nil];
    [alert show];
  }
  else
  {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示"
                                                                              message:@"您确定放弃录入的数据？"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction * _Nonnull action)
                                  {
                                    [self.navigationController popViewControllerAnimated:YES];
                                  }];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action)
                                    {
                                      
                                    }];
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
  }
  
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  [self.view endEditing:YES];
  if (buttonIndex == alertView.cancelButtonIndex) {
    return;
  }
  [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@interface CHCPGCountOffController ()
@property (nonatomic, strong) CHCSqliteManager * iSqliteManager;
@end

@implementation CHCPGCountOffController

- (instancetype)init
{
  if (self = [super init]) {
    NSString * path = [NSString stringWithFormat:@"%@/%@",
                       [CHCPGUserDataSycnController createUserPath],
                       @"database.db"];
    HCLog(@"%@",path);
    self.iSqliteManager = [CHCSqliteManager creatSqliteManager:path];
  }
  return self;
}
- (NSArray *)readOneDayData:(NSDate *)date
{
  NSString * dateStr = [DateFomatterTool getDateStringFromDate:date
                                                 dateFormatter:@"YYYY-MM-dd"];
  NSString * startDateStr = [NSString stringWithFormat:@"%@ %@",dateStr,@"00:00:00"];
  NSString * endDateStr = [NSString stringWithFormat:@"%@ %@",dateStr,@"23:59:59"];
  
  NSNumber * startDateFort = [DateFomatterTool getTimeStampWithDateStr:startDateStr
                                                            dateFormat:@"YYYY-MM-dd HH:mm:ss"];

  NSNumber * endDateFort = [DateFomatterTool getTimeStampWithDateStr:endDateStr
                                                          dateFormat:@"YYYY-MM-dd HH:mm:ss"];
  NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE createAt >= %@ and createAt <= %@",
                    HCPG_SimpDiaryTable,
                    startDateFort,
                    endDateFort];
  NSArray * datas = [self.iSqliteManager executeQueryRtnAry:sql];
  return  datas;
}
- (NSArray *)readSomeHistorySimpleDiaar
{
  NSString * dateStr = [DateFomatterTool getDateStringFromDate:[NSDate date]
                                                 dateFormatter:@"YYYY-MM-dd"];
  NSString * startDateStr = [NSString stringWithFormat:@"%@ %@",dateStr,@"00:00:00"];
  NSNumber * startDateFort = [DateFomatterTool getTimeStampWithDateStr:startDateStr
                                                            dateFormat:@"YYYY-MM-dd HH:mm:ss"];
  NSString * sql = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE  createAt <= %@ LIMIT 0,1",
                    HCPG_SimpDiaryTable,
                    startDateFort];
  NSArray * datas = [self.iSqliteManager executeQueryRtnAry:sql];
  return  datas;
}
- (void)saveCountPigData:(NSDictionary *)data tableName:(NSString *)tableName
{
  //若数据库中存在纪录，不能更新id,
  NSMutableDictionary * dataDic = [NSMutableDictionary dictionaryWithDictionary:data];
  if (![dataDic objectForKey:@"mid"])
  {
    [dataDic setObject:@(-1) forKey:@"id"];
  }
  else
  {
    [dataDic setObject:@"0" forKey:@"upFlag"];
  }
  [dataDic setObject:[CHCCommonInfoVO sharedManager].iHCid forKey:@"uid"];
  [dataDic setObject:@([DateFomatterTool getCurrentTimeStamp]) forKey:@"createAt"];
  
  NSMutableString * updataSql = [NSMutableString string];
  
  [updataSql appendFormat:@"INSERT OR REPLACE INTO "];
  [updataSql appendFormat:@"'%@'",tableName?:@""];
  [updataSql appendFormat:@" ("];
  
  NSMutableString *keys = [NSMutableString stringWithString:@""];
  NSMutableString *values = [NSMutableString stringWithString:@""];
  [dataDic enumerateKeysAndObjectsUsingBlock:
   ^(id key, id obj, BOOL *stop)
   {
     [keys appendFormat:@"\"%@\" ,",key];
     [values appendFormat:@"\"%@\" ,",obj];
   }];
  [keys deleteCharactersInRange:NSMakeRange(keys.length-1, 1)];
  [values deleteCharactersInRange:NSMakeRange(values.length-1, 1)];
  
  [updataSql appendFormat:@"%@",keys];
  [updataSql appendFormat:@") VALUES ("];
  [updataSql appendFormat:@"%@",values];
  
  [updataSql appendFormat:@")"];
  [self.iSqliteManager openDB];
  [self.iSqliteManager beginTransaction];
  [self.iSqliteManager executeNotQuery:updataSql];
  
  [self.iSqliteManager commitTransaction];
  [self.iSqliteManager closeDB];
  
}

@end
