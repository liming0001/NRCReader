//
//  EPTitleBar.m
//  Ellipal
//
//  Created by cyl on 2018/7/4.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "EPTitleBar.h"
#import "EPTitleBarItem.h"
#import "EPTitleLabel.h"

@interface EPTitleBar ()

@property (nonatomic, strong) UIView *blankView; // 唯一作用是给左右两边item对齐用

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) UIFont *leftButtonFont;
@property (nonatomic, strong) UIFont *rightButtonFont;

@property (nonatomic, assign) CGFloat leftItemWidth;
@property (nonatomic, assign) CGFloat rightItemWidth;

//@property (nonatomic, copy) void(^leftButtonBlock)(void);
//@property (nonatomic, copy) void(^rightButtonBlock)(void);

@end

@implementation EPTitleBar
@dynamic showBottomLine;
@dynamic title;

- (instancetype)init {
    self = [super init];
    
    self.backgroundColor = [UIColor clearColor];
    
    self.blankView = [UIView new];
    self.blankView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.blankView];
    self.isContainStatuBar = YES;
    
    self.titleLabel = [EPTitleLabel new];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    self.titleLabel.font = [UIFont fontWithName:@"PingFang SC" size:26];
    self.titleLabel.textColor = [UIColor blackColor];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.blankView);
        make.centerX.equalTo(self);
    }];
    @weakify(self);
    [RACObserve(self, subTitle) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        CGFloat width = 10;
        [self layoutIfNeeded];
        if (self.leftItemWidth > self.rightItemWidth) {
            width = self.bounds.size.width - 2 * self.leftItemWidth;
        } else {
            width = self.bounds.size.width - 2 * self.rightItemWidth;
        }
        if (x == nil) {
            if (self.subTitleLabel) {
                [self.subTitleLabel removeFromSuperview];
                self.subTitleLabel = nil;
            }
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.blankView);
                make.centerX.equalTo(self);
                make.width.mas_equalTo(width);
            }];
        } else {
            if (!self.subTitleLabel) {
                self.subTitleLabel = [UILabel new];
                self.subTitleLabel.text = x;
                self.subTitleLabel.textAlignment = NSTextAlignmentCenter;
                self.subTitleLabel.font = [UIFont fontWithName:kEPFontNamePingFangSC size:12];
                self.subTitleLabel.textColor = [UIColor colorWithHexString:@"#999999"];
                [self addSubview:self.subTitleLabel];
                [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_offset(100);
                    make.bottom.equalTo(self).offset(-2);
                    make.centerX.equalTo(self);
                }];
            }
            [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.bottom.equalTo(self.subTitleLabel.mas_top).offset(-0);
                make.width.mas_equalTo(width);
            }];
        }
    }];
    self.bottomLineView = [UIView new];
    self.bottomLineView.backgroundColor = [UIColor colorWithHexString:@"#959595"];
    [self addSubview:self.bottomLineView];
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    
    self.showBottomLine = NO;
    
    self.tbTintColor = [UIColor colorWithHexString:@"#5A5A5A"];
    return self;
}

- (void)setIsContainStatuBar:(BOOL)isContainStatuBar {
    _isContainStatuBar = isContainStatuBar;
    CGFloat statuBarHeight = [EPTitleBar heightForStatuBar];
    [self.blankView mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (self.isContainStatuBar) {
            make.centerY.mas_equalTo((self.bounds.size.height - statuBarHeight) / 2 + statuBarHeight);
        } else {
            make.centerY.equalTo(self);
        }
        make.centerX.equalTo(self);
        make.width.height.mas_equalTo(1);
    }];

}
- (void)setTbTintColor:(UIColor *)tbTintColor {
    _tbTintColor = tbTintColor;
    
    self.titleLabel.textColor = tbTintColor;
}

- (void)setTitle:(NSString *)title {
    self.titleLabel.text = title;
}

- (NSString *)title {
    return self.titleLabel.text;
}

+ (CGFloat)heightForTitleBarPlusStatuBar {
    return [[UIApplication sharedApplication] statusBarFrame].size.height + 44;
}

+ (CGFloat)heightForTitleBar {
    return 44;
}

+ (CGFloat)heightForStatuBar {
    return [[UIApplication sharedApplication] statusBarFrame].size.height;
}

- (void)setShowBottomLine:(BOOL)showBottomLine {
    self.bottomLineView.hidden = !showBottomLine;
}

- (BOOL)showBottomLine {
    return !self.bottomLineView.hidden;
}

- (void)setLeftItem:(EPTitleBarItem *)leftItem {
    if (_leftItem != nil) {
        [_leftItem removeFromSuperview];
        _leftItem = nil;
    }
    _leftItem = leftItem;
    if (_leftItem != nil) {
        [self addSubview:_leftItem];
    }
    
    NSAttributedString *attrText = [_leftItem.contentButton attributedTitleForState:UIControlStateNormal];
    if ([attrText length] > 0) { // title
        CGSize size = CGSizeMake(1000, 100);
        CGRect rect = [attrText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGFloat width = MIN(rect.size.width, 80) + 32;
        self.leftItemWidth = width;
        [_leftItem mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.centerY.equalTo(self.blankView);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(width);
        }];
    } else { // image
        self.leftItemWidth = 56;
        [_leftItem mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(56);
            make.centerY.equalTo(self.blankView);
        }];
    }
    [self remakeTitleConstraintsIfNeed];
}

- (void)setRightItem:(EPTitleBarItem *)rightItem {
    if (_rightItem != nil) {
        [_rightItem removeFromSuperview];
        _rightItem = nil;
    }
    
    _rightItem = rightItem;
    [self addSubview:_rightItem];
    
    NSAttributedString *attrText = [_rightItem.contentButton attributedTitleForState:UIControlStateNormal];
    _rightItem.contentButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    NSString *textTitle = _rightItem.contentButton.titleLabel.text;
    UIImage *btnImg = _rightItem.contentButton.currentImage;
    if ([attrText length] > 0) { // title
        CGSize size = CGSizeMake(1000, 100);
        CGRect rect = [attrText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        CGFloat width = MIN(rect.size.width, 80) + 32;
        self.rightItemWidth = width;
        [_rightItem mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.centerY.equalTo(self.blankView);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(width);
        }];
    } else if (textTitle.length!=0&&btnImg){
        self.rightItemWidth = 90;
        [_rightItem mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(90);
            make.centerY.equalTo(self.blankView);
        }];
    } else { // image
        self.rightItemWidth = 56;
        [_rightItem mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.height.mas_equalTo(44);
            make.width.mas_equalTo(56);
            make.centerY.equalTo(self.blankView);
        }];
    }
}

- (void)remakeTitleConstraintsIfNeed {
    CGFloat width = 10;
    [self layoutIfNeeded];
    if (self.rightItemWidth>0) {
        if (self.leftItemWidth > self.rightItemWidth) {
            width = self.bounds.size.width - 2 * self.leftItemWidth;
        } else {
            width = self.bounds.size.width - 2 * self.rightItemWidth;
        }
    }else{
        width = self.bounds.size.width - self.leftItemWidth-16;
    }
    
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        if ([self.subTitle length]>0) {
            make.centerY.equalTo(self.blankView).offset(-10);
        }else{
            make.centerY.equalTo(self.blankView);
        }
        
        make.width.mas_equalTo(width);
    }];
    [self.titleLabel layoutIfNeeded];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
