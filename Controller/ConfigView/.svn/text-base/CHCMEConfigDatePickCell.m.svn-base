//
//  CHCMEConfigDatePickCell.m
//  Eggs
//
//  Created by HEcom_wzy on 16/3/17.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import "CHCMEConfigDatePickCell.h"
#import "CHCBaseConfigViewController.h"
#import "UWDatePickerView.h"

@interface CHCMEConfigDatePickCell()<UWDatePickerViewDelegate>

@property (nonatomic, weak) CHCBaseConfigVO *iViewVO;

@end

@implementation CHCMEConfigDatePickCell
@dynamic iViewVO;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadViewVO:(CHCBaseVO *)aVO
{
  [super loadViewVO:aVO];
  
  self.iNameLabel.text = @"";
  self.iValueLabel.text = @"";
  CHCBaseConfigVO *aConfigVO = (CHCBaseConfigVO *)aVO;
  self.iNameLabel.text = aConfigVO.keyShowName;
  // 3、value的显示值
  self.iValueLabel.text = [self setShowValueWithValueArray:aConfigVO.valueArray 
                                          mutableSeparator:aConfigVO.mutableSelectSeparator];
}

-(void)cellSelected
{
  [super cellSelected];
  HCLog(@"%s", __func__);
  
  // 显示datePickerView
  
  UWDatePickerView *datePickerView = [UWDatePickerView instanceDatePickerView];
  
  datePickerView.frame = [UIScreen mainScreen].bounds;
  [datePickerView setMinDate:self.iViewVO.startDate maxDate:self.iViewVO.endDate];
  datePickerView.delegate = self;
  NSString *dateStr = self.iValueLabel.text;
  if (dateStr && dateStr.length > 0) 
  {
    [datePickerView setPrimaryDate:self.iValueLabel.text];
  }
  [[UIApplication sharedApplication].keyWindow addSubview:datePickerView];
  
}

-(void)getSelectDate:(NSString *)date
{
  if (date && date.length > 0) 
  {
    self.iValueLabel.text = date;
    self.iViewVO.valueArray = @[date];
    self.iViewVO.iVC.needAlertWhilePopVc = YES;
  }
}

@end
