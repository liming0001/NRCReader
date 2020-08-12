//
//  EPLanguage.m
//  Ellipal_update
//
//  Created by cyl on 2018/8/10.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "EPLanguage.h"

@interface EPLanguage ()

@property (nonatomic, assign) EPLanguageType languageType;

@end

@implementation EPLanguage

- (instancetype)initWithLanguageType:(EPLanguageType)languageType {
    self = [super init];
    
    self.languageType = languageType;
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self yy_modelEncodeWithCoder:aCoder];
}
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self yy_modelInitWithCoder:aDecoder];
}
- (id)copyWithZone:(NSZone *)zone {
    return [self yy_modelCopy];
}
- (NSUInteger)hash {
    return [self yy_modelHash];
}
- (BOOL)isEqual:(id)object {
    return [self yy_modelIsEqual:object];
}
- (NSString *)description {
    return [self yy_modelDescription];
}

@end
