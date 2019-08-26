//
//  EPLanguage.h
//  Ellipal_update
//
//  Created by cyl on 2018/8/10.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kEPLanguageTypeEn,
    kEPLanguageTypeCn,
    kEPLanguageTypeJp,
    kEPLanguageTypeKr
} EPLanguageType;
@interface EPLanguage : NSObject

@property (nonatomic, readonly) EPLanguageType languageType;

- (instancetype)initWithLanguageType:(EPLanguageType)languageType;

- (NSString *)gLangParam;

- (NSString *)languageFullString;
- (NSString *)languageNumString;

@end
