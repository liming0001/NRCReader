//
//  NSData+SSToolkitAdditions.h
//  SSToolkit
//
//  Created by Sam Soffes on 9/29/08.
//  Copyright 2008-2011 Sam Soffes. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (SSToolkitAdditions)


- (BOOL)isAllZero;

//返回十六进制字符串
- (NSString *)hexString;

//MD5加密
- (NSString *)MD5Sum;

//SHA1加密
- (NSString *)SHA1Sum;

//SHA256加密
- (NSString *)SHA256Sum;

//BASE64编码
- (NSString *)base64EncodedString;

//BASE64反编码
+ (NSData *)dataWithBase64String:(NSString *)base64String;

//AES256加密
- (NSData*)AES256EncryptWithKey:(NSString*)key;

//AES256解密
- (NSData*)AES256DecryptWithKey:(NSString*)key;

@end
