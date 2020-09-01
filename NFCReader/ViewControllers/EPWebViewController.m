//
//  EPWebViewController.m
//  Ellipal
//
//  Created by cyl on 2018/7/26.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "EPWebViewController.h"
#import <WebKit/WebKit.h>

@interface EPWebViewController ()<WKUIDelegate,WKNavigationDelegate>

/** 加载进度条 */
@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *webView;


@end

@implementation EPWebViewController

- (UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height + 44, self.view.frame.size.width, 2);
        //设置进度条的色彩
        [_progressView setTrackTintColor:[UIColor colorWithRed:240.0/255 green:240.0/255 blue:240.0/255 alpha:1.0]];
        _progressView.progressTintColor = [UIColor blueColor];
    }
    return _progressView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.webView = [[WKWebView alloc] init];
    self.webView.UIDelegate=self;
    self.webView.navigationDelegate=self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleBar.mas_bottom);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
    //使用kvo监听进度
    [self.webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    //进度条
    [self.view addSubview:self.progressView];
    if (self.isLocalLink) {
        NSURL *url = [NSURL fileURLWithPath:self.link];
        NSError *error = nil;
        NSString *htmlContent = [NSString stringWithContentsOfURL:url usedEncoding:nil error:&error];
        if (error) {
            DLOG(@"%@", error);
        }
        [self.webView loadHTMLString:htmlContent baseURL:nil];
    } else {
        NSURL *url = [NSURL URLWithString:self.link];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];
    }
}

- (void)configureTitleBar {
    self.titleBar.backgroundColor = [UIColor blackColor];
    [self.titleBar setTitle:self.webTitle];
    [self setLeftItemForGoBack];
    self.titleBar.rightItem = nil;
    self.titleBar.showBottomLine = YES;
    [self configureTitleBarToBlack];
}

/**
 开始加载web的时候
 
 @param webView webView description
 @param navigation navigation description
 */
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    //开始加载的时候,让进度条显示
    self.progressView.hidden = NO;
    self.progressView.progress = 0;
    self.progressView.alpha = 1.0;
    [UIView animateWithDuration:0.8 animations:^{
        self.progressView.progress = 0.1;
        
    }];
}

/**
 当网页加载完成的时候调用
 
 @param webView web描述
 @param navigation 导航的描述
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.progressView = nil;
    self.progressView.hidden = YES;
    self.progressView.progress = 0;
    self.progressView.alpha = 0;
}

/**
 kvo监听进度条
 
 @param keyPath keyPath description
 @param object object description
 @param change change description
 @param context context description
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView ) {
        [self.progressView setAlpha:1.0];
        
        [self.progressView setProgress:self.webView.estimatedProgress ];
        if (self.webView.estimatedProgress >= 1.0) {
            [UIView animateWithDuration:0.7 animations:^{
                [self.progressView setProgress:1.0 animated:YES];
                [self.progressView setAlpha:0.0];
                
            }];
            
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)dealloc{
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
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

@end
