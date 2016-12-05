//
//  CHCPGAboutPigViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/28.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGAboutPigViewController.h"
#import "UIView+frame.h"
#import "NSString+frame.h"

@interface CHCPGAboutPigViewController ()
@property (weak, nonatomic) IBOutlet UILabel *iAppNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *iVersionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iDescibLabelHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *iDescripLabel;
@end

@implementation CHCPGAboutPigViewController
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"关于猪福达";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  NSDictionary * infoDict = [[NSBundle mainBundle] infoDictionary];
  NSString * appName = [infoDict objectForKey:@"CFBundleDisplayName"];
  NSString * version = [infoDict objectForKey:@"CFBundleShortVersionString"];
  NSString * aDescPath = [[NSBundle mainBundle] pathForResource:@"AboutPig" ofType:@"txt"];
  NSString * aDesc = [NSString stringWithContentsOfFile:aDescPath encoding:NSUTF8StringEncoding error:nil];
  self.iAppNameLabel.text = appName;
  self.iVersionLabel.text = [NSString stringWithFormat:@"%@%@",@"Version",version];
  CGFloat aDescHeight = ceil([aDesc heightWithFont:self.iDescripLabel.font withinWidth:[UIScreen mainScreen].bounds.size.width - 28]);
  self.iDescibLabelHeightConstraint.constant = aDescHeight;
  self.iDescripLabel.text = aDesc;
  [self.view updateConstraintsIfNeeded];
}
- (IBAction)leftButtonAction:(id)sender {
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
