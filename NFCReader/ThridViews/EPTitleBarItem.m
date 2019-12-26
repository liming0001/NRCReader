//
//  EPTitleBarItem.m
//  Ellipal
//
//  Created by cyl on 2018/7/10.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "EPTitleBarItem.h"

@interface EPTitleBarItem ()

@property (nonatomic, strong) UIButton *contentButton;
@property (nonatomic, copy) void(^contentButtonBlock)(void);
@property (nonatomic, copy) void(^imageButtonBlock)(BOOL isSelected);
@property (nonatomic, strong) UIFont *buttonFont;
@property (nonatomic, strong) UIColor *tbTintColor;

@end

@implementation EPTitleBarItem

- (instancetype)initWithImage:(UIImage *)image tintColor:(UIColor *)tintColor block:(void(^)(void))block {
    self = [super init];
    
    self.tbTintColor = tintColor;
    [self configureContentButton];
    [self.contentButton setImage:image forState:UIControlStateNormal];
    self.contentButtonBlock = block;
    return self;
}

- (instancetype)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage block:(void(^)(BOOL isSelected))block {
    self = [super init];
    [self configureImageButton];
    [self.contentButton setImage:image forState:UIControlStateNormal];
    [self.contentButton setImage:selectedImage forState:UIControlStateSelected];
    self.imageButtonBlock = block;
    return self;
}

- (instancetype)initWithImage:(UIImage *)image BackImage:(UIImage *)backImg Text:(NSString *)text tintColor:(UIColor *)tintColor block:(void(^)(void))block {
    self = [super init];
    
    self.tbTintColor = tintColor;
    [self configureExchangeButton];
    [self.contentButton setBackgroundImage:backImg forState:UIControlStateNormal];
    [self.contentButton setTitle:[NSString stringWithFormat:@" %@ ",text] forState:UIControlStateNormal];
    self.contentButtonBlock = block;
    return self;
}

- (instancetype)initWithText:(NSString *)text tintColor:(UIColor *)tintColor block:(void(^)(void))block {
    self = [super init];

    self.buttonFont = [UIFont fontWithName:kEPFontNamePingFangSC size:14];
    NSDictionary *dict = @{NSFontAttributeName:self.buttonFont};
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:dict];
    
    return [self initWithAttributeText:attrString tintColor:tintColor block:block];
}

- (instancetype)initWithAttributeText:(NSAttributedString *)attrText tintColor:(UIColor *)tintColor block:(void(^)(void))block {
    self = [super init];
    
    self.tbTintColor = tintColor;
    [self configureContentButton];
    [self.contentButton setAttributedTitle:attrText forState:UIControlStateNormal];
    self.contentButtonBlock = block;
    
    return self;
}

- (void)configureContentButton {

    self.contentButton  = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.contentButton setTintColor:self.tbTintColor];
    self.contentButton.titleLabel.numberOfLines = 2;
    [self.contentButton addTarget:self action:@selector(handleButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.contentButton];
    [self.contentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)configureImageButton {
    self.contentButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.contentButton.titleLabel.numberOfLines = 2;
    [self.contentButton addTarget:self action:@selector(handleImageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.contentButton];
    [self.contentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
}

- (void)configureExchangeButton {
    self.contentButton  = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentButton setTintColor:self.tbTintColor];
    self.contentButton.titleLabel.numberOfLines = 2;
    self.contentButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.contentButton addTarget:self action:@selector(handleButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.contentButton];
    [self.contentButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(5);
        make.right.equalTo(self).offset(-10);
        make.width.mas_offset(80);
        make.height.mas_offset(30);
    }];
}

- (void)handleButton {
    if (self.contentButtonBlock) {
        self.contentButtonBlock();
    }
}

- (void)handleImageButton:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (self.imageButtonBlock) {
        self.imageButtonBlock(btn.selected);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
