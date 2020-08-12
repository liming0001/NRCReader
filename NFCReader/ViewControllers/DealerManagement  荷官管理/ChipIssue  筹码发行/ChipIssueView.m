//
//  ChipIssueView.m
//  NFCReader
//
//  Created by 李黎明 on 2020/7/27.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "ChipIssueView.h"
#import "NRChipCodeItem.h"
#import "NRChipManagerInfo.h"
#import "NRChipInfo.h"
#import "NRChipAllInfo.h"

@interface ChipIssueView ()

@property (nonatomic, strong) UIButton *chipIssueButton;
@property (nonatomic, strong) UIView *chipIssueView;
@property (nonatomic, strong) UIView *chipIssue_typeView;
@property (nonatomic, strong) UIView *chipIssue_fmeView;
@property (nonatomic, strong) NSMutableArray *chipFmeList;
@property (nonatomic, strong) UILabel *scanChipNumberLab;
@property (nonatomic, strong) NSMutableArray *chipIssueList;
@property (nonatomic, strong) NSMutableArray *chipTypeItemList;
@property (nonatomic, strong) NSMutableArray *chipFmeItemList;
@property (nonatomic, strong) NRChipCodeItem *chipTypeSelectedItem;
@property (nonatomic, strong) NRChipCodeItem *chipFmeSelectedItem;

@property (nonatomic, strong) UILabel *cashValueLab;
@property (nonatomic, strong) UILabel *serialNumberLab;
@property (nonatomic, strong) UITextField *serialNumberTextFiled;
@property (nonatomic, strong) UILabel *batchLab;
@property (nonatomic, strong) UITextField *batchTextFiled;
@property (nonatomic, strong) UIButton *chipissueButton;

//筹码类型
@property (nonatomic, strong) UILabel *cashTypeLab;

@property (nonatomic, strong) NSMutableArray *chipInfoList;

@property (nonatomic, strong) NSMutableDictionary *chooseChipInfoDict;

@end

@implementation ChipIssueView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.chipInfoList = [NSMutableArray arrayWithCapacity:0];
    self.chooseChipInfoDict = [NSMutableDictionary dictionary];
    [self _setUpBaseView];
    return self;
}

#pragma mark - 筹码发行界面
- (void)_setUpBaseView{
    @weakify(self);
    [PublicHttpTool getChipTypeWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        @strongify(self);
        if (success) {
            NSArray *list = [NSArray yy_modelArrayWithClass:[NRChipInfo class] json:data];
            NSArray *sortList = [self shaiXuanWithList:list];
            [sortList enumerateObjectsUsingBlock:^(NSArray *infoList, NSUInteger idx, BOOL * _Nonnull stop) {
                NRChipAllInfo *allInfo = [[NRChipAllInfo alloc]init];
                if (infoList.count!=0) {
                    NRChipInfo *info = infoList.firstObject;
                    allInfo.fcmtype = info.fcmtype;
                    allInfo.fcmtype_name = info.fcmtype_name;
                }
                allInfo.list = infoList;
                [self.chipInfoList addObject:allInfo];
                [PublicHttpTool shareInstance].chipTypeList = self.chipInfoList;
                dispatch_async(dispatch_get_main_queue(), ^{
                    //筹码发行界面
                    [self chipIssueShowView];
                });
            }];
        }
    }];
}

