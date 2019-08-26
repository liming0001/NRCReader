//
//  EPPopView.m
//  TestPopView
//
//  Created by smarter on 2018/8/6.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import "EPPopView.h"

@implementation TitleConfiguration
@end

@implementation MessageConfiguration
@end

@interface PopUpViewBtnModel : NSObject
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) LQPopUpBtnStyle btnStyle;
@property (nonatomic, copy) buttonAction actionHandler;

@end

@implementation PopUpViewBtnModel
@end

@interface EPPopView () <UIGestureRecognizerDelegate>
@property (nonatomic, weak) UIView *contentView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *messageLabel;
@property (nonatomic, weak) UILabel *warmMessageLabel;
@property (nonatomic, strong) UITextField *entryTF;
@property (nonatomic, strong) TitleConfiguration *title_Configuration;
@property (nonatomic, strong) MessageConfiguration *msg_configuration;

@property (nonatomic, strong) NSMutableArray<PopUpViewBtnModel *> *buttonModels;
@property (nonatomic, assign) LQPopUpViewStyle popUpViewStyle;
@end

#define rgb_a(r, g, b, a)       [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define kTextFieldViewBottom 15.0
#define kColorHex(rgbValue, alphaValue)        [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0x00FF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0x0000FF))/255.0 \
alpha:(alphaValue)]

//Modifiable
#define kButtonHeight                                   50.0
#define kTextFieldHeight                               30.0
#define kLineHeight                                       0.6
#define kBtnStyleDefaultTextColor               kColorHex(0x0a7af3, 1.0)   // system alert blue
#define kBtnStyleCancelTextColor                kColorHex(0x555555, 1.0)  // black
#define kBtnStyleDestructiveTextColor          kColorHex(0xff4141, 1.0)  // red

@implementation EPPopView {
    CGFloat _contentWidth;
    CGFloat _contentHeight;
    CGFloat _wramMsgHeight;
    
    NSInteger _cancelBtnIndex;// 由于actionSheet的取消按钮需要单独添加，所以这里记录其下标
    BOOL _hasAddCancelBtnForOnce;// 由于actionSheet样式的特殊性，其“取消”按钮只允许添加一次
    
    NSNumber *_canHideByClickBgView;  // 0 default, 1 YES, 2 NO
    
    BOOL _onlyShowMessage;// 只展示信息
}


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = rgb_a(0, 0, 0, 0.5);
        self.alpha = 0;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBackGroundHide:)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        [self _initializeUI];
    }
    return self;
}

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    if (title) {
        _onlyShowMessage = NO;
        _contentHeight = 220;
    }else{
        _onlyShowMessage = YES;
        _contentHeight = 220;
    }
    return [self initWithTitleConfiguration:^(TitleConfiguration *titleConf) {
        titleConf.text = title;
    } messageConfiguration:^(MessageConfiguration *msgConf) {
        msgConf.text = message;
    }];
}

- (instancetype) initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray <NSString *>*)otherButtonTitles actionWithIndex:(void(^)(NSInteger index))action {
    EPPopView *popUpView = [self initWithTitleConfiguration:^(TitleConfiguration *titleConf) {
        titleConf.text = title;
    } messageConfiguration:^(MessageConfiguration *msgConf) {
        msgConf.text = message;
    }];
    
    if (otherButtonTitles && otherButtonTitles.count) {
        for (int i = 0; i < otherButtonTitles.count; i ++) {
            NSString *btnTitle = otherButtonTitles[i];
            if (btnTitle && btnTitle.length) {
                [popUpView addBtnWithTitle:btnTitle type:LQPopUpBtnStyleDefault handler:^{
                    if (action) action(i+1);
                }];
            }
        }
    }
    
    if (cancelButtonTitle && cancelButtonTitle.length) {
        [popUpView addBtnWithTitle:cancelButtonTitle type:LQPopUpBtnStyleCancel handler:^{
            if (action) action(0);
        }];
    }
    return popUpView;
}

-(instancetype) initWithTitleConfiguration:(void (^)(TitleConfiguration *configuration))titleConfiguration messageConfiguration:(void (^)(MessageConfiguration *configuration))msgConfiguration {
    self = [self init];
    if (self) {
        if (titleConfiguration) {
            
            titleConfiguration(_title_Configuration);
            if (!_title_Configuration.text || !_title_Configuration.text.length) _title_Configuration = nil;
        }else {
            _title_Configuration = nil;
        }
        
        if (msgConfiguration) {
            msgConfiguration(_msg_configuration);
            if (!_msg_configuration.text || !_msg_configuration.text.length) _msg_configuration = nil;
        }else {
            _msg_configuration = nil;
        }
    }
    return self;
}


