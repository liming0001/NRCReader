//
//  EPAppData.m
//  Ellipal
//
//  Created by cyl on 2018/7/6.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "EPAppData.h"
#import "EPStr.h"

@interface EPAppData ()


@end

@implementation EPAppData

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static EPAppData *appData;
    dispatch_once(&onceToken, ^{
        appData = [EPAppData new];
    });
    return appData;
}

- (instancetype)init {
    self = [super init];
    
    NSString *pfLanguageCode = [NSLocale preferredLanguages][0];
    if ([pfLanguageCode hasPrefix:@"zh"]) {
        _language = [[EPLanguage alloc] initWithLanguageType:kEPLanguageTypeBm];
    } else {
        _language = [[EPLanguage alloc] initWithLanguageType:kEPLanguageTypeEn];
    }
    [EPStr sharedInstance].language = _language;
    [self load];
    return self;
}

- (void)setLanguage:(EPLanguage *)language {
    _language = language;
    [EPStr sharedInstance].language = _language;
    [self save];
}

- (void)load {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *language = [userDefaults objectForKey:@"language"];
    if ([language isKindOfClass:[NSData class]]) {
        EPLanguage *object = [NSKeyedUnarchiver unarchiveObjectWithData:language];
        if (object) {
            _language = object;
            [EPStr sharedInstance].language = _language;
        }
    }
    _isAlreadyShowGuidePage = [[userDefaults objectForKey:@"isAlreadyShowGuidePage"] boolValue];
}

- (void)save {
    NSData *language = [NSKeyedArchiver archivedDataWithRootObject:self.language];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:language forKey:@"language"];
    [userDefaults setObject:@(self.isAlreadyShowGuidePage) forKey:@"isAlreadyShowGuidePage"];
    [userDefaults synchronize];
}

//+ (BOOL)socketNoConnectedShow{
//    [EPSound playWithSoundName:@"click_sound"];
//    if ([SGSocketManager SocketConnectState]!=SGSocketConnectState_ConnectSuccess) {
//        [[EPToast makeText:@"未连接上设备，请检查设备网络或IP地址是否对应" WithError:YES]showWithType:LongTime];
//        return NO;
//    }else{
//        return YES;
//    }
//}
//
//#pragma mark -- 是否开启了新一局
//+ (BOOL)canStepToNextStep{
//    if (([PublicHttpTool shareInstance].puciCount != [PublicHttpTool shareInstance].prePuciCount)||[PublicHttpTool shareInstance].puciCount==0) {
//        [[EPToast makeText:@"请先开启新一局"]showWithType:ShortTime];
//        //响警告声音
//        [EPSound playWithSoundName:@"wram_sound"];
//        return NO;
//    }else{
//        return YES;
//    }
//}

@end
