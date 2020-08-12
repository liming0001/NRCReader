//
//  TableInfoView.h
//  NFCReader
//
//  Created by 李黎明 on 2020/6/9.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^tableInfoButtonActionBlock)(NSInteger tag ,int BtnType);

@interface TableInfoView : UIView

@property (nonatomic, strong) tableInfoButtonActionBlock tableInfoBtnBlock;

#pragma mark -- 更新台桌信息
- (void)updateTableInfo;
- (void)_setPlatFormBtnNormalStatusWithResult:(NSString*)result;
#pragma mark -- 龙虎
- (void)_setUpTigerView;
- (void)showTableTitleInfo;
- (void)updateTigerCountWithCountList:(NSArray *)countList;

#pragma mark -- 百家乐
- (void)_setUpBaccaratView;
- (void)updateBaccaratCountWithCountList:(NSArray *)countList;

#pragma mark -- 牛牛
- (void)_setUpCowView;
#pragma mark -- 清除牛牛庄家点数
- (void)clearCowPoint;

@end

NS_ASSUME_NONNULL_END
