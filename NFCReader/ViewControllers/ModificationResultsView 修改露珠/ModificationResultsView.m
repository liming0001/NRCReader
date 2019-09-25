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

@interface ModificationResultsView ()
//提交参数
@property (nonatomic, strong) NSString *curLoginToken;
@property (nonatomic, strong) NSString *curTableID;
@property (nonatomic, strong) NSString *curSerialnumber;
@property (nonatomic, assign) int curXueci;
@property (nonatomic, strong) NSString *curLuzhuID;
@property (nonatomic, strong) NSString *result_string;
@property (nonatomic, strong) NSMutableArray *resultList;
@property (nonatomic, strong) NSMutableArray *customterRecordIDList;
@property (nonatomic, strong) NSMutableArray *resultRecordList;
@property (nonatomic, strong) NSMutableArray *fyj_list;

@property (nonatomic, assign) BOOL isTiger;

//授权验证
@property (nonatomic, strong) EmpowerView *empowerView;
@property (nonatomic, assign) int updateType;

@property (nonatomic, strong) NSMutableArray *fsy_list;
@property (nonatomic, strong) NSArray *puciInfoList;
@property (nonatomic, strong) NSArray *curXz_setting;

@property (nonatomic, strong) EPSelectPopView *popView;


@end

@implementation ModificationResultsView

- (EmpowerView *)empowerView{
    if (!_empowerView) {
        _empowerView = [[[NSBundle mainBundle]loadNibNamed:@"EmpowerView" owner:nil options:nil]lastObject];
        _empowerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _empowerView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
        self.result_string = @"龙赢";
        self.updateType = 1;
        [self.zhuangBtn setSelected:YES];
        [self.xianBtn setSelected:NO];
        [self.zhuangDuiBtn setSelected:NO];
        [self.xianDuiBtn setSelected:NO];
        [self.heBtn setSelected:NO];
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:2]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
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
        }
    }
    
}
- (IBAction)xianAction:(id)sender {
    if (self.isTiger) {
        self.result_string = @"虎赢";
        self.updateType = 2;
        [self.zhuangBtn setSelected:NO];
        [self.xianBtn setSelected:YES];
        [self.zhuangDuiBtn setSelected:NO];
        [self.xianDuiBtn setSelected:NO];
        [self.heBtn setSelected:NO];
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
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
        }
    }
}
- (IBAction)heAction:(id)sender {
    if (self.isTiger) {
        self.result_string = @"和局";
        self.updateType = 3;
        [self.zhuangBtn setSelected:NO];
        [self.xianBtn setSelected:NO];
        [self.zhuangDuiBtn setSelected:NO];
        [self.xianDuiBtn setSelected:NO];
        [self.heBtn setSelected:YES];
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:2]]||[self.resultList containsObject:[NSNumber numberWithInteger:4]]||[self.resultList containsObject:[NSNumber numberWithInteger:5]]) {
            [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
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
        self.result_string = @"闲";
        self.updateType = 4;
        [self.zhuangBtn setSelected:NO];
        [self.xianBtn setSelected:NO];
        [self.zhuangDuiBtn setSelected:YES];
        [self.xianDuiBtn setSelected:NO];
        [self.heBtn setSelected:NO];
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
            if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                return;
            }
        }else{
            [[EPToast makeText:@"请先选择庄或者闲"]showWithType:ShortTime];
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
        self.result_string = @"闲对";
        self.updateType = 5;
        [self.zhuangBtn setSelected:NO];
        [self.xianBtn setSelected:NO];
        [self.zhuangDuiBtn setSelected:NO];
        [self.xianDuiBtn setSelected:YES];
        [self.heBtn setSelected:NO];
    }else{
        if ([self.resultList containsObject:[NSNumber numberWithInteger:1]]||[self.resultList containsObject:[NSNumber numberWithInteger:2]]) {
            if ([self.resultList containsObject:[NSNumber numberWithInteger:3]]) {
                [[EPToast makeText:@"您不能选择此项"]showWithType:ShortTime];
                return;
            }
        }else{
            [[EPToast makeText:@"请先选择庄或者闲"]showWithType:ShortTime];
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

- (void)showWaitingViewInWindow {
    UIView *window = [self findWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.layer.zPosition = 100;
}

- (UIView *)findWindow {
    UIView *window = [[UIApplication sharedApplication] keyWindow];
    if (!window) {
        window = self;
    }
    return window;
}

- (void)hideWaitingViewInWindow {
    UIView *window = [self findWindow];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

- (IBAction)OKAction:(id)sender {
    if (self.isTiger) {
        if (self.updateType==0) {
            [[EPToast makeText:@"请选择结果" WithError:YES]showWithType:ShortTime];
            return;
        }
    }else{
        if (self.resultList.count==0) {
            [[EPToast makeText:@"请选择结果" WithError:YES]showWithType:ShortTime];
            return;
        }
    }
    [self removeFromSuperview];
    @weakify(self);
    [[UIApplication sharedApplication].keyWindow addSubview:self.empowerView];
    self.empowerView.sureActionBlock = ^(NSString * _Nonnull adminName, NSString * _Nonnull password) {
        @strongify(self);
        [self showWaitingViewInWindow];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self authorizationAccountWitAccountName:adminName Password:password Block:^(BOOL success, NSString *msg, EPSreviceError error) {
                if (success) {
                    [self getCurLuzhuInfoRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                        if (success) {
                            [self updateLuzhuInfoRecordWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
                                [self hideWaitingViewInWindow];
                                if (success) {
                                    [[EPToast makeText:@"修改露珠成功" WithError:NO]showWithType:ShortTime];
                                    //响警告声音
                                    [EPSound playWithSoundName:@"succeed_sound"];
                                    if (self.sureActionBlock) {
                                        self.sureActionBlock(YES);
                                    }
                                }else{
                                    [[EPToast makeText:@"修改露珠失败" WithError:YES]showWithType:ShortTime];
                                    //响警告声音
                                    [EPSound playWithSoundName:@"wram_sound"];
                                }
                            }];
                        }else{
                            [self hideWaitingViewInWindow];
                            [[EPToast makeText:@"修改露珠失败" WithError:YES]showWithType:ShortTime];
                            //响警告声音
                            [EPSound playWithSoundName:@"wram_sound"];
                        }
                    }];
                }else{
                    NSString *messgae = [msg NullToBlankString];
                    if (messgae.length == 0) {
                        messgae = @"网络异常";
                    }
                    [[EPToast makeText:messgae WithError:YES]showWithType:ShortTime];
                    //响警告声音
                    [EPSound playWithSoundName:@"wram_sound"];
                }
            }];
        });
    };
}
- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}

