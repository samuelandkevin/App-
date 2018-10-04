//
//  YHProtocol.h
//  PikeWay
//
//  Created by kun on 2018/10/3.
//  Copyright © 2018年 yhsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


FOUNDATION_EXTERN const NSString *kBaseURL;

//MARK:/**********登录注册*************/
//验证手机号码是否已注册
FOUNDATION_EXTERN const NSString *kPathVerifyPhoneExist;
//注册
FOUNDATION_EXTERN const NSString *kPathRegister;
//token是否有效
FOUNDATION_EXTERN const NSString *kPathValidateToken;
//登录
FOUNDATION_EXTERN const NSString *kPathLogin;
//忘记密码
FOUNDATION_EXTERN const NSString *kPathForgetPasswd;
//退出登录
FOUNDATION_EXTERN const NSString *kPathLogout;
//批量校验手机号是否已注册
FOUNDATION_EXTERN const NSString *kPathWhetherPhonesAreRegistered;
//验证第三方账号登录有效性
FOUNDATION_EXTERN const NSString *kPathVerifyThridPartyAccount;
//通过第三方登录绑定手机号
FOUNDATION_EXTERN const NSString *kPathBindPhoneByThirdPartyAccountLogin;
//第三方绑定手机后设置密码
FOUNDATION_EXTERN const NSString *kPathThridPartyLoginSetPasswd;
//税道网页登录
FOUNDATION_EXTERN const NSString *kPathLoginByWebPage;
//启动日志
FOUNDATION_EXTERN const NSString *kPathBootLogging;



//MARK:- /************我***********/
//验证税道账号是否存在
FOUNDATION_EXTERN const NSString *kPathTaxAccountExist;

//修改我的名片
FOUNDATION_EXTERN const NSString *kPathEditMyCard;
//我的名片
FOUNDATION_EXTERN const NSString *kPathMyCard;

//修改密码
FOUNDATION_EXTERN const NSString *kPathModifyPasswd;

//上传图片
FOUNDATION_EXTERN const NSString *kPathUploadImage;

//上传图片（带图片来源）
FOUNDATION_EXTERN const NSString *kPathUploadImageWithSource;

//验证旧密码是否正确
FOUNDATION_EXTERN const NSString *kPathValidateOldPasswd;

//更改手机号码
FOUNDATION_EXTERN const NSString *kPathChangePhone ;

//更改税道账号
FOUNDATION_EXTERN const NSString *kPathChangeTaxAccount;

//获取应用基本信息
FOUNDATION_EXTERN const NSString *kPathGetAppInfo;

//检查更新
FOUNDATION_EXTERN const NSString *kPathCheckUpdate;

//获取关于内容
FOUNDATION_EXTERN const NSString *kPathGetAbout;

//获取行业职位列表
FOUNDATION_EXTERN const NSString *kPathIndustryList;

//编辑职位标签
FOUNDATION_EXTERN const NSString *kPathEditJobTags;

//编辑工作经历
FOUNDATION_EXTERN const NSString *kPathEditWorkExp;

//编辑教育经历
FOUNDATION_EXTERN const NSString *kPathEditEducationExp;

