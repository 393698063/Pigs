//
//  MineTestViewController.m
//  Pigs
//
//  Created by HEcom on 16/5/9.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "MineTestViewController.h"

@interface MineTestViewController ()

@end

@implementation MineTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  //  UIActivityViewController * activetyController = [[UIActivityViewController alloc] init];
  //  UIDocumentInteractionController * dvc = [[UIDocumentInteractionController alloc] init];
  //  dvc.UTI = @"com.microsoft.word.doc";
  //  [dvc presentOptionsMenuFromRect:CGRectMake(0, 300, 375, 200) inView:self.view animated:YES];
  NSString *textToShare = @"要分享的文本内容";
  NSURL *urlToShare = [NSURL URLWithString:@"http://blog.csdn.net/hitwhylz"];
  NSArray *activityItems = @[textToShare, urlToShare];
  //  NSArray * activities = @[UIActivityTypePostToFacebook,UIActivityTypePostToTwitter,UIActivityTypePostToWeibo,
  //                           UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypePrint,
  //                           UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,
  //                           UIActivityTypeAddToReadingList,UIActivityTypePostToFlickr,UIActivityTypePostToVimeo,
  //                           UIActivityTypePostToTencentWeibo,UIActivityTypeAirDrop];
  UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                                                          applicationActivities:nil];
  activityVC.excludedActivityTypes = @[];
  [self presentViewController:activityVC animated:YES completion:nil];
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
