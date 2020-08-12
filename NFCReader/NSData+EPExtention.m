//
//  NSData+EPExtention.m
//  Ellipal_update
//
//  Created by cyl on 2018/8/14.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "NSData+EPExtention.h"

@implementation NSData (EPExtention)

+ (instancetype)dataWithHexString:(NSString *)string {
    NSMutableData *data = [NSMutableData data];
    NSRange range;
    range.length = 2;
    for (int i = 0; i < string.length; i += 2) {
        range.location = i;
        NSScanner *scanner = [NSScanner scannerWithString:[string substringWithRange:range]];
        unsigned u;
        [scanner scanHexInt:&u];
        [data appendBytes:&u length:1];
    }
    return data;
}


@end
