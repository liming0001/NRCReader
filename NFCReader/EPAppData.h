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

+ (instancetype)sharedInstance;

@end
