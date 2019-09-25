//
//  EPSixWinShowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "EPSixWinShowView.h"

@implementation EPSixWinShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)twonCardAction:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setSelected:YES];
    [self.threeCardsBtn setSelected:NO];
    self.twoSelectIcon.hidden = NO;
    self.threeSelectIcon.hidden = YES;
    self.twoCardsWinLab.textColor = [UIColor colorWithHexString:@"#2ab400"];
    self.twoCardsWinEnLab.textColor = [UIColor colorWithHexString:@"#2ab400"];
    self.threeCardsWinLab.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
    self.threeCardsWinEnLav.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
}
- (IBAction)threeCardsActin:(id)sender {
    UIButton *btn = (UIButton *)sender;
    [btn setSelected:YES];
    [self.twoCardsBtn setSelected:NO];
    self.twoSelectIcon.hidden = YES;
    self.threeSelectIcon.hidden = NO;
    self.twoCardsWinLab.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
    self.twoCardsWinEnLab.textColor = [UIColor colorWithHexString:@"#A0A0A0"];
    self.threeCardsWinLab.textColor = [UIColor colorWithHexString:@"#2ab400"];
    self.threeCardsWinEnLav.textColor = [UIColor colorWithHexString:@"#2ab400"];
}
- (IBAction)confirmAction:(id)sender {
    [self removeFromSuperview];
}

@end
