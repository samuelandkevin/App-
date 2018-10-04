//
//  YHChapterModel.h
//  PikeWay
//
//  Created by YHIOS002 on 2017/7/6.
//  Copyright © 2017年 YHSoft. All rights reserved.
//  工作指引-章节Model

#import <Foundation/Foundation.h>

@interface YHChapterModel : NSObject

@property (nonatomic,copy) NSString *bookID;
@property (nonatomic,strong) NSArray *childList;
@property (nonatomic,assign) int code;
@property (nonatomic,copy) NSString *createTime;
@property (nonatomic,copy) NSString *filePath;
@property (nonatomic,copy) NSString *chapterID;
@property (nonatomic,assign) BOOL isFree;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *parentID;
@property (nonatomic,copy) NSString *sortNo;
@property (nonatomic,assign) int status;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *updateTime;

//以下字段非服务器返回
@property (nonatomic,assign) NSInteger chapterIndex;
@property (nonatomic,assign) CGFloat contentOffsetY;
@property (nonatomic,assign) BOOL isCollected;//是否被添加为书签

- (YHChapterModel *)dictToModelWith:(NSDictionary *)dict;

@end
