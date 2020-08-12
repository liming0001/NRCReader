//
//  ChipInfoHeader.m
//  NFCReader
//
//  Created by 李黎明 on 2020/7/28.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "ChipInfoHeader.h"

@interface ChipInfoHeader ()

@property (nonatomic, strong) UILabel *exchangNumberLab;
@property (nonatomic, strong) UILabel *exchangTotalMoneyLab;
@property (nonatomic, strong) UILabel *exchangMoneyLab;

@property (nonatomic, strong) UILabel *takeOutChipMoneyLab;
@property (nonatomic, strong) UILabel *takeOutChipMoneyValueLab;

@end

@implementation ChipInfoHeader

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self _setUpBaseView];
    return self;
}

- (void)_setUpBaseView{
    self.backgroundColor = [UIColor colorWithHexString:@"#666666"];
    self.exchangNumberLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, 150, 20)];
    self.exchangNumberLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.exchangNumberLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.exchangNumberLab.numberOfLines = 0;
    self.exchangNumberLab.text = @"筹码数量:0枚";
    [self addSubview:self.exchangNumberLab];
    
    self.exchangTotalMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.exchangNumberLab.frame), 20, 200, 20)];
    self.exchangTotalMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:18];
    self.exchangTotalMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.exchangTotalMoneyLab.numberOfLines = 0;
    self.exchangTotalMoneyLab.text = @"筹码总额:0";
    [self addSubview:self.exchangTotalMoneyLab];
    
    self.takeOutChipMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.exchangNumberLab.frame)+15, 210, 40)];
    self.takeOutChipMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:28];
    self.takeOutChipMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.takeOutChipMoneyLab.numberOfLines = 0;
    self.takeOutChipMoneyLab.hidden = YES;
    self.takeOutChipMoneyLab.text = [NSString stringWithFormat:@"客人可取出金额:"];
    [self addSubview:self.takeOutChipMoneyLab];
    
    self.takeOutChipMoneyValueLab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.takeOutChipMoneyLab.frame), CGRectGetMaxY(self.exchangNumberLab.frame)+20, kScreenWidth-210-40-150, 40)];
    self.takeOutChipMoneyValueLab.font = [UIFont fontWithName:@"PingFang SC" size:30];
    self.takeOutChipMoneyValueLab.textColor = [UIColor redColor];
    self.takeOutChipMoneyValueLab.numberOfLines = 0;
    self.takeOutChipMoneyValueLab.hidden = YES;
    self.takeOutChipMoneyValueLab.text = [NSString stringWithFormat:@"%d",0];
    [self addSubview:self.takeOutChipMoneyValueLab];
    
    self.exchangMoneyLab = [[UILabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.exchangNumberLab.frame)+15, 300, 40)];
    self.exchangMoneyLab.font = [UIFont fontWithName:@"PingFang SC" size:30];
    self.exchangMoneyLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.exchangMoneyLab.numberOfLines = 0;
    [self addSubview:self.exchangMoneyLab];
}

- (void)_setUpChipHeaderWithType:(int)type{
    if (type==6) {
        self.exchangMoneyLab.hidden = YES;
        self.takeOutChipMoneyValueLab.hidden = NO;
        self.takeOutChipMoneyLab.hidden = NO;
    }else{
        self.exchangMoneyLab.hidden = NO;
        self.takeOutChipMoneyValueLab.hidden = YES;
        self.takeOutChipMoneyLab.hidden = YES;
    }
}

- (void)fellInfoWithDict:(NSDictionary *)dict{
    self.exchangNumberLab.text = dict[@"chipNumber"];
    self.exchangTotalMoneyLab.text = dict[@"chipTotalMoney"];
}

@end
