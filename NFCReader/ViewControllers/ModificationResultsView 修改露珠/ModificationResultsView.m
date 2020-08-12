//
//  ModificationResultsView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/4.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "ModificationResultsView.h"
#import "EmpowerView.h"
#import "EPSelectPopView.h"
#import "EPCowPointChooseShowView.h"
#import "EPINSShowView.h"

@interface ModificationResultsView ()
//提交参数
@property (nonatomic, strong) NSString *curLuzhuID;
@property (nonatomic, strong) NSString *result_string;
@property (nonatomic, strong) NSMutableArray *resultList;
@property (nonatomic, strong) NSMutableArray *customterRecordIDList;
@property (nonatomic, strong) NSMutableArray *resultRecordList;
@property (nonatomic, strong) NSMutableArray *fyj_list;

@property (nonatomic, assign) BOOL isTiger;
@property (nonatomic, assign) BOOL isCow;
@property (nonatomic, assign) BOOL isCowWin;
@property (nonatomic, assign) BOOL isLucky;

@property (nonatomic, assign) int updateType;
@property (nonatomic, assign) int cowPointResult;

@property (nonatomic, strong) NSMutableArray *fsy_list;
@property (nonatomic, strong) NSArray *puciInfoList;
@property (nonatomic, strong) NSArray *curXz_setting;

@property (nonatomic, strong) EPSelectPopView *popView;
@property (nonatomic, strong) EPCowPointChooseShowView *cowPointShowView;
@property (nonatomic, strong) NSArray *updateLuzhuCustomerList;


@end

@implementation ModificationResultsView

- (EPCowPointChooseShowView *)cowPointShowView{
    if (!_cowPointShowView) {
        _cowPointShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPCowPointChooseShowView" owner:nil options:nil]lastObject];
        _cowPointShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _cowPointShowView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)cowPointAction:(id)sender {
    [[MJPopTool sharedInstance] popView:self.cowPointShowView animated:YES];
    @weakify(self);
    self.cowPointShowView.pointsResultBlock = ^(int curPoint) {
        @strongify(self);
        DLOG(@"curPoint===%d",curPoint);
        if (curPoint==99) {
            [self.cowPointBtn setTitle:@"没牛" forState:UIControlStateNormal];
        }else if (curPoint==10){
            [self.cowPointBtn setTitle:@"牛牛" forState:UIControlStateNormal];
        }else if (curPoint==11){
            [self.cowPointBtn setTitle:@"五花牛" forState:UIControlStateNormal];
        }else if (curPoint==12){
            [self.cowPointBtn setTitle:@"炸弹" forState:UIControlStateNormal];
        }else if (curPoint==13){
            [self.cowPointBtn setTitle:@"五小牛" forState:UIControlStateNormal];
        }else{
            [self.cowPointBtn setTitle:[NSString stringWithFormat:@"%d",curPoint] forState:UIControlStateNormal];
        }
        if (curPoint==99) {
            self.cowPointResult = 0;
        }else{
            self.cowPointResult = curPoint;
        }
        self.result_string = self.cowPointBtn.titleLabel.text;
        [self getCurLuzhuInfoRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
            if (self.updateLuzhuCustomerList.count!=0) {
                NSDictionary *luzhuDict = self.updateLuzhuCustomerList.firstObject;
                NSString *customer_dianshu = luzhuDict[@"fdianshu"];
                if (self.cowPointResult == [customer_dianshu intValue]) {
                    EPINSShowView *cowResultShowView = [[AppDelegate shareInstance]cowResultShowView];
                    [cowResultShowView showWithCowType];
                    [[MJPopTool sharedInstance] popView:cowResultShowView animated:YES];
                    @weakify(self);
                    cowResultShowView.INSResultBlock = ^(BOOL isWin) {
                        @strongify(self);
                        self.isCowWin = isWin;
                    };
                }else if (self.cowPointResult > [customer_dianshu intValue]){
                    self.isCowWin = NO;
                }else{
                    self.isCowWin = YES;
                }
            }
        }];
    };
}

