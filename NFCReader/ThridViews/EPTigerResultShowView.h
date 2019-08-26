//
//  EPResultShowView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/5/13.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^resultTigerAlertbuttonAction) (void);
typedef void(^resultAlertTigerbuttonClickAction) (int buttonType);

@class NRChipResultInfo;
@interface EPTigerResultShowView : UIView

+ (void)showInWindowWithNRChipResultInfo:(NRChipResultInfo *)resultInfo handler:(resultAlertTigerbuttonClickAction)handler;

@end

NS_ASSUME_NONNULL_END
