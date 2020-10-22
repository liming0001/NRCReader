//
//  NRSingleChipViewController.h
//  NFCReader
//
//  Created by 李黎明 on 2020/9/20.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NRSingleChipViewController : NRBaseViewController

@property (nonatomic, strong) NSDictionary *infoDict;
@property (nonatomic, strong) void (^tranChipUIDListBlock)(NSArray *chipUIDList);

@end

NS_ASSUME_NONNULL_END
