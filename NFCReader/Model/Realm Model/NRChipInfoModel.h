//
//  NRChipInfoModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/22.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRChipInfoModel : NSObject

@property (nonatomic, strong) NSString *chipUID;//筹码UID
@property (nonatomic, strong) NSString *chipType;//筹码类型
@property (nonatomic, strong) NSString *chipStatus;//筹码状态
@property (nonatomic, strong) NSString *chipSerialNumber;//筹码序列号
@property (nonatomic, strong) NSString *chipDenomination;//筹码面额
@property (nonatomic, strong) NSString *hasKillZhaohuiMoney;//已找回金额
@property (nonatomic, strong) NSString *hasPayMoney;//已放入金额
@property (nonatomic, strong) NSString *chipBatch;//筹码批次
@property (nonatomic, strong) NSString *guestWashesNumber;//客人洗码号
@property (nonatomic, strong) NSString *fcredit;//类型
@property (nonatomic, strong) NSString *guestName;//客人姓名
@property (nonatomic, strong) NSString *authorName;//授权人
@property (nonatomic, strong) NSString *notes;//备注

@property (nonatomic, strong) NSString *tipWashesNumber;//小费洗码号
@property (nonatomic, strong) NSString *tipMoney;//小费金额


- (instancetype)initWithChipUID:(NSString *)chipUID
                  ChipType:(NSString *)chipType
                        ChipStatus:(NSString *)chipStatus
                    ChipSerialNumber:(NSString *)chipSerialNumber
                 ChipDenomination:(NSString *)chipDenomination
                     ChipBatch:(NSString *)chipBatch
                GuestWashesNumber:(NSString *)guestWashesNumber
                    GuestName:(NSString *)guestName;

@end

NS_ASSUME_NONNULL_END