- (void) _initializeUI {
    [self _valueInitialize];
    [self _setUpContentView];
    [self _setUpTitleLabel];
    [self _setUpMessageLabel];
}

- (void)_valueInitialize {
    _canHideByClickBgView = @(0);
    _contentWidth = kScreenWidth-150*2;
    _textFieldFontSize = 15.0;
    _btnStyleDefaultTextColor = kBtnStyleDefaultTextColor;
    _btnStyleCancelTextColor = kBtnStyleCancelTextColor;
    _btnStyleDestructiveTextColor = kBtnStyleDestructiveTextColor;
    _textFieldHeight = kTextFieldHeight;
    _buttonHeight = kButtonHeight;
    _lineHeight = kLineHeight;
    _buttonModels = [NSMutableArray array];
    
    _title_Configuration = [TitleConfiguration new];
    _title_Configuration.fontSize = 18.0;
    _title_Configuration.textColor = kColorHex(0x546875, 1.0);
    _title_Configuration.top = 15;
    
    _msg_configuration = [MessageConfiguration new];
    _msg_configuration.fontSize = 16.0;
    _msg_configuration.textColor = kColorHex(0x444444, 1.0);
    
}

- (void)_setUpContentView {
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = 4.0*(kScreenHeight/568.0);
    contentView.clipsToBounds = YES;
    [self addSubview:contentView];
    _contentView = contentView;
}

- (void)_setUpTitleLabel {
    UILabel *titleLabel = [UILabel new];
    titleLabel.numberOfLines = 0;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)_setUpMessageLabel {
    UILabel *messageLabel = [UILabel new];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [_contentView addSubview:messageLabel];
    _messageLabel = messageLabel;
}

- (void)addWarmMessage:(NSString *)warmS{
    [self _configureAndLayoutTitleLabel];
    [self _configureAndLayoutMsgLabel];
    UILabel *wramLabel = [UILabel new];
    wramLabel.numberOfLines = 0;
    wramLabel.textAlignment = NSTextAlignmentCenter;
    wramLabel.text = warmS;
    CGFloat adjust_w = 15.5;
    wramLabel.frame = CGRectMake(adjust_w, 5, _contentWidth-2*17.5-2*adjust_w, 80-10);
    wramLabel.textColor = kColorHex(0x282828, 1.0);
    wramLabel.font = [UIFont systemFontOfSize:15];
    _warmMessageLabel = wramLabel;
    
    [self _layoutWramMsg];
}

-(void)addBtnWithTitle:(NSString *)title type:(LQPopUpBtnStyle)style handler:(buttonAction)handler {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 1000+_buttonModels.count;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[self colorWithBtnStyle:style] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    [_contentView addSubview:button];
    
    PopUpViewBtnModel *btnModel = [PopUpViewBtnModel new];
    btnModel.button = button;
    btnModel.btnStyle = style;
    btnModel.actionHandler = handler;
    [_buttonModels addObject:btnModel];
}


- (void) addTextFieldWithPlaceholder:(NSString *)placeholder text:(NSString *)text secureEntry:(BOOL)secureEntry {
    UITextField *tf = [[UITextField alloc] init];
    tf.text = text;
    tf.placeholder = placeholder;
    tf.textColor = kColorHex(0x333333, 1.0);
    tf.font = [UIFont systemFontOfSize:_textFieldFontSize];
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    tf.secureTextEntry = secureEntry;
    tf.keyboardType = UIKeyboardTypeNumberPad;
    _entryTF = tf;
}


- (void)_configureAndLayoutTitleLabel {
    if (_title_Configuration) {
        CGFloat left_padding = 25;
        CGFloat labelWidth = _contentWidth-left_padding-left_padding;
        _titleLabel.text = _title_Configuration.text;
        _titleLabel.textColor = _title_Configuration.textColor;
        _titleLabel.font = [UIFont systemFontOfSize:_title_Configuration.fontSize];
        [self fixTopAndBottomValues];
        CGFloat top = _title_Configuration.top;
        CGSize titleSize = [_titleLabel.text boundingRectWithSize:CGSizeMake(labelWidth, 250) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _titleLabel.font} context:nil].size;
        _titleLabel.frame = CGRectMake(left_padding, top, labelWidth, titleSize.height);
    }
}

