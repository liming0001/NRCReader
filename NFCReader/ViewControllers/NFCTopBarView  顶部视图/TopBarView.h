//
//  TopBarView.h
//  NFCReader
//
//  Created by 李黎明 on 2020/6/9.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^BarButtonActionBlock)(NSInteger tag ,int BtnType,BOOL isChange);
@interface TopBarView : UIView
@property (nonatomic, strong) BarButtonActionBlock barBtnBlock;
@end

NS_ASSUME_NONNULL_END
