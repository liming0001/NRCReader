//
//  EPINSShowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "EPINSShowView.h"

@implementation EPINSShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showWithCowType{
    [self.INSWinBtn setTitle:@"WIN" forState:UIControlStateNormal];
    [self.INSLostBtn setTitle:@"LOSE" forState:UIControlStateNormal];
}

- (IBAction)INSWinAction:(id)sender {
    [self.INSWinBtn setSelected:YES];
    [self.INSLostBtn setSelected:NO];
    [self removeFromSuperview];
    if (_INSResultBlock) {
        _INSResultBlock(YES);
    }
}
- (IBAction)INSLostAction:(id)sender {
    [self.INSWinBtn setSelected:NO];
    [self.INSLostBtn setSelected:YES];
    [self removeFromSuperview];
    if (_INSResultBlock) {
        _INSResultBlock(NO);
    }
}

@end
