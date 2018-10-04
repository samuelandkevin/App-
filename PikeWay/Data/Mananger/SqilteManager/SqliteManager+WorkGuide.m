//
//  SqliteManager+WorkGuide.m
//  PikeWay
//
//  Created by YHIOS002 on 2017/8/1.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

#import "SqliteManager+WorkGuide.h"

@implementation SqlManager (WorkGuide)

#pragma mark - 工作指引-继续阅读表

//建继续阅读表
- (CreatTable *)creatConReadinTable{
    
    CreatTable *model = [self _firstCreatConReadingQueue];
    FMDatabaseQueue *queue = model.queue;
    NSArray *sqlArr    = model.sqlCreatTable;
    for (NSString *sql in sqlArr) {
        [queue inDatabase:^(FMDatabase *db) {
            
            BOOL ok = [db executeUpdate:sql];
            if (ok == NO) {
                DDLog(@"----NO:%@---",sql);
            }
            
        }];
    }
    return model;
}

/*
 *  更新continueReading表
 */
- (void)updateConReadingModel:(YHChapterModel *)conReadingModel complete:(void (^)(BOOL success,id obj))complete{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CreatTable *model = [self _setupConReadingDBqueue];
        FMDatabaseQueue *queue = model.queue;
        
        NSString *tableName = tableNameConReading();
        
            [queue inDatabase:^(FMDatabase *db) {
                /** 存储:会自动调用insert或者update，不需要担心重复插入数据 */
                [db yh_saveDataWithTable:tableName model:conReadingModel userInfo:nil otherSQL:nil option:^(BOOL save) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (complete) {
                            complete(save,nil);
                        }
                    });
                }];
                    
            }];
        
    });

}

/*
 *  查询continueReading表
 */
- (void)queryConReadingTableComplete:(void (^)(BOOL success,id obj))complete{
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        CreatTable *model = [self _setupConReadingDBqueue];
//        FMDatabaseQueue *queue = model.queue;
//
//        [queue inDatabase:^(FMDatabase *db) {
//            [db yh_excuteDatasWithTable:tableNameConReading() model:[YHChapterModel new] userInfo:nil fuzzyUserInfo:nil otherSQL:nil option:^(NSMutableArray *models) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (complete) {
//                        complete(YES,models);
//                    }
//                });
//            }];
//
//        }];
//    });
}

/*
 *  查询某本书要继续阅读的章节信息
 */
- (void)queryOneConReadingWithBookID:(NSString *)bookID complete:(void (^)(BOOL success,id obj))complete{
    
//    CreatTable *model = [self _setupConReadingDBqueue];
//    FMDatabaseQueue *queue = model.queue;
//    YHChapterModel *searchModel = [YHChapterModel new];
//    searchModel.bookID = bookID;
//
//    [queue inDatabase:^(FMDatabase *db) {
//        [db yh_excuteDataWithTable:tableNameConReading() model:searchModel userInfo:nil fuzzyUserInfo:nil otherSQL:nil option:^(id output_model) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (output_model) {
//                    complete(YES,output_model);
//                }else{
//                    complete(NO,nil);
//                }
//            });
//        }];
//
//    }];
}

/*
 *  删除continueReading表
 */
- (void)deleteConReadingTableComplete:(void(^)(BOOL success,id obj))complete{
    NSString *path= pathConReading();
    BOOL success = [self _deleteFileAtPath:path];
    if (success) {
        [self.continueReadingArray removeAllObjects];
    }
    complete(success,nil);
}

#pragma mark - Private
//第一次建继续阅读表
- (CreatTable *)_firstCreatConReadingQueue{
    
//    NSString *path = pathConReading();
//    NSFileManager *fileM = [NSFileManager defaultManager];
//    if(![fileM fileExistsAtPath:YHWorkGuideDir]){
//        //如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
//        if (![fileM fileExistsAtPath:YHUserDir]) {
//            [fileM createDirectoryAtPath:YHUserDir withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//        if (![fileM fileExistsAtPath:YHWorkGuideDir]){
//            [fileM createDirectoryAtPath:YHWorkGuideDir withIntermediateDirectories:YES attributes:nil error:nil];
//        }
//    }
//
//    DDLog(@"-----数据库操作路径------\n%@",path);
//
//    CreatTable *model = [[CreatTable alloc] init];
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:path];
//
//    if (queue) {
//
//        //存ID和队列
//
//        model.queue = queue;
//
//
//        //存SQL语句
//        NSString *tableName = tableNameConReading();
//        NSString *creatTableSql = [YHChapterModel yh_sqlForCreatTable:tableName primaryKey:@"id"];
//        if (creatTableSql) {
//            model.sqlCreatTable = @[creatTableSql];
//        }
//
//        [self.continueReadingArray addObject:model];
//    }
//    return model;
    return nil;
}

//设置继续阅读队列
- (CreatTable *)_setupConReadingDBqueue{
    //是否已存在Queue
    NSString *path = pathConReading();
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (self.continueReadingArray.count) {
        
        if (exist) {
#ifdef DEBUG
            DDLog(@"-----数据库操作路径------\n%@",path);
            return self.continueReadingArray[0];
#else
            
#endif
        }else{
            [self.continueReadingArray removeAllObjects];
        }
        
    }
    
    //没有就创建文件目录表
    return [self creatConReadinTable];
}




@end
