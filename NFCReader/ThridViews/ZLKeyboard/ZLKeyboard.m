//
//  ZLKeyboard.m
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/18.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import "ZLKeyboard.h"
#import "ZLCharKeyboard.h"
#import "ZLNumberKeyboard.h"
#import "Masonry.h"
#import <sys/utsname.h>

@interface ZLKeyboard()

@property(nonatomic,weak)UITextField* zlTextField;

@property(nonatomic,strong)ZLCharKeyboard* charKeyboard;
@property(nonatomic,strong)ZLNumberKeyboard* numberKeyboard;

@end

@implementation ZLKeyboard

- (instancetype)initWithTextField:(UITextField*)textField {
    self = [super init];
    if (self) {
        [self setupKeyboard];
        self.zlTextField = textField;
        self.zlTextField.autocorrectionType=UITextAutocorrectionTypeNo;
        self.zlTextField.inputView = self;
        UITextInputAssistantItem* item = [self.zlTextField inputAssistantItem];
        item.leadingBarButtonGroups = @[];
        item.trailingBarButtonGroups = @[];
        self.keyBoardLayoutStyle = KeyBoardLayoutStyleNumbers;
    }
    return self;
}

- (instancetype)initWithKeyboardType:(ZLKeyBoardLayoutStyle)style {
    self = [super init];
    if (self) {
        [self setupKeyboard];
        self.keyBoardLayoutStyle = style;
    }
    return self;
}

+ (instancetype)bindKeyboard:(UITextField*)textField {
    ZLKeyboard *keyboard = [[ZLKeyboard alloc]initWithTextField:textField];
    return keyboard;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setKeyBoardLayoutStyle:(ZLKeyBoardLayoutStyle)keyBoardLayoutStyle {
    _keyBoardLayoutStyle = keyBoardLayoutStyle;
    self.charKeyboard.hidden = YES;
    self.numberKeyboard.hidden = YES;
    switch (keyBoardLayoutStyle) {
        case KeyBoardLayoutStyleDefault:
        case KeyBoardLayoutStyleLetters:
            self.charKeyboard.hidden = NO;
            break;
        case KeyBoardLayoutStyleNumbers:
            self.numberKeyboard.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)setupKeyboard {
    self.backgroundColor = [UIColor whiteColor];
    [self setupFrame];
    
    [self setupCharKeyboard];
    
    [self setupNumberKeyboard];
}

- (void)setupFrame {
    self.frame = CGRectMake(0, 0, 0, 389);
}

- (void)setupCharKeyboard {
    [self addSubview:self.charKeyboard];
    [self.charKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.mas_equalTo(389);
    }];
    
    __weak typeof(ZLKeyboard*) weakSelf = self;
    self.charKeyboard.onClickChar = ^(ZLKeyValue key, NSString *value) {
        if (key == KeyLetter) {
            weakSelf.zlTextField.text = [weakSelf.zlTextField.text stringByAppendingString:value];
        } else if (key == KeyDelete) {
            NSUInteger stringLength = weakSelf.zlTextField.text.length;
            if (stringLength > 0) {
                weakSelf.zlTextField.text = [weakSelf.zlTextField.text substringToIndex:stringLength - 1];
            }
        } else if (key == KeySwitchNumber) {
            weakSelf.numberKeyboard.hidden = NO;
            weakSelf.charKeyboard.hidden = YES;
        } else if (key == KeyConfirm) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"sureEntryCustomerInfo" object:nil];
        } else if (key == KeySpace) {
            weakSelf.zlTextField.text = [weakSelf.zlTextField.text stringByAppendingString:@" "];
        }
    };
}

- (void)setupNumberKeyboard {
    [self addSubview:self.numberKeyboard];
    [self.numberKeyboard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.charKeyboard);
        make.top.left.mas_equalTo(self.charKeyboard);
    }];
    self.numberKeyboard.hidden = YES;
    
    __weak typeof(ZLKeyboard*) weakSelf = self;
    self.numberKeyboard.clickNumber = ^(ZLKeyValue key, NSString *value) {
        if (key == KeyNumber) {
            weakSelf.zlTextField.text = [weakSelf.zlTextField.text stringByAppendingString:value];
        } else if (key == KeyDelete) {
            NSUInteger stringLength = weakSelf.zlTextField.text.length;
            if (stringLength > 0) {
                weakSelf.zlTextField.text = [weakSelf.zlTextField.text substringToIndex:stringLength - 1];
            }
        } else if (key == KeySwitchLetter) {
            weakSelf.numberKeyboard.hidden = YES;
            weakSelf.charKeyboard.hidden = NO;
        } else if (key == KeyConfirm) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"sureEntryCustomerInfo" object:nil];
        } else if (key == KeySpace) {
            weakSelf.zlTextField.text = [weakSelf.zlTextField.text stringByAppendingString:@" "];
        }
    };
}

- (ZLCharKeyboard*)charKeyboard {
    if (!_charKeyboard) {
        _charKeyboard = [[[NSBundle mainBundle]loadNibNamed:@"ZLCharKeyboard" owner:nil options:nil]lastObject];
    }
    return _charKeyboard;
}

- (ZLNumberKeyboard*)numberKeyboard {
    if (!_numberKeyboard) {
        _numberKeyboard = [[[NSBundle mainBundle]loadNibNamed:@"ZLNumberKeyboard" owner:nil options:nil]lastObject];
    }
    return _numberKeyboard;
}

@end