#pragma mark - 筹码发行界面
- (void)chipIssueShowView{
    self.chipTypeItemList = [NSMutableArray arrayWithCapacity:0];
    self.chipIssueView = [UIView new];
    self.chipIssueView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.chipIssueView];
    [self.chipIssueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(0);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    int chip_row = 0;
    int listCount = (int)self.chipInfoList.count;
    if ((listCount/3) != 0) {
        chip_row = listCount/3+1;
    }else{
        chip_row = listCount/3;
    }
    
    int typeView_h = 40 + chip_row*(40+20);
    self.chipIssue_typeView = [UIView new];
    self.chipIssue_typeView.backgroundColor = [UIColor clearColor];
    [self.chipIssueView addSubview:self.chipIssue_typeView];
    [self.chipIssue_typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssueView).offset(80);
        make.left.equalTo(self.chipIssueView);
        make.right.equalTo(self.chipIssueView);
        make.height.mas_equalTo(typeView_h);
    }];
    
    self.cashTypeLab = [UILabel new];
    self.cashTypeLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.cashTypeLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.cashTypeLab.textAlignment = NSTextAlignmentRight;
    self.cashTypeLab.numberOfLines = 0;
    self.cashTypeLab.text = @"筹码类型:";
    [self.chipIssue_typeView addSubview:self.cashTypeLab];
    [self.cashTypeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssue_typeView).offset(0);
        make.left.equalTo(self.chipIssue_typeView).offset(40);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    CGFloat item_width = (kScreenWidth-200-80-40-40-40-20)/3;
    int chipTypeCount = 0;
    for (int i=0; i<listCount; i++) {
        NSInteger rowCount =3;
        NRChipAllInfo *chipallInfo = self.chipInfoList[i];
        NRChipCodeItem *prechipCode = [[NRChipCodeItem alloc]initWithTitle:chipallInfo.fcmtype_name];
        [self.chipTypeItemList addObject:prechipCode];
        if (i==0) {
            self.chipFmeList = [NSMutableArray arrayWithCapacity:0];
            [self.chipFmeList addObjectsFromArray:chipallInfo.list];
            [prechipCode checkSelected];
            self.chipTypeSelectedItem = prechipCode;
            NRChipAllInfo *chipallInfo = self.chipInfoList[i];
            int intType = [chipallInfo.fcmtype intValue];
            [self.chooseChipInfoDict setValue:[NSString stringWithFormat:@"%02d",intType] forKey:@"chipType"];
        }
        prechipCode.tag = i+100;
        [self.chipIssue_typeView addSubview:prechipCode];
        if (i <= (rowCount -1)) {
            [prechipCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.chipIssue_typeView).offset(0);
                if (i== 0) {
                    make.left.equalTo(self.cashTypeLab.mas_right).offset(40);
                }else if(i == 1){
                    make.left.equalTo(self.cashTypeLab.mas_right).offset(item_width+40+20);
                }else if(i ==2){
                    make.right.equalTo(self.chipIssue_typeView.mas_right).offset(-20);
                }
                make.width.mas_equalTo(item_width);
                make.height.mas_equalTo(40);
            }];
            if (i == rowCount - 1 ){
                chipTypeCount = i;
            }
        }else if(i>(rowCount-1)){
            NRChipCodeItem *topchipCode = (NRChipCodeItem *)[self.chipIssue_typeView viewWithTag:chipTypeCount+100];
            [prechipCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(topchipCode.mas_bottom).offset(20);
                if(i%rowCount == 0){
                    make.left.equalTo(self.cashTypeLab.mas_right).with.offset(40);
                }else if(i%rowCount == 1){
                    make.left.equalTo(self.cashTypeLab.mas_right).offset(item_width+40+20);
                }else if(i%rowCount == 2){
                    make.right.equalTo(self.chipIssue_typeView.mas_right).offset(-20);
                }
                make.width.mas_equalTo(item_width);
                make.height.mas_equalTo(40);
            }];
            if(i%rowCount == 2){
                chipTypeCount = i;
            }
        }
    }
    //展示初始化界面
    [self displayChipFme];
    //筹码类型
    for (int i=0; i<self.chipTypeItemList.count; i++) {
        NRChipCodeItem *chipType = self.chipTypeItemList[i];
        @weakify(self);
        [chipType.selectSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if (chipType!=self.chipTypeSelectedItem) {
                [self.chipTypeSelectedItem checkSelectUn];
                [chipType checkSelected];
                self.chipTypeSelectedItem = chipType;
            }else{
                [self.chipTypeSelectedItem checkSelected];
            }
            NRChipAllInfo *chipallInfo = self.chipInfoList[i];
            [self.chipFmeList removeAllObjects];
            [self.chipFmeList addObjectsFromArray:chipallInfo.list];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self displayChipFme];
            });
            int intType = [chipallInfo.fcmtype intValue];
            [self.chooseChipInfoDict setValue:[NSString stringWithFormat:@"%02d",intType] forKey:@"chipType"];
        }];
    }
}

