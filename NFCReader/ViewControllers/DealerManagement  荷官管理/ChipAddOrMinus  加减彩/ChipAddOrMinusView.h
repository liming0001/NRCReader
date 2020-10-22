//
//  ChipAddOrMinusView.h
//  NFCReader
//
//  Created by 李黎明 on 2020/9/6.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChipAddOrMinusView : UIView
@property (nonatomic, strong) void (^addOrMinusBlock) (NSInteger curIndex);
- (void)fellWithInfoList:(NSArray *)infoList;

@end

NS_ASSUME_NONNULL_END
