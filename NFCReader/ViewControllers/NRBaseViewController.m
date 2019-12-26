//
//  NRBaseViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/12.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRBaseViewController.h"
#import "EPLoadingView.h"

@interface NRBaseViewController ()

@property (nonatomic, strong) EPTitleBar *titleBar;
@property (nonatomic, strong) EPLoadingView *friendlyLoadingView;

@end

@implementation NRBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleBar = [EPTitleBar new];
    [self.view addSubview:self.titleBar];
    [self.titleBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.height.mas_equalTo([EPTitleBar heightForTitleBarPlusStatuBar]);
    }];
    
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    DLOG(@"%@ %@", NSStringFromCGRect(rectStatus), NSStringFromCGRect(self.titleBar.frame));
    
    @weakify(self);
    [[self.view rac_signalForSelector:@selector(addSubview:)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self);
        [self takeTitleBarToFront];
        DLOG(@"takeTitleBarToFront");
    }];
    
    [self configureTitleBar];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    [self takeTitleBarToFront];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)configureTitleBar {
    [self.titleBar setTitle:@""];
    [self setLeftItemForGoBack];
    self.titleBar.rightItem = nil;
}

- (void)takeTitleBarToFront {
    [self.view bringSubviewToFront:self.titleBar];
}

- (void)configureTitleBarToBlack {
    self.titleBar.tbTintColor = [UIColor colorWithHexString:@"#ffffff"];
    self.titleBar.leftItem.contentButton.tintColor = [UIColor colorWithHexString:@"#546875"];
    self.titleBar.rightItem.contentButton.tintColor = [UIColor colorWithHexString:@"#546875"];
}

- (void)configureTitleBarToWhite {
    self.titleBar.tbTintColor = [UIColor blackColor];
    self.titleBar.leftItem.contentButton.tintColor = kEPTitleBarItemColorWhite;
    self.titleBar.rightItem.contentButton.tintColor = kEPTitleBarItemColorWhite;
}

- (void)setLeftItemForGoBack {
    @weakify(self);
    self.titleBar.leftItem = [[EPTitleBarItem alloc] initWithImage:[UIImage imageNamed:@"nav_icon_back_w"] tintColor:kEPTitleBarItemColorBlack block:^{
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)reloadDataInView{
    
}

- (void)showLoadingViewWithTop:(CGFloat)topOffset{
    if (!_friendlyLoadingView) {
        _friendlyLoadingView = [[EPLoadingView alloc] initWithFrame:CGRectMake(0, topOffset+[[UIApplication sharedApplication] statusBarFrame].size.height-20, kScreenWidth, kScreenHeight-topOffset)];
    }
    @weakify(self);
    self.friendlyLoadingView.reloadButtonClickedCompleted = ^(UIButton *sender) {
        // 这里可以做网络重新加载的地方
        @strongify(self);
        [self reloadDataInView];
    };
    [self.view addSubview:self.friendlyLoadingView];
    [self.friendlyLoadingView showFriendlyLoadingWithAnimated:YES];
}

- (void)hideLoadingView{
    [self.friendlyLoadingView hideLoadingView];
    self.friendlyLoadingView = nil;
}

- (void)showLoadingResultWithType:(EPLoadingType)loadingType{
    if (loadingType==kEPNetWorkError) {
        [self.friendlyLoadingView showFriendlyLoadingWithAnimated:NO];
    }else{
        [self.friendlyLoadingView showReloadView];
    }
}

- (void)showWaitingViewWithText:(NSString *)text {
    UIView *window = [self findWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.label.text = text;
    hud.layer.zPosition = 100;
    [hud hideAnimated:YES afterDelay:15];
}

- (void)showWaitingView {
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.layer.zPosition = 100;
    UIView *window = [self findWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.layer.zPosition = 100;
    [hud hideAnimated:YES afterDelay:15];
}

- (void)hideWaitingView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self hideWaitingViewInWindow];
}

- (void)showWaitingViewInWindow {
    UIView *window = [self findWindow];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.layer.zPosition = 100;
    [hud hideAnimated:YES afterDelay:15];
}

- (void)hideWaitingViewInWindow {
    UIView *window = [self findWindow];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

- (void)showMessage:(NSString *)message {
    [[EPToast makeText:message]showWithType:ShortTime];
}

- (void)showLognMessage:(NSString *)message {
    [[EPToast makeText:message]showWithType:LongTime];
}

- (void)showMessage:(NSString *)message withSuccess:(BOOL)sucess {
    [[EPToast makeText:message WithError:!sucess]showWithType:ShortTime];
}

- (void)showLongMessage:(NSString *)message withSuccess:(BOOL)sucess {
    [[EPToast makeText:message WithError:!sucess]showWithType:LongTime];
}

- (UIView *)findWindow {
    UIView *window = [[UIApplication sharedApplication] keyWindow];
    if (!window) {
        window = self.view;
    }
    return window;
}

- (void)dealloc {
    self.friendlyLoadingView = nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
