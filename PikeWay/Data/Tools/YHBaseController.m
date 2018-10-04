//
//  YHBaseController.m
//  PikeWay
//
//  Created by YHIOS002 on 2017/12/15.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

#import "YHBaseController.h"
#import "UILabel+Extension.h"
@interface YHBaseController ()
@property (nonatomic,strong) NSString *barTitle;
@end

@implementation YHBaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)setTitle:(NSString *)title{
    self.barTitle = title;
    self.navigationItem.titleView = [UILabel getTitleViewWithTitle:title];
}

- (NSString *)title{
    return self.barTitle;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
