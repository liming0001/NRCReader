//
//  DenominationView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/6.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DenominationView : UIView

@property (strong, nonatomic)  UILabel *chipNumberLab;
@property (strong, nonatomic)  UILabel *chipFmValueLab;
@property (strong, nonatomic)  UILabel *chipMoneyValueLab;

@end

NS_ASSUME_NONNULL_END