- (void)_configureAndLayoutMsgLabel {
    if (_msg_configuration) {
        CGFloat left_padding = 17.5;
        CGFloat labelWidth = _contentWidth-left_padding-left_padding;
        _messageLabel.text = _msg_configuration.text;
        _messageLabel.textColor = _msg_configuration.textColor;
        _messageLabel.font = [UIFont systemFontOfSize:_msg_configuration.fontSize];
        [self fixTopAndBottomValues];
        CGFloat top = CGRectGetMaxY(_titleLabel.frame) + _title_Configuration.bottom + _msg_configuration.top+5;
        CGSize msgSize = [_messageLabel.text boundingRectWithSize:CGSizeMake(labelWidth, 250) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _messageLabel.font} context:nil].size;
        _messageLabel.frame = CGRectMake(left_padding, top, labelWidth, msgSize.height);
    }
}

- (void)_configureAndLayoutOnlyMsgLabel {
    if (_msg_configuration) {
        CGFloat left_padding = 17.5;
        CGFloat labelWidth = _contentWidth-left_padding-left_padding;
        _messageLabel.text = _msg_configuration.text;
        _messageLabel.textColor = _msg_configuration.textColor;
        _messageLabel.font = [UIFont systemFontOfSize:_msg_configuration.fontSize];
        _messageLabel.frame = CGRectMake(left_padding, 0, labelWidth, 100);
    }
}

- (void)_layoutTextFields {
    if (_popUpViewStyle == LQPopUpViewStyleAlert) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboard_willShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboard_willHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    
    CGFloat tfPadding = 17.5;
    UIView *textFieldBgView = [UIView new];
    textFieldBgView.layer.cornerRadius = 4;
    textFieldBgView.backgroundColor = kColorHex(0xf5f5f5, 1);
    [_contentView addSubview:textFieldBgView];
    CGFloat baseTop = [self getTitleAndMsgLabelBaseHeight];
    textFieldBgView.frame = CGRectMake(tfPadding, baseTop, _contentWidth-2*tfPadding, 40);
    _entryTF.frame = CGRectMake(5, 5, _contentWidth-2*tfPadding-15.5*2, _textFieldHeight);
    _entryTF.keyboardType = UIKeyboardTypeNumberPad;
    [textFieldBgView addSubview:_entryTF];

    _contentView.frame = CGRectMake(10, kScreenHeight, _contentWidth, 200);
    _contentHeight = 200;
}

- (void)_layoutWramMsg {
    CGFloat left_padding = 17.5;
    UIView *warmMsgBgView = [UIView new];
    warmMsgBgView.layer.cornerRadius = 4;
    warmMsgBgView.backgroundColor = kColorHex(0xf5f5f5, 1);
    [_contentView addSubview:warmMsgBgView];
    CGFloat baseTop = CGRectGetMaxY(_messageLabel.frame)+11.5;
    warmMsgBgView.frame = CGRectMake(left_padding, baseTop, _contentWidth-2*left_padding, 80);
    [warmMsgBgView addSubview:_warmMessageLabel];
    _wramMsgHeight = CGRectGetMaxY(warmMsgBgView.frame)+14;
}

- (void)_layoutButtons {
    if (_popUpViewStyle == LQPopUpViewStyleAlert) {
        [self layoutBtnsForAlert];
    }else if (_popUpViewStyle == LQPopUpViewStyleActionSheet) {
        [self layoutBtnsForActionSheet];
    }
}

