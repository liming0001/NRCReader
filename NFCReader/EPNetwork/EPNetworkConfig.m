//
//  EPNetworkConfig.m
//  EPEtherDemo
//
//  Created by smarter on 2018/7/14.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import "EPNetworkConfig.h"

#define kBaseURL @"http://dbluo.t.zwjxt.com/api/service/index.html"
//#define kBaseURL @"http://test.2t6.cn/api/service/index.html"
#define kHTTPCookieDomain @"dbluo.t.zwjxt.com"

@implementation EPNetworkConfig

+ (EPNetworkConfig *)defaultConfig {
    static EPNetworkConfig *config;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[EPNetworkConfig alloc] init];
    });
    return config;
}

- (NSString *)baseURL {
    return kBaseURL;
}

- (void)addCookie {
    NSDictionary *info = [NSBundle mainBundle].infoDictionary;
    NSString *version = info[@"CFBundleShortVersionString"];
    NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"ClientVersion" forKey:NSHTTPCookieName];
    [cookieProperties setObject:version forKey:NSHTTPCookieValue];
    [cookieProperties setObject:kHTTPCookieDomain forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:kBaseURL forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

@end
