//
//  NRLoginInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/30.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRLoginInfo : NSObject

@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *femp_xm;
@property (nonatomic, strong) NSString *bind_ip;
@property (nonatomic, strong) NSString *femp_num;
@property (nonatomic, strong) NSString *femp_pwd;
@property (nonatomic, strong) NSString *femp_role;
@property (nonatomic, strong) NSString *fsfz;
@property (nonatomic, strong) NSString *frz_time;
@property (nonatomic, strong) NSString *flz_time;
@property (nonatomic, strong) NSString *fedit_time;
@property (nonatomic, strong) NSString *access_token;
@property (nonatomic, strong) NSArray *chipsUIDs;//筹码ID
@property (nonatomic, strong) NSString *takeOutPassword;//取款密码
@property (nonatomic, strong) NSString *userAllMoney;//存取金额

@end

NS_ASSUME_NONNULL_END