- (void) layoutBtnsForAlert {
    if (_buttonModels.count == 2) {
        if (_titleLabel&&!_entryTF&&!_onlyShowMessage) {
            CGFloat baseTop = CGRectGetMaxY(_titleLabel.frame) + _title_Configuration.bottom;
            //要确保“取消”按钮在最下面
            NSInteger offset = 0;
            NSInteger nonCancelBtnCount = 0;// 用于计算非取消按钮的个数及总高度
            for (int i = 0; i < _buttonModels.count; i ++) {
                PopUpViewBtnModel *btnModel = _buttonModels[i];
                if (btnModel.btnStyle == LQPopUpBtnStyleCancel) {
                    offset --;
                    continue;
                }
                nonCancelBtnCount ++;
                CGFloat top = baseTop;
                NSInteger index = i + offset;
                
                // Line 横线
                CALayer *lineLayer = [CALayer layer];
                lineLayer.backgroundColor = [kColorHex(0xdbdbdb, 1.0) CGColor];
                top += ((_lineHeight+_buttonHeight)*index);
                lineLayer.frame = CGRectMake(0, top, _contentWidth, _lineHeight);
                [_contentView.layer addSublayer:lineLayer];
                
                UIButton *button = btnModel.button;
                [button setTitleColor:[self colorWithBtnStyle:btnModel.btnStyle] forState:UIControlStateNormal];
                button.frame = CGRectMake(0, top+_lineHeight, _contentWidth, _buttonHeight);
            }
            //添加取消按钮
            CGFloat baseTop2 = baseTop + (_lineHeight+_buttonHeight) * nonCancelBtnCount;
            NSInteger index = 0;
            for (int i = 0; i < _buttonModels.count; i ++) {
                PopUpViewBtnModel *btnModel = _buttonModels[i];
                if (btnModel.btnStyle == LQPopUpBtnStyleCancel) {
                    CGFloat top = baseTop2;
                    
                    // Line 横线
                    CALayer *lineLayer = [CALayer layer];
                    lineLayer.backgroundColor = [kColorHex(0xdbdbdb, 1.0) CGColor];
                    top += ((_lineHeight+_buttonHeight)*index);
                    lineLayer.frame = CGRectMake(0, top, _contentWidth, _lineHeight);
                    [_contentView.layer addSublayer:lineLayer];
                    
                    UIButton *button = btnModel.button;
                    [button setTitleColor:[self colorWithBtnStyle:btnModel.btnStyle] forState:UIControlStateNormal];
                    button.frame = CGRectMake(0, top+_lineHeight, _contentWidth, _buttonHeight);
                    index ++;
                }
            }
            CGFloat content_height = 150;
            _contentView.frame = CGRectMake(10, kScreenHeight, _contentWidth, content_height);
            _contentHeight = _contentView.frame.size.height;
        }else{
            
            CGFloat content_height = 150;
            if (_entryTF) {
                content_height = 182;
            }
            for (int i = 0; i < _buttonModels.count; i ++) {
                PopUpViewBtnModel *btnModel = _buttonModels[i];
                UIButton *button = btnModel.button;
                [button setTitleColor:[self colorWithBtnStyle:btnModel.btnStyle] forState:UIControlStateNormal];
                button.frame = CGRectMake(_contentWidth/2.0*i, content_height-_buttonHeight, _contentWidth/2.0, _buttonHeight);
            }
            
            // Line 横线
            CALayer *lineLayer = [CALayer layer];
            lineLayer.backgroundColor = [kColorHex(0xdbdbdb, 1.0) CGColor];
            lineLayer.frame = CGRectMake(0, content_height-_buttonHeight-_lineHeight, _contentWidth, _lineHeight);
            [_contentView.layer addSublayer:lineLayer];
            //竖线
            CALayer *lineLayer2 = [CALayer layer];
            lineLayer2.backgroundColor = [kColorHex(0xdbdbdb, 1.0) CGColor];
            lineLayer2.frame = CGRectMake(_contentWidth/2.0, content_height-_buttonHeight, _lineHeight, _buttonHeight);
            [_contentView.layer addSublayer:lineLayer2];
            
            _contentView.frame = CGRectMake(10, kScreenHeight, _contentWidth, content_height);
            _contentHeight = _contentView.frame.size.height;
        }
    }else if (_buttonModels.count == 1) {
        _messageLabel.textColor = kColorHex(0xfb5859, 1.0);
        _messageLabel.font = [UIFont systemFontOfSize:15];
        PopUpViewBtnModel *btnModel = _buttonModels[0];
        UIButton *button = btnModel.button;
        [button setTitleColor:[self colorWithBtnStyle:btnModel.btnStyle] forState:UIControlStateNormal];
        button.frame = CGRectMake((_contentWidth-180)/2, _wramMsgHeight, 180, 40);
        button.layer.cornerRadius = 4;
        UIImage *image = [UIImage imageNamed:@"gradiant_h"];
        // 拉伸图片
        UIImage *newImage = [image stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [button setBackgroundImage:newImage forState:UIControlStateNormal];
        
        _contentView.frame = CGRectMake(10, kScreenHeight, _contentWidth, CGRectGetMaxY(button.frame)+14);
        _contentHeight = _contentView.frame.size.height;
    }else if (_buttonModels.count >= 3){
        CGFloat baseTop = 0;
        if (_titleLabel) {
            baseTop = CGRectGetMaxY(_titleLabel.frame) + _title_Configuration.bottom;
        }
        
        //要确保“取消”按钮在最下面
        NSInteger offset = 0;
        NSInteger nonCancelBtnCount = 0;// 用于计算非取消按钮的个数及总高度
        for (int i = 0; i < _buttonModels.count; i ++) {
            PopUpViewBtnModel *btnModel = _buttonModels[i];
            if (btnModel.btnStyle == LQPopUpBtnStyleCancel) {
                offset --;
                continue;
            }
            nonCancelBtnCount ++;
            CGFloat top = baseTop;
            NSInteger index = i + offset;
            
            // Line 横线
            CALayer *lineLayer = [CALayer layer];
            lineLayer.backgroundColor = [kColorHex(0xdbdbdb, 1.0) CGColor];
            top += ((_lineHeight+_buttonHeight)*index);
            lineLayer.frame = CGRectMake(0, top, _contentWidth, _lineHeight);
            [_contentView.layer addSublayer:lineLayer];
            
            UIButton *button = btnModel.button;
            [button setTitleColor:[self colorWithBtnStyle:btnModel.btnStyle] forState:UIControlStateNormal];
            button.frame = CGRectMake(0, top+_lineHeight, _contentWidth, _buttonHeight);
        }
        
        //添加取消按钮
        CGFloat baseTop2 = baseTop + (_lineHeight+_buttonHeight) * nonCancelBtnCount;
        NSInteger index = 0;
        for (int i = 0; i < _buttonModels.count; i ++) {
            PopUpViewBtnModel *btnModel = _buttonModels[i];
            if (btnModel.btnStyle == LQPopUpBtnStyleCancel) {
                CGFloat top = baseTop2;
                
                // Line 横线
                CALayer *lineLayer = [CALayer layer];
                lineLayer.backgroundColor = [kColorHex(0xdbdbdb, 1.0) CGColor];
                top += ((_lineHeight+_buttonHeight)*index);
                lineLayer.frame = CGRectMake(0, top, _contentWidth, _lineHeight);
                [_contentView.layer addSublayer:lineLayer];
                
                UIButton *button = btnModel.button;
                [button setTitleColor:[self colorWithBtnStyle:btnModel.btnStyle] forState:UIControlStateNormal];
                button.frame = CGRectMake(0, top+_lineHeight, _contentWidth, _buttonHeight);
                index ++;
            }
        }
        CGFloat content_height = 150;
        if (_titleLabel) {
            content_height = 200;
        }
        _contentView.frame = CGRectMake(10, kScreenHeight, _contentWidth, content_height);
        _contentHeight = _contentView.frame.size.height;
    }
}

- (void) layoutBtnsForActionSheet {
    CGFloat baseTop = 0;
    //要确保“取消”按钮在最下面
    NSInteger offset = 0;
    _cancelBtnIndex = 0;
    for (int i = 0; i < _buttonModels.count; i ++) {
        PopUpViewBtnModel *btnModel = _buttonModels[i];
        if (btnModel.btnStyle == LQPopUpBtnStyleCancel) {
            if (_hasAddCancelBtnForOnce) {
                NSAssert(!_hasAddCancelBtnForOnce, @"LQPopUpView：在ActionSheet样式时，请不要添加两个以上的取消按钮");
                return;
            }else {
                _hasAddCancelBtnForOnce = YES;
            }
            
            offset = -1;
            _cancelBtnIndex = i;
            continue;
        }
        
        CGFloat top = baseTop;
        NSInteger index = i + offset;
        // Line 横线
        CALayer *lineLayer = [CALayer layer];
        lineLayer.backgroundColor = [kColorHex(0xdbdbdb, 1.0) CGColor];
        top += ((_lineHeight+_buttonHeight)*index);
        lineLayer.frame = CGRectMake(0, top, _contentWidth, _lineHeight);
        [_contentView.layer addSublayer:lineLayer];
        
        UIButton *button = btnModel.button;
        [button setTitleColor:[self colorWithBtnStyle:btnModel.btnStyle] forState:UIControlStateNormal];
        button.frame = CGRectMake(0, top+_lineHeight, _contentWidth, _buttonHeight);
    }
    
    //计算contentView的frame
    if (_hasAddCancelBtnForOnce) {
        _contentView.frame = CGRectMake(10, kScreenHeight, _contentWidth, baseTop+(_lineHeight+_buttonHeight)*(_buttonModels.count-1));
    }else {
        _contentView.frame = CGRectMake(10, kScreenHeight, _contentWidth, baseTop+(_lineHeight+_buttonHeight)*_buttonModels.count);
    }
    //添加取消按钮
    if (_hasAddCancelBtnForOnce) {
        PopUpViewBtnModel *cancelBtnModel = _buttonModels[_cancelBtnIndex];
        UIButton *button = cancelBtnModel.button;
        [button setTitleColor:[self colorWithBtnStyle:cancelBtnModel.btnStyle] forState:UIControlStateNormal];
        CGFloat cancelBtnTop = kScreenHeight + _contentView.bounds.size.height + 10 + _buttonHeight + 10;
        button.frame = CGRectMake(10, cancelBtnTop, _contentWidth, _buttonHeight);
        button.layer.masksToBounds = YES;
        button.backgroundColor = [UIColor whiteColor];
        button.layer.cornerRadius = _contentView.layer.cornerRadius;
        [button removeFromSuperview];
        [self addSubview:button];
    }
}

- (void)fixTopAndBottomValues {
    if (_title_Configuration) {
        if (_msg_configuration) {
            if (_msg_configuration.bottom == 0) {
                _msg_configuration.bottom = 15.0;
            }
        }else {
            if (_title_Configuration.bottom == 0) {
                _title_Configuration.bottom = 15.0;
            }
        }
    }else {
        if (_msg_configuration) {
            if (_msg_configuration.top < 15.0) {
                _msg_configuration.top = 15.0;
            }
            if (_msg_configuration.bottom == 0) {
                _msg_configuration.bottom = 15.0;
            }
        }else {
        }
    }
}

- (CGFloat)getTitleAndMsgLabelBaseHeight {
    CGFloat height = 0;
    if (_msg_configuration) {
        height = CGRectGetMaxY(_messageLabel.frame) + _msg_configuration.bottom;
    }else {
        if (_title_Configuration) {
            height = CGRectGetMaxY(_titleLabel.frame) + _title_Configuration.bottom;
        }else {
            height = 15.0;
        }
    }
    return height;
}

- (UIColor *)colorWithBtnStyle:(LQPopUpBtnStyle)style {
    if (style == LQPopUpBtnStyleDefault) {
        return _btnStyleDefaultTextColor;
    }else if (style == LQPopUpBtnStyleCancel) {
        return _btnStyleCancelTextColor;
    }else if (style == LQPopUpBtnStyleDestructive) {
        return _btnStyleDestructiveTextColor;
    }
    return nil;
}

-(void)showInWindowWithPreferredStyle:(LQPopUpViewStyle)preferredStyle {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self showInView:window preferredStyle:preferredStyle];
}

