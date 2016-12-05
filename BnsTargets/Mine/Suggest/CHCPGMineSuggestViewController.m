//
//  CHCPGMineSuggestViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/28.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGMineSuggestViewController.h"
#import "BnsMineDef.h"
#import "NSString+frame.h"
#import "CHCStringUtil.h"

@interface CHCPGMineSuggestViewController ()<UITextViewDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *iSubmitButton;
@property (weak, nonatomic) IBOutlet UITextView *iContentTextView;
@property (nonatomic, strong) CHCPGMineSuggestController * iController;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iPlaceHolderLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *iPlaceHolderLabel;
@end

@implementation CHCPGMineSuggestViewController
@dynamic iController;

- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"意见/建议";
}
- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  self.iSubmitButton.enabled = NO;
  self.view.backgroundColor = [UIColor whiteColor];
  [self.iContentTextView becomeFirstResponder];
  self.iPlaceHolderLabelHeightConstraint.constant =
  ceil([self.iPlaceHolderLabel.text heightWithFont:self.iPlaceHolderLabel.font
                                  withinWidth:[UIScreen mainScreen].bounds.size.width - 20]);
  [self.view updateConstraintsIfNeeded];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
  NSInteger length = 200;
  NSString * toatStr = [NSString stringWithFormat:@"已超过%ld个字了",(long)length];
  NSString * lang = [textView.textInputMode primaryLanguage];//键盘输入模式
  if ([lang isEqualToString:@"zh-Hans"]) {
    UITextRange * selectRange = [textView markedTextRange];
    self.iPlaceHolderLabel.hidden = YES;
    UITextPosition * position = [textView positionFromPosition:selectRange.start offset:0];
    
    if (!position) {
      if (textView.text.length > length)
      {
        textView.text = [textView.text substringToIndex:length];
        [textView resignFirstResponder];
        [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                      withShowingText:toatStr
                                                    withIconImageName:@""];
      }
      if (textView.text.length == 0) {
        self.iSubmitButton.enabled = NO;
        self.iPlaceHolderLabel.hidden = NO;
      }
      else
      {
        self.iSubmitButton.enabled = YES;
        self.iPlaceHolderLabel.hidden = YES;
      }
    }
  }
  else
  {
    if (textView.text.length > length) {
      textView.text = [textView.text substringToIndex:length];
      [textView resignFirstResponder];
      [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                    withShowingText:toatStr
                                                  withIconImageName:@""];
    }
    if (textView.text.length == 0) {
      self.iSubmitButton.enabled = NO;
      self.iPlaceHolderLabel.hidden = NO;
    }
    else
    {
      self.iSubmitButton.enabled = YES;
      self.iPlaceHolderLabel.hidden = YES;
    }
  }
}
- (IBAction)iSubmitAction:(id)sender
{
  [self.view endEditing:YES];
  CHCCommonInfoVO * userInfo = [CHCCommonInfoVO sharedManager];
  NSString * suggest = [self.iContentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if ([suggest isEqualToString:@""]) {
    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                  withShowingText:@"请输入您的意见/建议" withIconImageName:nil];
    return;
  }
//  if ([CHCStringUtil stringContainsEmoji:suggest])
//  {
//    [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
//                                                  withShowingText:@"意见/建议不能包含表情" withIconImageName:nil];
//    return;
//  }
  [self.iController submitSuggestWithUid:userInfo.iHCid
                                 suggest:suggest completion:^(BOOL isSucceed, NSString *aDes)
   {
     if (isSucceed) {
       [self.navigationController popViewControllerAnimated:YES];
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:@"提交成功，感谢您的反馈"
                                                   withIconImageName:nil];
     }
     else
     {
       [[CHCMessageView sharedMessageView] showInWindowsIsFullScreen:YES
                                                     withShowingText:aDes
                                                   withIconImageName:nil];
     }
   }];
}

- (IBAction)leftButtonAction:(id)sender
{
  [self.view endEditing:YES];
  NSString * content = [self.iContentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  if ([content isEqualToString:@""]) {
    [self.navigationController popViewControllerAnimated:YES];
  }
  else
  {
  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                   message:@"您是否要提交您的意见/建议?"
                                                  delegate:self
                                         cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
  }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == alertView.cancelButtonIndex) {
    return;
  }
  else
  {
    [self iSubmitAction:nil];
  }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  if (buttonIndex == alertView.cancelButtonIndex) {
    [self.view endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
  }
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

@implementation CHCPGMineSuggestController

- (void)submitSuggestWithUid:(NSNumber *)uid
                     suggest:(NSString *)suggest
                  completion:(void (^)(BOOL, NSString *))aCompletion
{
  NSString * method = [NSString stringWithFormat:@"%@%@",HC_UrlConnection_Service,HCPG_MineSuggest];
  NSDictionary * param = @{@"uid":uid,@"advise":suggest};
  [self.iModelHandler postMethod:method parameters:param
                      completion:^(NSInteger aFlag, NSString *aDesc, NSError *error, NSDictionary *aData)
   {
     NSError * aError = error;
     if (aFlag != 0 && !aError)
     {
       aError = [NSError errorWithDomain:aDesc code:0 userInfo:nil];
     }
     if (aError)
     {
       if (aCompletion)
       {
         aCompletion(NO,[aError domain]);
       }
     }
     else
     {
       
       if (aCompletion) {
         aCompletion(YES,nil);
       }
     }
   }];
}

@end
