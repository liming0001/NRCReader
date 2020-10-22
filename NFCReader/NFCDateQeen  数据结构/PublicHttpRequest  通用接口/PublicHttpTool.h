//
//  PublicHttpTool.h
//  NFCReader
//
//  Created by 李黎明 on 2020/6/10.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^PublicHttpResponseBlock)(BOOL success,id data,NSString *msg);

@class NRUpdateInfo;
@interface PublicHttpTool : NSObject

//登录token
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSString *femp_num;
//当前台桌ID
@property (nonatomic, strong) NSString *fid;
//当前台桌名称
@property (nonatomic, strong) NSString *tableName;
//当前台桌结算日起
@property (nonatomic, strong) NSString *cp_tableRijieDate;
//当前台桌最新更新信息
@property (nonatomic, strong) NRUpdateInfo *curupdateInfo;
//当前台桌提交结果之后的ID
@property (nonatomic, strong) NSString *cp_tableIDString;
//当前台桌赔率
@property (nonatomic, strong) NSArray *curXz_setting;

@property (nonatomic, strong) NSArray *chipUIDList;//筹码uid
@property (nonatomic, strong) NSArray *chipFmeList;//筹码面额
@property (nonatomic, strong) NSArray *chipTypeList;//筹码类型
@property (nonatomic, strong) NSArray *paramList;//统一参数
@property (nonatomic, strong) NSArray *resultList;//结果集合（用于百家乐）
@property (nonatomic, assign) int tiger_resultTag;//龙虎结果(用于龙虎)

@property (nonatomic, strong) NSDictionary *updateParam;//修改露珠参数

@property (nonatomic, assign) int shouldZhaoHuiValue;//需找回金额

//判断是否开台
@property (nonatomic, assign) int hasFoundingStatus;
//判断当前台桌（1有佣百家乐，2免佣百家乐，3牛牛,4龙虎）
@property (nonatomic, assign) int curGameType;
@property (nonatomic, assign) int cowPoint;//当前牛牛点数
@property (nonatomic, assign) int customerPoint;//当前牛牛客人点数

//当前台桌流水号
@property (nonatomic, strong) NSString *cp_Serialnumber;
@property (nonatomic, strong) NSString *exchangeWashNumber;//筹码兑换洗码号
@property (nonatomic, strong) NSString *takeOutPsd;//存入密码
@property (nonatomic, strong) NSString *fcredit;//类型
@property (nonatomic, strong) NSString *guestName;//客人姓名
@property (nonatomic, strong) NSString *authorName;//授权人
@property (nonatomic, strong) NSString *notes;//备注
@property (nonatomic, strong) NSString *userAllMoney;//用户筹码金额

//当前铺次对比
@property (nonatomic, assign) int puciCount;
@property (nonatomic, assign) int prePuciCount;
@property (nonatomic, assign) int xueciCount;

//兑换类型
@property (nonatomic, assign) int exchangeChipType;
@property (nonatomic, assign) int operationType;
//客人可取出金额
@property (nonatomic, strong) NSString *customerTakeOutMoney;

//输赢记录参数
@property (nonatomic, strong) NSString *winStatus;
@property (nonatomic, assign) BOOL hasNewGameEntry;//是否开启了新一局
@property (nonatomic, assign) BOOL isAutoOrManual;//手动或者自动(默认手动)

@property (nonatomic, assign) BOOL winOrLose;//判断输赢(默认输)
@property (nonatomic, assign) BOOL isShaZhuOperation;//是否杀注操作
@property (nonatomic, assign) BOOL isDaShuiOperation;//是否识别水钱
@property (nonatomic, assign) BOOL isZhaoHuiChip;//是否找回筹码
@property (nonatomic, assign) BOOL recordTips;//记录小费
@property (nonatomic, assign) BOOL exchangeMoneyFirstStep;//换钱第一步
@property (nonatomic, assign) BOOL exchangeMoneySecondStep;//换钱第二步
@property (nonatomic, assign) BOOL detectionChip;//筹码识别

@property (nonatomic, assign) BOOL isBigPermissions;//是否大账房权限

@property (nonatomic, assign) BOOL isStoreOrTakeOutChip;//是否存入或者取出

//@property (nonatomic, assign) int operateType;//操作类型(0普通识别，1记录小费，2识别赔付筹码，3识别水钱，4换钱，5筹码识别，6修改洗码号,7展示杀赔弹出框,8绑定筹码)


#pragma mark - 对象实例化
+ (instancetype)shareInstance;
+ (void)showWaitingView;
+ (void)hideWaitingView;
+ (void)showSoundMessage:(NSString *)message;
+ (void)showSucceedSoundMessage:(NSString *)message;