- (IBAction)puciSelectAction:(id)sender {
    NSMutableArray *puciList = [NSMutableArray array];
    [self.puciInfoList enumerateObjectsUsingBlock:^(NSDictionary *infoDict, NSUInteger idx, BOOL * _Nonnull stop) {
        [puciList addObject:[NSString stringWithFormat:@"%@",infoDict[@"fpuci"]]];
    }];
    self.popView = [EPSelectPopView popViewWithFuncDicts:puciList LeftOffset:290 RightOffset:210 TopOffset:470 CoverColor:[UIColor clearColor] CellHeight:55];
    [self.popView showInKeyWindow];
    @weakify(self);
    self.popView.myFuncBlock = ^(NSInteger index){
        @strongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *puciDict = self.puciInfoList[index];
            self.puciValueLab.text = [NSString stringWithFormat:@"%@",puciDict[@"fpuci"]];
            self.curLuzhuID = [NSString stringWithFormat:@"%@",puciDict[@"fid"]];
        });
        [self.popView dismissFromKeyWindow];
    };
}


- (IBAction)zhuangAction:(id)sender {
    if (self.isTiger) {
        self.result_string = @"龙";
        self.updateType = 1;
        [self.zhuangBtn setSelected:YES];
        [self.xianBtn setSelected:NO];
        [self.zhuangDuiBtn setSelected:NO];
        [self.xianDuiBtn setSelected:NO];
        [self.heBtn setSelected:NO];
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
            [PublicHttpTool showSoundMessage:@"您不能选择此项"];
            return;
        }
        UIButton *btn = (UIButton *)sender;
        btn.selected = !btn.selected;
        if (btn.selected) {
            if (![self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
                [self.resultList addObject:[NSNumber numberWithInteger:1]];
            }
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:1]];
            }
            //去掉庄对
            if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:4]];
                [self.zhuangDuiBtn setSelected:NO];
            }
            //去掉闲对
            if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                [self.xianDuiBtn setSelected:NO];
            }
            //去掉幸运6,6点赢
            if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:6]];
                [self.zhuangSixBtn setSelected:NO];
            }
        }
    }
    
}
- (IBAction)xianAction:(id)sender {
    if (self.isTiger) {
        self.result_string = @"虎";
        self.updateType = 2;
        [self.zhuangBtn setSelected:NO];
        [self.xianBtn setSelected:YES];
        [self.zhuangDuiBtn setSelected:NO];
        [self.xianDuiBtn setSelected:NO];
        [self.heBtn setSelected:NO];
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
            [PublicHttpTool showSoundMessage:@"您不能选择此项"];
            return;
        }
        UIButton *btn = (UIButton *)sender;
        btn.selected = !btn.selected;
        if (btn.selected) {
            if (![self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                [self.resultList addObject:[NSNumber numberWithInteger:2]];
            }
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:2]];
            }
            //去掉庄对
            if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:4]];
                [self.zhuangDuiBtn setSelected:NO];
            }
            //去掉闲对
            if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:5]];
                [self.xianDuiBtn setSelected:NO];
            }
        }
    }
}
- (IBAction)heAction:(id)sender {
    if (self.isTiger) {
        self.result_string = @"和";
        self.updateType = 3;
        [self.zhuangBtn setSelected:NO];
        [self.xianBtn setSelected:NO];
        [self.zhuangDuiBtn setSelected:NO];
        [self.xianDuiBtn setSelected:NO];
        [self.heBtn setSelected:YES];
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:2]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
            [PublicHttpTool showSoundMessage:@"您不能选择此项"];
            return;
        }
        UIButton *btn = (UIButton *)sender;
        btn.selected = !btn.selected;
        if (btn.selected) {
            if (![self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                [self.resultList addObject:[NSNumber numberWithInteger:3]];
            }
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:3]];
            }
        }
    }
}

