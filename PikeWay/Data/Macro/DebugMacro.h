//
//  DebugMacro.h
//  MyProject
//
//  Created by Troy on 14-6-18.
//  Copyright (c) 2014年 Dope Beats Co.,Ltd. All rights reserved.
//
// NSLog
#ifdef YH_DEBUG

/** 打印（使用NSLog实现，release状态时打印失效）*/
  #define DDLog(FORMAT, ...)   fprintf(stderr, "\n[%s]  function:%s line:%d content:%s\n", __TIME__, __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

/** 打标记 arg为一个字符串 */
  #define LocalMark(arg)	   NSLog(@"%@ ---> %@, %d, %s ", arg, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __FUNCTION__)

/** 自定义printf */
  #define DPrint(format, ...)  printf(format, ##__VA_ARGS__); printf("\n")

/** 自定义 assert， release时不会assert */
  #define DErrLog(format, ...) NSLog([NSString stringWithFormat:@"%@ %@", format, @"** ---> %@, %d, %s"], ##__VA_ARGS__, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __FUNCTION__); assert(false);
#else
  #define DDLog(...)		   do {	\
} while (0)
  #define LocalMark(arg)	   do {	\
} while (0)
  #define DPrint(format, ...)  do {	\
} while (0)
  #define DErrLog(format, ...) NSLog([NSString stringWithFormat:@"%@ %@", format, @"** ---> %@, %d, %s"], ##__VA_ARGS__, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __FUNCTION__);
#endif
