//
//  JhPageItemView.m
//  
//
//  Created by Jh on 2018/11/15.
//  Copyright © 2018 Jh. All rights reserved.
//

#import "JhPageItemView.h"
#import "JhPageItemCell.h"
#import "JhCustomHorizontalLayout.h"

@interface JhPageItemView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, assign) CGRect ViewFrame;

@property (nonatomic, strong) UICollectionViewLayout *layout;

@property (nonatomic, strong) JhCustomHorizontalLayout *customlayout;

@end

@implementation JhPageItemView

static NSString * const reuseIdentifier = @"Cell";


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _ViewFrame = frame;
        [self collectionView];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray{
    
}

- (void)fellLuzhuListWithDataList:(NSArray *)list{
    _dataArray = list;
    [self.collectionView reloadData];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(UICollectionViewLayout *)layout{
    if (!_layout) {
        UICollectionViewFlowLayout *layout =[[UICollectionViewFlowLayout alloc] init];
        //设置水平滚动
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGFloat viewHeight = _ViewFrame.size.height;
        CGFloat item_w = viewHeight/6;
        //设置每个cell的尺寸
        layout.itemSize = CGSizeMake(item_w, item_w);
        //cell之间的水平间距  行间距
        layout.minimumLineSpacing = 0;
        //cell之间的垂直间距 cell间距
        layout.minimumInteritemSpacing = 0;
        //设置四周边距
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.layout =layout;
        
    }
    return _layout;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        CGFloat viewWidth = _ViewFrame.size.width;
        CGFloat viewHeight = _ViewFrame.size.height;
        CGRect Collectionframe =CGRectMake(0,0, viewWidth, viewHeight);
        _collectionView = [[UICollectionView alloc] initWithFrame:Collectionframe collectionViewLayout:self.layout];
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([JhPageItemCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:reuseIdentifier];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        //隐藏滚动条
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.collectionView];
        
    }
    return _collectionView;
}


#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JhPageItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.data =self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - 点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(JhPageItemViewDelegate:indexPath:)])
    {
        [self.delegate JhPageItemViewDelegate:self indexPath:indexPath];
    }
}

@end
