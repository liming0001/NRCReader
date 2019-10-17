//
//  JiaJIanCaiCell.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/5.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class DenominationView;
@interface JiaJIanCaiCell : UITableViewCell

@property (nonatomic, strong) UILabel *chipTypeLab;
@property (nonatomic, strong) UIButton *openOrCloseArow;
@property (nonatomic, strong) UILabel *openOrCloseLab;

@property (nonatomic, strong) UILabel *totalNumberLab;
@property (nonatomic, strong) UILabel *totalMoneyLab;
@property (nonatomic, strong) UIButton *chipTypeBtn;

@property (nonatomic, assign) NSInteger cellIndex;

@property (nonatomic, strong) DenominationView *desView;

@property (nonatomic, strong) void (^openOrCloseBock)(BOOL isOpen,NSInteger curIndex);

@property (nonatomic, strong) void (^refrashBottomMoneyBlock)(int cellId,NSString *totalMonney);
@property (nonatomic, strong) void (^refrashSigleValueBlock)(int cellId,NSString *numberValue,NSString*moneyValue,int type);

- (void)fellCellWithOpen:(BOOL)isOpen Type:(int)type;
+ (CGFloat)cellHeightWithOpen:(BOOL)isOpen;

@end

NS_ASSUME_NONNULL_END