#pragma mark - 展示筹码面额
- (void)displayChipFme{
    int chip_fme_row = 0;
    int list_fme_Count = (int)self.chipFmeList.count;
    if ((list_fme_Count%3) != 0) {//不可以整除
        chip_fme_row = list_fme_Count/3;
    }else{//可以整除
        chip_fme_row = list_fme_Count/3;
        if (chip_fme_row>0) {
            chip_fme_row-=1;
        }
    }
    int typeView_fme_h = 40 + chip_fme_row*(40+20);
    [self.chipIssue_fmeView  removeFromSuperview];
    self.chipIssue_fmeView = nil;
    self.chipIssue_fmeView = [UIView new];
    self.chipIssue_fmeView.backgroundColor = [UIColor clearColor];
    [self.chipIssueView addSubview:self.chipIssue_fmeView];
    [self.chipIssue_fmeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssue_typeView.mas_bottom).offset(20);
        make.left.equalTo(self.chipIssueView);
        make.right.equalTo(self.chipIssueView);
        make.height.mas_equalTo(typeView_fme_h);
    }];
    
    [self.chipIssue_fmeView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    if (!self.cashValueLab) {
        self.cashValueLab = [UILabel new];
    }
    self.cashValueLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.cashValueLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.cashValueLab.textAlignment = NSTextAlignmentRight;
    self.cashValueLab.numberOfLines = 0;
    self.cashValueLab.text = @"筹码面额:";
    [self.chipIssue_fmeView addSubview:self.cashValueLab];
    [self.cashValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssue_typeView.mas_bottom).offset(20);
        make.left.equalTo(self.chipIssue_typeView).offset(40);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];
    
    self.chipFmeItemList = [NSMutableArray arrayWithCapacity:0];
    CGFloat item_width = (kScreenWidth-200-80-40-40-40-20)/3;
    int chipType_fme_Count = 0;
    for (int i=0; i<self.chipFmeList.count; i++) {
        NSInteger rowCount =3;
        NRChipInfo *chipallInfo = self.chipFmeList[i];
        NRChipCodeItem *prechipCode = [[NRChipCodeItem alloc]initWithTitle:chipallInfo.fme];
        [self.chipFmeItemList addObject:prechipCode];
        if (i==0) {
            [prechipCode checkSelected];
            self.chipFmeSelectedItem = prechipCode;
            NRChipInfo *chipallInfo = self.chipFmeList[i];
            [self.chooseChipInfoDict setValue:[NSString stringWithFormat:@"%@",chipallInfo.fme] forKey:@"chipMoney"];
        }
        prechipCode.tag = i+1000;
        [self.chipIssue_fmeView addSubview:prechipCode];
        if (i <= (rowCount -1)) {
            [prechipCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.chipIssue_fmeView).offset(0);
                if (i== 0) {
                    make.left.equalTo(self.cashValueLab.mas_right).offset(40);
                }else if(i == 1){
                    make.left.equalTo(self.cashValueLab.mas_right).offset(item_width+40+20);
                }else if(i ==2){
                    make.right.equalTo(self.chipIssue_fmeView.mas_right).offset(-20);
                }
                make.width.mas_equalTo(item_width);
                make.height.mas_equalTo(40);
            }];
            if (i == rowCount - 1 ){
                chipType_fme_Count = i;
            }
        }else if(i>(rowCount-1)){
            NRChipCodeItem *topchipCode = (NRChipCodeItem *)[self.chipIssue_fmeView viewWithTag:chipType_fme_Count+1000];
            [prechipCode mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(topchipCode.mas_bottom).offset(20);
                if(i%rowCount == 0){
                    make.left.equalTo(self.cashValueLab.mas_right).with.offset(40);
                }
                else if(i%rowCount == 1){
                    make.left.equalTo(self.cashValueLab.mas_right).offset(item_width+40+20);
                }else if(i%rowCount == 2){
                    make.right.equalTo(self.chipIssue_fmeView.mas_right).offset(-20);
                }
                make.width.mas_equalTo(item_width);
                make.height.mas_equalTo(40);
            }];
            if(i%rowCount == 2){
                chipType_fme_Count = i;
            }
        }
    }
    if (!self.serialNumberLab) {
        self.serialNumberLab = [UILabel new];
    }
    self.serialNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.serialNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.serialNumberLab.textAlignment = NSTextAlignmentRight;
    self.serialNumberLab.numberOfLines = 0;
    self.serialNumberLab.text = @"序号:";
    [self.chipIssueView addSubview:self.serialNumberLab];
    [self.serialNumberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssue_fmeView.mas_bottom).offset(60);
        make.left.equalTo(self.chipIssueView).offset(40);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    if (!self.serialNumberTextFiled) {
        self.serialNumberTextFiled = [UITextField new];
    }
    self.serialNumberTextFiled.layer.cornerRadius = 5;
    self.serialNumberTextFiled.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.serialNumberTextFiled.layer.borderWidth = 1;
    self.serialNumberTextFiled.text = @"01";
    self.serialNumberTextFiled.enabled = NO;
    self.serialNumberTextFiled.textColor = [UIColor colorWithHexString:@"#ffffff"];
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.serialNumberTextFiled.leftView = leftview;
    self.serialNumberTextFiled.leftViewMode = UITextFieldViewModeAlways;
    [self.chipIssueView addSubview:self.serialNumberTextFiled];
    [self.serialNumberTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chipIssue_fmeView.mas_bottom).offset(55);
        make.left.equalTo(self.serialNumberLab.mas_right).offset(40);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    if (!self.batchLab) {
        self.batchLab = [UILabel new];
    }
    self.batchLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.batchLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.batchLab.textAlignment = NSTextAlignmentRight;
    self.batchLab.numberOfLines = 0;
    self.batchLab.text = @"批次:";
    [self.chipIssueView addSubview:self.batchLab];
    [self.batchLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serialNumberLab.mas_bottom).offset(50);
        make.left.equalTo(self.chipIssueView).offset(40);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(80);
    }];
    
    if (!self.batchTextFiled) {
        self.batchTextFiled = [UITextField new];
    }
    self.batchTextFiled.layer.cornerRadius = 5;
    self.batchTextFiled.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.batchTextFiled.layer.borderWidth = 1;
    NSString *batchString = [NRCommand getCurrentTimes];
    self.batchTextFiled.text = batchString;
    self.batchTextFiled.textColor = [UIColor colorWithHexString:@"#ffffff"];
    UIView *batchleftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.batchTextFiled.leftView = batchleftview;
    self.batchTextFiled.leftViewMode = UITextFieldViewModeAlways;
    [self.chipIssueView addSubview:self.batchTextFiled];
    [self.batchTextFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.serialNumberTextFiled.mas_bottom).offset(40);
        make.left.equalTo(self.batchLab.mas_right).offset(40);
        make.width.mas_equalTo(200);
        make.height.mas_equalTo(30);
    }];
    
    if (!self.chipissueButton) {
        self.chipissueButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    [self.chipissueButton setTitle:@"立即发行" forState:UIControlStateNormal];
    self.chipissueButton.layer.cornerRadius = 5;
    self.chipissueButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.chipissueButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    [self.chipissueButton setTitleColor:[UIColor colorWithHexString:@"#52a938"] forState:UIControlStateSelected];
    self.chipissueButton.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.chipissueButton addTarget:self action:@selector(chipIssueImmediatelyAction) forControlEvents:UIControlEventTouchUpInside];
    [self.chipIssueView addSubview:self.chipissueButton];
    [self.chipissueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.batchTextFiled.mas_bottom).offset(100);
        make.left.equalTo(self.chipIssueView).offset(100);
        make.height.mas_equalTo(50);
        make.centerX.equalTo(self.chipIssueView);
    }];
    
    //筹码面值
    for (int i=0; i<self.chipFmeItemList.count; i++) {
        NRChipCodeItem *chipFme = self.chipFmeItemList[i];
        @weakify(self);
        [chipFme.selectSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            if (chipFme!=self.chipFmeSelectedItem) {
                [self.chipFmeSelectedItem checkSelectUn];
                [chipFme checkSelected];
                self.chipFmeSelectedItem = chipFme;
            }else{
                [self.chipFmeSelectedItem checkSelected];
            }
            NRChipInfo *chipallInfo = self.chipFmeList[i];
            [self.chooseChipInfoDict setValue:[NSString stringWithFormat:@"%@",chipallInfo.fme] forKey:@"chipMoney"];
        }];
    }
    
    @weakify(self);
    [[self.batchTextFiled rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if ([[x NullToBlankString] length]==8) {
            [self.chooseChipInfoDict setValue:[NSString stringWithFormat:@"%@",self.batchTextFiled.text] forKey:@"chipBatch"];
            [self getOrderByBatch];
        }
    }];
}

