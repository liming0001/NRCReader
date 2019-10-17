//
//  NRTableDataModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/29.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRTableDataModel : NSObject

@property (nonatomic, strong) NSString *fcmtype;//筹码ID
@property (nonatomic, strong) NSString *finit_money;//开工本金
@property (nonatomic, strong) NSString *fcur_money;//当前本金
@property (nonatomic, strong) NSString *fmoney;//当前本金

@end

NS_ASSUME_NONNULL_END
