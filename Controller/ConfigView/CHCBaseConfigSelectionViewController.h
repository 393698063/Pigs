//
//  CHCBaseConfigSelectionViewController.h
//  Eggs
//
//  Created by HEcom_wzy on 16/3/17.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import "CHCBaseViewController.h"

@interface CHCBaseConfigSelectionViewController : CHCBaseViewController
- (IBAction)iBackBtnAction:(id)sender;
+ (void)enterConfigSelectVcWithSelectDictItems:(NSArray *)aSelectDictItems 
                                  mutiSelected:(BOOL)aMutiSelected 
                                      titleStr:(NSString *)aTitleStr
                                        pushVc:(CHCBaseViewController *)aPushVc
                                selectComplete:(void (^)(NSArray * selectionInfo))aSelectCompletion;
@end

@interface CHCBaseConfigSelectionController : CHCBaseController

@property (nonatomic, strong) NSArray *iListItemsArray;
-(NSArray *)loadConfigSelectedVOArrayWithArray:(NSArray *)itemArray;
-(NSArray *)getItemsDictArray;
@end

@interface CHCBaseConfigSelectionVO : CHCBaseVO
@property (nonatomic, copy) NSString *aValueId;
@property (nonatomic, copy) NSString *aValue;
@property (nonatomic, assign, getter=isSelected) BOOL isSelected;
+(instancetype)initWithItemDict:(NSDictionary *)dict;
@end