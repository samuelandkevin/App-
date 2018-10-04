//
//  CellForJobDetail.h
//  PikeWay
//
//  Created by kun on 16/4/24.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellForJobDetail : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelTitle;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