- (IBAction)zhuangDuiAction:(id)sender {
    if (self.isTiger) {
        self.updateType = 4;
        [self.zhuangBtn setSelected:NO];
        [self.xianBtn setSelected:NO];
        [self.zhuangDuiBtn setSelected:YES];
        [self.xianDuiBtn setSelected:NO];
        [self.heBtn setSelected:NO];
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
            if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                [PublicHttpTool showSoundMessage:@"您不能选择此项"];
                return;
            }
        }else{
            [PublicHttpTool showSoundMessage:@"请先选择庄或者闲"];
            return;
        }
        UIButton *btn = (UIButton *)sender;
        btn.selected = !btn.selected;
        if (btn.selected) {
            if (![self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                [self.resultList addObject:[NSNumber numberWithInteger:4]];
            }
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:4]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:4]];
            }
        }
    }
}
- (IBAction)xianDuiAction:(id)sender {
    if (self.isTiger) {
        self.updateType = 5;
        [self.zhuangBtn setSelected:NO];
        [self.xianBtn setSelected:NO];
        [self.zhuangDuiBtn setSelected:NO];
        [self.xianDuiBtn setSelected:YES];
        [self.heBtn setSelected:NO];
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
            if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                [PublicHttpTool showSoundMessage:@"您不能选择此项"];
                return;
            }
        }else{
            [PublicHttpTool showSoundMessage:@"请先选择庄或者闲"];
            return;
        }
        UIButton *btn = (UIButton *)sender;
        btn.selected = !btn.selected;
        if (btn.selected) {
            if (![self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                [self.resultList addObject:[NSNumber numberWithInteger:5]];
            }
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:5]];
            }
        }
    }
}
- (IBAction)zhuangSixAction:(id)sender {
    if (self.isTiger) {
        self.updateType = 6;
        [self.zhuangBtn setSelected:NO];
        [self.xianBtn setSelected:NO];
        [self.zhuangDuiBtn setSelected:NO];
        [self.xianDuiBtn setSelected:NO];
        [self.zhuangSixBtn setSelected:YES];
        [self.heBtn setSelected:NO];
    }else{
        if (![self.resultList containsObject:[NSNumber numberWithInteger:1]]) {
            [PublicHttpTool showSoundMessage:@"请先选择庄"];
            return;
        }
        UIButton *btn = (UIButton *)sender;
        btn.selected = !btn.selected;
        if (btn.selected) {
            if (![self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                [self.resultList addObject:[NSNumber numberWithInteger:6]];
            }
        }else{
            if ([self.resultList containsObject:[NSNumber numberWithInteger:6]]) {
                [self.resultList removeObject:[NSNumber numberWithInteger:6]];
            }
        }
    }
}

- (IBAction)OKAction:(id)sender {
    [EPSound playWithSoundName:@"click_sound"];
    if (self.cowPointResult==99) {
        [PublicHttpTool showSoundMessage:@"请选择牛牛点数"];
        return;
    }
    if (self.isTiger) {
        if (self.updateType==0) {
            [PublicHttpTool showSoundMessage:@"请选择结果"];
            return;
        }
    }else{
        if (!self.isCow) {
            if (self.resultList.count==0) {
                [PublicHttpTool showSoundMessage:@"请选择结果"];
                return;
            }
            NSMutableArray *reslutNameList = [NSMutableArray array];
            for (int i=0; i<self.resultList.count; i++) {
                NSInteger tagResult = [self.resultList[i]integerValue];
                if (tagResult==1) {
                    [reslutNameList addObject:@"庄"];
                }else if (tagResult==2){
                    [reslutNameList addObject:@"闲"];
                }else if (tagResult==3){
                    [reslutNameList addObject:@"和"];
                }else if (tagResult==4){
                    [reslutNameList addObject:@"庄对"];
                }else if (tagResult==5){
                    [reslutNameList addObject:@"闲对"];
                }else if (tagResult==6){
                    if (self.isLucky) {
                        [reslutNameList addObject:@"Lucky6"];
                    }else{
                        [reslutNameList addObject:@"6点赢"];
                    }
                }
            }
            self.result_string = [reslutNameList componentsJoinedByString:@","];
        }
    }
    [self removeFromSuperview];
    [self fengzhuangLuzhuCustomerInfo];
    EmpowerView *empowerView = [[AppDelegate shareInstance]empowerView];
    [[MJPopTool sharedInstance] popView:empowerView animated:YES];
    empowerView.sureActionBlock = ^(NSString * _Nonnull adminName, NSString * _Nonnull password) {
        [PublicHttpTool shareInstance].curupdateInfo.femp_num = adminName;
        [PublicHttpTool shareInstance].curupdateInfo.femp_pwd = password;
        [PublicHttpTool showWaitingView];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [PublicHttpTool authorizationAccountWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                if (success) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [PublicHttpTool updateLuzhuInfoRecordWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
                            [PublicHttpTool hideWaitingView];
                            if (success) {
                                if ([AppDelegate shareInstance].updateLuzhuResultBlock) {
                                    [AppDelegate shareInstance].updateLuzhuResultBlock(1);
                                }
                                [PublicHttpTool showSucceedSoundMessage:@"修改露珠成功"];
                            }else{
                                [PublicHttpTool showSoundMessage:msg];
                            }
                        }];
                    });
                }else{
                    [PublicHttpTool hideWaitingView];
                    [PublicHttpTool showSoundMessage:msg];
                }
            }];
        });
    };
}
- (IBAction)closeAction:(id)sender {
    [EPSound playWithSoundName:@"click_sound"];
    [self removeFromSuperview];
}

