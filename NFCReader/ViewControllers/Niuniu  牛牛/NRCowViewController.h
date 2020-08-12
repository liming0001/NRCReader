//
//  NRCowViewController.h
//  NFCReader
//
//  Created by 李黎明 on 2019/5/8.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRGameBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class NRCowViewModel;
@interface NRCowViewController : NRGameBaseViewController
@property (nonatomic, strong) NRCowViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
