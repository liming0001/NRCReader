//
//  JhPageItemView.h
//
//
//  Created by Jh on 2018/11/15.
//  Copyright © 2018 Jh. All rights reserved.
//  

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class JhPageItemView;
@protocol JhPageItemViewDelegate <NSObject>
- (void)JhPageItemViewDelegate:(JhPageItemView *)JhPageItemViewDeleagte indexPath:(NSIndexPath * )indexPath;
@end

@interface JhPageItemView : UIView
// 数据源
@property (nonatomic,strong) NSArray * dataArray;

@property (nonatomic, weak) id<JhPageItemViewDelegate> delegate;



@end

NS_ASSUME_NONNULL_END
