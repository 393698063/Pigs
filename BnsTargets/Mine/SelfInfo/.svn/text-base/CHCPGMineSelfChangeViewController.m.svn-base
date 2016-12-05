//
//  CHCPGMineSelfChangeViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/27.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMineSelfChangeViewController.h"
#import "BnsMineDef.h"
#import "UIView+frame.h"

@interface CHCPGMineSelfChangeViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *iTextField;
@property (nonatomic,assign) EHCChangeType iType;
@property (nonatomic, copy) NSString * iName;
@property (nonatomic, copy) void(^iCompletion)(BOOL isCompleted);
@property (nonatomic, strong) CHCPGMineSelfChangeController * iController;

@end

@implementation CHCPGMineSelfChangeViewController
@dynamic iController;

- (instancetype)initWtihChangeType:(EHCChangeType)type
                              name:(NSString *)name
                        completion:(void(^)(BOOL isCompleted))aCompletion;
{
  if (self = [super init]) {
    self.iType = type;
    self.iName = name;
    self.iCompletion = aCompletion;
    switch (type) {
      case kChangeTypeName:
        self.iTitleStr = @"修改姓名";
        break;
        
      case kChangeTypeNick:
        self.iTitleStr = @"修改昵称";
        break;
    }
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  UIView * leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, _iTextField.height)];
  leftView.backgroundColor = [UIColor whiteColor];
  self.iTextField.text = self.iName;
  self.iTextField.leftView = leftView;
  [self.iTextField becomeFirstResponder];
  
}
#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
  [textField addTarget:self
                action:@selector(textFieldDidChage:)
      forControlEvents:UIControlEventEditingChanged];
}
- (void)textFieldDidChage:(UITextField *)textField
{
  NSInteger length = 9;
  if (_iType == kChangeTypeNick) {
    length = 15;
  }
  NSString * toatStr = [NSString stringWithFormat:@"已超过%ld个字了",(long)length];
  NSString * lang = [textField.textInputMode primaryLanguage];//键盘输入模式
  if ([lang isEqualToString:@"zh-Hans"]) {
    UITextRange * selectRange = [textField markedTextRange];
    
    UITextPosition * position = [textField positionFromPosition:selectRange.start offset:0];
    
    if (!position) {
      if (textField.text.length > length)
      {
        textField.text = [textField.text substringToIndex:length];
        [textField resignFirstResponder];
        [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                      withShowingText:toatStr
                                                    withIconImageName:@""];
      }
    }
  }
  else
  {
    if (textField.text.length > length) {
      textField.text = [textField.text substringToIndex:length];
      [textField resignFirstResponder];
      [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                    withShowingText:toatStr
                                                  withIconImageName:@""];
    }
  }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
  [textField removeTarget:self
                   action:@selector(textFieldDidChage:)
         forControlEvents:UIControlEventEditingChanged];
}
- (IBAction)leftButtonAction:(id)sender
{
  [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)SaveButtonAction:(id)sender
{
  NSString * inStr = [self.iTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if (!inStr.length) {
    NSString * toatStr = @"请填写姓名";
    if (self.iType == kChangeTypeNick) {
      toatStr = @"请填写昵称";
    }
    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:toatStr
                                                withIconImageName:nil];
    return;
  }
  __weak typeof(self)wSelf = self;
  CHCCommonInfoVO * userinfo = [CHCCommonInfoVO sharedManager];
  NSString * name = nil;
  NSString * nickName = nil;
  switch (self.iType) {
    case kChangeTypeName:
    {
      name = inStr;
      break;
    }
    case kChangeTypeNick:
    {
      nickName = inStr;
      break;
    }
  }
  [self.iController changeUserInfoWithUid:userinfo.iHCid
                                     name:name
                                 niceName:nickName
                               completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (isSucceed) {
       if (self.iCompletion)
       {
         self.iCompletion(YES);
       }
       [wSelf.navigationController popViewControllerAnimated:YES];
     }
     else
     {
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:aDes
                                                   withIconImageName:nil];
     }
   }];
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

@implementation CHCPGMineSelfChangeController

- (void)changeUserInfoWithUid:(NSNumber *)uid
                         name:(NSString *)name
                     niceName:(NSString *)nickName
                   completion:(void(^)(BOOL isSucceed,NSString * aDes))aCompletion
{
  NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithObject:uid forKey:@"uid"];
  if (name) {
    [dataDic setObject:name forKey:@"name"];
  }
  if (nickName) {
    [dataDic setObject:nickName forKey:@"nickName"];
  }
  NSString *method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_SaveUserInfo];
  //  __weak typeof(self) weakSelf = self;
  [self.iModelHandler postMethod:method
                      parameters:dataDic
                      completion:
   ^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError * nError = error;
     if (aFlag != 0 && !nError)
     {
       nError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     if (nError)
     {
       if (aCompletion) {
         aCompletion(NO,aDesc);
       }
     }
     else
     {
       CHCCommonInfoVO * userinfo = [CHCCommonInfoVO sharedManager];
       if (name) {
         userinfo.name = name;
       }
       if (nickName) {
         userinfo.nickName = nickName;
       }
       NSDictionary * userDic = [userinfo fillVoDictionary];
       [[NSUserDefaults standardUserDefaults] setObject:userDic forKey:HC_CommonInfo_UserData];
       [[NSUserDefaults standardUserDefaults] synchronize];
       aCompletion(YES, nil);
     }
   }];
}

@end
