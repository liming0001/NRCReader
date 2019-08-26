//
//  EPToast.m
//  Planning Design Survey System
//
//  Created by flame_thupdi on 13-4-21.
//  Copyright (c) 2013年 flame_thupdi. All rights reserved.
//

#import "EPToast.h"
#import <QuartzCore/CALayer.h>
#import "AppDelegate.h"
static EPToast * _EPToast = nil;

@implementation EPToast

- (id)initWithText:(NSString*)text
{
    self = [super init];
    if (self) {
        _text = [text copy];
        // Initialization code
        CGFloat text_allWidth = kScreenWidth-32-20;
        UIFont *font = [UIFont systemFontOfSize:26];
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(text_allWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :font} context:nil].size;
        //leak;
        CGFloat con_w = textSize.width;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, con_w, textSize.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor blackColor];
        label.font = font;
        label.text = _text;
        label.numberOfLines = 0;
        self.backgroundColor = [UIColor whiteColor];
        CGRect rect;
        CGFloat label_w = MIN(con_w + 20, kScreenWidth-32);
        CGFloat origin_w = MAX((kScreenWidth-label_w)/2, 16);
        rect.size = CGSizeMake(label_w, textSize.height + 10);
        rect.origin = CGPointMake(origin_w, kScreenHeight-20-textSize.height - 90);
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setFrame:rect];
        [self addSubview:label];
    }
    return self;
}


+(EPToast *)makeText:(NSString *)text{
    @synchronized(self){
        if(_EPToast == nil){
            _EPToast = [[EPToast alloc]initWithText:text];
        }
    }
    return _EPToast;
}

-(void)showWithType:(enum TimeType)type{
    if (type == LongTime) {
        _time = 3.0f;
    }
    else{
        _time = 1.0f;
    }
//    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:(_time/4.0f)  target:self selector:@selector(removeEPToast) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

-(void)removeEPToast
{
    [UIView animateWithDuration:_time animations:^{
            if (_EPToast.alpha!=0.0f) {
                _EPToast.alpha -= 0.3f;
            }
        }
        completion:^(BOOL finished) {
        [_EPToast setAlpha:0];
        [_EPToast removeFromSuperview];
        _EPToast = nil;
        }
    ];
}

@end
