//
//  DataParser.m
//  MyProject
//
//  Created by YHIOS002 on 16/4/10.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "DataParser.h"
//#import "YHUtils.h"
#import "NSDate+LYXCategory.h"
//#import "YHExpressionHelper.h"


@interface DataParser()
@property (nonatomic,assign)CGFloat addFontSize;
@end

@implementation DataParser

+ (DataParser *)shareInstance{
    static DataParser *g_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_instance = [[DataParser alloc] init];
    });
    return g_instance;
}

#pragma mark - Private
- (CGFloat)addFontSize{
    return [[[NSUserDefaults standardUserDefaults] valueForKey:kSetSystemFontSize] floatValue];
}

//- (YHGroupMember *)_parseGroupMemberWithDict:(NSDictionary *)dict groupOwnerID:(NSString *)groupOwnerID{
//    YHGroupMember *model = [YHGroupMember new];
//    model.sessionID      = dict[@"id"];
//    model.groupID        = dict[@"groupId"];
//    model.userID         = dict[@"memberUserId"];
//    model.userName       = dict[@"memberName"];
//    model.createdDate    = dict[@"createdDate"];
//    model.updatedDate    = dict[@"updatedDate"];
//    model.avtarUrl       = dict[@"userHead"];
//    if (groupOwnerID && [groupOwnerID isEqualToString:model.userID]) {
//        model.isGroupOwner = YES;
//    }
//    return model;
//}

#pragma mark - Public

//解析用户列表
- (NSArray <YHUserInfo*>*)parseUserListWithListData:(NSArray<NSDictionary*> *)listData curReqPage:(int)curReqPage{
    NSMutableArray *userArray = [NSMutableArray array];
    if (listData && [listData isKindOfClass:[NSArray class]]) {
        for (NSDictionary *dict in listData) {
            YHUserInfo *userInfo = [self parseUserInfo:dict curReqPage:curReqPage isSelf:NO];
            [userArray addObject:userInfo];
        }
    }
    return userArray;
}

//解析用户模型
- (YHUserInfo*)parseUserInfo:(NSDictionary *)dict curReqPage:(int)curReqPage isSelf:(BOOL)isSelf{

    YHUserInfo *userInfo     = [YHUserInfo new];
    userInfo.isSelfModel     = isSelf;
    userInfo.isRegister      = YES;
    userInfo.uid             = dict[@"id"];
    userInfo.mobilephone     = dict[@"mobile"];
    userInfo.userName        = dict[@"name"];
    userInfo.province        = dict[@"province"];
    userInfo.workCity        = dict[@"city"];
    userInfo.taxAccount      = dict[@"userName"];
    userInfo.dynamicCount    = [dict[@"dynamic_count"] intValue];
    userInfo.visitTime       = dict[@"visitor_time"];
    NSString *jobTagsString  = dict[@"workMark"];
    
    if (jobTagsString.length && jobTagsString) {
      
        NSArray *jobTags=  [jobTagsString componentsSeparatedByString:@","];
        if (jobTags) {
            userInfo.jobTags = [NSMutableArray arrayWithArray:jobTags];
        }
    }
    
    
    userInfo.workLocation    = dict[@"location"];
    userInfo.intro       = dict[@"description"];
    NSString *strAvatar  = dict[@"profileImageUrl"];
    if (strAvatar.length > 4) {
        userInfo.avatarUrl  = [NSURL URLWithString:strAvatar];
        
    }
    userInfo.company     = dict[@"company"];
    userInfo.job         = dict[@"job"];
    userInfo.industry    = dict[@"indusry"];
    NSString *gender     = dict[@"gender"];
    if ([gender isEqualToString:@"1"]) {
        //1 是男, 0 是 女
         userInfo.sex    = Gender_Man ;
    }else{
         userInfo.sex    = Gender_Women;
    }
   
    userInfo.loginTime            = dict[@"createdDate"];
    NSArray *workExp     = dict[@"professional"];
    if ([workExp isKindOfClass:[NSArray class]] && workExp.count) {
        userInfo.workExperiences = [self parseWorkExp:workExp];
    }
    NSArray *eduExp        = dict[@"education"];
    if ([eduExp isKindOfClass:[NSArray class]] && eduExp.count) {
        userInfo.eductaionExperiences = [self parseEduExp:eduExp];
    }
    userInfo.fansCount     = [dict[@"focusCount"] intValue];
    userInfo.isFollowed    = [dict[@"isFocus"] boolValue];
    userInfo.friShipStatus = [dict[@"friendStatus"] intValue];

    NSString * addFriStauts = dict[@"is_sqf"];
    
    if( addFriStauts.length)
    {
        if ([addFriStauts intValue] == 0)
        {
            userInfo.addFriStatus =  AddFriendStatus_otherPersonAddMe;
        }
        else if([addFriStauts intValue] == 1)
        {
            userInfo.addFriStatus =  AddFriendStatus_IAddOtherPerson;
        }
    }
  
    userInfo.identity   = [dict[@"type"] intValue];
    userInfo.department = dict[@"deptName"];
    userInfo.curReqPage = curReqPage;
    userInfo.isInMyBlackList = [dict[@"is_black_list"] boolValue];
    userInfo.companyID  = dict[@"companyId"];
    
    return userInfo;

}

