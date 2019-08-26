//
//  NSString+EPExtention.h
//  Ellipal_update
//
//  Created by smarter on 2018/8/23.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (EPExtention)

- (NSString *)formartLongScientificNotation;
-(NSString *)UTCchangeWithFormant:(NSString *)formant;
- (NSString *)NullToBlankString;
- (NSString *)SHA256;
- (NSString *)to32BitString;
- (int)countNumberDecmb;
- (NSString *)separateNumberUseComma;

- (NSString *)formartEightScientificNotation;
- (NSString *)formartScientificNotation;
- (NSString *)formartTrueAmountScientificNotation;

- (NSString *) stringPaddedForBase64;

- (NSString *)getTimeFromTimestamp;


- (NSString *)URLEncodedString;

@end
