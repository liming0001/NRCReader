//
//  NRBaccaratViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRCowViewController.h"
#import "NRCustomerInfo.h"
#import "JXButton.h"
#import "EPService.h"
#import "NRLoginInfo.h"
#import "NRCowViewModel.h"
#import "NRTableInfo.h"
#import "NRGameInfo.h"
#import "NRUpdateInfo.h"
#import "NRGameInfo.h"

#import "EPPopAtipInfoView.h"
#import "GCDAsyncSocket.h"
#import "BLEIToll.h"
#import "JhPageItemView.h"
#import "SFLabel.h"
#import "ManualManagerCow.h"

#import "NFPopupContainView.h"
#import "NFPopupTextContainView.h"

#import "TableDataInfoView.h"
#import "EmpowerView.h"
#import "ModificationResultsView.h"
#import "TableJiaJiancaiView.h"
#import "JhPageItemModel.h"
#import "EPCowPointChooseShowView.h"

#import "EPWebViewController.h"
#import "EPKillShowView.h"
#import "EPPayShowView.h"
#import "ChipInfoView.h"
#import "EPDaSanInfoView.h"
#import "EPINSShowView.h"

#import "TopBarView.h"
#import "DewInfoView.h"
#import "TableInfoView.h"
#import "OperationInfoView.h"

@interface NRCowViewController ()

//手动版视图
@property (nonatomic, strong) ManualManagerCow *manuaManagerView;

@end

@implementation NRCowViewController

#pragma mark - 手动版视图
- (ManualManagerCow *)manuaManagerView{
    if (!_manuaManagerView) {
        _manuaManagerView = [[ManualManagerCow alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dewInfoView.frame)+20, kScreenWidth, kScreenHeight-CGRectGetMaxY(self.dewInfoView.frame)-20)];
        _manuaManagerView.hidden = YES;
    }
    return _manuaManagerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.manuaManagerView];
    [self.tableInfoView _setUpCowView];
    [self.platFormInfoView _setUpCowView];
    [self.operationInfoView _setUpCowView];
    [PublicHttpTool shareInstance].cp_Serialnumber = [NRCommand randomStringWithLength:30];
}

#pragma mark --手自动版切换
- (void)automoticChangeAction:(BOOL)isChange{
    if (isChange) {
        [PublicHttpTool shareInstance].isAutoOrManual = NO;
        self.manuaManagerView.hidden = NO;
        self.automaticShowView.hidden = YES;
        [[MJPopTool sharedInstance]popView:self.manuaManagerView WithFatherView:self.view animated:YES];
    }else{
        [PublicHttpTool shareInstance].isAutoOrManual = YES;
        self.automaticShowView.hidden = NO;
        self.manuaManagerView.hidden = YES;
        [[MJPopTool sharedInstance]popView:self.automaticShowView WithFatherView:self.view animated:YES];
    }
}

#pragma mark -- 上传最新靴次
- (void)postNewXueciAndClear{
    [self.manuaManagerView clearMoney];
    [PublicHttpTool postNewxueciWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        [self getCurGameLuZhuList];
    }];
    [self showMessage:[EPStr getStr:kEPChangeXueciSucceed note:@"更换靴次成功"] withSuccess:YES];
    //响警告声音
    [EPSound playWithSoundName:@"succeed_sound"];
}

#pragma mark -- 修改露珠
- (void)uddateCurGameLuzhu{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.viewModel.realLuzhuList.count<=0) {
        [self showMessage:@"暂无露珠可修改" withSuccess:NO];
        return;
    }
    ModificationResultsView *modifyResultsView = [[AppDelegate shareInstance]modifyResultsView];
    [[MJPopTool sharedInstance] popView:modifyResultsView animated:YES];
    [modifyResultsView clearAllButtons];
    [modifyResultsView updateBottomViewBtnNiuniu];
    [modifyResultsView fellViewDataWithList:self.viewModel.realLuzhuList];
    @weakify(self);
    [AppDelegate shareInstance].updateLuzhuResultBlock = ^(int gameType) {
        @strongify(self);
        [self refrashCurTableInfo];
    };
}

#pragma mark -- 获取当前最新露珠
- (void)getCurGameLuZhuList{
    [self.viewModel getLuzhuWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        if (success) {
            [self updateLuzhuInfoWithList:self.viewModel.luzhuInfoList];
        }
        [self hideWaitingView];
    }];
}

@end
