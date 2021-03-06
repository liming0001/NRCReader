//
//  NRLoginViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/12.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRLoginViewController.h"
#import "NRTableChooseViewController.h"
#import "NRLoginViewModel.h"
#import "NRLoginInfo.h"
#import "DealerManagementViewController.h"
#import "BLEIToll.h"
#import "NRUpdateInfo.h"
#import "NRAddOrMinusChipViewController.h"

@interface NRLoginViewController ()

@property (nonatomic, strong) UIImageView *loginbg_img;
@property (nonatomic, strong) UILabel *login_title;
@property (nonatomic, strong) UILabel *login_user_tip;

@property (nonatomic, strong) UITextField *userNameTextField;
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) NRLoginInfo *curLoginInfo;

@end

@implementation NRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.loginbg_img = [UIImageView new];
    self.loginbg_img.image = [UIImage imageNamed:@"BG"];
    self.loginbg_img.backgroundColor = [UIColor colorWithHexString:@"#000000"];
    [self.view addSubview:self.loginbg_img];
    [self.loginbg_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.view);
    }];
    
    self.login_title = [UILabel new];
    self.login_title.font = [UIFont fontWithName:@"PingFang SC" size:26];
    self.login_title.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.login_title.text = @"VM娱乐桌面跟踪系统";
    self.login_title.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.login_title];
    [self.login_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.top.equalTo(self.view).offset([[UIApplication sharedApplication] statusBarFrame].size.height+10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(30);
    }];
    
    self.login_user_tip = [UILabel new];
    self.login_user_tip.font = [UIFont fontWithName:@"PingFang SC" size:22];
    self.login_user_tip.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.login_user_tip.text = @"用户登录";
    self.login_user_tip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.login_user_tip];
    [self.login_user_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(16);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-110);
        make.height.mas_equalTo(20);
    }];
    
    self.userNameTextField = [UITextField new];
    self.userNameTextField.backgroundColor = [UIColor colorWithHexString:@"#1b252e"];
    self.userNameTextField.layer.cornerRadius = 5;
    self.userNameTextField.textColor = [UIColor colorWithHexString:@"#ffffff"];
    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#ffffff"]}];
    self.userNameTextField.attributedPlaceholder = placeholderString;
    UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.userNameTextField.leftView = leftview;
    self.userNameTextField.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.userNameTextField];
    [self.userNameTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(150);
        make.centerX.equalTo(self.view);
        make.centerY.equalTo(self.view).offset(-40);
        make.height.mas_equalTo(55);
    }];
    
    self.passwordTextField = [UITextField new];
    self.passwordTextField.backgroundColor = [UIColor colorWithHexString:@"#1b252e"];
    self.passwordTextField.layer.cornerRadius = 5;
    self.passwordTextField.textColor = [UIColor colorWithHexString:@"#ffffff"];
    NSMutableAttributedString *pwsplaceholderString = [[NSMutableAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#ffffff"]}];
    self.passwordTextField.attributedPlaceholder = pwsplaceholderString;
    self.passwordTextField.text = @"123";
    UIView *pas_leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    self.passwordTextField.leftView = pas_leftview;
    self.passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.passwordTextField.secureTextEntry = YES;
    [self.view addSubview:self.passwordTextField];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameTextField.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(150);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(55);
    }];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginButton.layer.cornerRadius = 5;
    [self.loginButton setTitle:@"登入" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.loginButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.loginButton.backgroundColor = [UIColor colorWithHexString:@"#347622"];
    [self.loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.left.equalTo(self.view).offset(150);
    }];
    
    [self employee_logoutplusWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
    }];
    
    NSString *login_userName = [[LYKeychainTool readKeychainValue:@"login_userName"]NullToBlankString];
    self.userNameTextField.text = login_userName;
}

- (void)configureTitleBar {
    self.titleBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[PublicHttpTool shareInstance]stopPingTimer];
}

