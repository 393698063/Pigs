//
//  TodayViewController.m
//  PriceList
//
//  Created by Jorgon on 2016/11/10.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "TableViewCell.h"

@interface TodayViewController () <NCWidgetProviding,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *iTableview;
@property (nonatomic, strong) NSMutableArray * iDataArray;
@end
static NSString * name = @"group.com.hecom.xinyun.GROUP150811A";
@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  UIView * aView = [[UIView alloc] init];
  self.iTableview.tableFooterView = aView;
  NSUserDefaults * myDefaults = [[NSUserDefaults alloc] initWithSuiteName:name];
  self.iDataArray = [myDefaults objectForKey:@"data"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.iDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  TableViewCell * cell = [TableViewCell cellWithTableView:tableView];
  NSDictionary * data = [self.iDataArray objectAtIndex:indexPath.row];
  [cell loadData:data];
  return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
