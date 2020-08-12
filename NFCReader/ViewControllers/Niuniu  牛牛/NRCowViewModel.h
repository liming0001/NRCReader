//
//  NRCowViewModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/5/8.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "RVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NRCowViewModel : RVMViewModel
@property (nonatomic, strong) NSArray *luzhuInfoList;
@property (nonatomic, strong) NSArray *realLuzhuList;

#pragma mark - 获取露珠
- (void)getLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block;

@end

NS_ASSUME_NONNULL_END
