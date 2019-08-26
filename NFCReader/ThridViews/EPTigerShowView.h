//
//  EPResultShowView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/5/13.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^tigerresultAlertbuttonAction) (void);
typedef void(^tigerresultAlertbuttonClickAction) (int buttonTag);

@class NRChipResultInfo;
@interface EPTigerShowView : UIView

+ (void)showInWindowWithNRChipResultInfo:(NRChipResultInfo *)resultInfo handler:(tigerresultAlertbuttonClickAction)handler;

@end

NS_ASSUME_NONNULL_END