- (void)updateBottomViewBtnWithTag:(BOOL)isLonghu{
    self.isTiger = isLonghu;
    if (isLonghu) {
        [self.zhuangBtn setTitle:@"龙" forState:UIControlStateNormal];
        [self.xianBtn setTitle:@"虎" forState:UIControlStateNormal];
        self.zhuangDuiBtn.hidden = YES;
        self.xianDuiBtn.hidden = YES;
        self.zhuangSixBtn.hidden = YES;
    }else{
        self.resultList = [NSMutableArray array];
    }
}

- (void)updateBottomViewBtnBaijiale:(BOOL)isYouYong{
    self.isLucky = isYouYong;
    if (isYouYong) {
        [self.zhuangSixBtn setTitle:@"Lucky6" forState:UIControlStateNormal];
    }else{
        [self.zhuangSixBtn setTitle:@"6点赢" forState:UIControlStateNormal];
    }
}

- (void)clearAllButtons{
    self.cowPointResult = 0;
    self.isCow = NO;
    self.cowPointBtn.hidden = YES;
    [self.zhuangBtn setSelected:NO];
    [self.zhuangDuiBtn setSelected:NO];
    [self.xianBtn setSelected:NO];
    [self.xianDuiBtn setSelected:NO];
    [self.heBtn setSelected:NO];
    [self.zhuangSixBtn setSelected:NO];
}

- (void)updateBottomViewBtnNiuniu{
    self.cowPointResult = 99;
    self.isCow = YES;
    self.cowPointBtn.hidden = NO;
    self.zhuangBtn.hidden = YES;
    self.zhuangDuiBtn.hidden = YES;
    self.xianBtn.hidden = YES;
    self.xianDuiBtn.hidden = YES;
    self.heBtn.hidden = YES;
    self.zhuangSixBtn.hidden = YES;
}

- (void)fellViewDataWithList:(NSArray *)infoList{
    self.customterRecordIDList = [NSMutableArray array];
    self.resultRecordList = [NSMutableArray array];
    self.fyj_list = [NSMutableArray array];
    //输赢
    self.fsy_list = [NSMutableArray array];
    self.curXz_setting = [PublicHttpTool shareInstance].curXz_setting;
    self.puciInfoList = infoList;
    self.tableIDlab.text = [PublicHttpTool shareInstance].fid;
    self.dateValueLab.text = [NRCommand getCurrentDate];
    self.xueciValueLab.text = [NSString stringWithFormat:@"%d",[PublicHttpTool shareInstance].xueciCount];
    if (self.puciInfoList.count!=0) {
        NSDictionary *puciDict = [self.puciInfoList lastObject];
        self.puciValueLab.text = [NSString stringWithFormat:@"%@",puciDict[@"fpuci"]];
        self.curLuzhuID = [NSString stringWithFormat:@"%@",puciDict[@"fid"]];
        [self getCurLuzhuInfoRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        }];
        NSString *cp_result = puciDict[@"fkpresult"];
        if (!self.isTiger) {
            if (self.isCow) {
                if ([cp_result isEqualToString:@"没牛"]) {
                    self.cowPointResult = 0;
                }else if ([cp_result isEqualToString:@"牛牛"]){
                    self.cowPointResult = 10;
                }else if ([cp_result isEqualToString:@"五花牛"]){
                    self.cowPointResult = 11;
                }else if ([cp_result isEqualToString:@"炸弹"]){
                    self.cowPointResult = 12;
                }else if ([cp_result isEqualToString:@"五小牛"]){
                    self.cowPointResult = 13;
                }else{
                    self.cowPointResult = [cp_result intValue];
                }
                self.result_string = cp_result;
                [self.cowPointBtn setTitle:cp_result forState:UIControlStateNormal];
            }else{
                //判断结果
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.resultList removeAllObjects];
                    NSArray *resultList = [cp_result componentsSeparatedByString:@","];
                    if ([resultList containsObject:@"庄"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:1]];
                        [self.zhuangBtn setSelected:YES];
                    }
                    if ([resultList containsObject:@"庄对"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:4]];
                        [self.zhuangDuiBtn setSelected:YES];
                    }
                    if ([resultList containsObject:@"闲"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:2]];
                        [self.xianBtn setSelected:YES];
                    }else{
                        [self.xianBtn setSelected:NO];
                    }
                    if ([resultList containsObject:@"闲对"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:5]];
                        [self.xianDuiBtn setSelected:YES];
                    }
                    if ([resultList containsObject:@"和"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:3]];
                        [self.heBtn setSelected:YES];
                    }
                    if ([resultList containsObject:@"Lucky6"]||[resultList containsObject:@"6点赢"]) {
                        [self.resultList addObject:[NSNumber numberWithInt:6]];
                        [self.zhuangSixBtn setSelected:YES];
                    }
                });
            }
            
        }else{
            if ([cp_result isEqualToString:@"龙"]) {
                self.updateType = 1;
                [self.zhuangBtn setSelected:YES];
            }else if ([cp_result isEqualToString:@"虎"]){
                self.updateType = 2;
                [self.xianBtn setSelected:YES];
            }else{
                self.updateType = 3;
                [self.heBtn setSelected:YES];
            }
        }
    }
}