- (void)updateBottomViewBtnWithTag:(BOOL)isLonghu{
    self.isTiger = isLonghu;
    if (isLonghu) {
        [self.zhuangBtn setTitle:@"龙" forState:UIControlStateNormal];
        [self.xianBtn setTitle:@"虎" forState:UIControlStateNormal];
        self.zhuangDuiBtn.hidden = YES;
        self.xianDuiBtn.hidden = YES;
    }else{
        self.resultList = [NSMutableArray array];
    }
}

- (void)fellViewDataWithLoginID:(NSString *)loginId TableID:(NSString *)tableId Xueci:(int)xueci List:(NSArray *)infoList Xz_setting:(NSArray *)xz_setting{
    self.customterRecordIDList = [NSMutableArray array];
    self.resultRecordList = [NSMutableArray array];
    self.fyj_list = [NSMutableArray array];
    
    self.puciInfoList = infoList;
    self.curLoginToken = loginId;
    self.curTableID = tableId;
    self.curXueci = xueci;
    self.tableIDlab.text = tableId;
    self.dateValueLab.text = [NRCommand getCurrentDate];
    self.xueciValueLab.text = [NSString stringWithFormat:@"%d",xueci];
    if (self.puciInfoList.count!=0) {
        NSDictionary *puciDict = self.puciInfoList[0];
        self.puciValueLab.text = [NSString stringWithFormat:@"%@",puciDict[@"fpuci"]];
        self.curLuzhuID = [NSString stringWithFormat:@"%@",puciDict[@"fid"]];
    }
}

