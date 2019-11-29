//
//  LYKeychainTool.h
//  NFCReader
//
//  Created by 李黎明 on 2019/11/27.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LYKeychainTool : NSObject

/**
 * 储存字符串到钥匙串
 * @param sValue 对应的Value
 * @param sKey 对应的Key
 */
+ (void)saveKeychainValue:(NSString *)sValue key:(NSString *)sKey;
 
/**
 * 从钥匙串获取字符串
 * @param sKey 对应的Key
 * @return 返回储存的Value
 */
+ (NSString *)readKeychainValue:(NSString *)sKey;
 
/**
 * 从钥匙串删除字符串
 * @param sKey 对应的Key
 */
+ (void)deleteKeychainValue:(NSString *)sKey;

@end

NS_ASSUME_NONNULL_END