#pragma mark - 根据露珠ID获取当前露珠信息
- (void)getCurLuzhuInfoRecordWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"ftable_id":[PublicHttpTool shareInstance].fid,//桌子ID
                             @"fid":self.curLuzhuID//露珠ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"tablerec_luzhu_rec",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_Public_ListWithParamter:Realparam block:^(NSArray *list, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            self.updateLuzhuCustomerList = list;
        }
        block(suc, msg,error);
    }];
}

- (void)fengzhuangLuzhuCustomerInfo{
    if (self.updateLuzhuCustomerList.count!=0) {
        [self.customterRecordIDList removeAllObjects];
        [self.resultRecordList removeAllObjects];
        [self.fyj_list removeAllObjects];
        [self.fsy_list removeAllObjects];
        if (!self.isTiger) {
            if (!self.isCow) {
                NSMutableArray *reslutNameList = [NSMutableArray array];
                for (int i=0; i<self.resultList.count; i++) {
                    NSInteger tagResult = [self.resultList[i]integerValue];
                    if (tagResult==1) {
                        [reslutNameList addObject:@"庄"];
                    }else if (tagResult==2){
                        [reslutNameList addObject:@"闲"];
                    }else if (tagResult==3){
                        [reslutNameList addObject:@"和"];
                    }else if (tagResult==4){
                        [reslutNameList addObject:@"庄对"];
                    }else if (tagResult==5){
                        [reslutNameList addObject:@"闲对"];
                    }else if (tagResult==6){
                        if (self.isLucky) {
                            [reslutNameList addObject:@"Lucky6"];
                        }else{
                            [reslutNameList addObject:@"6点赢"];
                        }
                    }
                }
                self.result_string = [reslutNameList componentsJoinedByString:@","];
            }
        }
        [self.updateLuzhuCustomerList enumerateObjectsUsingBlock:^(NSDictionary *luzhuDict, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.customterRecordIDList addObject:luzhuDict[@"fid"]];
            if (self.isTiger) {
                [self.fyj_list addObject:@"0"];
                NSString *customer_resultName = luzhuDict[@"fxz_name"];
                NSString *customer_money = luzhuDict[@"fxz_money"];
                if ([self.result_string isEqualToString:@"龙"]) {
                    if ([customer_resultName isEqualToString:@"龙"]) {
                        //赔率
                        CGFloat odds = 0;
                        CGFloat yj = 0;
                        NSArray *xz_array = self.curXz_setting;
                        if (xz_array.count>0) {
                            odds = [xz_array[0][@"fpl"] floatValue];
                            yj = [xz_array[0][@"fyj"] floatValue]/100;
                        }
                        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                    }else if ([customer_resultName isEqualToString:@"虎"]){
                        [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                        [self.resultRecordList addObject:luzhuDict[@"fxz_money"]];
                    }else {
                        [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                        CGFloat resultValue = 0.5*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                    }
                }else if ([self.result_string isEqualToString:@"虎"]){
                    if ([customer_resultName isEqualToString:@"虎"]){
                        //赔率
                        CGFloat odds = 0;
                        CGFloat yj = 0;
                        NSArray *xz_array = self.curXz_setting;
                        if (xz_array.count>1) {
                            odds = [xz_array[1][@"fpl"] floatValue];
                            yj = [xz_array[1][@"fyj"] floatValue]/100;
                        }
                        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                    }else if ([customer_resultName isEqualToString:@"龙"]) {
                        [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                        [self.resultRecordList addObject:luzhuDict[@"fxz_money"]];
                    }else{
                        [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                        CGFloat resultValue = 0.5*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                    }
                }else{
                    if ([customer_resultName isEqualToString:@"和"]){
                        //赔率
                        CGFloat odds = 0;
                        CGFloat yj = 0;
                        NSArray *xz_array = self.curXz_setting;
                        if (xz_array.count>2) {
                            odds = [xz_array[2][@"fpl"] floatValue];
                            yj = [xz_array[2][@"fyj"] floatValue]/100;
                        }
                        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                    }else{
                        [self.fsy_list addObject:[NSNumber numberWithInt:0]];
                        [self.resultRecordList addObject:luzhuDict[@"fxz_money"]];
                    }
                }
            }else if (self.isCow){//牛牛
                NSString *customer_dianshu = luzhuDict[@"fdianshu"];
                NSString *customer_resultName = luzhuDict[@"fxz_name"];
                NSString *customer_money = luzhuDict[@"fxz_money"];
                //赔率
                NSArray *xz_array = self.curXz_setting;
                //超级翻倍
                NSDictionary *fplDict = xz_array[2][@"fpl"];
                NSDictionary *fyjDict = xz_array[2][@"fyj"];
                //翻倍
                NSDictionary *fplDict1 = xz_array[1][@"fpl"];
                NSDictionary *fyjDict1 = xz_array[1][@"fyj"];
                //平倍
                NSDictionary *fplDict2 = xz_array[0][@"fpl"];
                NSDictionary *fyjDict2 = xz_array[0][@"fyj"];
                if (self.isCowWin) {//闲家赢,需要减去佣金
                    [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                    if ([customer_resultName isEqualToString:@"超级翻倍"]) {
                        CGFloat superOdds = [[fplDict objectForKey:[NSString stringWithFormat:@"%@",customer_dianshu]]floatValue];
                        CGFloat superYj = [[fyjDict objectForKey:[NSString stringWithFormat:@"%@",customer_dianshu]]floatValue]/100;
                        CGFloat superYjValue = superYj*[customer_money integerValue];
                        CGFloat superResultValue = (1+superOdds-superYj*superOdds)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:superResultValue]];
                        [self.fyj_list addObject:[NSNumber numberWithDouble:superYjValue]];
                    }else if ([customer_resultName isEqualToString:@"翻倍"]){
                        CGFloat doubleOdds = [[fplDict1 objectForKey:[NSString stringWithFormat:@"%@",customer_dianshu]]floatValue];
                        CGFloat doubleYj = [[fyjDict1 objectForKey:[NSString stringWithFormat:@"%@",customer_dianshu]]floatValue]/100;
                        CGFloat doubleYjValue = doubleYj*[customer_money integerValue];
                        CGFloat doubleResultValue = (1+doubleOdds-doubleYj*doubleOdds)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:doubleResultValue]];
                        [self.fyj_list addObject:[NSNumber numberWithDouble:doubleYjValue]];
                    }else{
                        CGFloat Odds = [[fplDict2 objectForKey:[NSString stringWithFormat:@"%@",customer_dianshu]]floatValue];
                        CGFloat Yj = [[fyjDict2 objectForKey:[NSString stringWithFormat:@"%@",customer_dianshu]]floatValue]/100;
                        CGFloat YjValue = Yj*[customer_money integerValue];
                        CGFloat ResultValue = (1+Odds-Yj*Odds)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:ResultValue]];
                        [self.fyj_list addObject:[NSNumber numberWithDouble:YjValue]];
                    }
                }else{//庄家赢
                    [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                    [self.fyj_list addObject:[NSNumber numberWithInt:0]];
                    if ([customer_resultName isEqualToString:@"超级翻倍"]) {
                        CGFloat superOdds = [[fplDict objectForKey:[NSString stringWithFormat:@"%d",self.cowPointResult]]floatValue];
                        CGFloat superResultValue = superOdds*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:superResultValue]];
                    }else if ([customer_resultName isEqualToString:@"翻倍"]){
                        CGFloat doubleOdds = [[fplDict1 objectForKey:[NSString stringWithFormat:@"%d",self.cowPointResult]]floatValue];
                        CGFloat doubleResultValue = doubleOdds*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:doubleResultValue]];
                    }else{
                        CGFloat Odds = [[fplDict2 objectForKey:[NSString stringWithFormat:@"%d",self.cowPointResult]]floatValue];
                        CGFloat ResultValue = Odds*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:ResultValue]];
                    }
                }
            }else{
                NSString *customer_resultName = luzhuDict[@"fxz_name"];
                NSString *customer_money = luzhuDict[@"fxz_money"];
                if ([self.resultList containsObject:[NSNumber numberWithInt:1]]) {//庄
                    if ([customer_resultName isEqualToString:@"庄"]) {//庄
                        //赔率
                        CGFloat odds = 0;
                        CGFloat yj = 0;
                        NSArray *xz_array = self.curXz_setting;
                        if (xz_array.count>0) {
                            odds = [xz_array[0][@"fpl"] floatValue];
                            yj = [xz_array[0][@"fyj"] floatValue]/100;
                        }
                        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                        CGFloat yjValue = yj*[customer_money integerValue];
                        [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
                    }else if ([customer_resultName isEqualToString:@"6点赢"]){
                        //赔率
                        CGFloat odds = 0;
                        CGFloat yj = 0;
                        NSArray *xz_array = self.curXz_setting;
                        if (xz_array.count>6) {
                            odds = [xz_array[6][@"fpl"] floatValue];
                            yj = [xz_array[6][@"fyj"] floatValue]/100;
                        }
                        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                        CGFloat yjValue = yj*[customer_money integerValue];
                        [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
                    }else if ([customer_resultName isEqualToString:@"Lucky6"]){
                        //赔率
                        CGFloat odds = 0;
                        CGFloat yj = 0;
                        NSArray *xz_array = self.curXz_setting;
                        if (xz_array.count>7) {
                            odds = [xz_array[7][@"fpl"] floatValue];
                            yj = [xz_array[7][@"fyj"] floatValue]/100;
                        }
                        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                        CGFloat yjValue = yj*[customer_money integerValue];
                        [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
                    }else if ([customer_resultName isEqualToString:@"保险"]){
                        [self.fyj_list addObject:@"0"];
                        //赔率
                        CGFloat curMoneyValue = [customer_money doubleValue];
                        if (curMoneyValue>0) {
                            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                            [self.resultRecordList addObject:customer_money];
                        }else{
                            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                            [self.resultRecordList addObject:customer_money];
                        }
                    }else {
                        [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                        [self.resultRecordList addObject:customer_money];
                        [self.fyj_list addObject:@"0"];
                    }
                }
                if ([self.resultList containsObject:[NSNumber numberWithInt:2]]) {//闲
                    if ([customer_resultName isEqualToString:@"闲"]) {//闲
                        //赔率
                        CGFloat odds = 0;
                        CGFloat yj = 0;
                        NSArray *xz_array = self.curXz_setting;
                        if (xz_array.count>1) {
                            odds = [xz_array[1][@"fpl"] floatValue];
                            yj = [xz_array[1][@"fyj"] floatValue]/100;
                        }
                        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                        CGFloat yjValue = yj*[customer_money integerValue];
                        [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
                    }else if ([customer_resultName isEqualToString:@"保险"]){
                        [self.fyj_list addObject:@"0"];
                        //赔率
                        CGFloat curMoneyValue = [customer_money doubleValue];
                        if (curMoneyValue>0) {
                            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                            [self.resultRecordList addObject:customer_money];
                        }else{
                            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                            [self.resultRecordList addObject:customer_money];
                        }
                    }else{
                        [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                        [self.resultRecordList addObject:customer_money];
                        [self.fyj_list addObject:@"0"];
                    }
                }
                if ([self.resultList containsObject:[NSNumber numberWithInt:3]]) {//和
                    if ([customer_resultName isEqualToString:@"和"]) {//闲
                        //赔率
                        CGFloat odds = 0;
                        CGFloat yj = 0;
                        NSArray *xz_array = self.curXz_setting;
                        if (xz_array.count>4) {
                            odds = [xz_array[4][@"fpl"] floatValue];
                            yj = [xz_array[4][@"fyj"] floatValue]/100;
                        }
                        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                        CGFloat yjValue = yj*[customer_money integerValue];
                        [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
                    }else if ([customer_resultName isEqualToString:@"保险"]){
                        [self.fyj_list addObject:@"0"];
                        //赔率
                        CGFloat curMoneyValue = [customer_money doubleValue];
                        if (curMoneyValue>0) {
                            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                            [self.resultRecordList addObject:customer_money];
                        }else{
                            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                            [self.resultRecordList addObject:customer_money];
                        }
                    }else{
                        [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                        [self.resultRecordList addObject:customer_money];
                        [self.fyj_list addObject:@"0"];
                    }
                }
                if ([self.resultList containsObject:[NSNumber numberWithInt:4]]) {//庄对
                    if ([customer_resultName isEqualToString:@"庄对"]) {//庄
                        //赔率
                        CGFloat odds = 0;
                        CGFloat yj = 0;
                        NSArray *xz_array = self.curXz_setting;
                        if (xz_array.count>2) {
                            odds = [xz_array[2][@"fpl"] floatValue];
                            yj = [xz_array[2][@"fyj"] floatValue]/100;
                        }
                        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                        CGFloat yjValue = yj*[customer_money integerValue];
                        [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
                    }else if ([customer_resultName isEqualToString:@"保险"]){
                        [self.fyj_list addObject:@"0"];
                        //赔率
                        CGFloat curMoneyValue = [customer_money doubleValue];
                        if (curMoneyValue>0) {
                            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                            [self.resultRecordList addObject:customer_money];
                        }else{
                            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                            [self.resultRecordList addObject:customer_money];
                        }
                    }else{
                        [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                        [self.resultRecordList addObject:customer_money];
                        [self.fyj_list addObject:@"0"];
                    }
                }
                if ([self.resultList containsObject:[NSNumber numberWithInt:5]]) {//闲对
                    if ([customer_resultName isEqualToString:@"闲对"]) {//闲
                        //赔率
                        CGFloat odds = 0;
                        CGFloat yj = 0;
                        NSArray *xz_array = self.curXz_setting;
                        if (xz_array.count>3) {
                            odds = [xz_array[3][@"fpl"] floatValue];
                            yj = [xz_array[3][@"fyj"] floatValue]/100;
                        }
                        [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                        CGFloat resultValue = (1+odds-yj)*[customer_money integerValue];
                        [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                        CGFloat yjValue = yj*[customer_money integerValue];
                        [self.fyj_list addObject:[NSNumber numberWithDouble:yjValue]];
                    }else if ([customer_resultName isEqualToString:@"保险"]){
                        [self.fyj_list addObject:@"0"];
                        //赔率
                        CGFloat curMoneyValue = [customer_money doubleValue];
                        if (curMoneyValue>0) {
                            [self.fsy_list addObject:[NSNumber numberWithInt:1]];
                            [self.resultRecordList addObject:customer_money];
                        }else{
                            [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                            [self.resultRecordList addObject:customer_money];
                        }
                    }else{
                        [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                        [self.resultRecordList addObject:customer_money];
                        [self.fyj_list addObject:@"0"];
                    }
                }
            }
        }];
    }
    NSDictionary * param = @{
        @"access_token":[PublicHttpTool shareInstance].access_token,
        @"fid":self.curLuzhuID,//露珠ID
        @"fkpresult":self.result_string,//结果
        @"frecid_list":self.customterRecordIDList,//客人输赢记录ID
        @"fsy_list":self.fsy_list,//客人输赢记录
        @"fresult_list":self.resultRecordList,//
        @"fyj_list":self.fyj_list,//佣金
    };
    [PublicHttpTool shareInstance].updateParam = param;
}

@end
