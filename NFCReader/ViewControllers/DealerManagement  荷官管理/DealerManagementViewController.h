//
//  DealerManagementViewController.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/18.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class NRDealerManagerViewModel;
@interface DealerManagementViewController : NRBaseViewController
@property (nonatomic, strong) NRDealerManagerViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
