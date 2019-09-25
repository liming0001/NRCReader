//
//  EPINSOddsShowView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPINSOddsShowView : UIView

@property (weak, nonatomic) IBOutlet UITextField *oddsTF;

@property (nonatomic, strong) void (^INSOddsResultBlock)(CGFloat insOdds);

@end

NS_ASSUME_NONNULL_END
