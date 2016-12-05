//
//  CHCBaseConfigSelectionViewController.m
//  Eggs
//
//  Created by HEcom_wzy on 16/3/17.
//  Copyright © 2016年 Hecom. All rights reserved.
//

#import "CHCBaseConfigSelectionViewController.h"

#define kUnselectedColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define kSelectedColor [UIColor colorWithRed:4/255.0 green:166/255.0 blue:80/255.0 alpha:1.0]

typedef void (^SelectCompleteBlock)(NSArray *selectionInfo);

@interface CHCBaseConfigSelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *iTableView;
@property (nonatomic, strong)CHCBaseConfigSelectionController *iController;
@property (nonatomic, copy) SelectCompleteBlock selectCompleteBlock;
@property (nonatomic, assign, getter=isMutiSelected) BOOL isMutiSelected;
@end

@implementation CHCBaseConfigSelectionViewController
@dynamic iController;

- (IBAction)iBackBtnAction:(id)sender 
{
//  self.selectCompleteBlock(self.iController.iListItemsArray);
  [self.navigationController popViewControllerAnimated:YES];
}

+ (void)enterConfigSelectVcWithSelectDictItems:(NSArray *)aSelectDictItems 
                                  mutiSelected:(BOOL)aMutiSelected 
                                      titleStr:(NSString *)aTitleStr
                                        pushVc:(CHCBaseViewController *)aPushVc
                                selectComplete:(void (^)(NSArray * selectionInfo))aSelectCompletion
{
  CHCBaseConfigSelectionViewController *aVC = [[CHCBaseConfigSelectionViewController alloc] initWithTitle:aTitleStr listItems:aSelectDictItems];
  aVC.selectCompleteBlock = aSelectCompletion;
  aVC.isMutiSelected = aMutiSelected;
  aVC.isMutiSelected = NO;
  [aPushVc.navigationController pushViewController:aVC animated:YES];
}

-(BOOL)isNeedBaseViewTapAction
{
  return NO;
}

-(instancetype)initWithTitle:(NSString *)aTitle listItems:(NSArray *)aListItems
{
  self = [super init];
  if (self) 
  {
    self.iTitleStr = aTitle;
    self.iController.iListItemsArray = [self.iController loadConfigSelectedVOArrayWithArray:aListItems];
  }
  return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  self.iTableView.dataSource = self;
  self.iTableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView的数据源方法和代理方法
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 0.1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.iController.iListItemsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"configSelectCell"];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"configSelectCell"];
  }
  CHCBaseConfigSelectionVO *baseConfigVO = self.iController.iListItemsArray[indexPath.row];
  cell.textLabel.text = baseConfigVO.aValue;
  cell.textLabel.font = [UIFont systemFontOfSize:15];
  cell.textLabel.textColor = baseConfigVO.isSelected ? kSelectedColor : kUnselectedColor;
  
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (self.isMutiSelected) 
  {
    CHCBaseConfigSelectionVO *baseConfigVO = self.iController.iListItemsArray[indexPath.row];
    baseConfigVO.isSelected = !baseConfigVO.isSelected;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
  }
  else
  {
    for (NSInteger i = 0; i < self.iController.iListItemsArray.count; i++) 
    {
      CHCBaseConfigSelectionVO *baseConfigVO = self.iController.iListItemsArray[i];
      if (i != indexPath.row) 
      {
        baseConfigVO.isSelected = NO;
      }
      else if (i == indexPath.row && !baseConfigVO.isSelected) 
      {
        baseConfigVO.isSelected = !baseConfigVO.isSelected;
      }
    }
    [tableView reloadData];
    NSArray *itemDictArray = [self.iController getItemsDictArray];
    self.selectCompleteBlock(itemDictArray);
    [self.navigationController popViewControllerAnimated:YES];
  }
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


@interface CHCBaseConfigSelectionController()

@property (nonatomic, weak)CHCBaseConfigSelectionViewController *iViewController;

@end
@implementation CHCBaseConfigSelectionController
@dynamic iViewController;

-(NSArray *)loadConfigSelectedVOArrayWithArray:(NSArray *)itemArray
{
  // valueId\value\valueSelected
  NSMutableArray *aSelectedVOArray = [NSMutableArray array];
  for (NSDictionary *dict in itemArray) 
  {
    CHCBaseConfigSelectionVO *aBaseConfigVO = [CHCBaseConfigSelectionVO initWithItemDict:dict];
    [aSelectedVOArray addObject:aBaseConfigVO];
  }
  return aSelectedVOArray;
}

-(NSArray *)getItemsDictArray
{
  NSMutableArray *aItemDictArray = [NSMutableArray array];
  for (CHCBaseConfigSelectionVO * baseConfigVO in self.iListItemsArray) 
  {
    NSMutableDictionary *aDict = [NSMutableDictionary dictionary];
    [aDict setObject:baseConfigVO.aValue forKey:@"value"];
    [aDict setObject:baseConfigVO.aValueId forKey:@"valueId"];
    [aDict setObject:@(baseConfigVO.isSelected) forKey:@"valueSelected"];
    [aItemDictArray addObject:aDict];
  }
  return aItemDictArray;
}

@end

@implementation CHCBaseConfigSelectionVO

+(instancetype)initWithItemDict:(NSDictionary *)dict
{
  CHCBaseConfigSelectionVO *aBaseConfigVO = [[CHCBaseConfigSelectionVO alloc] init];
  aBaseConfigVO.aValue = [dict objectForKey:@"value"];
  aBaseConfigVO.aValueId = [dict objectForKey:@"valueId"];
  aBaseConfigVO.isSelected = [[dict objectForKey:@"valueSelected"] boolValue];
  return aBaseConfigVO;
}

@end
