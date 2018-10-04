//
//  YHUtils.m
//  PikeWay
//
//  Created by samuelandkevin on 14-6-26.
//  Copyright (c) 2014年 samuelandkevin Beats Co.,Ltd. All rights reserved.
//

#import "YHUtils.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSDate+LYXCategory.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import "RegexKitLite.h"
#import "YHUICommon.h"
#import "YHFileTool.h"
#import <AVFoundation/AVFoundation.h>

#define kNickMaxLength 20
@interface YHUtils ()

@end


@implementation YHUtils


+ (BOOL)isExpiredWithCacheKey:(NSString *)cacheKey validDuration:(long)validDuration{
    //取出
    NSInteger ts = [[NSUserDefaults standardUserDefaults] integerForKey:cacheKey];
    
    if (ts == 0) {
        ts = [[NSDate date] timeIntervalSince1970];
        [[NSUserDefaults standardUserDefaults] setObject:@(ts) forKey:cacheKey];
    }
    
    //旧时间日期
    NSDate *oDate = [NSDate dateWithTimeIntervalSince1970:ts];
    //时间间隔
    NSTimeInterval distance = [[NSDate date] timeIntervalSinceDate:oDate];
    
    if (distance > validDuration) {
        return YES;
    }
    return NO;
}

+ (NSString *)md5HexDigest:(NSString*)input{
    
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (CC_LONG)input.length, digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
    
}

+ (NSString *)getDeviceVersion {
    NSString *deviceType;
    struct utsname systemInfo;
    uname(&systemInfo);
    deviceType = [NSString stringWithCString:systemInfo.machine
                                    encoding:NSUTF8StringEncoding];
    return deviceType;
}

+ (NSString*)phoneType
{
    NSString *platform = getDeviceVersion();
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])   return@"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])   return@"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])   return@"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])   return@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])   return@"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])   return@"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])   return @"iPhone 4s";
    if ([platform isEqualToString:@"iPhone5,1"])   return @"iPhone 5 (GSM/WCDMA)";
    if ([platform isEqualToString:@"iPhone4,2"])   return @"iPhone 5 (CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    //iPot Touch
    if ([platform isEqualToString:@"iPod1,1"])     return@"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])     return@"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])     return@"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])     return@"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])     return@"iPod Touch 5G";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])     return@"iPad";
    if ([platform isEqualToString:@"iPad2,1"])     return@"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])     return@"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])     return@"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])     return@"iPad 2 New";
    if ([platform isEqualToString:@"iPad2,5"])     return@"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad3,1"])     return@"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])     return@"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])     return@"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])     return@"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])        return@"Simulator";
    
    return platform;
}

+ (NSString *)phoneSystem{
    return [NSString stringWithFormat:@"%@%@",[UIDevice currentDevice].systemName,[UIDevice currentDevice].systemVersion];
}

+ (NSString *)appStoreNumber{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appBulidNumber{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)carrierName{
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry = [carrier carrierName];
    DDLog(@"[carrier isoCountryCode]==%@,[carrier allowsVOIP]=%d,[carrier mobileCountryCode=%@,[carrier mobileCountryCode]=%@",[carrier isoCountryCode],[carrier allowsVOIP],[carrier mobileCountryCode],[carrier mobileNetworkCode]);
    return currentCountry;
}


@end




NSString* getDeviceVersion()
{

    NSString *deviceType;
    struct utsname systemInfo;
    uname(&systemInfo);
    deviceType = [NSString stringWithCString:systemInfo.machine
                                    encoding:NSUTF8StringEncoding];
    return deviceType;
}

NSString * platformString ()
{
    NSString *platform = getDeviceVersion();
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"])   return@"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])   return@"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])   return@"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])   return@"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])   return@"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])   return@"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])   return @"iPhone 4s";
    if ([platform isEqualToString:@"iPhone5,1"])   return @"iPhone 5 (GSM/WCDMA)";
    if ([platform isEqualToString:@"iPhone4,2"])   return @"iPhone 5 (CDMA)";
    
    //iPot Touch
    if ([platform isEqualToString:@"iPod1,1"])     return@"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])     return@"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])     return@"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])     return@"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])     return@"iPod Touch 5G";
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])     return@"iPad";
    if ([platform isEqualToString:@"iPad2,1"])     return@"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])     return@"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])     return@"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])     return@"iPad 2 New";
    if ([platform isEqualToString:@"iPad2,5"])     return@"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad3,1"])     return@"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])     return@"iPad 3 (CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])     return@"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])     return@"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"])        return@"Simulator";
    
    return platform;
}

