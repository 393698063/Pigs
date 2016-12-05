//
//  CHCPGMineSelfInfoViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/26.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMineSelfInfoViewController.h"
#import "CHCAttachmentAdd.h"
#import "CHCCommonInfoVO.h"
#import "UIImageView+WebCache.h"
#import "CHCFileUtil.h"
#import "BnsMineDef.h"
#import "UIView+frame.h"
#import "CHCPGMineSelfChangeViewController.h"

@interface CHCPGMineSelfInfoViewController ()<MHCPhotoSelectDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *iScrollView;
@property (weak, nonatomic) IBOutlet UILabel *iNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iNickNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *iPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *iAddressLabel;
@property (nonatomic, strong) CHCAttachmentAdd *iAttachAdd;
@property (nonatomic, copy) void(^iChangeBlock)(BOOL isChanged);
@property (nonatomic, strong) CHCPGMineSelfInfoController * iController;
@end

@implementation CHCPGMineSelfInfoViewController
@dynamic iController;
- (instancetype)initWithChangeBlock:(void(^)(BOOL isChanged))aChangeBlock
{
  if (self = [super init]) {
    self.iChangeBlock = aChangeBlock;
    self.iTitleStr = @"个人信息";
    CHCAttachInitVO *aInitVO = [[CHCAttachInitVO alloc]init];
    [aInitVO setIIsHavePhoto:YES];
    self.iAttachAdd = [[CHCAttachmentAdd alloc]initWithSuperViewController:self
                                                                withInitVO:aInitVO
                                                              withFilePath:nil];
    self.iAttachAdd.iDelegate = self;
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.automaticallyAdjustsScrollViewInsets = NO;
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  self.iNameLabel.text = userInfo.name;
  
  NSString * nickName = @"匿名网友";
  if(![userInfo.nickName isEqualToString:@""])
  {
    nickName = userInfo.nickName;
  }
  else if (![userInfo.province isEqualToString:@""])
  {
    nickName = [NSString stringWithFormat:@"%@%@%@",userInfo.province,userInfo.city,@"网友"];
  }
  self.iNickNameLabel.text = nickName;
  self.iPhoneLabel.text = userInfo.mobile;
  self.iAddressLabel.text = [userInfo.lottery_address stringByReplacingOccurrencesOfString:@"\n" withString:@""] ;
  self.iIconImageView.layer.cornerRadius = self.iIconImageView.width * 0.5;
  self.iIconImageView.clipsToBounds = YES;
  [self updateIconImage];
 
}
- (void)updateIconImage
{
  NSString *aLocalPath = [NSString stringWithFormat:@"%@/PG_UserPhoto",[CHCFileUtil getCachesPath]];
  NSFileManager * fileManager = [NSFileManager defaultManager];
  NSArray * filesNames = [fileManager contentsOfDirectoryAtPath:aLocalPath error:nil];
  __block NSString *fileName = nil;
  [filesNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([obj rangeOfString:[CHCCommonInfoVO sharedManager].mobile].location != NSNotFound) {
      fileName = obj;
      * stop = YES;
    }
  }];
  if (fileName) {
    self.iIconImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",aLocalPath,fileName]];
  }
  else
  {
    CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
    NSString * iconStr = [NSString stringWithFormat:@"%@%@:%@/%@/%@",HC_UrlConnection_FileProtocolType,
                          HC_UrlConnection_FileURL,
                          HC_UrlConnection_FilePort,
                          @"image",
                          userInfo.headLink];
    [self.iIconImageView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"wode_img"]];
  }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)iChangeIcon:(id)sender {
  [self.iAttachAdd triggerAttachAddEvent:sender];
}
- (IBAction)iChangeName:(id)sender
{
  __weak typeof(self)wSelf = self;
  CHCPGMineSelfChangeViewController * avc =
  [[CHCPGMineSelfChangeViewController alloc] initWtihChangeType:kChangeTypeName
                                                           name:self.iNameLabel.text
                                                     completion:^(BOOL isCompleted)
                                             {
                                               wSelf.iNameLabel.text = [CHCCommonInfoVO sharedManager].name;
                                               wSelf.iChangeBlock(YES);
                                             }];
  [self.navigationController pushViewController:avc animated:YES];
}
- (IBAction)iChangeNickName:(id)sender
{
  __weak typeof(self)wSelf = self;
  CHCPGMineSelfChangeViewController * avc =
  [[CHCPGMineSelfChangeViewController alloc] initWtihChangeType:kChangeTypeNick
                                                           name:self.iNickNameLabel.text
                                                     completion:^(BOOL isCompleted)
   {
     wSelf.iNickNameLabel.text = [CHCCommonInfoVO sharedManager].nickName;
     wSelf.iChangeBlock(YES);
   }];
  [self.navigationController pushViewController:avc animated:YES];

}
- (IBAction)leftButtonAction:(id)sender {
  [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Selected Image Delegate
- (void)imagePickerDidDismiss
{
  [[CHCSpinnerView sharedSpinnerView]showInWindowsIsFullScreen:YES withShowingText:@"图片处理中..."];
}

- (void)willClipImage
{
  [[CHCSpinnerView sharedSpinnerView]hiddenSpinnerView];
}

- (void)didSelectImage:(CHCAttachmentVO *)aVO
{
  if ([aVO.iFileName isEqualToString:@""])
  {
    aVO.iFileName = [NSString stringWithFormat:@"%ld",(long)[NSDate date].timeIntervalSince1970];
  }
  __weak typeof(self)wSelf = self;
  NSString *fileName = [NSString stringWithFormat:@"%@.%@",aVO.iFileName,aVO.iFileType];
  NSString *localFileName = [NSString stringWithFormat:@"%@.%@", [CHCCommonInfoVO sharedManager].mobile, aVO.iFileType];
  NSString *aLocalPath = [NSString stringWithFormat:@"%@/PG_UserPhoto/%@",[CHCFileUtil getTmpPath],localFileName];
  [CHCFileUtil createFileWithPath:aLocalPath content:aVO.iFile];
  CHCHttpFilePartVO *aFileVO = [[CHCHttpFilePartVO alloc]initWithFileName:fileName filePath:aLocalPath];
  
  [self.iController upload:aFileVO completion:^(NSError *error, NSString *aPath)
   {
     if (error)
     {
       [CHCFileUtil deleteFileWithName:aLocalPath error:nil];
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES withShowingText:[error domain] withIconImageName:nil];
     }
     else
     {
       [self.iController updateUserPhoto:aPath completion:^(BOOL isSuccess, NSError *error) {
         if (isSuccess)
         {
           [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES withShowingText:@"上传成功" withIconImageName:nil];
           // 更新头像成功，更新当前保存在本地的信息
           [CHCCommonInfoVO sharedManager].headLink = aPath;
           NSDictionary *aDataDic = [[CHCCommonInfoVO sharedManager] fillVoDictionary];
           [[NSUserDefaults standardUserDefaults] setObject:aDataDic forKey:HC_CommonInfo_UserData];
           [[NSUserDefaults standardUserDefaults] synchronize];
           // 头像保存到cache路径下
           NSString *aCachePath = [NSString stringWithFormat:@"%@/PG_UserPhoto/%@",[CHCFileUtil getCachesPath],localFileName];
           [CHCFileUtil createFileWithPath:aCachePath content:aVO.iFile];
           [wSelf updateIconImage];
           wSelf.iChangeBlock(YES);
         }
       }];
     }
   }];
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

@implementation CHCPGMineSelfInfoController

-(void)upload:(CHCHttpFilePartVO *)aVO
   completion:(void (^)(NSError *, NSString *))aBlock
{
  CHCHttpMultiConstructor *aCons = [[CHCHttpMultiConstructor alloc]init];
  [aCons addParts:aVO];
  CHCHttpStringPartVO *aStringVo = [[CHCHttpStringPartVO alloc]initWithValue:HC_UrlConnection_FileProject];
  [aCons addParts:aStringVo];
  
  NSString *userId = [[CHCCommonInfoVO sharedManager].iHCid stringValue];
  CHCHttpStringPartVO *aUIDVo = [[CHCHttpStringPartVO alloc]initWithKey:@"uid" withValue:userId ];
  [aCons addParts:aUIDVo];
  
  NSString *method = [NSString stringWithFormat:@"%@", HCPG_UpLoadUserPhoto];
  [self.iModelHandler postMethod:method
                      parameters:aCons
                      completion:
   ^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     //     NSString *aa = [[NSString alloc]initWithData: [((NSError *)[error.userInfo objectForKey:@"NSUnderlyingError"]).userInfo objectForKey:@"com.alamofire.serialization.response.error.data"]  encoding:NSUTF8StringEncoding];
     NSString *path = @"";
     NSError *aError = error;
     if(aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     
     if (!aError)
     {
       path = [aData objectForKey:@"path"];
       if (!path)
       {
         path = @"";
       }
     }
     
     if (aBlock)
     {
       aBlock(aError,path);
     }
   }];
}

-(void)updateUserPhoto:(NSString *)aPath
            completion:(void (^)(BOOL, NSError *))aBlock
{
  NSDictionary *dataDic = @{@"headLink":aPath?:[NSNull null],
                            @"uid":[CHCCommonInfoVO sharedManager].iHCid};
  
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
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:[nError domain] withIconImageName:nil];
     }
     else
     {
       aBlock(YES, nil);
     }
   }];
}


@end
