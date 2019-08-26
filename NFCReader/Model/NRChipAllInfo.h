//
//  NRChipAllInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2019/5/5.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NRChipInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface NRChipAllInfo : NSObject

@property (nonatomic, strong) NSString *fcmtype_name;
@property (nonatomic, strong) NSString *fcmtype;
@property NSArray<NRChipInfo *> *list;

@end

NS_ASSUME_NONNULL_END
