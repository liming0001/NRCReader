//
//  EPCowPointChooseShowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRThreeFairsPointShowView.h"

@implementation NRThreeFairsPointShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)topCowAction:(id)sender {
    [self removeFromSuperview];
    //响警告声音
    [EPSound playWithSoundName:@"click_sound"];
    UIButton *btn = (UIButton *)sender;
    if (_fairsPointsResultBlock) {
        _fairsPointsResultBlock((int)btn.tag);
    }
}
- (IBAction)midCowAction:(id)sender {
    [self removeFromSuperview];
    [EPSound playWithSoundName:@"click_sound"];
    UIButton *btn = (UIButton *)sender;
    if (_fairsPointsResultBlock) {
        _fairsPointsResultBlock((int)btn.tag);
    }
}
- (IBAction)noCowAction:(id)sender {
    [self removeFromSuperview];
    [EPSound playWithSoundName:@"click_sound"];
    UIButton *btn = (UIButton *)sender;
    if (_fairsPointsResultBlock) {
        _fairsPointsResultBlock((int)btn.tag);
    }
}

@end
