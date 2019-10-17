//
//  NRTableChooseViewController.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/14.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class NRTableChooseViewModel,NRLoginInfo,BLEModel;
@interface NRTableChooseViewController : NRBaseViewController

@property (nonatomic, strong) NRTableChooseViewModel *viewModel;
@property (nonatomic, strong) BLEModel *manager;

@property (nonatomic, strong) NSMutableArray *peripheralDataArray;

@end

NS_ASSUME_NONNULL_END
