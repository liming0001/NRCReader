//
//  NSDictionary+NullJson.h
//  NFCReader
//
//  Created by 李黎明 on 2020/6/10.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (NullJson)

//类型识别:将所有的NSNull类型转化成@""

+(id)changeType:(id)myObj;

@end

NS_ASSUME_NONNULL_END
