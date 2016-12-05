//
//  CHCMEHouseKeeperInputCell.m
//  Eggs
//
//  Created by HEcom_wzy on 16/3/15.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import "CHCMEConfigInputCell.h"
#import "CHCBaseConfigViewController.h"
#import "CHCInputValidUtil.h"
@interface CHCMEConfigInputCell()<UITextFieldDelegate>
@property (nonatomic, assign) NSInteger iMaxTextInputLength;
@property (nonatomic, weak) CHCBaseConfigVO *iViewVO;
@end

@implementation CHCMEConfigInputCell
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
  self.iValueField.text = @"";
  CHCBaseConfigVO *aConfigVO = (CHCBaseConfigVO *)aVO;
  self.iNameLabel.text = aConfigVO.keyShowName;
  self.iValueField.delegate = self;
  // 这里设置各种属性
  // 1、是否可编辑
  self.iValueField.enabled = ([aConfigVO.enableEdit integerValue] == 1);
  // 2、键盘类型
  self.iValueField.keyboardType = [self getKeyboardTypeWithType:aConfigVO.inputType];
  // 设置占位符
  self.iValueField.placeholder = aConfigVO.placeHolder;
  // 3、value的显示值
  self.iValueField.text = [self setShowValueWithValueArray:aConfigVO.valueArray 
                                          mutableSeparator:aConfigVO.mutableSelectSeparator];
  // 4、最大输入长度
  if (aConfigVO.maxInputNum && [aConfigVO.maxInputNum integerValue] > 0) 
  {
    // 添加通知，进行设置
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(textFieldEditChanged:)
                                                 name:@"UITextFieldTextDidChangeNotification" 
                                               object:self.iValueField];
    self.iMaxTextInputLength = [aConfigVO.maxInputNum integerValue];
  }
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
  [((CHCBaseConfigController *)self.iViewVO.iVC.iController) refreshRelatedDataCanChangedInfoWithBaseConfigVO:self.iViewVO];
  return YES;
}

#pragma mark - Notification Method
-(void)textFieldEditChanged:(NSNotification *)obj
{
  // 如果有小数点，小数点后保留两位有效数字
//  self.iViewVO.inputType
  
  UITextField *textField = (UITextField *)obj.object;
  
  if (textField == self.iValueField) 
  {
    NSMutableString *toBeString = [NSMutableString stringWithString:textField.text];
    if (self.iViewVO.inputType == EHCMEInputTypeDecimalPad
        || self.iViewVO.inputType == EHCMEInputTypeNumberPad) 
    {
      // 判断当前有没有包含数字或者.以外的其他字符，如果有，删除
      if (toBeString.length > 0) 
      {
        for (long i = [toBeString length]; i > 0; i--) 
        {
          NSString *subChar = [toBeString substringWithRange:NSMakeRange(i - 1, 1)];
          if (![CHCInputValidUtil checkInteger:subChar] 
              && ![subChar isEqualToString:@"."]) 
          {
            [toBeString replaceOccurrencesOfString:subChar 
                                        withString:@"" 
                                           options:NSLiteralSearch 
                                             range:NSMakeRange(i - 1, 1)];
          }
        }
      }
    }
    textField.text = toBeString;

    //获取高亮部分
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
      if ([toBeString containsString:@"."]) 
      {
        // 表明当前输入了小数点
        NSArray *subStringArr = [toBeString componentsSeparatedByString:@"."];
        NSLog(@"%@", subStringArr);
        if (subStringArr.count > 2) 
        {
          toBeString = [NSMutableString stringWithString:[toBeString substringToIndex:toBeString.length - 1]];
        }
        else
        {
          NSInteger secondPartLength = [subStringArr[1] length];
          if (secondPartLength > 2) 
          {
            toBeString = [NSMutableString stringWithString:[toBeString substringToIndex:(toBeString.length - (secondPartLength - 2))]];
          }
        }
        textField.text = toBeString;
      }
      else
      {
        if (toBeString.length > self.iMaxTextInputLength)
        {
          NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.iMaxTextInputLength];
          if (rangeIndex.length == 1)
          {
            textField.text = [toBeString substringToIndex:self.iMaxTextInputLength];
          }
          else
          {
            NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.iMaxTextInputLength)];
            textField.text = [toBeString substringWithRange:rangeRange];
          }
        }
      }
    }
    if (textField.text.length == 0) 
    {
      self.iViewVO.valueArray = nil;
    }
    else
    {
      self.iViewVO.valueArray = @[textField.text];
    }
    
    self.iViewVO.iVC.needAlertWhilePopVc = YES;
    [((CHCBaseConfigController *)self.iViewVO.iVC.iController) refreshRelatedDataWithBaseConfigVO:self.iViewVO]; 
  }
}

-(void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                  name:@"UITextFieldTextDidChangeNotification" 
                                                object:self.iValueField];
}

-(UIKeyboardType)getKeyboardTypeWithType:(EHCMEInputType)aInputType
{
  UIKeyboardType aKeyBoardType;
  switch (aInputType) 
  {
    case EHCMEInputTypePhonePad:
      aKeyBoardType = UIKeyboardTypePhonePad;
      break;
    case EHCMEInputTypeNumberPad:
      aKeyBoardType = UIKeyboardTypeNumberPad;
      break;
    case EHCMEInputTypeDecimalPad:
      aKeyBoardType = UIKeyboardTypeDecimalPad;
      break;
    default:
      aKeyBoardType = UIKeyboardTypeDefault;
      break;
  }
  
  return aKeyBoardType;
}

@end
