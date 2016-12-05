//
//  CHCPGGuideViewController.m
//  Pigs
//
//  Created by HEcom on 16/6/2.
//  Copyright © 2016年 HEcom. All rights reserved.
//
#define kScreenSize [UIScreen mainScreen].bounds.size

#import "CHCPGGuideViewController.h"

@interface CHCPGGuideViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *iScrollView;
@property (weak, nonatomic) IBOutlet UIButton *iStartButton;
@property (weak, nonatomic) IBOutlet UIPageControl *iPageController;
@property (nonatomic, strong) NSMutableArray * iImageAry;
@property (nonatomic, copy) void(^iCompletion)(BOOL isEnd);

@end

@implementation CHCPGGuideViewController

+ (BOOL)isNeedShow
{
  BOOL rtn = YES;
  NSString * rtnStr = [[NSUserDefaults standardUserDefaults] objectForKey:HCPG_GuideViewKey];
  if (rtnStr && [rtnStr isEqualToString:@"N"]) {
    rtn = NO;
  }
  return rtn;
}
- (instancetype)initWithImageAry:(NSArray *)images completion:(void (^)(BOOL isEnd))aCompletion
{
  if (self = [super init])
  {
    self.iImageAry = [NSMutableArray arrayWithCapacity:1];
    [self.iImageAry addObjectsFromArray:images];
    self.iCompletion = aCompletion;
  }
  return self;
}
- (BOOL)prefersStatusBarHidden
{
  return YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  [self.iImageAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
  {
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(idx * kScreenSize.width, 0, kScreenSize.width, kScreenSize.height)];
    imageView.image = [UIImage imageNamed:obj];
    [self.iScrollView addSubview:imageView];
  }];
  self.iScrollView.contentSize = CGSizeMake(self.iImageAry.count * kScreenSize.width, kScreenSize.height);
  self.iPageController.numberOfPages = self.iImageAry.count;

}

#pragma mark
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  CGPoint point = scrollView.contentOffset;
  NSInteger page = (NSInteger)point.x/scrollView.frame.size.width;
  [self.iPageController setCurrentPage:page];
  if (page+1 == [self.iImageAry count])
  {
    [self.iPageController setHidden:YES];
//    [UIView animateWithDuration:1 animations:^
//     {
    
       [self.iStartButton setAlpha:1.0];
//     }
//                     completion:
//     ^(BOOL finished)
//     {
       [self.iStartButton setHidden:NO];
//     }];
  }
  else
  {
    [self.iPageController setHidden:NO];
    [self.iStartButton setHidden:YES];
  }
}

- (IBAction)startAction:(id)sender
{
  [[NSUserDefaults standardUserDefaults] setObject:@"N" forKey:HCPG_GuideViewKey];
  [[NSUserDefaults standardUserDefaults] synchronize];
  if (self.iCompletion)
  {
    self.iCompletion(YES);
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
