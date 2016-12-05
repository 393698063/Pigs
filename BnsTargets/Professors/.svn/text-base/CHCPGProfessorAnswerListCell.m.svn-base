//
//  CHCPGProfessorAnswerListCell.m
//  Pigs
//
//  Created by Lemon-HEcom on 16/7/26.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "CHCPGProfessorAnswerListCell.h"
#import "CHCPGProfessorHomeViewController.h"

static NSInteger const HCPG_NameBottom = 5;
static NSInteger const HCPG_AnswerBottom = 21;

@interface CHCPGProfessorAnswerListCell()
@property (nonatomic, weak)CHCPGProblemListVO *iDataVO;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iNameBottom;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *iAnswerBottom;
@end

@implementation CHCPGProfessorAnswerListCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadDataVO:(CHCPGProblemListVO *)aVO
{
  self.iDataVO = aVO;
  
  self.iQuestionLabel.text = aVO.questionTitle?:@"";
  
  if (aVO.lastCommentContent.length > 0)
  {
    self.iNameLabel.text = aVO.lastCommentName?:@"";
    self.iTimeLabel.text = [self timeFromStr:aVO.lastCommentTime];
    self.iLastAnswerLabel.text = aVO.lastCommentContent?:@"";
    
    self.iNameBottom.constant = HCPG_NameBottom;
    self.iAnswerBottom.constant = HCPG_AnswerBottom;
  }
  else
  {
    self.iNameLabel.text = @"";
    self.iTimeLabel.text = @"";
    self.iLastAnswerLabel.text = @"";
    
    self.iNameBottom.constant = 0;
    self.iAnswerBottom.constant = 0;
  }
  
  self.iCommentNumLabel.text = [NSString stringWithFormat:@"%@条回复",aVO.commentNum?:@(0)];
}

- (NSString *)timeFromStr:(NSNumber *)aStr
{
  NSString *rtnStr = @"";
  
  if (aStr.integerValue>0)
  {
    NSInteger seconds = [aStr integerValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:seconds/1000];
    NSString *format = @"MM-dd";
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:format];
    rtnStr = [formatter stringFromDate:date];
  }
  
  return rtnStr?:@"";
}

@end
