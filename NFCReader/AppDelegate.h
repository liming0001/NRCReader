//
//  AppDelegate.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/11.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableDataInfoView,EmpowerView,ChipInfoView,EPKillShowView,EPPayShowView,TableJiaJiancaiView,EPCowPointChooseShowView,EPINSShowView,NRThreeFairsPointShowView,EPINSOddsShowView,EPSixWinShowView;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,copy)void (^updateLuzhuResultBlock)(int gameType);

#pragma mark - 对象实例化
+ (instancetype)shareInstance;
#pragma mark -- 登录
- (void)showLoginVC;
#pragma mark -- 台面数据
- (TableDataInfoView *)tableDataInfoV;
#pragma mark -- 权限验证
- (EmpowerView *)empowerView;
#pragma mark -- 筹码信息
- (ChipInfoView *)chipInfoView;
#pragma mark -- 杀注界面
- (EPKillShowView *)killShowView;
#pragma mark -- 赔付界面
- (EPPayShowView *)payShowView;
#pragma mark -- 修改露珠
- (ModificationResultsView *)modifyResultsView;
#pragma mark -- 加减彩
- (TableJiaJiancaiView *)addOrMinusView;
#pragma mark -- 点数选择
- (EPCowPointChooseShowView *)cowPointShowView;
#pragma mark -- 输赢选择
- (EPINSShowView *)cowResultShowView;
- (EPINSOddsShowView *)insOddsShowView;
#pragma mark -- 三公点数选择
- (NRThreeFairsPointShowView *)fairsPointShowView;
- (EPSixWinShowView *)sixWinShowView;

@end

