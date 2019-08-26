//
//  EPPopView.h
//  TestPopView
//
//  Created by smarter on 2018/8/6.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LQPopUpBtnStyle) {
    LQPopUpBtnStyleDefault = 0,
    LQPopUpBtnStyleCancel = 1,
    LQPopUpBtnStyleDestructive = 2,
};

typedef NS_ENUM(NSUInteger, LQPopUpViewStyle) {
    LQPopUpViewStyleAlert = 0,
    LQPopUpViewStyleActionSheet = 1,
    LQPopUpViewStyleText= 2
};

// Title custom
@interface TitleConfiguration : NSObject

@property (nonatomic, copy) NSString *text;

// default 18
@property (nonatomic, assign) CGFloat fontSize;

// default 0x000000
@property (nonatomic, strong) UIColor *textColor;

// default 15
@property (nonatomic, assign) CGFloat top;

// default 0
@property (nonatomic, assign) CGFloat bottom;

@end


// message custom
@interface MessageConfiguration : NSObject

@property (nonatomic, copy) NSString *text;

// default 16
@property (nonatomic, assign) CGFloat fontSize;

// default 0x333333
@property (nonatomic, strong) UIColor *textColor;

// default 10
@property (nonatomic, assign) CGFloat top;

// default 15
@property (nonatomic, assign) CGFloat bottom;

@end

typedef void(^buttonAction) (void);
typedef void(^buttonClickAction) (int buttonType);
typedef void(^buttonsClickAction) (int buttonType);
typedef void(^entryTextInfoBlock) (NSString * entryText);
typedef void(^copuMsgInfoBlock) (NSString * copyMsg);

@interface EPPopView : UIView

// customize property

// default 50.0
@property (nonatomic, assign) CGFloat buttonHeight;

// default 33.0
@property (nonatomic, assign) CGFloat textFieldHeight;

// default 0.6
@property (nonatomic, assign) CGFloat lineHeight;

// default 15.0
@property (nonatomic, assign) CGFloat textFieldFontSize;

// default 0x0a7af3, system alert blue
@property (nonatomic, strong) UIColor *btnStyleDefaultTextColor;

// default 0x555555, black
@property (nonatomic, strong) UIColor *btnStyleCancelTextColor;

// default 0xff4141, red
@property (nonatomic, strong) UIColor *btnStyleDestructiveTextColor;

// default when preferredStyle is LQPopUpViewStyleAlert NO, when preferredStyle is LQPopUpViewStyleActionSheet YES
@property (nonatomic, assign) BOOL canClickBackgroundHide;

+ (void)showInWindowWithMessage:(NSString *)message handler:(buttonClickAction)hander;

+ (void)showEntryInView:(UIView *)view WithTitle:(NSString *)title handler:(entryTextInfoBlock)entryText;

+ (void)showInWindowWithTitle:(NSString *)title BtnsA:(NSArray *)btns handler:(buttonsClickAction)buttons;

+ (void)showInWindowWithBtnsA:(NSArray *)btns Style:(LQPopUpViewStyle)style handler:(buttonsClickAction)buttons;

+ (void)showInWindowWithTitle:(NSString *)title WarmMessage:(NSString *)wramMessage Message:(NSString *)message handler:(copuMsgInfoBlock)hander;

@end
