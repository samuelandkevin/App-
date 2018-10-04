//
//  YHFileTool.h
//  YHSOFT
//
//  Created by samuelandkevin on 16/9/17.
//  Copyright (c) 2016年 samuelandkevin Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHFileTool : NSObject

+ (NSString *)getAppSupportDataDirectory;
+ (NSString *)getAppCacheDirectory;
+ (NSString *)getLocalBeatsArtworkCacheDirectory;
+ (NSString *)getTempDataCacheDirectory;
+ (NSString *)getDataCacheDirectory;
+ (NSArray *)GetFilesListAtPath:(NSString *)dirPath withType:(NSString *)type;
+ (NSString *)getWebrootDirectory;

// 文件主目录
+ (NSString *)fileMainPath;
// 文件大小
+ (NSString *)filesize:(NSString *)path;
+ (CGFloat)fileSizeWithPath:(NSString *)path;
@end