//解析企业信息
- (YHCompanyInfo *)parseCompanyInfo:(NSDictionary *)dict{
    YHCompanyInfo *model = [YHCompanyInfo new];
    if ([dict isKindOfClass:[NSDictionary class]]) {
        model.uid        = dict[@"id"];
        model.baseUrl    = dict[@"baseUrl"];
        model.createDate = dict[@"createDate"];
        model.expireDate = dict[@"expireDate"];
        model.name       = dict[@"name"];
        model.shortName  = dict[@"shortName"];
        model.status     = [dict[@"status"] intValue];
        model.updateDate = dict[@"updateDate"];
    }
    return model;
}



- (NSMutableArray *)parseWorkExp:(NSArray *)workExp{
    
    NSMutableArray *maWorkExp = [NSMutableArray arrayWithCapacity:workExp.count];
    for (NSDictionary *dict in workExp) {
        YHWorkExperienceModel *model = [YHWorkExperienceModel new];
        model.position          = dict[@"job"];
        model.company           = dict[@"company"];
        model.beginTime         = dict[@"startDate"];
        model.endTime           = dict[@"endDate"];
        model.workExpId         = dict[@"id"];
        model.moreDescription   = dict[@"description"];
        [maWorkExp addObject:model ];
    }
    
    if ([maWorkExp count] >= 2) {
        
        [maWorkExp sortUsingComparator:^NSComparisonResult(YHWorkExperienceModel *obj1, YHWorkExperienceModel *obj2) {
            
            if ([NSDate compareWithBeginDateString:obj1.endTime andEndDateString:obj2.beginTime])
            {
                return NSOrderedDescending;
            }
            else
            {
                return NSOrderedAscending;
            }
            
        }];

    }
    
    
    return maWorkExp;
    
}

- (NSMutableArray *)parseEduExp:(NSArray *)eduExp{
    
    NSMutableArray *maEduExp = [NSMutableArray arrayWithCapacity:eduExp.count];
    for (NSDictionary *dict in eduExp) {
        YHEducationExperienceModel *model = [YHEducationExperienceModel new];
        model.school            = dict[@"university"];
        model.major             = dict[@"major"];
        model.educationBackground   = dict[@"degree"];
        model.beginTime         = dict[@"startDate"];
        model.endTime           = dict[@"endDate"];
        model.eduExpId          = dict[@"id"];
        model.moreDescription   = dict[@"description"];
        [maEduExp addObject:model ];
    }
    
    if ([maEduExp count] >= 2) {
        
        [maEduExp sortUsingComparator:^NSComparisonResult(YHEducationExperienceModel *obj1, YHEducationExperienceModel *obj2) {
            
            if ([NSDate compareWithBeginDateString:obj1.endTime andEndDateString:obj2.beginTime])
            {
                return NSOrderedDescending;
            }
            else
            {
                return NSOrderedAscending;
            }
            
        }];
        
    }
    
    return maEduExp;
    
}

