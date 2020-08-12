//
//  SetPlatformView.h
//  NFCReader
//
//  Created by 李黎明 on 2020/6/9.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^platformButtonActionBlock)(NSInteger tag ,int BtnType);

@interface SetPlatformView : UIView

@property (nonatomic, strong) platformButtonActionBlock platformBtnBlock;

#pragma mark -- 龙虎
- (void)_setUpTigerView;
- (void)showBtnsTitleInfo;
- (void)_setPlatFormBtnNormalStatusWithResult:(NSString*)result;

#pragma mark -- 百家乐
- (void)_setUpBaccaratView;

#pragma mark -- 牛牛
- (void)_setUpCowView;

@end

NS_ASSUME_NONNULL_END
