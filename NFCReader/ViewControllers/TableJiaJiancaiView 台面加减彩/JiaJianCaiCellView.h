//
//  JiaJianCaiCellView.h
//  NFCReader
//
//  Created by 李黎明 on 2020/1/3.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JiaJianCaiCellView : UIView
@property (strong, nonatomic)  UILabel *chipNumberLab;
@property (strong, nonatomic)  UITextField *chipNumberTF;
@property (strong, nonatomic)  UIButton *chipNumberEditBtn;
@property (strong, nonatomic)  UILabel *chipMoneyValueLab;

@property (nonatomic, strong) void (^editBtnBock)(NSInteger curTag);

- (void)chipNumberAction:(UIButton *)btn;

@end

NS_ASSUME_NONNULL_END
