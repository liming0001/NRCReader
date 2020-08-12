//
//  AppDelegate.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/11.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "AppDelegate.h"
#import "NRLoginViewController.h"
#import "NRLoginViewModel.h"
#import "NRNavigationViewController.h"
#import "AsyncUdpSocketN.h"
#import <UMCommon/UMCommon.h>
#import "TableDataInfoView.h"
#import "EmpowerView.h"
#import "ChipInfoView.h"
#import "EPKillShowView.h"
#import "EPPayShowView.h"
#import "ModificationResultsView.h"
#import "TableJiaJiancaiView.h"
#import "EPCowPointChooseShowView.h"
#import "EPINSShowView.h"
#import "EPINSOddsShowView.h"
#import "NRThreeFairsPointShowView.h"
#import "EPSixWinShowView.h"

static NSString *Channel = @"App Store";
//友盟统计
static NSString *UMGAppKey = @"5deeff8e0cafb20d5e00058b";

@interface AppDelegate ()

@property (nonatomic, strong) AsyncUdpSocketN *sendSocket;
@property (nonatomic, strong) AsyncUdpSocketN *recvSocket;
@property (nonatomic, copy) NSString *serviceAddress;

@end

@implementation AppDelegate

#pragma mark - 对象实例化
+ (instancetype)shareInstance{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //注册友盟统计
    [UMConfigure initWithAppkey:UMGAppKey channel:Channel];
    [self getCurrentLanguage];
    [self showLoginVC];
    
//    [self createSender];
//    [NRCommand writeInfoToChip4_testWithwashaNumber:@"ewsrew-1"];
//    DLOG(@"5555555=========%@",[NRCommand changeNormalStrToBase64Hex:@"U88888"]);
    return YES;
}

#pragma mark -- 登录
- (void)showLoginVC{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NRLoginViewModel *viewModel = [[NRLoginViewModel alloc]init];
    NRLoginViewController *login = [NRLoginViewController new];
    login.viewModel = viewModel;
    NRNavigationViewController *loginController = [[NRNavigationViewController alloc] initWithRootViewController:login];
    self.window.rootViewController = loginController;
    [self.window makeKeyAndVisible];
}

#pragma mark -- 台面数据
- (TableDataInfoView *)tableDataInfoV{
    TableDataInfoView *tableDataInfoV = [[[NSBundle mainBundle]loadNibNamed:@"TableDataInfoView" owner:nil options:nil]lastObject];
    tableDataInfoV.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return tableDataInfoV;
}

#pragma mark -- 权限验证
- (EmpowerView *)empowerView{
    EmpowerView *empowerView = [[[NSBundle mainBundle]loadNibNamed:@"EmpowerView" owner:nil options:nil]lastObject];
    empowerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return empowerView;
}

#pragma mark -- 筹码信息
- (ChipInfoView *)chipInfoView{
    ChipInfoView *chipInfoView = [[[NSBundle mainBundle]loadNibNamed:@"ChipInfoView" owner:nil options:nil]lastObject];
    chipInfoView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return chipInfoView;
}

#pragma mark -- 杀注界面
- (EPKillShowView *)killShowView{
    EPKillShowView *killShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPKillShowView" owner:nil options:nil]lastObject];
    killShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return killShowView;
}

#pragma mark -- 赔付界面
- (EPPayShowView *)payShowView{
    EPPayShowView *payShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPPayShowView" owner:nil options:nil]lastObject];
    payShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return payShowView;
}

#pragma mark -- 修改露珠
- (ModificationResultsView *)modifyResultsView{
    ModificationResultsView *modifyResultsView = [[[NSBundle mainBundle]loadNibNamed:@"ModificationResultsView" owner:nil options:nil]lastObject];
    modifyResultsView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return modifyResultsView;
}