BOOL compareStringIdsDiff( NSArray *allphones, NSString *phonesCacheFilePath, NSArray **addlist, NSArray **removelist ) {
    NSMutableArray *cachephones = [NSMutableArray arrayWithContentsOfFile:phonesCacheFilePath];
   
    NSMutableArray *sortedAllPhones = [NSMutableArray arrayWithArray:allphones];
    [sortedAllPhones sortUsingSelector:@selector(compare:)];
    
    NSMutableArray *maAddList = [NSMutableArray array];
    NSMutableArray *maRemoveList = [NSMutableArray array];
    BOOL hasChange = NO;
    if (cachephones) {
        // 有过记录
        NSMutableIndexSet *shouldRemoveIndex = [NSMutableIndexSet indexSet];
        
        int lindx, rindx; lindx = rindx = 0;
        
        do {
            if ( lindx >= cachephones.count) {
                // 左边没有了，右边全部增加到addlist
                NSArray *subarray = [sortedAllPhones subarrayWithRange:NSMakeRange(rindx, sortedAllPhones.count - rindx)];
                [maAddList addObjectsFromArray:subarray];
                break;
            }
            
            if ( rindx >= sortedAllPhones.count) {
                // 右边没有了，左边全部回到removelist
                NSArray *subarray = [cachephones subarrayWithRange:NSMakeRange(lindx, cachephones.count - lindx)];
                [maRemoveList addObjectsFromArray:subarray];
                break;
            }
            
    
            long long lv = [cachephones[lindx] longLongValue];
            long long rv = [sortedAllPhones[rindx] longLongValue];
            if ( lv > rv ) {
                [maAddList addObject:sortedAllPhones[rindx]];
                rindx++;
            }
            else if (lv == rv) {
                lindx++;
                rindx++;
            }
            else {
                [maRemoveList addObject:cachephones[lindx]];
                [shouldRemoveIndex addIndex:lindx];
                lindx++;
            }
        } while (1);
        
        if (maAddList.count > 0 || maRemoveList.count > 0) {
            hasChange = YES;
        }
    }
    else {
        
    }
    
    [sortedAllPhones writeToFile:phonesCacheFilePath atomically:NO];
    
    if (addlist) {
        *addlist = maAddList;
    }
    if (removelist) {
        *removelist = maRemoveList;
    }
    
    return hasChange;
}


BOOL checkABGranted(){
    __block BOOL _bAccessGranted  = NO; //获取通讯录权限标记
    
    
    if (kSystemVersion < 6.0){
        
        _bAccessGranted = YES;
        
    }else if(kSystemVersion < 9.0){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        //获取通讯录权限
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){
            _bAccessGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
#pragma clang diagnostic pop
    }else{
        
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusAuthorized || status == CNAuthorizationStatusNotDetermined) {
            _bAccessGranted = YES;
        }else{
            _bAccessGranted = NO;
        }
        
    }
    return _bAccessGranted;
}

BOOL checkVideoGranted(){
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    
    if(authStatus == ALAuthorizationStatusRestricted || authStatus == ALAuthorizationStatusDenied){
        //kun调试
//        [YHAlertView showWithTitle:@"提示" message:@"此程序没有权限访问相机的权限，请在“隐私设置”中启用" cancelButtonTitle:nil otherButtonTitle:@"确定" clickButtonBlock:^(YHAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//
//        }];

        return NO;
    }
    return YES;
}


time_t getTimestamp() {
    time_t raw_time;
    time(&raw_time);
    return raw_time;
}

BOOL isValidePassword( NSString * strPsw ) {
    if ( ![strPsw isMatchedByRegex:@"^[\\x21-\\x7e]{6,20}$"] ) {  // ASCII 可见字符
        // ^[a-zA-Z0-9`~!@#\$%\^&\*\(\)\-\+_=\[\]\{\}\\\|;:'"<>,\.\/\?]{6,20}$
        return NO;
    }
    else
        return YES;
    
}