////解析工作圈模型列表
//- (NSArray<YHWorkGroup*> *)parseWorkGroupListWithData:(NSArray<NSDictionary *> *)listData curReqPage:(int)curReqPage{
//    
//    NSMutableArray *workGroupArray = [NSMutableArray new];
//    
//    if (listData.count && listData) {
//
//        for (NSDictionary *dict in listData)
//        {
//            
//            YHWorkGroup *workGroup = [self parseWorkGroupWithDict:dict curReqPage:curReqPage];
//            [workGroupArray addObject:workGroup];
//            
//        }
//    
//    }
//    return workGroupArray;
//}
//
////解析工作圈模型
//- (YHWorkGroup *)parseWorkGroupWithDict:(NSDictionary *)dict curReqPage:(int)curReqPage{
//    
//    YHWorkGroup *workGroup = [YHWorkGroup new];
//    YHUserInfo  *userInfo  = [YHUserInfo new];
//    //用户列表
//    NSDictionary *userDict =  dict[@"user"];
//    workGroup.dynamicId    =  dict[@"id"];
//    
//    if (userDict) {
//        userInfo  = [self parseUserInfo:userDict curReqPage:curReqPage isSelf:NO];
//    }
//    workGroup.userInfo      = userInfo;
//    if ([dict[@"isLike"] isEqualToString:@"yes"]) {
//        workGroup.isLike = 1;
//    }
//    if ([dict[@"isLike"] isEqualToString:@"no"]) {
//        workGroup.isLike = 0;
//    }
//    
//    workGroup.likeCount     = [dict[@"attitudesCount"] intValue];
//    workGroup.commentCount  = [dict[@"commentsCount"] intValue];
//    workGroup.msgContent    = dict[@"content"];
////    workGroup.msgContent    = [YHExpressionHelper attributedStringWithText:content fontSize:(13+self.addFontSize) textColor:RGB16(0x303030)];
//    
//    //发布时间
//    NSString *publishTime   = dict[@"createdDate"];
//    workGroup.publishTime   = publishTime;
//    workGroup.publishTimeFormat   = [NSDate showDateString:publishTime];
//    workGroup.type          = [dict[@"type"] intValue];
//    workGroup.dynTag        = [dict[@"dynamicType"] intValue];
//    workGroup.visible       = [dict[@"visible"] intValue];
//    NSString *originalPic   =  dict[@"originalPic"];
//    
//    NSMutableArray *originalUrls     = [NSMutableArray array];
//    NSMutableArray *thumbnailPicUrls = [NSMutableArray array];
//    if (originalPic && originalPic.length) {
//        NSArray *array = [originalPic componentsSeparatedByString:@"|"];
//        for (NSString *originalPicStr in array) {
//            
//            //原图url
//            NSURL *originalUrl = [[NSURL alloc] initWithString:originalPicStr];
//            [originalUrls addObject:originalUrl];
//            
//            
//            //缩略图url
//            NSString *thumbnailStr = [originalPicStr stringByAppendingString:@"!t300x300.jpg"];
//            NSURL *url = [[NSURL alloc] initWithString:thumbnailStr];
//            [thumbnailPicUrls addObject:url];
//        }
//    }
//    
//    workGroup.originalPicUrls  = [originalUrls copy];
//    workGroup.thumbnailPicUrls = [thumbnailPicUrls copy];
//    workGroup.curReqPage       = curReqPage;
//    
//    //转发上一条动态内容
//    id forwardDyn =  dict[@"forwardDynamic"];
//    if ([forwardDyn isKindOfClass:[NSDictionary class]]) {
//         workGroup.forwardModel   = [self parseWorkGroupWithDict:forwardDyn curReqPage:curReqPage];
//
//    }
//
//    return workGroup;
//    
//}

////解析评论列表
//- (NSArray<YHCommentData*> *)parseCommentListWithListData:(NSArray<NSDictionary *>*)listData{
//    
//    NSMutableArray *commentArray = [NSMutableArray new];
//    if ([listData isKindOfClass:[NSArray class]]) {
//        
//        for (NSDictionary *dict in listData) {
//            YHCommentData *model =  [self parseCommentDataWithDict:dict];
//            [commentArray addObject:model];
//        }
//        
//    }
//    return commentArray;
//}
//
////解析评论model
//- (YHCommentData *)parseCommentDataWithDict:(NSDictionary *)dict{
//    YHCommentData *model    = [YHCommentData new];
//    model.commentId         = dict[@"id"];
//    
//    NSDictionary *dictReply = dict[@"replyComment"];
//    if ([dictReply isKindOfClass:[NSDictionary class]] && dictReply.count)
//    {
//        model.toReplyCommentData =  [self parseCommentDataWithDict:dictReply];
//    }
//    
//    NSString *content       = dict[@"content"];
//    
//    if (model.toReplyCommentData) {
//        content = [NSString stringWithFormat:@"回复 @%@:  %@",model.toReplyCommentData.authorInfo.userName,content];
//    }
// 
//    model.commentContent   = [YHExpressionHelper attributedStringWithText:content fontSize:(12.0+self.addFontSize) textColor:RGBCOLOR(120, 120, 120)];
//
//    model.publishTime      = dict[@"createdDate"];
//    NSDictionary *dictUser = dict[@"user"];
//    YHUserInfo *authorInfo = [YHUserInfo new];
//    if (dictUser) {
//        authorInfo = [self parseUserInfo:dictUser curReqPage:0 isSelf:NO];
//    }
//    model.authorInfo      = authorInfo;
//   
//    return model;
//}

