//
//  NSString+Characters.m
//  AddressBook
//
//  Created by y_小易 on 14-6-10.
//  Copyright (c) 2014年 www.lanou3g.com. All rights reserved.
//

#import "NSString+Characters.h"

@implementation NSString (Characters)

//讲汉字转换为拼音
- (NSString *)pinyinOfName
{
	NSMutableString *name = [[NSMutableString alloc] initWithString:self];

	CFRange range = CFRangeMake(0, 1);

	// 汉字转换为拼音,并去除音调
	if (!CFStringTransform((__bridge CFMutableStringRef)name, &range, kCFStringTransformMandarinLatin, NO) ||
		!CFStringTransform((__bridge CFMutableStringRef)name, &range, kCFStringTransformStripDiacritics, NO))
	{
		return @"";
	}

	return name;
}

//汉字转换为拼音后，返回大写的首字母
- (NSString *)uppercasePinYinFirstLetter
{
	NSMutableString *first = [[NSMutableString alloc] initWithString:[self substringWithRange:NSMakeRange(0, 1)]];

	CFRange range = CFRangeMake(0, 1);

	// 汉字转换为拼音,并去除音调
	if (!CFStringTransform((__bridge CFMutableStringRef)first, &range, kCFStringTransformMandarinLatin, NO) ||
		!CFStringTransform((__bridge CFMutableStringRef)first, &range, kCFStringTransformStripDiacritics, NO))
	{
		return @"";
	}

	NSString *result;
	result = [first substringWithRange:NSMakeRange(0, 1)];

	return result.uppercaseString;
}


- (NSString *)decimalTOBinary:(uint64_t)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%llu",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
    }
    
    return a;
    
}
@end