-(void)showInView:(UIView *)view preferredStyle:(LQPopUpViewStyle)preferredStyle {
    _popUpViewStyle = preferredStyle;
    if (preferredStyle == LQPopUpViewStyleAlert) {
        _contentWidth = kScreenWidth-150*2;
        [view addSubview:self];
        _contentView.center = self.center;
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
        }];
        [self showAlertAnimation];
    }else if (preferredStyle == LQPopUpViewStyleActionSheet) {
        _contentWidth = kScreenWidth - 10 - 10;
        [view addSubview:self];
        [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseIn animations:^{
                                CGRect rect = self.contentView.frame;
                                CGFloat offset = self->_hasAddCancelBtnForOnce ? self->_buttonHeight+10 : 0;
                                rect.origin.y = kScreenHeight - rect.size.height - 10 - offset;
                                self.contentView.frame = rect;
                                
                                //取消按钮的动画
                                if (self->_hasAddCancelBtnForOnce) {
                                    PopUpViewBtnModel *cancelBtnModel = self->_buttonModels[self->_cancelBtnIndex];
                                    UIButton *button = cancelBtnModel.button;
                                    CGRect rect = button.frame;
                                    rect.origin.y = kScreenHeight - rect.size.height - 10;
                                    button.frame = rect;
                                }
                                
                                self.alpha = 1.0;
                            } completion:nil];
    }
}

