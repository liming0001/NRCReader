//
//  AppDelegate.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/11.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "AppDelegate.h"
#import "NRLoginViewController.h"
#import "IQKeyboardManager.h"
#import "NRLoginViewModel.h"
#import "NRNavigationViewController.h"
#import "EPAppData.h"
#import "AsyncUdpSocketN.h"

@interface AppDelegate ()

@property (nonatomic, strong) AsyncUdpSocketN *sendSocket;
@property (nonatomic, strong) AsyncUdpSocketN *recvSocket;
@property (nonatomic, copy) NSString *serviceAddress;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    [self getCurrentLanguage];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NRLoginViewModel *viewModel = [[NRLoginViewModel alloc]init];
    NRLoginViewController *login = [NRLoginViewController new];
    login.viewModel = viewModel;
    NRNavigationViewController *loginController = [[NRNavigationViewController alloc] initWithRootViewController:login];
    self.window.rootViewController = loginController;
    [self.window makeKeyAndVisible];
    
//    [self createSender];
    
    return YES;
}

#pragma mark - 创建发送
- (void) createSender{
    NSError *error = nil;
    self.sendSocket = [[AsyncUdpSocketN alloc] initWithDelegate:self];
    [self.sendSocket enableBroadcast:YES error:&error];
    [self.sendSocket bindToPort:65535 error:&error];
    [self.sendSocket receiveWithTimeout: -1 tag: 0];
    
    [self sendMsg:@""];
}

- (void)sendMsg:(NSString *) msg{
    // 我想给ip的机器发送消息msg
//    NSData *msgData = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [self.sendSocket sendData:[NRCommand stringToByte:@"58"] toHost:@"255.255.255.255" port:65535 withTimeout:-1 tag:0];
}

- (BOOL) onUdpSocket:(AsyncUdpSocketN *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    // data 对方出过来的数据
    // tag == 200
    // host从哪里来数据 ip
    // port 对象的端口
        
    NSLog(@"recv data from %@:%d", host, port);
//    if (tag == 200) {
        NSString *sData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"recv data : %@", sData);
        [sock receiveWithTimeout:-1 tag:tag];
        
        // 此处处理接受到的数据
        
//    }
    return YES;
}

- (void)onUdpSocket:(AsyncUdpSocketN *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error{
    NSLog(@"didNotReceiveDataWithTag = %@", error);
}

- (void)getCurrentLanguage
{
    NSArray*languages = [NSLocale preferredLanguages];
    NSString*currentLanguage = [languages objectAtIndex:0];
    if (![EPAppData sharedInstance].isAlreadyShowGuidePage) {//第一次启动,跟随系统
        if ([currentLanguage hasPrefix:@"zh"]) {//中文
            [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:1];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:1] forKey:@"languageKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{//英文
            [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:0];
            [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:0] forKey:@"languageKey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }else{
        NSNumber *languageIndex =  [[NSUserDefaults standardUserDefaults]objectForKey:@"languageKey"];
        [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:languageIndex.integerValue];
        [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
