//
//  NRChipCodeItem.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/19.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRChipCodeItem : UIView

@property (nonatomic, strong) UIImageView *checkIcon;
@property (nonatomic, strong) UILabel *infoLabel;
@property (nonatomic, strong) UIButton *checkButton;
@property (nonatomic, assign) BOOL isCheck;
@property (nonatomic, strong) RACSubject *selectSubject;
- (instancetype)initWithTitle:(NSString *)title_s;

- (void)checkSelectUn;
- (void)checkSelected;

@end

NS_ASSUME_NONNULL_END
