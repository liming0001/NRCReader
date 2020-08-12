//
//  NRGameBaseViewController.h
//  NFCReader
//
//  Created by 李黎明 on 2020/6/23.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRBaseViewController.h"
#import "NFPopupContainView.h"
#import "NFPopupTextContainView.h"
#import "TableDataInfoView.h"
#import "EmpowerView.h"
#import "ModificationResultsView.h"
#import "TableJiaJiancaiView.h"
#import "EPWebViewController.h"
#import "TopBarView.h"
#import "DewInfoView.h"
#import "TableInfoView.h"
#import "SetPlatformView.h"

#import "OperationInfoView.h"

#import "NRTableInfo.h"
#import "NRGameInfo.h"
#import "NRCustomerInfo.h"
#import "NRLoginInfo.h"

#import "EPPopAtipInfoView.h"
#import "EPDaSanInfoView.h"
#import "ChipInfoView.h"

NS_ASSUME_NONNULL_BEGIN

@interface NRGameBaseViewController : NRBaseViewController

//顶部视图
@property (nonatomic, strong) TopBarView *topBarView;
//露珠视图
@property (nonatomic, strong) DewInfoView *dewInfoView;
//台桌信息
@property (nonatomic, strong) TableInfoView *tableInfoView;
//结算台信息
@property (nonatomic, strong) SetPlatformView *platFormInfoView;
//操作中心
@property (nonatomic, strong) OperationInfoView *operationInfoView;
//自动版视图
@property (nonatomic, strong) UIView *automaticShowView;

@property (nonatomic, strong) EPDaSanInfoView *daSanInfoView;

#pragma mark -- 修改露珠
- (void)uddateCurGameLuzhu;
#pragma mark -- 获取当前最新露珠
- (void)getCurGameLuZhuList;
- (void)postNewXueciAndClear;

#pragma mark --手自动版切换
- (void)automoticChangeAction:(BOOL)isChange;

#pragma mark--更新露珠
- (void)updateLuzhuInfoWithList:(NSArray *)luzhuList;

#pragma mark -- 更新台桌信息
- (void)updateTableInfoWithTableType:(int)type CountList:(NSArray *)list;
- (void)refrashCurTableInfo;
#pragma mark --录入开牌结果
- (void)EnterOpeningResult;

#pragma mark - 筹码信息检测
- (BOOL)chipInfoCheck;

@end

NS_ASSUME_NONNULL_END
