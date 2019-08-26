//
//  EPStr.m
//  Ellipal_update
//
//  Created by cyl on 2018/8/15.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "EPStr.h"

@interface EPStr ()

@property (nonatomic, strong) NSDictionary *dataDict;
@property (nonatomic, assign) NSInteger langIndex;

@end

@implementation EPStr

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static EPStr *str;
    dispatch_once(&onceToken, ^{
        str = [[EPStr alloc] init];
    });
    return str;
}

+ (NSString *)getStr:(NSString *)key {
    return [[EPStr sharedInstance] getStr:key];
}

+ (NSString *)getStr:(NSString *)key note:(NSString *)note {
    return [self getStr:key];
}

- (instancetype)init {
    self = [super init];
    
    _langIndex = 2;
    [self load];
    
    return self;
}

- (void)setLanguage:(EPLanguage *)language {
    _language = language;
    switch (_language.languageType) {
        case kEPLanguageTypeEn:
            _langIndex = 2;
            break;
        case kEPLanguageTypeCn:
            _langIndex = 1;
            break;
        case kEPLanguageTypeJp:
            _langIndex = 3;
            break;
        case kEPLanguageTypeKr:
            _langIndex = 4;
            break;
        default:
            break;
    }
}

- (void)load {
    NSBundle *bundle    = [NSBundle mainBundle];
    NSURL *url = [bundle URLForResource:@"EPStr" withExtension:@"txt"];
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSArray *array = [str componentsSeparatedByString:@"\n"];
    NSString *sep = @"    ";
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    for (NSString *line in array) {
        NSArray *words = [line componentsSeparatedByString:sep];
        if ([words count] == 5) {
            dict[words[0]] = words;
        }
    }
    self.dataDict = dict;
}

- (NSString *)getStr:(NSString *)key {
    if (!key) return nil;
    return self.dataDict[key][self.langIndex];
}


@end
