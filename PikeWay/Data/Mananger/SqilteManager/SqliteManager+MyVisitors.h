//
//  SqliteManager+MyVisitors.h
//  PikeWay
//
//  Created by YHIOS002 on 17/1/10.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

#import "SqlManager.h"

@interface SqlManager (MyVisitors)

/*
 *  更新我的访客表多条动态
 */
- (void)updateMyVisitorsList:(NSArray <YHUserInfo *>*)vistorsList complete:(void (^)(BOOL success,id obj))complete;

/*
 *  查询我的访客表
 */
- (void)queryMyVisitorsTableWithLastData:(YHUserInfo *)lastData length:(int)length complete:(void (^)(BOOL success,id obj))complete;
@end