#pragma mark - 根据露珠ID获取当前露珠信息
- (void)getCurLuzhuInfoRecordWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"ftable_id":self.curTableID,//桌子ID
                             @"fid":self.curLuzhuID//露珠ID
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"tablerec_luzhu_rec",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_Public_ListWithParamter:Realparam block:^(NSArray *list, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            if (list.count!=0) {
                [self.customterRecordIDList removeAllObjects];
                [self.resultRecordList removeAllObjects];
                [self.fyj_list removeAllObjects];
                //输赢
                self.fsy_list = [NSMutableArray array];
                if (!self.isTiger) {
                    NSMutableArray *reslutNameList = [NSMutableArray array];
                    for (int i=0; i<self.resultList.count; i++) {
                        NSInteger tagResult = [self.resultList[i]integerValue];
                        if (tagResult==1) {
                            [reslutNameList addObject:@"庄赢"];
                        }else if (tagResult==2){
                            [reslutNameList addObject:@"闲赢"];
                        }else if (tagResult==3){
                            [reslutNameList addObject:@"和"];
                        }else if (tagResult==4){
                            [reslutNameList addObject:@"庄对"];
                        }else if (tagResult==5){
                            [reslutNameList addObject:@"闲对"];
                        }
                    }
                    self.result_string = [reslutNameList componentsJoinedByString:@","];
                }
                [list enumerateObjectsUsingBlock:^(NSDictionary *luzhuDict, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.customterRecordIDList addObject:luzhuDict[@"fid"]];
                    if (self.isTiger) {
                        [self.fyj_list addObject:@"0"];
                        NSString *customer_resultName = luzhuDict[@"fxz_name"];
                        NSString *customer_money = luzhuDict[@"fxz_money"];
                        if ([self.result_string isEqualToString:@"龙赢"]) {
                            if ([customer_resultName isEqualToString:@"龙赢"]||[customer_resultName isEqualToString:@"龙"]) {
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
                            }else if ([customer_resultName isEqualToString:@"虎赢"]||[customer_resultName isEqualToString:@"虎"]){
                                [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                                [self.resultRecordList addObject:luzhuDict[@"fxz_money"]];
                            }else {
                                [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                                CGFloat resultValue = 0.5*[customer_money integerValue];
                                [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                            }
                            
                        }else if ([self.result_string isEqualToString:@"虎赢"]){
                            if ([customer_resultName isEqualToString:@"虎赢"]||[customer_resultName isEqualToString:@"虎"]){
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
                            }else if ([customer_resultName isEqualToString:@"龙赢"]||[customer_resultName isEqualToString:@"龙"]) {
                                [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                                [self.resultRecordList addObject:luzhuDict[@"fxz_money"]];
                            }else{
                                [self.fsy_list addObject:[NSNumber numberWithInt:-1]];
                                CGFloat resultValue = 0.5*[customer_money integerValue];
                                [self.resultRecordList addObject:[NSNumber numberWithDouble:resultValue]];
                            }
                        }else{
                            if ([customer_resultName isEqualToString:@"和局"]||[customer_resultName isEqualToString:@"和"]){
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
                    }else{
                        NSString *customer_resultName = luzhuDict[@"fxz_name"];
                        NSString *customer_money = luzhuDict[@"fxz_money"];
                        if ([self.resultList containsObject:[NSNumber numberWithInt:1]]) {//庄
                            if ([customer_resultName isEqualToString:@"庄"]||[customer_resultName isEqualToString:@"庄赢"]) {//庄
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
                            }else if ([customer_resultName isEqualToString:@"6点赢"]||[customer_resultName isEqualToString:@"庄6点赢"]){
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
                            }else if ([customer_resultName isEqualToString:@"保险"]){
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
                            }
                        }
                        
                        if ([self.resultList containsObject:[NSNumber numberWithInt:2]]) {//闲
                            if ([customer_resultName isEqualToString:@"闲"]||[customer_resultName isEqualToString:@"闲赢"]) {//闲
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
                            }
                        }
                        
                        if ([self.resultList containsObject:[NSNumber numberWithInt:3]]) {//和
                            if ([customer_resultName isEqualToString:@"和"]||[customer_resultName isEqualToString:@"和局"]) {//闲
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
                            }
                        }
                    }
                }];
            }
        }
        block(suc, msg,error);
        
    }];
}

#pragma mark - 修改露珠
- (void)updateLuzhuInfoRecordWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"fid":self.curLuzhuID,//露珠ID
                             @"fkpresult":self.result_string,//结果
                             @"frecid_list":self.customterRecordIDList,//客人输赢记录ID
                             @"fsy_list":self.fsy_list,//客人输赢记录
                             @"fresult_list":self.resultRecordList,//
                             @"frecid_list":self.customterRecordIDList,//客人输赢记录ID
                             @"fyj_list":self.fyj_list,//佣金
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Tablerec_luzhu_edit",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
        }
        block(suc, msg,error);
        
    }];
}

#pragma mark - 验证账号
- (void)authorizationAccountWitAccountName:(NSString *)accountName Password:(NSString *)password Block:(EPFeedbackWithErrorCodeBlock)block{
    NSDictionary * param = @{
                             @"access_token":self.curLoginToken,
                             @"femp_num":accountName,
                             @"femp_pwd":password
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"employee_chkadmin",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        block(suc, msg,error);
    }];
}

@end
