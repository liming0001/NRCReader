//
//  EPTitleLabel.m
//  Ellipal_update
//
//  Created by cyl on 2018/8/27.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "EPTitleLabel.h"

@implementation EPTitleLabel

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = self.bounds;
    if (CGRectContainsPoint(rect, point)) {
        return self;
    } else {
        return nil;
    }
}


@end
