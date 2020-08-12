//
//  NRBaccaratViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRThreeFairsViewController.h"
#import "NRThreeFairsViewModel.h"
#import "ThreeFairsManual.h"

@interface NRThreeFairsViewController ()

@property (nonatomic,strong) ThreeFairsManual *threeFairsManager;

@end

@implementation NRThreeFairsViewController

- (ThreeFairsManual *)threeFairsManager{
    if (!_threeFairsManager) {
        _threeFairsManager = [[ThreeFairsManual alloc]initWithFrame:CGRectMake(0,94, kScreenWidth, kScreenHeight-94)];
        _threeFairsManager.hidden = YES;
    }
    return _threeFairsManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.threeFairsManager];
    [self.tableInfoView _setUpCowView];
    [self.platFormInfoView _setUpCowView];
    [self.operationInfoView _setUpCowView];
    [PublicHttpTool shareInstance].cowPoint=99;
    [PublicHttpTool shareInstance].cp_Serialnumber = [NRCommand randomStringWithLength:30];
    
    @weakify(self);
    self.tableInfoView.tableInfoBtnBlock = ^(NSInteger tag, int BtnType) {
        @strongify(self);
        [self.threeFairsManager calculateCustomerMoneyWithZhuangCowPoint];
    };
}

#pragma mark -- 上传最新靴次
- (void)postNewXueciAndClear{
    [self.threeFairsManager clearMoney];
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
    [modifyResultsView updateBottomViewBtnWithTag:YES];
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
