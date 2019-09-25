//
//  ManualManagerCow.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ManualManagerCow : UIView

@property (nonatomic, strong) UILabel *xueciLab;
@property (nonatomic, strong) UILabel *puciLab;
@property (nonatomic, assign) int xueciCount;//靴次
@property (nonatomic, assign) int puciCount;//铺次
@property (nonatomic, assign) int prePuciCount;

- (void)transLoginInfoWithLoginID:(NSString *)loginID TableID:(NSString *)tableID Serialnumber:(NSString *)serialnumber;

@end

NS_ASSUME_NONNULL_END
