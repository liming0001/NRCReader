//
//  NRUpdateInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2019/5/28.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRUpdateInfo : NSObject

@property (nonatomic, strong) NSString *cp_xueci;//靴次
@property (nonatomic, strong) NSString *cp_puci;//铺次
@property (nonatomic, strong) NSString *cp_Serialnumber;//流水号
@property (nonatomic, strong) NSString *cp_washNumber;//洗码号
@property (nonatomic, strong) NSString *cp_chipType;//筹码类型
@property (nonatomic, strong) NSString *cp_benjin;//本金
@property (nonatomic, strong) NSString *cp_name;//下注名称
@property (nonatomic, strong) NSString *cp_Result_name;//客人下注名称
@property (nonatomic, strong) NSString *cp_beishu;//倍数
@property (nonatomic, strong) NSString *add_chipMoney;//需增加的筹码金额
@property (nonatomic, strong) NSString *cp_dianshu;//点数
@property (nonatomic, strong) NSString *cp_result;//判断客人的输赢：1为赢，-1为输，0为不杀不赔
@property (nonatomic, strong) NSString *cp_money;//应付额
@property (nonatomic, strong) NSString *cp_commission;//佣金
@property (nonatomic, strong) NSArray *cp_ChipUidList;
@property (nonatomic, strong) NSArray *cp_DashuiUidList;
@property (nonatomic, strong) NSArray *cp_zhaohuiList;
@property (nonatomic, strong) NSArray *cp_xiaofeiList;
@property (nonatomic, strong) NSString *cp_fid;//提交结果
@property (nonatomic, strong) NSString *femp_num;//管理员登录账号
@property (nonatomic, strong) NSString *femp_pwd;//登录密码
@property (nonatomic, strong) NSString *fhg_id;//荷官ID

@end

NS_ASSUME_NONNULL_END
