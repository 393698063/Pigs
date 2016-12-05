//
//  CHCPGCustomCalloutView.m
//  Pigs
//
//  Created by HEcom on 16/7/14.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGCustomCalloutView.h"
#import "UIColor+Hex.h"
#import "CHCSqliteManager.h"
#import "CHCPGUserDataSycnViewController.h"
#import "SynchronzeDef.h"
#import "CHCInputValidUtil.h"

@interface CHCPGCustomCalloutView ()<UITextFieldDelegate>
@property (nonatomic, strong) CHCSqliteManager * iSqliteManager;
@end

@implementation CHCPGCustomCalloutView

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self)
  {
    self.backgroundColor = [UIColor clearColor];
    NSString * path = [NSString stringWithFormat:@"%@/%@",[CHCPGUserDataSycnController createUserPath],@"database.db"];
    self.iSqliteManager = [CHCSqliteManager creatSqliteManager:path];

    [self initSubViews];
  }
  return self;
}
- (void)initSubViews
{
  UIImageView * backImageView = [[UIImageView alloc] initWithFrame:self.bounds];
  backImageView.image = [UIImage imageNamed:@"count_bulbBack"];
  [self addSubview:backImageView];
  
  UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.bounds.size.width, 17)];
  titleLabel.textColor = [UIColor colorWithHex:0xffE15150];
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.font = [UIFont systemFontOfSize:14];
  titleLabel.text = @"居然没有猪？快来数一下";
  [self addSubview:titleLabel];
  
  UILabel * fatLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLabel.frame) + 15, 90, 17)];
  fatLabel.text = @"育肥猪存栏：";
  fatLabel.font = [UIFont systemFontOfSize:14];
  [self addSubview:fatLabel];
  
  CGFloat fatX = CGRectGetMaxX(fatLabel.frame);
  CGFloat fatY = fatLabel.frame.origin.y;
  CGFloat fatW = self.bounds.size.width - 20 - fatX;
  CGFloat fatH = fatLabel.bounds.size.height;
  self.iFatPigCountField = [[UITextField alloc] initWithFrame:CGRectMake(fatX, fatY, fatW, fatH)];
  self.iFatPigCountField.placeholder = @"输入数量";
  self.iFatPigCountField.font = [UIFont systemFontOfSize:14];
  self.iFatPigCountField.textAlignment = NSTextAlignmentRight;
  self.iFatPigCountField.keyboardType = UIKeyboardTypeNumberPad;
  self.iFatPigCountField.delegate = self;
  [self addSubview:self.iFatPigCountField];
  
  CGFloat lineX = 20;
  CGFloat lineY = CGRectGetMaxY(fatLabel.frame) + 5;
  CGFloat lineW = self.bounds.size.width - 40;
  CGFloat lineH = 0.5;
  UIView * firstLine = [[UIView alloc] initWithFrame:CGRectMake(lineX, lineY, lineW, lineH)];
  firstLine.backgroundColor = [UIColor colorWithHex:0xffcccccc];
  [self addSubview: firstLine];
  
  UILabel * sowLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(firstLine.frame) + 15, 90, 17)];
  sowLabel.text = @"母猪存栏：";
  sowLabel.font = [UIFont systemFontOfSize:14];
  [self addSubview:sowLabel];
  
  self.iSowCountField = [[UITextField alloc] initWithFrame:CGRectMake(fatX, sowLabel.frame.origin.y, fatW, fatH)];
  self.iSowCountField.placeholder = @"输入数量";
  self.iSowCountField.textAlignment = NSTextAlignmentRight;
  self.iSowCountField.font = [UIFont systemFontOfSize:14];
  self.iSowCountField.keyboardType = UIKeyboardTypeNumberPad;
  self.iSowCountField.delegate = self;
  [self addSubview:self.iSowCountField];
  
  UIView * sLine = [[UIView alloc] initWithFrame:CGRectMake(lineX, CGRectGetMaxY(sowLabel.frame) + 5, lineW, lineH)];
  sLine.backgroundColor = [UIColor colorWithHex:0xffcccccc];
  [self addSubview:sLine];
  
  UIButton * subButton = [UIButton buttonWithType:UIButtonTypeCustom];
  self.iSubmitButton = subButton;
  subButton.frame = CGRectMake(20, CGRectGetMaxY(sLine.frame) + 15,lineW , 40);
  [subButton setBackgroundImage:[UIImage imageNamed:@"count_submit"] forState:UIControlStateNormal];
  [subButton setTitle:@"提交" forState:UIControlStateNormal];
  [subButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
  [subButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
  [self addSubview:subButton];
  
  UILabel * goldLabel = [[UILabel alloc] init];
  CGFloat goldLabelX = subButton.center.x + 20;
  CGFloat goldLabelY = subButton.center.y - 6.5;
  CGFloat goldLabelW = 65;
  CGFloat goldLabelH = 15;
  goldLabel.frame = CGRectMake(goldLabelX, goldLabelY, goldLabelW, goldLabelH);
  goldLabel.font = [UIFont systemFontOfSize:11];
  goldLabel.textColor = [UIColor colorWithHex:0xfffcff00];
  goldLabel.text = [NSString stringWithFormat:@"+%@金币",[self readGoldCount]];
  [self addSubview:goldLabel];
}
- (NSNumber * )readGoldCount
{
  NSNumber * goldCount = @(200);
  NSString * sql = [NSString stringWithFormat:@"select * from %@ where code = 106",HCPG_GoldRulesTable];
  NSArray * golds = [self.iSqliteManager executeQueryRtnAry:sql];
  if (golds) {
    NSDictionary * goldDic = [golds firstObject];
    goldCount = [goldDic objectForKey:@"min"];
  }
  return goldCount;
}
- (void)submitAction:(UIButton *)button
{
  [self endEditing:YES];
  if ([self.delegate respondsToSelector:@selector(submitFatPig:sow:)])
  {
    [self.delegate submitFatPig:self.iFatPigCountField.text sow:self.iSowCountField.text];
  }
}
#pragma mark - UITextFielDelegate
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
}
- (void)textFieldDidChange:(UITextField *)textField
{
  if (textField.text.length > 6)
  {
    textField.text = [textField.text substringToIndex:6];
  }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
