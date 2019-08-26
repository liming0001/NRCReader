//
//  NFPopupTextContainView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/7/16.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NFPopupTextContainView.h"

@implementation NFPopupTextContainView

- (id)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
        
        UILabel *title_lab = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-200, 20)];
        title_lab.text = @"请输入管理员账号密码";
        title_lab.textAlignment = NSTextAlignmentCenter;
        title_lab.font = [UIFont systemFontOfSize:18];
        [self addSubview:title_lab];
        
        self.adminNameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 80, kScreenWidth-200, 60)];
        self.adminNameTF.placeholder = @"请输入管理员账号";
        self.adminNameTF.layer.borderWidth = 0.5;
        self.adminNameTF.layer.borderColor = [UIColor colorWithHexString:@"#c1c1c1"].CGColor;
        self.adminNameTF.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        UIView *leftview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.adminNameTF.leftView = leftview;
        self.adminNameTF.leftViewMode = UITextFieldViewModeAlways;
        self.adminNameTF.font = [UIFont systemFontOfSize:16];
        self.adminNameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:self.adminNameTF];
        
        self.adminPasswordTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 140, kScreenWidth-200, 60)];
        self.adminPasswordTF.placeholder = @"请输入管理员密码";
        self.adminPasswordTF.textColor = [UIColor colorWithHexString:@"#4a4a4a"];
        self.adminPasswordTF.font = [UIFont systemFontOfSize:16];
        self.adminPasswordTF.layer.borderWidth = 0.5;
        UIView *leftview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        self.adminPasswordTF.leftView = leftview1;
        self.adminPasswordTF.leftViewMode = UITextFieldViewModeAlways;
        self.adminPasswordTF.layer.borderColor = [UIColor colorWithHexString:@"#c1c1c1"].CGColor;
        self.adminPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.adminPasswordTF.secureTextEntry = YES;
        [self addSubview:self.adminPasswordTF];
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame = CGRectMake(20, 220, (kScreenWidth-160-40-20)/2, 50);
        [sureButton setTitle:[EPStr getStr:kEPConfirm note:@"确定"] forState:UIControlStateNormal];
        [sureButton setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont systemFontOfSize:16];
        sureButton.layer.borderWidth = 0.5;
        sureButton.layer.borderColor = [UIColor colorWithHexString:@"#c1c1c1"].CGColor;
        [sureButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
        sureButton.backgroundColor = [UIColor clearColor];
        [self addSubview:sureButton];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(CGRectGetMaxX(sureButton.frame)+20, 220, (kScreenWidth-160-40-20)/2, 50);
        [cancelButton setTitle:[EPStr getStr:kEPCancel note:@"取消"] forState:UIControlStateNormal];
        cancelButton.layer.borderWidth = 0.5;
        cancelButton.layer.borderColor = [UIColor colorWithHexString:@"#c1c1c1"].CGColor;
        [cancelButton setTitleColor:[UIColor colorWithHexString:@"#4a4a4a"] forState:UIControlStateNormal];
        cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        cancelButton.backgroundColor = [UIColor clearColor];
        [cancelButton addTarget:self action:@selector(cancelPupopView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
    } return self;
}

- (void)confirmButtonAction{
    if ([[self.adminNameTF.text NullToBlankString]length]==0 ) {
        [[EPToast makeText:@"请输入用户名"]showWithType:ShortTime];
        return;
    }
    if ([[self.adminPasswordTF.text NullToBlankString]length]==0 ) {
        [[EPToast makeText:@"请输入密码"]showWithType:ShortTime];
        return;
    }
    [self cancelPupopView];
    if (_sureButtonClickedCompleted) {
        _sureButtonClickedCompleted(self.adminNameTF.text,self.adminPasswordTF.text);
    }
}

- (void)cancelPupopView{
    [self.container dismiss];
}

// 准备弹出(初始化弹层位置)
- (void)willPopupContainer:(DSHPopupContainer *)container; {
    CGRect frame = self.frame;
    frame.size = CGSizeMake(kScreenWidth-160, 290);
    frame.origin.x = 80;
    frame.origin.y = (kScreenHeight-290)/2;
    self.frame = frame;
}

// 已弹出(做弹出动画)
- (void)didPopupContainer:(DSHPopupContainer *)container duration:(NSTimeInterval)duration; {
    self.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:duration animations:^{
        self.transform = CGAffineTransformMakeScale(1.f, 1.f);
    }];
}

// 将要移除(做移除动画)
- (void)willDismissContainer:(DSHPopupContainer *)container duration:(NSTimeInterval)duration; {
    CGRect frame = self.frame;
    frame.origin.y = container.frame.size.height;
    [UIView animateWithDuration:duration animations:^{
        self.alpha = 0.f;
    }];
}

@end
