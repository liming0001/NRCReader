//
//  NRBaccaratViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRBaccaratView_workersController.h"
#import "NRBaccarat_workersViewModel.h"
#import "NRManualManger_workers.h"

@interface NRBaccaratView_workersController ()
//手动版视图
@property (nonatomic, strong) NRManualManger_workers *manuaManagerView;
@end

@implementation NRBaccaratView_workersController

#pragma mark - 手动版视图
- (NRManualManger_workers *)manuaManagerView{
    if (!_manuaManagerView) {
        _manuaManagerView = [[NRManualManger_workers alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.dewInfoView.frame)+20, kScreenWidth, kScreenHeight-CGRectGetMaxY(self.dewInfoView.frame)-20)];
        _manuaManagerView.hidden = YES;
    }
    return _manuaManagerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.manuaManagerView];
    
    [self.tableInfoView _setUpBaccaratView];
    [self.platFormInfoView _setUpBaccaratView];
    [self.operationInfoView _setUpBaccaratView];
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
    [PublicHttpTool showSucceedSoundMessage:@"更换靴次成功"];
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
    [modifyResultsView updateBottomViewBtnWithTag:NO];
    [modifyResultsView updateBottomViewBtnBaijiale:YES];
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
            [self updateTableInfoWithTableType:2 CountList:@[[NSNumber numberWithInt:self.viewModel.zhuangCount],[NSNumber numberWithInt:self.viewModel.zhuangDuiCount],[NSNumber numberWithInt:self.viewModel.xianCount],[NSNumber numberWithInt:self.viewModel.xianDuiCount],[NSNumber numberWithInt:self.viewModel.sixCount],[NSNumber numberWithInt:self.viewModel.heCount]]];
        }
        [self hideWaitingViewInWindow];
    }];
}

@end
