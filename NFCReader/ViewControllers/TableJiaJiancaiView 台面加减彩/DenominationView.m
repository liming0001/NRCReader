//
//  DenominationView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/6.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "DenominationView.h"
#import "ZLKeyboard.h"

@implementation DenominationView

- (void)drawRect:(CGRect)rect {
    // Drawing code
    [ZLKeyboard bindKeyboard:self.oneValueTF];
    [ZLKeyboard bindKeyboard:self.twoValueTF];
    [ZLKeyboard bindKeyboard:self.threeValueTF];
    [ZLKeyboard bindKeyboard:self.thridValueTF];
    [ZLKeyboard bindKeyboard:self.fiveValueTF];
    [ZLKeyboard bindKeyboard:self.sixValueTF];
    [ZLKeyboard bindKeyboard:self.sevenValueTF];
    [ZLKeyboard bindKeyboard:self.eightValueTF];
    [ZLKeyboard bindKeyboard:self.nineValueTF];
    [ZLKeyboard bindKeyboard:self.tenValueTF];
    [ZLKeyboard bindKeyboard:self.evlevenValueTF];
}

- (IBAction)oneValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.oneValueTF.enabled = YES;
        self.oneValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.oneValueTF.enabled = NO;
        self.oneValueTF.background = [UIImage imageNamed:@""];
    }
}
- (IBAction)twoValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.twoValueTF.enabled = YES;
        self.twoValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.twoValueTF.enabled = NO;
        self.twoValueTF.background = [UIImage imageNamed:@""];
    }
}
- (IBAction)threeValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.threeValueTF.enabled = YES;
        self.threeValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.threeValueTF.enabled = NO;
        self.threeValueTF.background = [UIImage imageNamed:@""];
    }
}
- (IBAction)thridValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.thridValueTF.enabled = YES;
        self.thridValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.thridValueTF.enabled = NO;
        self.thridValueTF.background = [UIImage imageNamed:@""];
    }
}
- (IBAction)fiveValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.fiveValueTF.enabled = YES;
        self.fiveValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.fiveValueTF.enabled = NO;
        self.fiveValueTF.background = [UIImage imageNamed:@""];
    }
}
- (IBAction)sixValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.sixValueTF.enabled = YES;
        self.sixValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.sixValueTF.enabled = NO;
        self.sixValueTF.background = [UIImage imageNamed:@""];
    }
}
- (IBAction)sevenValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.sevenValueTF.enabled = YES;
        self.sevenValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.sevenValueTF.enabled = NO;
        self.sevenValueTF.background = [UIImage imageNamed:@""];
    }
}
- (IBAction)eightValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.eightValueTF.enabled = YES;
        self.eightValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.eightValueTF.enabled = NO;
        self.eightValueTF.background = [UIImage imageNamed:@""];
    }
}
- (IBAction)nineValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.nineValueTF.enabled = YES;
        self.nineValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.nineValueTF.enabled = NO;
        self.nineValueTF.background = [UIImage imageNamed:@""];
    }
}
- (IBAction)tenValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.tenValueTF.enabled = YES;
        self.tenValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.tenValueTF.enabled = NO;
        self.tenValueTF.background = [UIImage imageNamed:@""];
    }
}
- (IBAction)evlevenValueAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.evlevenValueTF.enabled = YES;
        self.evlevenValueTF.background = [UIImage imageNamed:@"总数量统计BG"];
    }else{
        self.evlevenValueTF.enabled = NO;
        self.evlevenValueTF.background = [UIImage imageNamed:@""];
    }
}


@end
