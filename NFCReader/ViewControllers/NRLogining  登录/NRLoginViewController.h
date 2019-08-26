//
//  NRLoginViewController.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/12.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class NRLoginViewModel;
@interface NRLoginViewController : NRBaseViewController

@property (nonatomic, strong) NRLoginViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
