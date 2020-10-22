//
//  NRTableChooseViewController.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/14.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRTableChooseViewController.h"
#import "NRTableChooseViewModel.h"
#import "NRTableCollectionViewCell.h"
#import "NRBaccaratViewController.h"
#import "NRLoginInfo.h"
#import "NRTigerViewController.h"
#import "NRCowViewController.h"
#import "NRTableInfo.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "NRBaccaratView_workersController.h"
#import "NRThreeFairsViewController.h"

@interface NRTableChooseViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UICollectionView *tablesCollectionView;

@property (nonatomic, strong) UILabel *roleLab;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UILabel *IDLab;

@property (nonatomic, strong) UILabel *tableTipsLab;

@property (nonatomic, strong) UILabel *languageLab;
@property (nonatomic, strong) UIButton *changeLanguageButton;

@property (nonatomic, strong) UIButton *logoutButton;

@end

@implementation NRTableChooseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    
    CGFloat fontSize = 16;
    self.roleLab = [UILabel new];
    self.roleLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.roleLab.font = [UIFont systemFontOfSize:fontSize];
    self.roleLab.text = @"当前登录角色:荷官";
    [self.view addSubview:self.roleLab];
    [self.roleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.left.equalTo(self.view).offset(16);
        make.height.mas_equalTo(20);
    }];
    
    self.userNameLab = [UILabel new];
    self.userNameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.userNameLab.font = [UIFont systemFontOfSize:fontSize];
    self.userNameLab.textAlignment = NSTextAlignmentCenter;
    self.userNameLab.text = [NSString stringWithFormat:@"姓名:%@",self.viewModel.loginInfo.femp_xm];
    [self.view addSubview:self.userNameLab];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
        make.width.mas_offset(120);
    }];
    
    self.IDLab = [UILabel new];
    self.IDLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.IDLab.font = [UIFont systemFontOfSize:fontSize];
    self.IDLab.text = [NSString stringWithFormat:@"ID:%@",self.viewModel.loginInfo.femp_num];
    [self.view addSubview:self.IDLab];
    [self.IDLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom).offset(30);
        make.right.equalTo(self.view).offset(-16);
        make.height.mas_equalTo(20);
    }];
     
    self.tableTipsLab = [UILabel new];
    self.tableTipsLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tableTipsLab.font = [UIFont systemFontOfSize:20];
    self.tableTipsLab.text = @"选择对应台桌";
    self.tableTipsLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.tableTipsLab];
    [self.tableTipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(100);
        make.left.equalTo(self.view).offset(16);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(20);
    }];
    
    self.languageLab = [UILabel new];
    self.languageLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.languageLab.font = [UIFont systemFontOfSize:fontSize];
    self.languageLab.text = @"当前版本MZ4.0.24";
    self.languageLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.languageLab];
    [self.languageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-60);
        make.centerX.equalTo(self.view).offset(0);
        make.height.mas_equalTo(20);
    }];
    
    self.logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logoutButton.layer.cornerRadius = 5;
    [self.logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    self.logoutButton.titleLabel.font = [UIFont systemFontOfSize:20];
    self.logoutButton.backgroundColor = [UIColor colorWithHexString:@"#ec3223"];
    [self.logoutButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.logoutButton];
    [self.logoutButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.languageLab.mas_top).offset(-30);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(50);
        make.left.equalTo(self.view).offset(150);
    }];
    
    self.tablesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
    self.tablesCollectionView.backgroundColor = [UIColor clearColor];
    [self.tablesCollectionView registerClass:[NRTableCollectionViewCell class] forCellWithReuseIdentifier:@"tablesCell"];
    [self.view addSubview:self.tablesCollectionView];
    self.tablesCollectionView.delegate = self;
    self.tablesCollectionView.dataSource = self;
    [self.tablesCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableTipsLab.mas_bottom).offset(20);
        make.bottom.equalTo(self.logoutButton.mas_top).offset(-20);
        make.left.equalTo(self.view).offset(16);
        make.centerX.equalTo(self.view);
        
    }];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    @weakify(self);
    [self.viewModel tableListWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        @strongify(self);
        [self.tablesCollectionView reloadData];
        [self.viewModel getChipTypeWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        }];
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //YES：允许右滑返回  NO：禁止右滑返回
    return NO;
}

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor colorWithHexString:@"#1c1c1c"];
    [self.titleBar setTitle:@"VM娱乐桌面跟踪系统"];
    [self setLeftItemForGoBack];
    self.titleBar.leftItem = nil;
    self.titleBar.rightItem = nil;
    self.titleBar.showBottomLine = NO;
    [self configureTitleBarToBlack];
}

- (void)logoutAction{
    [self showWaitingView];
    [self.viewModel employee_logoutplusWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self hideWaitingView];
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showSoundMessage:msg];
        }
    }];
}

- (void)configureSelectedCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NRTableCollectionViewCell *newCell = (NRTableCollectionViewCell *)cell;
    NRTableInfo *info = self.viewModel.tableList[indexPath.row];
    NSString *nameText = [NSString stringWithFormat:@"%@",info.ftbname];
    [newCell configureWithNumberText:nameText
                           titleText:nameText];
}

#pragma mark - Collection View Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.tableList.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"tablesCell" forIndexPath:indexPath];
    [self configureSelectedCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NRTableInfo *info = self.viewModel.tableList[indexPath.row];
    self.viewModel.selectTableInfo = info;
    [PublicHttpTool shareInstance].fid = info.fid;
    [PublicHttpTool shareInstance].tableName = info.ftbname;
    [LYKeychainTool saveKeychainValue:info.fid key:@"login_tableID"];
    [PublicHttpTool shareInstance].isAutoOrManual = NO;//默认自动版
    [EPAppData sharedInstance].bind_ip = info.bindip;
    [EPAppData sharedInstance].bind_port = 6000;
    [self showWaitingView];
    [self.viewModel chooseTableWithBlock:^(BOOL success, NSString *msg, EPSreviceError error) {
        [self hideWaitingView];
        if (success) {
            if ([info.fqptype isEqualToString:@"1"]) {//免佣百家乐
                [PublicHttpTool shareInstance].curGameType =1;
                NRBaccaratViewController *vc = [NRBaccaratViewController new];
                vc.viewModel = [self.viewModel baccaratViewModel];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([info.fqptype isEqualToString:@"2"]){//有佣百家乐
                [PublicHttpTool shareInstance].curGameType =2;
                NRBaccaratView_workersController *vc = [NRBaccaratView_workersController new];
                vc.viewModel = [self.viewModel baccarat_workersViewModel];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([info.fqptype isEqualToString:@"3"]){//牛牛
                [PublicHttpTool shareInstance].curGameType =4;
                NRCowViewController *vc = [NRCowViewController new];
                vc.viewModel = [self.viewModel cowViewModel];
                [self.navigationController pushViewController:vc animated:YES];
            }else if ([info.fqptype isEqualToString:@"4"]){//龙虎
                [PublicHttpTool shareInstance].curGameType =3;
                NRTigerViewController *vc = [[NRTigerViewController alloc]init];
                vc.viewModel = [self.viewModel tigerViewModel];
                [self.navigationController pushViewController:vc animated:YES];
            }else{//三公，牌九
                [PublicHttpTool shareInstance].curGameType = [info.fqptype intValue];
                NRThreeFairsViewController *vc = [NRThreeFairsViewController new];
                vc.viewModel = [self.viewModel ThreeFairsViewModel];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            [self showSoundMessage:msg];
        }
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(180, 60);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    return edgeInsets;
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
