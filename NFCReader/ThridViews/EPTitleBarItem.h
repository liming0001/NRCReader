//
//  EPTitleBarItem.h
//  Ellipal
//
//  Created by cyl on 2018/7/10.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EPTitilBarItemStyle) {
    EPTitilBarItemStylePlain,
    EPTitilBarItemStyleDone,
};

@interface EPTitleBarItem : UIView

@property (nonatomic, readonly) UIButton *contentButton;

- (instancetype)initWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage block:(void(^)(BOOL isSelected))block;
- (instancetype)initWithImage:(UIImage *)image tintColor:(UIColor *)tintColor block:(void(^)(void))block;
- (instancetype)initWithText:(NSString *)text tintColor:(UIColor *)tintColor block:(void(^)(void))block;
- (instancetype)initWithAttributeText:(NSAttributedString *)attrText tintColor:(UIColor *)tintColor block:(void(^)(void))block;
- (instancetype)initWithImage:(UIImage *)image BackImage:(UIImage *)backImg Text:(NSString *)text tintColor:(UIColor *)tintColor block:(void(^)(void))block;

@end
