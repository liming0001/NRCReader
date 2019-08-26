//
//  NRCRCString.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/20.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRCRCString : NSObject

#pragma mark - 将字典转字符串
+(NSString *)convertToJsonData:(NSDictionary *)dict;
#pragma mark - 检测洗码号是否正确
+(BOOL)isWashCodeValidWithWashNumber:(NSString *)washNumber;

@end

NS_ASSUME_NONNULL_END
