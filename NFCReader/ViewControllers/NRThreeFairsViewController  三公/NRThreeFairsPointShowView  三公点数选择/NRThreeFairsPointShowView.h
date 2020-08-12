//
//  EPCowPointChooseShowView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRThreeFairsPointShowView : UIView

@property (nonatomic, strong) void (^fairsPointsResultBlock)(int curPoint);

@end

NS_ASSUME_NONNULL_END
