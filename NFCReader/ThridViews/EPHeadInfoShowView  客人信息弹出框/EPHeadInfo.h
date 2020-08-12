//
//  EPHeadInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2020/2/25.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPHeadInfo : NSObject

@property (nonatomic, strong) NSString *fxmh;
@property (nonatomic, strong) NSString *chip_out;
@property (nonatomic, strong) NSString *bonus;
@property (nonatomic, strong) NSString *loss;
@property (nonatomic, strong) NSString *table_bonus;

@end

NS_ASSUME_NONNULL_END
