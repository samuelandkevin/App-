//
//  YHProtocol.m
//  PikeWay
//
//  Created by kun on 2018/10/3.
//  Copyright © 2018年 yhsoft. All rights reserved.
//

#import "YHProtocol.h"

const NSString *kBaseURL = @"https://csapp.gtax.cn";  //测试
//const NSString *kBaseURL = @"https://apps.gtax.cn";   //生产环境

//MARK:/**********登录注册*************/
//验证手机号码是否已注册
const NSString *kPathVerifyPhoneExist = @"/app_core_api/v1/account/verification_mobile";
//注册
const NSString *kPathRegister =  @"/app_core_api/v1/account/regist";
//token是否有效
const NSString *kPathValidateToken = @"/app_core_api/v1/account/check_token";
//登录
const NSString *kPathLogin = @"/app_core_api/v1/account/login";
//忘记密码
const NSString *kPathForgetPasswd = @"/app_core_api/v1/account/forget_password";
//退出登录
const NSString *kPathLogout = @"/app_core_api/v1/account/logout";
//批量校验手机号是否已注册
const NSString *kPathWhetherPhonesAreRegistered = @"/app_core_api/v1/account/verifyPhonesIsReg";
//验证第三方账号登录有效性
const NSString *kPathVerifyThridPartyAccount = @"/app_core_api/v1/account/authenticate";
//通过第三方登录绑定手机号
const NSString *kPathBindPhoneByThirdPartyAccountLogin = @"/app_core_api/v1/account/bind_authenticate";
//第三方绑定手机后设置密码
const NSString *kPathThridPartyLoginSetPasswd = @"/app_core_api/v1/account/reset_password";
//税道网页登录
const NSString *kPathLoginByWebPage = @"/taxtao/chat/confirm_login";
//启动日志
const NSString *kPathBootLogging = @"/taxtao/api/monitor/startupLog";



//MARK:- /************我***********/
const NSString *kPathTaxAccountExist  = @"/app_core_api/v1/account/verification_username";//验证税道账号是否存在
const NSString *kPathEditMyCard       = @"/taxtao/api/account/edit";           //修改我的名片
const NSString *kPathMyCard           = @"/taxtao/api/account/my_account";          //我的名片
const NSString *kPathModifyPasswd     = @"/app_core_api/v1/account/change_password";//修改密码
const NSString *kPathGetMyVistors     = @"/taxtao/api/friendships/visitors";    //获取我的访客
const NSString *kPathUploadImage      = @"/taxtao/api/images/uploads";          //上传图片
const NSString *kPathUploadImageWithSource = @"/taxtao/api/images/uploads/param"; //上传图片（带图片来源）
const NSString *kPathValidateOldPasswd = @"/app_core_api/v1/account/verification_pasword";                                           //验证旧密码是否正确
const NSString *kPathChangePhone      = @"/app_core_api/v1/account/change_mobile";    //更改手机号码
const NSString *kPathChangeTaxAccount = @"/app_core_api/v1/account/change_username";  //更改税道账号
const NSString *kPathGetAppInfo       = @"/app_core_api/v1/appBaseInfo";              //获取应用基本信息
const NSString *kPathCheckUpdate      = @"/app_core_api/v1/checkUpgrade";             //检查更新
const NSString *kPathGetAbout         = @"/app_core_api/v1/bootstrap";                 //获取关于内容
const NSString *kPathIndustryList     = @"/taxtao/api/industry/list";                     //获取行业职位列表
const NSString *kPathEditJobTags      = @"/taxtao/api/account/jobLable";                 //编辑职位标签
const NSString *kPathEditWorkExp      = @"/taxtao/api/account/workExp";                  //编辑工作经历
const NSString *kPathEditEducationExp = @"/taxtao/api/account/eduExp";                   //编辑教育经历
const NSString *kPathDeleteMyDynamic  = @"/taxtao/api/dynamics/destroy";//删除我的动态
