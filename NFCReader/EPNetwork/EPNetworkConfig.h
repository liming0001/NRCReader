//
//  EPNetworkConfig.h
//  EPEtherDemo
//
//  Created by smarter on 2018/7/14.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPNetworkConfig : NSObject

+ (EPNetworkConfig *)defaultConfig;

@property (strong, nonatomic) NSString *baseURL;

- (void)addCookie;

@end