+ (void)showInWindowWithMessage:(NSString *)message handler:(buttonClickAction)handler{
    EPPopView *popUpView = [[EPPopView alloc] initWithTitle:nil message:message];
    popUpView.btnStyleDefaultTextColor = kColorHex(0x4B9DF1, 1);
    popUpView.btnStyleCancelTextColor = kColorHex(0x999999, 1);
    [popUpView addBtnWithTitle:[EPStr getStr:kEPCancel note:@"取消"] type:LQPopUpBtnStyleCancel handler:^{
        // do something...
        handler(LQPopUpBtnStyleCancel);
    }];
    [popUpView addBtnWithTitle:[EPStr getStr:kEPConfirm note:@"确定"] type:LQPopUpBtnStyleDefault handler:^{
        // do something...
        handler(LQPopUpBtnStyleDefault);
    }];
    [popUpView showInWindowWithPreferredStyle:0];
}

+ (void)showEntryInView:(UIView *)view WithTitle:(NSString *)title handler:(entryTextInfoBlock)entryText{
    EPPopView *popUpView = [[EPPopView alloc] initWithTitle:title message:nil];
    __weak typeof(EPPopView) *weakPopUpView = popUpView;
    popUpView.btnStyleDefaultTextColor = kColorHex(0x4B9DF1, 1);
    popUpView.btnStyleCancelTextColor = kColorHex(0x546875, 1);
    [popUpView addTextFieldWithPlaceholder:title text:nil secureEntry:NO];
    [popUpView addBtnWithTitle:[EPStr getStr:kEPCancel note:@"取消"] type:LQPopUpBtnStyleCancel handler:nil];
    [popUpView addBtnWithTitle:[EPStr getStr:kEPConfirm note:@"确定"] type:LQPopUpBtnStyleDefault handler:^{
        [weakPopUpView.entryTF resignFirstResponder];
        // do something...
        entryText(weakPopUpView.entryTF.text);
    }];
    [popUpView showInView:view preferredStyle:0];
}