BOOL isValideTaxAccountFormat(NSString *taxAccount){
    BOOL isValidPhone = NO;
    BOOL isValidTaxAccount = NO;
    //税道账号格式
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userNameRegex];
    
    if (![userNamePredicate evaluateWithObject:taxAccount])
    {
        isValidTaxAccount = NO;
    }
    else{
        isValidTaxAccount = YES;
    }
    
    //手机格式
    if (![taxAccount isMatchedByRegex:@"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$"] ) {
        isValidPhone = NO;
    }
    else{
        isValidPhone = YES;
    }
    
    if (isValidPhone || isValidTaxAccount) {
        return YES;
    }
    return NO;
}

BOOL isValidePhoneFormat(NSString *mobileNum){
    
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}



BOOL isValideAccount( NSString * account ) {
    if ( ![account isMatchedByRegex:@"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$"] && ![account isMatchedByRegex:@"^[0-9]{8,11}$"] ) {
        return NO;
    }
    return YES;
}

BOOL isValideOpusName( NSString * name ) {
    
    NSString *regulaStr = @"^([\\u4e00-\\u9fa5\\x20-\\x7e\\（\\）\\·\\~\\、\\——]+\\s?)+$"; // @[^@]{1,7}| @\w{1,20}$ 、、 @[^@]+?(?=[\s:：(),.。])  //
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr                                options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAnchorsMatchLines
                                                                             error:&error];
    if (error == nil)
    {
        NSArray *arrayOfAllMatches = [regex matchesInString:name  options:0 range:NSMakeRange(0, [name length])];
        if (arrayOfAllMatches.count > 0) {
            return YES;
        }
        postTips(@"名字应为有效的中英文，且不能包含中文标点符号", @"提示");
        return NO;
    }
    else
        DErrLog(@"Match Error %@", error);
    return NO;
}

BOOL isValideNick( NSString * nick ) {
    if (nick.length == 0) {
        postTips( nil, @"昵称太短了" );
        return NO;
    }
    if (nick.length > kNickMaxLength && [nick lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > (kNickMaxLength * 3 + 3) ) {
        postTips([NSString stringWithFormat:@"昵称长度介于1~%d个字符", kNickMaxLength], nil);
        return NO;
    }
    if ([nick isMatchedByRegex:@"[!@#\\?]+"]) {
        postTips(@"名字不可以包含 !,@,#,? 等特殊字符！", @"提示");
        return NO;
    }
    
    NSString *regulaStr = @"^[\\x21-\\x7e\\u4e00-\\u9fa5]+$";
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAnchorsMatchLines
                                                                             error:&error];
    
    
    
    if (error == nil) {
        NSArray *arrayOfAllMatches = [regex matchesInString:nick  options:0 range:NSMakeRange(0, [nick length])];
        if (arrayOfAllMatches.count > 0) {
            return YES;
        }
        postTips(@"不能包含 !,@,#,?,空格和中文标点符号", @"提示");
    }
    else
        DDLog(@"Match Error %@", error);
    return NO;
}

BOOL isValideCustomTag( NSString *customTag){
    if(!customTag.length){
        postTips(@"标签内容不能为空", @"");
        return NO;
    }
    if ([customTag rangeOfString:@"#"].location != NSNotFound) {
        postTips(@"请勿添加带有#号、系统限制词,长度不能超过20个字符", @"");
        return NO;
    }
    if (![customTag isMatchedByRegex:@"^([\\u4e00-\\u9fa5\\x20-\\x7e]){1,20}$"]) {
        postTips(@"请勿添加带有#号、系统限制词,长度不能超过20个字符", @"");
        return NO;
    }else
        return YES;
}

#pragma mark - 文件管理
//计算文件/文件夹大小
unsigned long long fileSize(NSString *path){
    // 总大小
    unsigned long long size = 0;
    
    // 文件管理者
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    // 是否为文件夹
    BOOL isDirectory = NO;
    
    // 路径是否存在
    BOOL exists = [mgr fileExistsAtPath:path isDirectory:&isDirectory];
    if (!exists) return size;
    
    if (isDirectory) { // 文件夹
        // 获得文件夹的大小  == 获得文件夹中所有文件的总大小
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:path];
        for (NSString *subpath in enumerator) {
            // 全路径
            NSString *fullSubpath = [path stringByAppendingPathComponent:subpath];
            // 累加文件大小
            size += [mgr attributesOfItemAtPath:fullSubpath error:nil].fileSize;
        }
    } else { // 文件
        size = [mgr attributesOfItemAtPath:path error:nil].fileSize;
    }
    
    return size;
}

