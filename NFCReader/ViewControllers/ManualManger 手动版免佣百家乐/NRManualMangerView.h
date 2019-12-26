//
//  NRManualMangerView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/8/26.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRManualMangerView : UIView

@property (nonatomic, strong) UILabel *xueciLab;
@property (nonatomic, strong) UILabel *puciLab;
@property (nonatomic, assign) int xueciCount;//靴次
@property (nonatomic, assign) int puciCount;//铺次
@property (nonatomic, assign) int prePuciCount;
@property (nonatomic, strong) NSArray *realLuzhuList;

- (void)reloadLuzhuInfoWithLuzhuList:(NSArray *)luzhuList;
- (void)getManualBaseTableInfoAndLuzhuInfo;
- (void)transLoginInfoWithLoginID:(NSString *)loginID TableID:(NSString *)tableID Serialnumber:(NSString *)serialnumber Peilv:(NSArray *)xz_setting TableName:(NSString *)tableName RijieData:(NSString *)curRijieDate;
- (void)fellXueCiWithXueCi:(int)curXueci PuCi:(int)curPuCi;
- (void)restartChangeStatus;
- (void)resertResultBtnStatus;
#pragma mark --清除金额
- (void)clearMoney;
@end

NS_ASSUME_NONNULL_END