+ (void)showInWindowWithBtnsA:(NSArray *)btns Style:(LQPopUpViewStyle)style handler:(buttonsClickAction)buttons{
    EPPopView *popUpView = [[EPPopView alloc] initWithTitle:nil message:nil];
    popUpView.btnStyleDefaultTextColor = kColorHex(0x282828, 1);
    popUpView.btnStyleCancelTextColor = kColorHex(0x999999, 1);
    popUpView.btnStyleDestructiveTextColor = kColorHex(0x282828, 1);
    
    [popUpView addBtnWithTitle:btns[0] type:LQPopUpBtnStyleDefault handler:^{
        // do something...
        buttons(LQPopUpBtnStyleDefault);
    }];
    if (btns.count>=3) {
        [popUpView addBtnWithTitle:btns[1] type:LQPopUpBtnStyleDestructive handler:^{
            // do something...
            buttons(LQPopUpBtnStyleDestructive);
        }];
    }
    
    [popUpView addBtnWithTitle:btns[btns.count-1] type:LQPopUpBtnStyleCancel handler:^{
        // do something...
        buttons(LQPopUpBtnStyleCancel);
    }];
    
    [popUpView showInWindowWithPreferredStyle:style];
}

+ (void)showInWindowWithTitle:(NSString *)title BtnsA:(NSArray *)btns handler:(buttonsClickAction)buttons{
    EPPopView *popUpView = [[EPPopView alloc] initWithTitle:title message:nil];
    popUpView.btnStyleDefaultTextColor = kColorHex(0x282828, 1);
    popUpView.btnStyleCancelTextColor = kColorHex(0x999999, 1);
    popUpView.btnStyleDestructiveTextColor = kColorHex(0x282828, 1);
    
    [popUpView addBtnWithTitle:btns[0] type:LQPopUpBtnStyleDefault handler:^{
        // do something...
        buttons(LQPopUpBtnStyleDefault);
    }];
    
    if (btns.count>=3) {
        [popUpView addBtnWithTitle:btns[1] type:LQPopUpBtnStyleDestructive handler:^{
            // do something...
            buttons(LQPopUpBtnStyleDestructive);
        }];
    }
    
    [popUpView addBtnWithTitle:btns[btns.count-1] type:LQPopUpBtnStyleCancel handler:^{
        // do something...
        buttons(LQPopUpBtnStyleCancel);
    }];
    
    [popUpView showInWindowWithPreferredStyle:LQPopUpViewStyleAlert];
}


+ (void)showInWindowWithTitle:(NSString *)title WarmMessage:(NSString *)wramMessage Message:(NSString *)message handler:(copuMsgInfoBlock)hander{
    EPPopView *popUpView = [[EPPopView alloc] initWithTitle:title message:wramMessage];
    [popUpView addWarmMessage:message];
    popUpView.btnStyleDefaultTextColor = kColorHex(0xfb5859, 1);
    popUpView.btnStyleCancelTextColor = kColorHex(0xffffff, 1);
    [popUpView addBtnWithTitle:@"复制" type:LQPopUpBtnStyleCancel handler:^{
        // do something...
        hander(message);
    }];
    [popUpView showInWindowWithPreferredStyle:0];
}

