//
//  NRLoginViewModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "RVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@class NRTableChooseViewModel,NRDealerManagerViewModel,NRLoginInfo;
@interface NRLoginViewModel : RVMViewModel

- (NRTableChooseViewModel *)tableChooseViewModelWithLoginInfo:(NRLoginInfo*)loginInfo;
- (NRDealerManagerViewModel *)managerViewModelWithChipInfo:(NRLoginInfo*)chipInfo;

@end

NS_ASSUME_NONNULL_END
