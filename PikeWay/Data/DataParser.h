//
//  DataParser.h
//  MyProject
//
//  Created by YHIOS002 on 16/4/10.
//  Copyright © 2016年 kun. All rights reserved.
//  数据解析器

#import <Foundation/Foundation.h>
#import "YHUserInfo.h"
//#import "YHAboutModel.h"
//#import "YHChatModel.h"
//#import "YHChatGroupModel.h"
//#import "YHChatListModel.h"
//#import "YHGroupMember.h"
//#import "YHGroupInfo.h"
//#import "YHBookModel.h"
//#import "YHChapterModel.h"
//#import "YHBookMarkModel.h"

@interface DataParser : NSObject

+ (DataParser *)shareInstance;
/**
 *  解析用户列表
 */
- (NSArray <YHUserInfo*>*)parseUserListWithListData:(NSArray<NSDictionary*> *)listData curReqPage:(int)curReqPage;

/**
 *  解析用户信息
 */
- (YHUserInfo*)parseUserInfo:(NSDictionary *)dict curReqPage:(int)curReqPage isSelf:(BOOL)isSelf;

//解析企业信息
- (YHCompanyInfo *)parseCompanyInfo:(NSDictionary *)dict;

///**
// *  解析工作圈模型列表
// */
//- (NSArray<YHWorkGroup*> *)parseWorkGroupListWithData:(NSArray<NSDictionary *> *)listData curReqPage:(int)curReqPage;
//
///**
// *  解析工作圈模型
// */
//- (YHWorkGroup *)parseWorkGroupWithDict:(NSDictionary *)dict curReqPage:(int)curReqPage;

/**
// *  解析评论列表
// */
//- (NSArray<YHCommentData*> *)parseCommentListWithListData:(NSArray<NSDictionary *>*)listData;

///**
// *  解析关于Model
// *
// */
//- (YHAboutModel *)parseAboutModelWithDict:(NSDictionary *)dict;
//
///**
// *  解析聊天记录Model
// *
// */
//- (NSArray<YHChatModel *>*)parseChatLogWithListData:(NSArray<NSDictionary *>*)listData;
//
//
///**
// 解析一条聊天记录
//
// @param dict <#dict description#>
// @return <#return value description#>
// */
//- (YHChatModel *)parseOneChatLogWithDict:(NSDictionary *)dict;
//
//
///**
// 解析群列表
//
// @param listData 列表Dict
// @return 数组(YHChatGroupModel*)
// */
//- (NSArray<YHChatGroupModel *>*)parseGroupListWithListData:(NSArray<NSDictionary *>*)listData;
//
//
///**
// 解析一个群Model
//
// @param dict
// @return 群Model
// */
//- (YHChatGroupModel *)parseGroupModelWithDict:(NSDictionary *)dict;
//
//
//
///**
// 解析聊天列表
//
// @param listData 列表Dict
// @return 数组(YHChatListModel*)
// */
//- (NSArray<YHChatListModel *>*)parseChatListWithListData:(NSArray<NSDictionary *>*)listData;
///**
// 解析一个YHChatListModel
//
// @param dict dict
// @return YHChatListModel
// */
//- (YHChatListModel *)parseChatListModelWithDict:(NSDictionary *)dict;
//
//
///**
// 解析群成员列表
//
// @param listData 列表Dict
// @return 数组(YHGroupMember*)
// */
//- (NSArray<YHGroupMember*>*)parseGroupMembersWithList:(NSArray <NSDictionary*>*)listData;
//
//
///**
// 解析一个群成员
//
// @param dict dict
// @return YHGroupMember
// */
//- (YHGroupMember *)parseGroupMemberWithDict:(NSDictionary *)dict;
//
//
///**
// 解析一个群信息
//
// @param dict dict
// @return YHGroupInfo
// */
//- (YHGroupInfo *)parseGroupInfoWithDict:(NSDictionary *)dict;
//
//
//
///**
// 解析章节列表
//
// @param listData 数组<Dictionary>
// @return 数组[YHChapterModel]
// */
//- (NSArray <YHChapterModel *>*)parseChapterListWithListData:(NSArray*)listData;
//
///**
// 解析一个YHChapterModel
//
// @param dict dict
// @return YHChapterModel
// */
//- (YHChapterModel *)parseChapterModelWithDict:(NSDictionary *)dict;
//
//
///**
// 解析一个YHBookModel
//
// @param dict dict
// @return YHBookModel
// */
//- (YHBookModel *)parseBookModelWithDict:(NSDictionary *)dict;
//
//
////解析书签列表
//- (NSArray<YHBookMarkModel *>*)parseBookMarkListWithListData:(NSArray<NSDictionary*>*)listData;
//
////解析书签Model
//- (YHBookMarkModel*)parseBookMarkModelWithDict:(NSDictionary *)dict;

@end
