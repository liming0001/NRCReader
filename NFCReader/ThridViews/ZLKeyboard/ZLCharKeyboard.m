//
//  ZLCharKeyboard.m
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/18.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import "ZLCharKeyboard.h"
#import "Masonry.h"
#include <ctype.h>

@interface ZLCharKeyboard()

@property(nonatomic,strong)NSArray* upperLetters;
@property(nonatomic,strong)NSMutableArray* arrayLetters;

@end

@implementation ZLCharKeyboard

- (IBAction)alpheBtnAction:(UIButton *)sender {
    UIButton *btn = sender;
    if (btn.tag<27) {
        if (self.onClickChar) {
            self.onClickChar(KeyLetter, btn.titleLabel.text);
        }
    }else if (btn.tag==90){
        if (self.onClickChar) {
            self.onClickChar(KeyDelete, nil);
        }
    }else if (btn.tag==91){
        if (self.onClickChar) {
            self.onClickChar(KeySwitchNumber, nil);
        }
    }else if (btn.tag==92){
        if (self.onClickChar) {
            self.onClickChar(KeyTab, nil);
        }
    }else if (btn.tag==93){
        if (self.onClickChar) {
            self.onClickChar(KeySpace, nil);
        }
    }else if (btn.tag==94){
        if (self.onClickChar) {
            self.onClickChar(KeyConfirm, nil);
        }
    }
}

@end
