//
//  CHCPGMineGetCoinViewController.m
//  Pigs
//
//  Created by HEcom on 16/5/9.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size
#import "CHCPGMineGetCoinViewController.h"
#import "NSString+frame.h"

@interface CHCPGMineGetCoinViewController ()
@property (weak, nonatomic) IBOutlet UILabel *iContentLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iContentLabelHeight;

@end

@implementation CHCPGMineGetCoinViewController
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"如何获得金币";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.iContentLabel.numberOfLines = 0;
  NSString * cPath = [[NSBundle mainBundle] pathForResource:@"CHCPGMineGetCoin" ofType:@"txt"];
  NSString * content = [NSString stringWithContentsOfFile:cPath encoding:NSUTF8StringEncoding error:nil];
  CGFloat height = ceilf([content heightWithFont:self.iContentLabel.font withinWidth:kScreenSize.width - 20]);
  self.iContentLabel.text = content;
  self.iContentLabelHeight.constant = height;
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
