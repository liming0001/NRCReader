//
//  NRAddOrMinusChipDetailViewController.h
//  NFCReader
//
//  Created by 李黎明 on 2020/9/19.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import "NRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NRAddOrMinusChipDetailViewController : NRBaseViewController

@property (nonatomic, weak) id curInfo;

@property (nonatomic, strong) void (^refrashTableBlock)(int refrashType);

@end

NS_ASSUME_NONNULL_END
