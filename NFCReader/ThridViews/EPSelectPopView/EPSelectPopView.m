//
//  EPSelectPopView.m
//  Ellipal
//
//  Created by smarter on 2018/8/13.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import "EPSelectPopView.h"
#import "EPFuncTableViewCell.h"

/**
 *  设置颜色RGB值
 */
#define RGBCOLOR(r,g,b,_alpha) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:_alpha]

@interface EPSelectPopView ()<UITableViewDataSource, UITableViewDelegate,UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic, assign) CGFloat cellHeight;

@end

//static const CGFloat cellHeight = 55;
@implementation EPSelectPopView

+ (instancetype)popViewWithFuncDicts:(NSArray *)funcDicts LeftOffset:(CGFloat)left RightOffset:(CGFloat)right TopOffset:(CGFloat)top CoverColor:(UIColor *)coverColor CellHeight:(CGFloat)rowHeight{
    
    CGFloat height = 0;
    EPSelectPopView *popView = [[NSBundle mainBundle] loadNibNamed:@"EPSelectPopView" owner:self options:nil].lastObject;
    popView.funcModels = [@[] mutableCopy];
    popView.cellHeight = rowHeight;
    if (funcDicts && funcDicts.count) {
        [popView.funcModels addObjectsFromArray:funcDicts];
        height = rowHeight * popView.funcModels.count;
    }
    
    CGFloat hasHeight = kScreenHeight-top-16;
    if (height>hasHeight) {
        height = hasHeight;
    }
    // 设置弹出视图的位置
    popView.frame = CGRectMake(left , top, kScreenWidth-left-right,height);
    [popView createUIWithCoverColor:coverColor];
    return popView;
}
- (void)createUIWithCoverColor:(UIColor *)coverColor{
    
    self.tableView.layer.cornerRadius = 2;
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = [UIColor colorWithHexString:@"#f1f1f1"].CGColor;
    self.tableView.bounces = NO;
    self.tableView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.tableView.layer.shadowOffset = CGSizeMake(5, 5);
    self.coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.coverView.backgroundColor = coverColor;
    UIButton *coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    coverBtn.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [coverBtn addTarget:self action:@selector(singleTapCover) forControlEvents:UIControlEventTouchUpInside];
    [self.coverView addSubview:coverBtn];

}


- (void)showInKeyWindow{
    _isShow = YES;
    self.alpha = 0;
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self.coverView];
    [self.coverView addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}

- (void)dismissFromKeyWindow{
    _isShow = NO;
    [self.coverView removeFromSuperview];
    [UIView animateWithDuration:0.5 animations:^{
        self.transform = CGAffineTransformMakeScale(0.7, 0.7);
        self.transform = CGAffineTransformTranslate(self.transform, 40, -64);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.transform = CGAffineTransformIdentity;
        [self removeFromSuperview];
        
    }];
}

- (void)singleTapCover
{
    
    [self dismissFromKeyWindow];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.funcModels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellId = @"funcCell";
    EPFuncTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EPFuncTableViewCell" owner:self options:nil].lastObject;
    }
    if (!self.funcModels.count) {
        return cell;
    }
    
    NSString *selectString = self.funcModels[indexPath.row];
    if ([selectString rangeOfString:@"  "].location!=NSNotFound) {
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:selectString];
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithHexString:@"#4B9DF1"]
                        range:NSMakeRange(0, [selectString rangeOfString:@"  "].location)];
        cell.nameLab.attributedText = attrString;
    }else{
        cell.nameLab.text = selectString;
    }
    
    cell.nameLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
    if (_cellHeight==40) {
        cell.nameLab.textAlignment = NSTextAlignmentCenter;
        cell.nameLab.font =  [UIFont systemFontOfSize:14];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EPFuncTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    if(self.myFuncBlock){
        self.myFuncBlock (indexPath.row);
    }
}

- (void)dealloc{
    self.coverView = nil;
    self.tableView = nil;
}

@end