#pragma mark - 用户退出登录
- (void)employee_logoutplusWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    NSString *login_token = [[LYKeychainTool readKeychainValue:@"login_token"]NullToBlankString];
    NSString *login_fid = [[LYKeychainTool readKeychainValue:@"login_ID"]NullToBlankString];
    NSString *login_tableID = [[LYKeychainTool readKeychainValue:@"login_tableID"]NullToBlankString];
    if (!login_tableID) {
        login_tableID = @"";
    }
    if (login_token.length!=0) {
        NSDictionary * param = @{
                                    @"access_token":login_token,
                                    @"femp_num":login_fid,
                                    @"ftableid":login_tableID
                                 };
        NSArray *paramList = @[param];
        NSDictionary * Realparam = @{
                                     @"f":@"employee_logoutplus",
                                     @"p":[paramList JSONString]
                                     };
        [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
            if (suc) {
                [LYKeychainTool deleteKeychainValue:@"login_token"];
                [LYKeychainTool deleteKeychainValue:@"login_ID"];
                [LYKeychainTool deleteKeychainValue:@"login_tableID"];
            }
            block(suc, msg,error);
        }];
    }
}

- (void)loginAction{
    [EPSound playWithSoundName:@"click_sound"];
    if ([[self.userNameTextField.text NullToBlankString]length]==0) {
        [self showMessage:@"请输入用户名"];
        return;
    }
    if ([[self.passwordTextField.text NullToBlankString]length]==0) {
        [self showMessage:@"请输入密码"];
        return;
    }
    [self showWaitingViewWithText:@"登录中..."];
   NSDictionary * param = @{
              @"femp_num":self.userNameTextField.text,
              @"femp_pwd":self.passwordTextField.text
              };
    NSArray *paramList = @[param];
    NSDictionary * Realparam = @{
                             @"f":@"employee_loginplus",
                             @"p":[paramList JSONString]
                             };
    @weakify(self);
    [EPService nr_PublicWithParamter:Realparam block:^(NSDictionary *responseDict, NSString *msg, EPSreviceError error, BOOL suc) {
        @strongify(self);
        DLOG(@"responseDict = %@",responseDict);
        [self hideWaitingView];
        if (suc) {
            self.curLoginInfo = [NRLoginInfo yy_modelWithDictionary:responseDict];
            [PublicHttpTool shareInstance].access_token = self.curLoginInfo.access_token;
            [PublicHttpTool shareInstance].femp_num = [NSString stringWithFormat:@"%@",self.curLoginInfo.femp_num];
            [PublicHttpTool shareInstance].cp_tableRijieDate = [NRCommand getCurrentDate];
            [PublicHttpTool shareInstance].curupdateInfo.fhg_id = self.curLoginInfo.fid;
            [EPAppData sharedInstance].bind_ip = self.curLoginInfo.bind_ip;
            [LYKeychainTool saveKeychainValue:self.curLoginInfo.access_token key:@"login_token"];
            [LYKeychainTool saveKeychainValue:self.curLoginInfo.fid key:@"login_ID"];
            [LYKeychainTool saveKeychainValue:self.userNameTextField.text key:@"login_userName"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[PublicHttpTool shareInstance]startPingTimer];
            });
            if ([self.curLoginInfo.femp_role intValue]==1||[self.curLoginInfo.femp_role intValue]==8) {
                if ([self.curLoginInfo.femp_role intValue]==8) {
                    [PublicHttpTool shareInstance].isBigPermissions = YES;
                    NRAddOrMinusChipViewController *vc = [NRAddOrMinusChipViewController new];
                    vc.curLoginInfo = self.curLoginInfo;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    [PublicHttpTool shareInstance].isBigPermissions = NO;
                    [self managerLoginAction];
                }
            }else{
                [self tableChoose];
            }
        }else{
            [self showSoundMessage:msg];
        }
    }];
}

- (void)tableChoose{
    NRTableChooseViewController *vc = [NRTableChooseViewController new];
    vc.viewModel = [self.viewModel tableChooseViewModelWithLoginInfo:self.curLoginInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)managerLoginAction{
    
    DealerManagementViewController *vc = [DealerManagementViewController new];
    vc.viewModel = [self.viewModel managerViewModelWithChipInfo:self.curLoginInfo];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
