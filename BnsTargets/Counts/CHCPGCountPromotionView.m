//
//  CHCPGCountPromotionView.m
//  Pigs
//
//  Created by HEcom on 16/7/25.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGCountPromotionView.h"
#import "CHCPGCountPromotionVO.h"
#import "UIImageView+WebCache.h"
#import "UIView+frame.h"
#import "UIColor+Hex.h"

@interface CHCPGCountPromotionView ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl * iPageControl;
@property (nonatomic, weak) UIScrollView * iScrollView;
@end

@implementation CHCPGCountPromotionView
- (instancetype)initWithFrame:(CGRect)frame
{
  if (self = [super initWithFrame:frame])
  {
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}
+ (CHCPGCountPromotionView *)countPromotionViewWithFrame:(CGRect)frame
                                           promotionData:(NSArray *)datas
{
  CHCPGCountPromotionView * promotionView = [[CHCPGCountPromotionView alloc] initWithFrame:frame];
  promotionView.iDataAry = datas;
  return promotionView;
}
- (void)setIDataAry:(NSArray *)iDataAry
{
  _iDataAry = iDataAry;
  __weak typeof(self)wSelf = self;
  UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
  self.iScrollView = scrollView;
  scrollView.delegate = self;
  [self addSubview:scrollView];
  CGFloat width = self.bounds.size.width;
  CGFloat height = self.bounds.size.height;
  [iDataAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
  {
    UIView * view = [wSelf getContentViewWithVO:obj];
    view.frame = CGRectMake(width * idx, 0, width, height);
    view.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(tap:)];
    [view addGestureRecognizer:tap];
    [scrollView addSubview:view];
  }];
  scrollView.contentSize = CGSizeMake(width * self.iDataAry.count, height);
  scrollView.pagingEnabled = YES;
  scrollView.bounces = NO;
  scrollView.showsHorizontalScrollIndicator = NO;
  
  UIPageControl * pageControl = [[UIPageControl alloc] init];
  pageControl.left = 0;
  pageControl.width = 100;
  pageControl.height = 30;
  pageControl.top = self.height - 25;
   pageControl.centerX = self.centerX;
  pageControl.numberOfPages = self.iDataAry.count;
  pageControl.currentPageIndicatorTintColor = [UIColor redColor];
  pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
  pageControl.userInteractionEnabled = NO;
  self.iPageControl = pageControl;
  if (iDataAry.count != 1)
  {
    [self addSubview:pageControl];
  }
}
- (UIView *)getContentViewWithVO:(CHCPGCountPromotionVO*)aVo
{
  UIView * view = nil;
  switch (aVo.artType.integerValue) {
    case 1:
    {
      view = [self hotTextViewWithVO:aVo];
      break;
    }
    case 2:
    {
      view = [self promotionImageViewWithVO:aVo];
      break;
    }
    default:
      break;
  }

  return view;
}
- (UIView *)hotTextViewWithVO:(CHCPGCountPromotionVO *)aVo;
{
  UIView * view = [[UIView alloc] initWithFrame:self.bounds];
  UIImageView * imageView = [[UIImageView alloc] init];
  imageView.left = 10;
  imageView.top = 15;
  imageView.width = 80;
  imageView.height = 58;
  [view addSubview:imageView];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.clipsToBounds = YES;
  [imageView sd_setImageWithURL:[NSURL URLWithString:aVo.img]
               placeholderImage:[UIImage imageNamed:@"zhuge_default"]];
  UILabel * titleLabel = [[UILabel alloc] init];
  titleLabel.left = CGRectGetMaxX(imageView.frame) + 8;
  titleLabel.top = 15;
  titleLabel.width = self.bounds.size.width - 20 - imageView.width - 8;
  titleLabel.height = 17;
  titleLabel.font = [UIFont boldSystemFontOfSize:14];
  titleLabel.textColor = [UIColor colorWithHex:0xff333333];
  titleLabel.text = aVo.title;
  [view addSubview:titleLabel];
  
  UILabel * desLabel = [[UILabel alloc] init];
  desLabel.left = titleLabel.left;
  desLabel.top = CGRectGetMaxY(titleLabel.frame) + 13;
  desLabel.width = titleLabel.width;
  desLabel.height = 30.0f;
  desLabel.numberOfLines = 2;
  desLabel.font = [UIFont systemFontOfSize:12];
  desLabel.textColor = [UIColor colorWithHex:0xff999999];
  desLabel.text = aVo.artDesc;
  [view addSubview:desLabel];
  
  return view;
}
- (UIImageView *)promotionImageViewWithVO:(CHCPGCountPromotionVO *)aVo;
{
  UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.bounds];
  [imageView sd_setImageWithURL:[NSURL URLWithString:aVo.img]
               placeholderImage:[UIImage imageNamed:@"zhuge_default"]];
  return imageView;
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  NSInteger pageCount = (scrollView.contentOffset.x + self.width * 0.5) / self.width;
  self.iPageControl.currentPage = pageCount;
}
#pragma mark - tap
- (void)tap:(UITapGestureRecognizer*)tap
{
  UIView * view = tap.view;
  NSInteger index = [self.iScrollView.subviews indexOfObject:view];
  if ([self.delegate respondsToSelector:@selector(promotionViewDidSelectIndex:)])
  {
    [self.delegate promotionViewDidSelectIndex:index];
  }
}
@end
