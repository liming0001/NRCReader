//
//  ZLNumberKeyboard.m
//  ZLKeyboardDemo
//
//  Created by zhaoliang chen on 2018/7/19.
//  Copyright © 2018年 zhaoliang chen. All rights reserved.
//

#import "ZLNumberKeyboard.h"
#import "Masonry.h"

@interface ZLNumberKeyboard()

@property(nonatomic,copy)NSArray* arrayNumber;

@end

@implementation ZLNumberKeyboard

- (IBAction)numberBtnAction:(UIButton *)sender {
    UIButton *btn = sender;
    if (btn.tag<10 || btn.tag==91 || btn.tag==92 || btn.tag==93) {
        if (self.clickNumber) {
            self.clickNumber(KeyNumber, btn.titleLabel.text);
        }
    }else if (btn.tag==90){
        if (self.clickNumber) {
            self.clickNumber(KeyDelete, nil);
        }
    }else if (btn.tag==94){
        if (self.clickNumber) {
            self.clickNumber(KeySwitchLetter, nil);
        }
    }else if (btn.tag==95){
        if (self.clickNumber) {
            self.clickNumber(KeySpace, nil);
        }
    }else if (btn.tag==96){//换行
        if (self.clickNumber) {
            self.clickNumber(KeyTab, nil);
        }
    }else if (btn.tag==97){
        if (self.clickNumber) {
            self.clickNumber(KeyConfirm, nil);
        }
    }
}

@end
