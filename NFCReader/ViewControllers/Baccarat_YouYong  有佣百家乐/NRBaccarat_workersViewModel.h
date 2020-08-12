//
//  NRBaccaratViewModel.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "RVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NRBaccarat_workersViewModel : RVMViewModel

@property (nonatomic, strong) NSArray *luzhuInfoList;
@property (nonatomic, strong) NSArray *realLuzhuList;
@property (nonatomic, assign) int zhuangCount;//庄赢次数
@property (nonatomic, assign) int zhuangDuiCount;//庄对赢次数
@property (nonatomic, assign) int sixCount;//6点赢次数
@property (nonatomic, assign) int xianCount;//闲赢次数
@property (nonatomic, assign) int xianDuiCount;//闲对赢次数
@property (nonatomic, assign) int heCount;//和赢次数

#pragma mark - 获取露珠
- (void)getLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block;

@end

NS_ASSUME_NONNULL_END
