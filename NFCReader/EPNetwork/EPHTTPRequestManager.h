//
//  EPHTTPRequestManager.h
//  EPEtherDemo
//
//  Created by smarter on 2018/7/14.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPBaseRequest.h"

@interface EPHTTPRequestManager : NSObject

+ (EPHTTPRequestManager *)manager;

- (void)addRequest:(EPBaseRequest *)request;

- (void)removeRequest:(EPBaseRequest *)request;

@end