-(void)didMoveToSuperview {
    if (self.superview) {
        [self _configureAndLayoutTitleLabel];
        if (_onlyShowMessage) {
            [self _configureAndLayoutOnlyMsgLabel];
        }else{
           [self _configureAndLayoutMsgLabel];
        }
        if (_entryTF) {
            [self _layoutTextFields];
        }
        [self _layoutButtons];
    }
}

- (void)showAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;
    
    [_contentView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    
    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;
    
    [_contentView.layer addAnimation:animation forKey:@"dismissAlert"];
}

- (void)_hide {
    if (_popUpViewStyle == LQPopUpViewStyleAlert) {
        [self dismissAlertAnimation];
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        }];
        [UIView animateWithDuration:0.2 animations:^{
            self.contentView.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }else if(_popUpViewStyle == LQPopUpViewStyleActionSheet) {
        [UIView animateWithDuration:0.24 delay:0.08 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.alpha = 0.0;
            
            CGRect rect = self.contentView.frame;
            rect.origin.y = kScreenHeight;
            self.contentView.frame = rect;
            if (self->_hasAddCancelBtnForOnce) {
                PopUpViewBtnModel *cancelBtnModel = self->_buttonModels[self->_cancelBtnIndex];
                UIButton *button = cancelBtnModel.button;
                CGRect rect = button.frame;
                rect.origin.y = kScreenHeight + 10 + self->_buttonHeight + 10;
                button.frame = rect;
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
}

- (void)btnAction:(UIButton *)sender {
    NSInteger index = sender.tag-1000;
    
    PopUpViewBtnModel *model = _buttonModels[index];
    buttonAction handler = model.actionHandler;
    if (handler) handler();
    [self _hide];
}

- (void)clickBackGroundHide:(UITapGestureRecognizer *)tap {
    if (_canHideByClickBgView.integerValue == 0) {// 用户没有设置过 self.canClickBackgroundHide 的值，按默认处理
        if (_popUpViewStyle == LQPopUpViewStyleAlert) {
        }else if (_popUpViewStyle == LQPopUpViewStyleActionSheet) {
            [self _hide];
        }
    }else if (_canHideByClickBgView.integerValue == 1) {// YES
        [self _hide];
    }else if (_canHideByClickBgView.integerValue == 2) {// NO
    }
}

- (void)setBackgroundColorForButton:(id)sender {
    [sender setBackgroundColor:kColorHex(0xcccccc, 0.8)];
}

- (void)clearBackgroundColorForButton:(UIButton *)sender {
    NSInteger index = sender.tag - 1000;
    if (index == _cancelBtnIndex) {
        [sender setBackgroundColor:[UIColor whiteColor]];
    }else {
        [sender setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark - /---------------------- UIGestureRecognizerDelegate ----------------------/
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (CGRectContainsPoint(_contentView.frame, point)) {
        return NO;
    }
    return YES;
}

#pragma mark - /---------------------- Setters ----------------------/
-(void)setCanClickBackgroundHide:(BOOL)canClickBackgroundHide {
    _canHideByClickBgView = canClickBackgroundHide ? @(1) : @(2);
}

#pragma mark - /---------------------- notifications ----------------------/
-(void)keyboard_willShow:(NSNotification *)ntf {
    NSDictionary * userInfo = [ntf userInfo];
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    CGRect kbRect = [userInfo[@"UIKeyboardBoundsUserInfoKey"] CGRectValue];
    CGFloat kb_minY = kScreenHeight - CGRectGetHeight(kbRect);
    
    CGRect beginUserInfo = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey]   CGRectValue];
    if (beginUserInfo.size.height <=0) {//!!搜狗输入法弹出时会发出三次UIKeyboardWillShowNotification的通知,和官方输入法相比,有效的一次为UIKeyboardFrameBeginUserInfoKey.size.height都大于零时.
        return;
    }
    
    CGFloat contentView_maxY = CGRectGetMaxY(_contentView.frame)+(5); //+5让输入框再高于键盘5的高度
    CGFloat offset = contentView_maxY - kb_minY;
    if (offset > 0) {
        [UIView animateWithDuration:duration animations:^{
            CGRect rect = self.contentView.frame;
            rect.origin.y -= offset;
            self.contentView.frame = rect;
        }];
    }
}

-(void)keyboard_willHide:(NSNotification *)ntf {
    NSDictionary * userInfo = [ntf userInfo];
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    [UIView animateWithDuration:duration animations:^{
        self.contentView.center = self.center;
    }];
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