- (void)chipIssueImmediatelyAction{
    [EPSound playWithSoundName:@"click_sound"];
    if (self.issueBtnBlock) {
        self.issueBtnBlock(self.chooseChipInfoDict);
    }
}

- (NSArray *)shaiXuanWithList:(NSArray *)list{
    NSMutableArray *array = [NSMutableArray arrayWithArray:list];
    NSMutableArray *dateMutablearray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < array.count; i ++) {
        NRChipInfo *chipInfo = array[i];
        NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
        [tempArray addObject:chipInfo];
        for (int j = i+1; j < array.count; j ++) {
            NRChipInfo *jChipInfo = array[j];
            if([chipInfo.fcmtype isEqualToString:jChipInfo.fcmtype]){
                
                [tempArray addObject:jChipInfo];
                [array removeObjectAtIndex:j];
                j -= 1;
            }
        }
        [dateMutablearray addObject:tempArray];
    }
    return dateMutablearray;
}

#pragma mark - 根据批次号获取最新批次序号
- (void)getOrderByBatch{
    NSDictionary * param = @{
                             @"access_token":[PublicHttpTool shareInstance].access_token,
                             @"fbatch":self.batchTextFiled.text
                             };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                                 @"f":@"Cmpublish_getOrderByBatch",
                                 @"p":[paramList JSONString]
                                 };
    [EPService nr_String_PublicWithParamter:Realparam block:^(NSString *responseString, NSString *msg, EPSreviceError error, BOOL suc) {
        if (suc) {
            if ([[responseString NullToBlankString]length]!=0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.serialNumberTextFiled.text = responseString;
                    [self.chooseChipInfoDict setValue:[NSString stringWithFormat:@"%@",responseString] forKey:@"chipSerialNumber"];
                });
            }
        }
    }];
}

@end
