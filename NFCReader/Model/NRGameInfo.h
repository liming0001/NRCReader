//
//  NRGameInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2019/5/29.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRGameInfo : NSObject

@property (nonatomic, strong) NSString *lastsz;//上一铺杀注
@property (nonatomic, strong) NSString *lastpf;//上一铺赔付
@property (nonatomic, strong) NSString *lastsy;//上一铺输赢
@property (nonatomic, strong) NSArray *cur_money;//筹码
@property (nonatomic, strong) NSArray *xz_setting;//下注方式配置
@property (nonatomic, strong) NSString *fstatus;//1表示未开台，2表示开台
@property (nonatomic, strong) NSString *fsettle;//1表示未日结，2表示已经日结

@end

NS_ASSUME_NONNULL_END