////解析关于Model
//- (YHAboutModel *)parseAboutModelWithDict:(NSDictionary *)dict{
//    YHAboutModel *model = [YHAboutModel new];
//    model.aboutId = dict[@"id"];
//    NSString *urlString    = dict[@"articleUrl"];
//    model.url  = [NSURL URLWithString:urlString];
//    model.title   = dict[@"title"];
//    return model;
//}
//
//// 解析聊天记录Model
//- (NSArray<YHChatModel *>*)parseChatLogWithListData:(NSArray<NSDictionary *>*)listData{
//
//    NSMutableArray *chatLogArray = [NSMutableArray new];
//    if ([listData isKindOfClass:[NSArray class]]) {
//
//        for (NSDictionary *dict in listData) {
//            YHChatModel *model =  [self parseOneChatLogWithDict:dict];
//            [chatLogArray addObject:model];
//        }
//
//    }
//    return chatLogArray;
//}
//
//- (YHChatModel *)parseOneChatLogWithDict:(NSDictionary *)dict{
//    YHChatModel *model = [YHChatModel new];
//    if ([dict isKindOfClass:[NSDictionary class]]) {
//        model.chatId = dict[@"id"];
//        model.chatType    = [dict[@"isGroupChat"] intValue];
//        model.content     = dict[@"content"];
//        model.msgContent  = dict[@"msgContent"];
//        model.createTime  = dict[@"createTime"];
//        model.updateTime  = dict[@"updateTime"];
//        model.audienceDept= dict[@"audienceDept"];
//        model.audienceId  = dict[@"audienceId"];
//        NSString *audienceHead   = dict[@"audienceHead"];
//        if (audienceHead) {
//            model.audienceAvatar = [NSURL URLWithString:audienceHead];
//        }
//
//        model.audienceName     = dict[@"audienceName"];
//        NSString *speakerHead  = dict[@"speakerHead"];
//        if (speakerHead) {
//            NSString *thumbPic = [NSString stringWithFormat:@"%@.w80x80.png",speakerHead];
//            model.speakerAvatar    = [NSURL URLWithString:thumbPic];
//            model.speakerAvatarOri = [NSURL URLWithString:speakerHead];
//        }
//        model.speakerDept  = dict[@"speakerDept"];
//        model.speakerName  = dict[@"speakerName"];
//        model.speakerId    = dict[@"speakerId"];
//        model.isRead       = [dict[@"isRead"] intValue]?YES:NO;
//        model.timestamp    = [dict[@"cursor"] intValue];
//        model.msgType      = [dict[@"msgType"] intValue];
//        model.direction    = [dict[@"direction"] intValue];
//        model.status       = [dict[@"status"] intValue];
//    }
//    return model;
//}
//
////解析群列表
//- (NSArray<YHChatGroupModel *>*)parseGroupListWithListData:(NSArray<NSDictionary *>*)listData{
//    NSMutableArray *groupList = [NSMutableArray new];
//    if ([listData isKindOfClass:[NSArray class]]) {
//
//        for (NSDictionary *dict in listData) {
//            YHChatGroupModel *model =  [self parseGroupModelWithDict:dict];
//            [groupList addObject:model];
//        }
//
//    }
//    return groupList;
//}
//
////解析群Model
//- (YHChatGroupModel *)parseGroupModelWithDict:(NSDictionary *)dict{
//    YHChatGroupModel *model = [YHChatGroupModel new];
//    model.groupName = dict[@"groupName"];
//    model.groupDesc = dict[@"groupDesc"];
//    NSString *iconStr = dict[@"groupIconUrl"];
//    NSMutableArray *groupIconUrl = [NSMutableArray new];
//    if (iconStr) {
//      NSArray *urlStrArr = [iconStr componentsSeparatedByString:@","];
//        for (NSString *urlStr in urlStrArr) {
//            NSURL *iconUrl = [NSURL URLWithString:urlStr];
//            if (iconUrl) {
//                [groupIconUrl addObject:iconUrl];
//            }
//        }
//    }
//    model.groupIconUrl = groupIconUrl;
//    model.groupLabel = dict[@"groupLabel"];
//    model.groupState = dict[@"groupState"];
//    model.groupID = dict[@"id"];
//    model.memberCount = [dict[@"memberCount"] intValue];
//
//    NSArray *headUrls = dict[@"memberHeadUrls"];
//    NSMutableArray *memberHeadUrls = [NSMutableArray new];
//    if ([headUrls isKindOfClass:[NSArray class]]) {
//        for (NSString *urlStr in headUrls) {
//            NSURL *url = [NSURL URLWithString:urlStr];
//            if (url) {
//                [memberHeadUrls addObject:url];
//            }
//        }
//    }
//    model.memberHeadUrls = memberHeadUrls;
//    model.members = dict[@"members"];
//    model.updatedDate = dict[@"updatedDate"];
//    model.createdDate = dict[@"createdDate"];
//    model.createdID = dict[@"createdId"];
//    model.createdName = dict[@"createdName"];
//    NSNumber *isAsterisk = dict[@"isAsterisk"];
//    if(isAsterisk){
//        model.isStickTop =  [isAsterisk intValue] == 1 ? YES:NO;
//    }
//
//    return model;
//}
//
//
////解析聊天列表
//- (NSArray<YHChatListModel *>*)parseChatListWithListData:(NSArray<NSDictionary *>*)listData{
//    NSMutableArray *groupList = [NSMutableArray new];
//    if ([listData isKindOfClass:[NSArray class]]) {
//
//        for (NSDictionary *dict in listData) {
//            YHChatListModel *model =  [self parseChatListModelWithDict:dict];
//            [groupList addObject:model];
//        }
//
//    }
//    return groupList;
//}
//
////解析一个YHChatListModel
//- (YHChatListModel *)parseChatListModelWithDict:(NSDictionary *)dict{
//    YHChatListModel *model = [YHChatListModel new];
//    model.chatId      = dict[@"id"];
//    model.isStickTop  = [dict[@"isStickTop"] boolValue];
//    model.isGroupChat = [dict[@"isGroupChat"] boolValue];
//    model.memberCount = [dict[@"memberCount"] intValue];
//    model.lastContent = dict[@"lastContent"];
//    model.msgType     = [dict[@"msgType"] intValue];
//    model.userId      = dict[@"userId"];
//    model.sessionUserId = dict[@"sessionUserId"];
//    model.creatTime       = dict[@"createTime"];
//    model.creatTimeFormat = [NSDate showChatListDateString:dict[@"createTime"]];
//    model.sessionUserName = dict[@"sessionUserName"];
//    model.unReadCount   = [dict[@"isRead"] intValue];
//    model.groupName     = dict[@"groupName"];
//    model.lastCreatTime = dict[@"lastCreatTime"];
//
//    NSString *headsStr = dict[@"sessionUserHead"];
//    NSMutableArray *sessionUserHeadUrl = [NSMutableArray new];
//    if (headsStr) {
//        NSArray *urlStrArr = [headsStr componentsSeparatedByString:@","];
//        for (NSString *urlStr in urlStrArr) {
//            NSURL *headUrl = [NSURL URLWithString:urlStr];
//            if (headUrl) {
//                [sessionUserHeadUrl addObject:headUrl];
//            }
//        }
//    }
//
//    model.sessionUserHead = sessionUserHeadUrl;
//    model.msgId           = dict[@"msgId"];
//    model.status          = [dict[@"status"] intValue];
//    model.updateTime      = dict[@"updateTime"];
//    model.expertID        = dict[@"expertId"];
//    model.expertEndTime   = dict[@"expertEndTime"];
//    return model;
//}
//
////解析群成员
//- (NSArray<YHGroupMember*>*)parseGroupMembersWithList:(NSArray <NSDictionary*>*)listData{
//    NSMutableArray *groupMembers = [NSMutableArray new];
//    if ([listData isKindOfClass:[NSArray class]]) {
//        for (NSDictionary *dict in listData) {
//            YHGroupMember *model = [self parseGroupMemberWithDict:dict];
//            [groupMembers addObject:model];
//        }
//    }
//    return groupMembers;
//}
//
//
////解析一个YHGroupMember
//- (YHGroupMember *)parseGroupMemberWithDict:(NSDictionary *)dict{
//    return [self _parseGroupMemberWithDict:dict groupOwnerID:nil];
//}
//
//
///**
// 解析一个群信息
//
// @param dict dict
// @return YHGroupInfo
// */
//- (YHGroupInfo *)parseGroupInfoWithDict:(NSDictionary *)dict{
//    YHGroupInfo *model = [YHGroupInfo new];
//    if ([dict isKindOfClass:[NSDictionary class]]) {
//        model.createdDate  = dict[@"createdDate"];
//        model.createdID    = dict[@"createdId"];
//        model.createdName  = dict[@"createdName"];
//        model.groupDesc    = dict[@"groupDesc"];
//        model.groupIconUrl = dict[@"groupIconUrl"];
//        model.groupLabel   = dict[@"groupLabel"];
//        model.groupName    = dict[@"groupName"];
//        model.groupState   = [dict[@"groupState"] intValue];
//        model.groupID      = dict[@"id"];
//        model.memberCount  = [dict[@"memberCount"] intValue];
//        model.memberHeadUrls = dict[@"memberHeadUrls"];
//        NSArray *membersArr = dict[@"members"];
//        NSMutableArray <YHGroupMember *>*members = [NSMutableArray array];
//        for(NSDictionary *aDict in membersArr) {
//            YHGroupMember *member = [self _parseGroupMemberWithDict:aDict groupOwnerID:model.createdID];
//            [members addObject:member];
//        }
//        model.members      = members;
//        model.updatedDate  = dict[@"updatedDate"];
//    }
//    return model;
//}
//
////解析章节列表
//- (NSArray <YHChapterModel *>*)parseChapterListWithListData:(NSArray*)listData{
//    NSMutableArray *chapterList = [NSMutableArray new];
//    if ([listData isKindOfClass:[NSArray class]]) {
//        for (NSDictionary *dict in listData) {
//            YHChapterModel *model = [self parseChapterModelWithDict:dict];
//            [chapterList addObject:model];
//        }
//    }
//    return chapterList;
//}
//
////解析一个YHChapterModel
//- (YHChapterModel *)parseChapterModelWithDict:(NSDictionary *)dict{
//    YHChapterModel *model = [YHChapterModel new];
//    if ([dict isKindOfClass:[NSDictionary class]]) {
//       model.bookID         = dict[@"bookId"];
//       model.childList      = dict[@"childList"];
//       model.code           = [dict[@"code"] intValue];
//       model.createTime     = dict[@"createTime"];
//       model.filePath       = dict[@"filePath"];
//       model.chapterID      = dict[@"id"];
//       model.isFree         = [dict[@"isFree"] intValue] == 1? YES:NO;
//       model.name           = dict[@"name"];
//       model.parentID       = dict[@"parentId"];
//       model.sortNo         = dict[@"sortNo"];
//       model.status         = [dict[@"status"] intValue];
//       model.type           = dict[@"type"];
//       model.updateTime     = dict[@"updateTime"];
//    }
//    return model;
//}
//
//
////解析一个YHBookModel
//- (YHBookModel *)parseBookModelWithDict:(NSDictionary *)dict{
//    YHBookModel *model = [YHBookModel new];
//    if ([dict isKindOfClass:[NSDictionary class]]) {
//        model.bookID         = dict[@"id"];
//        model.name           = dict[@"name"];
//        model.summary        = dict[@"summary"];
//        model.price           = [dict[@"pice"] floatValue];
//        model.isPay          = [dict[@"is_pay"] boolValue];
//    }
//    return model;
//}
//
////解析书签列表
//- (NSArray<YHBookMarkModel *>*)parseBookMarkListWithListData:(NSArray<NSDictionary*>*)listData{
//    NSMutableArray *bookList = [NSMutableArray new];
//    if ([listData isKindOfClass:[NSArray class]]) {
//        for (NSDictionary *dict in listData) {
//            YHBookMarkModel *model = [self parseBookMarkModelWithDict:dict];
//            [bookList addObject:model];
//        }
//    }
//    return bookList;
//}
//
////解析书签Model
//- (YHBookMarkModel*)parseBookMarkModelWithDict:(NSDictionary *)dict{
//    YHBookMarkModel *model = [YHBookMarkModel new];
//    if ([dict isKindOfClass:[NSDictionary class]]) {
//
//        model.bookMarkID = dict[@"id"];
//        model.bookID     = dict[@"bookId"];
//        model.chapterID  = dict[@"chapterId"];
//        model.creatTime  = dict[@"createTime"];
//        model.creatTimeFormat = [NSDate showChatListDateString:model.creatTime];
//        model.chapterName= dict[@"name"];
//        model.content    = dict[@"baseContent"];
//
//    }
//    return model;
//}

@end
