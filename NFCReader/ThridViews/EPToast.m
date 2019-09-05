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

@interface EPToast ()

@property (nonatomic, strong) UIImageView *headbgImg;
@property (nonatomic, strong) UIImageView *headbgIcon;
@property (nonatomic, strong) UILabel *headbgTipsLab;

@end

@implementation EPToast

- (id)initWithText:(NSString*)text WithError:(BOOL)isError
{
    self = [super init];
    if (self) {
        _text = [text copy];
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        [self setFrame:CGRectMake((kScreenWidth-250)/2, (kScreenHeight-275)/2, 250, 275)];
        
        UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 250, 85)];
        [self addSubview:headV];
        
        self.headbgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 250, 85)];
        if (isError) {
            self.headbgImg.image = [UIImage imageNamed:@"错误提示头部"];
        }else{
            self.headbgImg.image = [UIImage imageNamed:@"正确提示头部"];
        }
        [headV addSubview:self.headbgImg];
        
        self.headbgIcon = [[UIImageView alloc]initWithFrame:CGRectMake(105, 14, 40, 40)];
        if (isError) {
            self.headbgIcon.image = [UIImage imageNamed:@"错误提示ICO"];
        }else{
            self.headbgIcon.image = [UIImage imageNamed:@"正确提示ICO"];
        }
        [headV addSubview:self.headbgIcon];
        
        self.headbgTipsLab = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.headbgIcon.frame)+5, self.frame.size.width-20, 20)];
        self.headbgTipsLab.backgroundColor = [UIColor clearColor];
        self.headbgTipsLab.textColor = [UIColor whiteColor];
        self.headbgTipsLab.textAlignment = NSTextAlignmentCenter;
        self.headbgTipsLab.font = [UIFont systemFontOfSize:16];
        self.headbgTipsLab.text = @"提示/Tips";
        [headV addSubview:self.headbgTipsLab];
        
        UIView *bottomV = [[UIView alloc]initWithFrame:CGRectMake(0, 85, 250, 190)];
        bottomV.backgroundColor = [UIColor blackColor];
        bottomV.alpha = 0.8;
        [self addSubview:bottomV];
        
        // Initialization code
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 230, 170)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
        label.text = _text;
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        [bottomV addSubview:label];
    }
    return self;
}


+(EPToast *)makeText:(NSString *)text WithError:(BOOL)isError{
    @synchronized(self){
        if(_EPToast == nil){
            _EPToast = [[EPToast alloc]initWithText:text WithError:isError];
        }
    }
    return _EPToast;
}

+(EPToast *)makeText:(NSString *)text{
    @synchronized(self){
        if(_EPToast == nil){
            _EPToast = [[EPToast alloc]initWithText:text WithError:YES];
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
    NSTimer *timer1 = [NSTimer timerWithTimeInterval:_time  target:self selector:@selector(removeEPToast) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    
    [[UIApplication sharedApplication].delegate.window addSubview:self];
}

-(void)removeEPToast
{
    [_EPToast setAlpha:0];
    [_EPToast removeFromSuperview];
    _EPToast = nil;
//    [UIView animateWithDuration:_time animations:^{
//            if (_EPToast.alpha!=0.0f) {
//                _EPToast.alpha -= 0.3f;
//            }
//        }
//        completion:^(BOOL finished) {
//        [_EPToast setAlpha:0];
//        [_EPToast removeFromSuperview];
//        _EPToast = nil;
//        }
//    ];
}

@end