#pragma mark -- 加减彩
- (TableJiaJiancaiView *)addOrMinusView{
    TableJiaJiancaiView *addOrMinusView = [[TableJiaJiancaiView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    return addOrMinusView;
}

#pragma mark -- 点数选择
- (EPCowPointChooseShowView *)cowPointShowView{
    EPCowPointChooseShowView *cowPointShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPCowPointChooseShowView" owner:nil options:nil]lastObject];
    cowPointShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return cowPointShowView;
}

#pragma mark -- 输赢选择
- (EPINSShowView *)cowResultShowView{
    EPINSShowView *cowResultShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPINSShowView" owner:nil options:nil]lastObject];
    cowResultShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return cowResultShowView;
}

#pragma mark -- 三公点数选择
- (NRThreeFairsPointShowView *)fairsPointShowView{
    NRThreeFairsPointShowView *fairsPointShowView = [[[NSBundle mainBundle]loadNibNamed:@"NRThreeFairsPointShowView" owner:nil options:nil]lastObject];
    fairsPointShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return fairsPointShowView;
}

- (EPINSOddsShowView *)insOddsShowView{
    EPINSOddsShowView *insOddsShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPINSOddsShowView" owner:nil options:nil]lastObject];
    insOddsShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return insOddsShowView;
}

- (EPSixWinShowView *)sixWinShowView{
    EPSixWinShowView *sixWinShowView = [[[NSBundle mainBundle]loadNibNamed:@"EPSixWinShowView" owner:nil options:nil]lastObject];
    sixWinShowView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return sixWinShowView;
}

#pragma mark - 创建发送
- (void) createSender{
    NSError *error = nil;
    self.sendSocket = [[AsyncUdpSocketN alloc] initWithDelegate:self];
    [self.sendSocket enableBroadcast:YES error:&error];
    [self.sendSocket bindToPort:65535 error:&error];
    [self.sendSocket receiveWithTimeout: -1 tag: 0];
    [self sendMsg:@"58"];
}

- (void)sendMsg:(NSString *) msg{
    // 我想给ip的机器发送消息msg
    [self.sendSocket sendData:[NRCommand stringToByte:msg] toHost:@"255.255.255.255" port:65535 withTimeout:-1 tag:0];
}

- (BOOL) onUdpSocket:(AsyncUdpSocketN *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    // data 对方出过来的数据
    // tag == 200
    // host从哪里来数据 ip
    // port 对象的端口
    NSLog(@"recv data from %@:%d", host, port);
//    [EPToast makeText:[NSString stringWithFormat:@"当前IP:%@:%d",host,port]];
//    if (tag == 200) {
        [sock receiveWithTimeout:-1 tag:tag];
        // 此处处理接受到的数据
//    }
    if ([host length]!=0) {
        [EPAppData sharedInstance].bind_ip = host;
        [EPAppData sharedInstance].bind_port = 6000;
    }
    return YES;
}

- (void)getCurrentLanguage{
    NSNumber *languageIndex =  [[NSUserDefaults standardUserDefaults]objectForKey:@"languageKey"];
    [EPAppData sharedInstance].language = [[EPLanguage alloc] initWithLanguageType:languageIndex.integerValue];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits
       DLOG(@"开始激活2");
       [[NSUserDefaults standardUserDefaults]setObject:[NSNumber numberWithInteger:[self getNowTimeTimestamp]] forKey:@"touchIDTimeKey"];
       [[NSUserDefaults standardUserDefaults]synchronize];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    DLOG(@"开始激活3");
       NSInteger curTimeStamp = [self getNowTimeTimestamp];
       DLOG(@"curTimeStamp = %ld",curTimeStamp);
       NSNumber *cacheTimeStamp = [[NSUserDefaults standardUserDefaults]objectForKey:@"touchIDTimeKey"];
       if (curTimeStamp-cacheTimeStamp.integerValue>10*60) {
           [self showLoginVC];
       }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.、
}

#pragma mark - 获取当前时间戳
- (NSInteger)getNowTimeTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval timeStamp =[dat timeIntervalSince1970];
    return timeStamp;
}


@end
