//
//  YHEducationExperienceModel.m
//  PikeWay
//
//  Created by YHIOS003 on 16/5/17.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHEducationExperienceModel.h"
#import <objc/runtime.h>
#import "YHSerializeKit.h"
#import "NSObject+YHDBRuntime.h"

@implementation YHEducationExperienceModel


//YHSERIALIZE_CODER_DECODER();
//
//YHSERIALIZE_COPY_WITH_ZONE();

//YHSERIALIZE_DESCRIPTION();

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}



- (id)copy
{
    YHEducationExperienceModel *model = [YHEducationExperienceModel new];
    model.eduExpId = _eduExpId;
    model.school = _school;
    model.major =_major;
    model.educationBackground =_educationBackground;
    model.beginTime =_beginTime;
    model.endTime = _endTime;
    model.moreDescription = _moreDescription;
    
    return model;
}

- (id)copyWithZone:(NSZone *)zone
{
   return [self copy];
    
}

- (id)mutableCopy
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return [self mutableCopy];
}


#pragma mark - YHFMDB
+ (NSString *)yh_primaryKey{
    return @"eduExpId";
}

+ (NSDictionary *)yh_replacedKeyFromPropertyName{
    return @{@"eduExpId":YHDB_PrimaryKey};
}

@end
