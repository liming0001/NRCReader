//
//  EPPayShowView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/14.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "EPPayShowView.h"

@implementation EPPayShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)confirmAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
- (IBAction)dashuiAction:(id)sender {
}

@end