#pragma mark -- 是否开启了新一局
+ (BOOL)canStepToNextStep;
#pragma mark -- 选择开结果
+ (BOOL)chooseKaipaiResult;
#pragma mark -- 提交开牌结果
+ (BOOL)commitKaipaiResult;
#pragma mark -- 判断TCP连接状态
+ (BOOL)socketNoConnectedShow;
#pragma mark -- 清除所有判断条件
- (void)clearAllCheckConditions;

#pragma  mark - 心跳定时器
- (void)startPingTimer;
- (void)stopPingTimer;

#pragma mark - 换桌
+ (void)otherTableWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 获取当前台桌状态
+ (void)tableStateWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 上传最新靴次
+ (void)postNewxueciWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 获取当前台桌的靴次
+ (void)getLastXueCiInfoWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 获取露珠
+ (void)getLuzhuWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 提交开牌结果
+ (void)commitkpResultWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 提交日结
+ (void)commitDailyWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 检测筹码是否正确
+ (void)checkChipIsTrueWithChipList:(NSArray *)chipList Block:(PublicHttpResponseBlock)block;
#pragma mark - 打散筹码
+ (void)changeChipWashNumberWithChipList:(NSArray *)chipList WashNumber:(NSString *)washNumber ChangChipList:(NSArray *)changeChipList Block:(PublicHttpResponseBlock)block;
#pragma mark - 台面操作记录列表
+ (void)queryOperate_listWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 查看台面数据
+ (void)queryTableDataWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 验证账号
+ (void)authorizationAccountWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 清空露珠
+ (void)clearLuzhuWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 提交小费
+ (void)commitTipResultWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 获取客人输赢
+ (void)Customer_getWinlossWithWashNumber:(NSString *)washNumber Block:(PublicHttpResponseBlock)block;
#pragma mark - 提交客人输赢记录和台桌流水记录(手动版)
+ (void)commitCustomerRecordWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 修改客人洗码号
+ (void)updateCustomerWashNumberWithChipList:(NSArray *)chipList CurWashNumber:(NSString *)washNumber Block:(PublicHttpResponseBlock)block;
#pragma mark - 提交客人输赢记录和台桌流水记录(自动)
+ (void)commitCustomerRecord_AutoWithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 提交客人输赢记录和台桌流水记录(杀注,自动)
+ (void)commitCustomerRecord_ShaZhuWithWashNumberList:(NSArray *)washNumberArray Block:(PublicHttpResponseBlock)block;
#pragma mark - 根据洗码号获取用户信息
+ (void)getInfoByXmh:(NSString *)washNumber WithBlock:(PublicHttpResponseBlock)block;
#pragma mark - 修改露珠
+ (void)updateLuzhuInfoRecordWithBlock:(PublicHttpResponseBlock)block;
#pragma mark -- 获取筹码面额
+ (void)getChipTypeWithBlock:(PublicHttpResponseBlock)block;

#pragma mark - 开台列表
+ (void)queryKaitaiApplyListWithParams:(NSDictionary *)params Block:(PublicHttpResponseBlock)block;
#pragma mark -- 台桌操作
+ (void)Table_operateChipWithParams:(NSDictionary *)params Block:(PublicHttpResponseBlock)block;
#pragma mark -- 获取账房加减彩列表
+ (void)Customer_getapplyinfoWithParams:(NSDictionary *)params Block:(PublicHttpResponseBlock)block;
#pragma mark -- 账房加减彩
+ (void)addOrMinusChipWithParams:(NSDictionary *)params Block:(PublicHttpResponseBlock)block;
#pragma mark -- 获取台面减彩请求
+ (void)Table_getMinuschipdataWithParams:(NSDictionary *)params Block:(PublicHttpResponseBlock)block;
#pragma mark -- 获取台面加彩请求
+ (void)Table_getaddchipdataWithParams:(NSDictionary *)params Block:(PublicHttpResponseBlock)block;
#pragma mark -- 台桌加减彩
+ (void)tableAddOrMinusChipWithParams:(NSDictionary *)params Block:(PublicHttpResponseBlock)block;
#pragma mark - 筹码详情
+ (void)queryTable_operate_detailWithParams:(NSDictionary *)params Block:(PublicHttpResponseBlock)block;
#pragma mark - 柜台筹码详情
+ (void)account_operate_detailWithParams:(NSDictionary *)params Block:(PublicHttpResponseBlock)block;

@end

NS_ASSUME_NONNULL_END
