//
//  EPStr.h
//  Ellipal_update
//
//  Created by cyl on 2018/8/15.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPLanguage.h"
#import "EPStrMacro.h"

@interface EPStr : NSObject

@property (nonatomic, strong) EPLanguage *language;

+ (instancetype)sharedInstance;

+ (NSString *)getStr:(NSString *)key;
+ (NSString *)getStr:(NSString *)key note:(NSString *)note;

@end
