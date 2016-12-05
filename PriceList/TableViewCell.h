//
//  TableViewCell.h
//  Pigs
//
//  Created by Jorgon on 2016/11/10.
//  Copyright © 2016年 HEcom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
+ (id)cellWithTableView:(UITableView *)tableView;
- (void)loadData:(NSDictionary *)dataDic;
@end
