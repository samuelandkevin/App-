//
//  SqliteManager+WorkGuide.h
//  PikeWay
//
//  Created by YHIOS002 on 2017/8/1.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

#import "SqlManager.h"
#import "YHChapterModel.h"

@interface SqlManager (WorkGuide)

#pragma mark - 工作指引-继续阅读表
/*
 *  更新continueReading表
 */
- (void)updateConReadingModel:(YHChapterModel *)conReadingModel complete:(void (^)(BOOL success,id obj))complete;

/*
 *  查询continueReading表
 */
- (void)queryConReadingTableComplete:(void (^)(BOOL success,id obj))complete;

/*
 *  查询某本书要继续阅读的章节信息
 */
- (void)queryOneConReadingWithBookID:(NSString *)bookID complete:(void (^)(BOOL success,id obj))complete;

/*
 *  删除continueReading表
 */
- (void)deleteConReadingTableComplete:(void(^)(BOOL success,id obj))complete;
@end
