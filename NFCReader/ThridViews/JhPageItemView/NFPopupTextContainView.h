//
//  NFPopupTextContainView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/7/16.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSHPopupContainer.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^surebuttonClickAction) (NSString *adminName,NSString *adminPassword);

@interface NFPopupTextContainView : UIView<DSHCustomPopupView>

@property (nonatomic, strong) UITextField *adminNameTF;

@property (nonatomic, strong) UITextField *adminPasswordTF;

@property (nonatomic, copy) surebuttonClickAction sureButtonClickedCompleted;



@end

NS_ASSUME_NONNULL_END
