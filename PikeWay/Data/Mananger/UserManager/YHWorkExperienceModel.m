//
//  YHWorkExperienceModel.m
//  PikeWay
//
//  Created by YHIOS003 on 16/5/17.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHWorkExperienceModel.h"
#import <objc/runtime.h>
#import "YHSerializeKit.h"
#import "NSObject+YHDBRuntime.h"


@implementation YHWorkExperienceModel


//YHSERIALIZE_CODER_DECODER();
//
//YHSERIALIZE_COPY_WITH_ZONE();

//YHSERIALIZE_DESCRIPTION();

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (id)copy
{
    YHWorkExperienceModel *model = [YHWorkExperienceModel new];
    model.workExpId = _workExpId;
    model.company = _company;
    model.position = _position;
    model.beginTime = _beginTime;
    model.endTime = _endTime;
    model.moreDescription = _moreDescription;
    return model;
}

- (id)copyWithZone:(NSZone *)zone
{
    return [self copy];
}

//- (id)mutableCopy
//{
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
//    
//    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
//}
//
//- (id)mutableCopyWithZone:(NSZone *)zone
//{
//    return [self mutableCopy];
//}

+ (NSString *)yh_primaryKey{
    return @"workExpId";
}

+ (NSDictionary *)yh_replacedKeyFromPropertyName{
    return @{@"workExpId":YHDB_PrimaryKey};
}


@end
