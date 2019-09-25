//
//  EPINSOddsShowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "EPINSOddsShowView.h"
#import "ZLKeyboard.h"

@implementation EPINSOddsShowView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [ZLKeyboard bindKeyboard:self.oddsTF];
}

- (IBAction)oneOddsAction:(id)sender {
    self.oddsTF.text = @"1.5";
}
- (IBAction)twoOddsAction:(id)sender {
    self.oddsTF.text = @"2";
}
- (IBAction)threeOddsAction:(id)sender {
    self.oddsTF.text = @"2.5";
}
- (IBAction)fourOddsAction:(id)sender {
    self.oddsTF.text = @"3";
}
- (IBAction)fiveOddsAction:(id)sender {
    self.oddsTF.text = @"3.5";
}
- (IBAction)sixOddsAction:(id)sender {
    self.oddsTF.text = @"4";
}
- (IBAction)sevenOddsAction:(id)sender {
    self.oddsTF.text = @"4.5";
}
- (IBAction)eightOddsAction:(id)sender {
    self.oddsTF.text = @"5";
}
- (IBAction)nineOddsAction:(id)sender {
    self.oddsTF.text = @"5.5";
}
- (IBAction)tenOddsAction:(id)sender {
    self.oddsTF.text = @"6";
}
- (IBAction)confirmAction:(id)sender {
    if ([self.oddsTF.text floatValue]<=0) {
        [[EPToast makeText:@"请输入赔率" WithError:YES]showWithType:ShortTime];
        return;
    }
    [self removeFromSuperview];
    if (_INSOddsResultBlock) {
        _INSOddsResultBlock([self.oddsTF.text floatValue]);
    }
}

@end
