//
//  EPAppData.h
//  Ellipal
//
//  Created by cyl on 2018/7/6.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EPLanguage.h"

@interface EPAppData : NSObject

@property (nonatomic, strong) EPLanguage *language;
@property (nonatomic, assign) BOOL isAlreadyShowGuidePage;
@property (nonatomic, assign) BOOL isConnectedSocket;
@property (nonatomic, strong) NSString *bind_ip;//需要绑定的IP
@property (nonatomic, assign) uint16_t bind_port;//需要绑定的端口

//#pragma mark -- 判断TCP连接状态
//+ (BOOL)socketNoConnectedShow;
//#pragma mark -- 是否开启了新一局
//+ (BOOL)canStepToNextStep;

+ (instancetype)sharedInstance;

@end
