//
//  EPSixWinShowView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPSixWinShowView : UIView
@property (weak, nonatomic) IBOutlet UIButton *twoCardsBtn;
@property (weak, nonatomic) IBOutlet UIImageView *twoSelectIcon;
@property (weak, nonatomic) IBOutlet UILabel *twoCardsWinLab;
@property (weak, nonatomic) IBOutlet UILabel *twoCardsWinEnLab;
@property (weak, nonatomic) IBOutlet UIButton *threeCardsBtn;
@property (weak, nonatomic) IBOutlet UIImageView *threeSelectIcon;
@property (weak, nonatomic) IBOutlet UILabel *threeCardsWinLab;
@property (weak, nonatomic) IBOutlet UILabel *threeCardsWinEnLav;
@property (nonatomic, assign) int sixType;
@property(nonatomic,copy)void (^sureActionBlock)(NSInteger sixWinType);


@end

NS_ASSUME_NONNULL_END
