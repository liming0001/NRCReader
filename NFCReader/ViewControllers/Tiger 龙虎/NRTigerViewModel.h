//
//  NRTigerViewModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/5/6.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "RVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NRTigerViewModel : RVMViewModel

@property (nonatomic, strong) NSArray *luzhuUpList;
@property (nonatomic, strong) NSArray *realLuzhuList;
@property (nonatomic, assign) int dragonCount;//龙赢次数
@property (nonatomic, assign) int tigerCount;//虎赢次数
@property (nonatomic, assign) int heCount;//和赢次数

#pragma mark - 获取露珠
- (void)getLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block;
@end

NS_ASSUME_NONNULL_END
