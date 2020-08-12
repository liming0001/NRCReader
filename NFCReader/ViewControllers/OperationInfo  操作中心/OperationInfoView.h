//
//  OperationInfoView.h
//  NFCReader
//
//  Created by 李黎明 on 2020/6/9.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^operationButtonActionBlock)(NSInteger tag ,int BtnType);

@interface OperationInfoView : UIView
@property (nonatomic, strong) operationButtonActionBlock operationBtnBlock;

- (void)showPublicBtnTitle;
#pragma mark -- 龙虎
- (void)_setUpTigerView;
- (void)showBtnsTitleInfo;

#pragma mark -- 百家乐
- (void)_setUpBaccaratView;

#pragma mark -- 牛牛
- (void)_setUpCowView;

#pragma mark -- 重置按钮状态
- (void)_resetBtnStatus;

@end

NS_ASSUME_NONNULL_END
