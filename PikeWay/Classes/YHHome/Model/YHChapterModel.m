//
//  YHChapterModel.m
//  PikeWay
//
//  Created by YHIOS002 on 2017/7/6.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

#import "YHChapterModel.h"
#import "DataParser.h"
#import "NSObject+YHDBRuntime.h"

@implementation YHChapterModel

+ (NSString *)yh_primaryKey{
    return @"bookID";
}

+ (NSDictionary *)yh_replacedKeyFromPropertyName{
    return @{@"bookID":YHDB_PrimaryKey};
}


- (YHChapterModel *)dictToModelWith:(NSDictionary *)dict{
//    return [[DataParser shareInstance] parseChapterModelWithDict:dict];
    return nil;
}
@end
