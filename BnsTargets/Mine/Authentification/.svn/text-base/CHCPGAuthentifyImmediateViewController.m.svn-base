//
//  CHCPGAuthentifyImmediateViewController.m
//  Pigs
//
//  Created by HEcom on 16/4/28.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGAuthentifyImmediateViewController.h"
#import "CHCPGFarmInfoViewController.h"
#import "CHCPGMineHomeViewController.h"

@interface CHCPGAuthentifyImmediateViewController ()
@property (nonatomic, strong) CHCPGAuthentifyVO * iAuthentifyVo;
@end

@implementation CHCPGAuthentifyImmediateViewController
- (void)creatObjsWhenInit
{
  [super creatObjsWhenInit];
  self.iTitleStr = @"认证";
}
- (instancetype)initWithAuthentify:(CHCPGAuthentifyVO *)iAuthentifyVo
{
  if (self = [super init])
  {
    self.iAuthentifyVo = iAuthentifyVo;
  }
  return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)immediateAuthentify:(id)sender
{
  CHCPGFarmInfoViewController * fvc = [[CHCPGFarmInfoViewController alloc] initWithAuthentify:self.iAuthentifyVo];
  [self.navigationController pushViewController:fvc animated:YES];
}

- (IBAction)leftButtonAction:(id)sender
{
  [[NSNotificationCenter defaultCenter] postNotificationName:HCPG_ExpertNeedFreshAuthentityInfo
                                                      object:nil];
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
