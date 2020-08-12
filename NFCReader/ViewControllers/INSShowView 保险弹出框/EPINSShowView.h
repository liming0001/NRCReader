//
//  EPINSShowView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EPINSShowView : UIView
@property (weak, nonatomic) IBOutlet UIButton *INSWinBtn;
@property (weak, nonatomic) IBOutlet UIButton *INSLostBtn;

@property (nonatomic, strong) void (^INSResultBlock)(BOOL isWin);

- (void)showWithCowType;

@end

NS_ASSUME_NONNULL_END
