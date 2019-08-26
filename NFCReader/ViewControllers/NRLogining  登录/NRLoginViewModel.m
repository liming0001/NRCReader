//
//  NRLoginViewModel.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRLoginViewModel.h"
#import "NRTableChooseViewModel.h"
#import "NRDealerManagerViewModel.h"
#import "NRLoginInfo.h"

@implementation NRLoginViewModel

- (NRTableChooseViewModel *)tableChooseViewModelWithLoginInfo:(NRLoginInfo*)loginInfo{
    NRTableChooseViewModel *viewModel = [[NRTableChooseViewModel alloc]initWithLoginInfo:loginInfo];
    return viewModel;
}

- (NRDealerManagerViewModel *)managerViewModelWithChipInfo:(NRLoginInfo*)chipInfo{
    NRDealerManagerViewModel *viewModel = [[NRDealerManagerViewModel alloc]initWithLoginInfo:chipInfo];
    return viewModel;
}

@end
