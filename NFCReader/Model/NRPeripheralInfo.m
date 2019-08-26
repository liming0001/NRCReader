//
//  NRPeripheralInfo.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/14.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRPeripheralInfo.h"

@implementation NRPeripheralInfo

-(instancetype)init{
    self = [super init];
    if (self) {
        _characteristics = [[NSMutableArray alloc]init];
    }
    return self;
}

@end
