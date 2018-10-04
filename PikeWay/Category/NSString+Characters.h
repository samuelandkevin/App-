//
//  NSString+Characters.h
//  AddressBook
//
//  Created by y_小易 on 14-6-10.
//  Copyright (c) 2014年 www.lanou3g.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Characters)

//将汉字转换为拼音
- (NSString *)pinyinOfName;

//汉字转换为拼音后，返回大写的首字母
- (NSString *)uppercasePinYinFirstLetter;


//将数字输出为二进制
- (NSString *)decimalTOBinary:(uint64_t)tmpid backLength:(int)length;
@end
