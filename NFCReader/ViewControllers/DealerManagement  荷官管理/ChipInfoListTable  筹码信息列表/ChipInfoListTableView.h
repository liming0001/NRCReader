//
//  ChipInfoListTableView.h
//  NFCReader
//
//  Created by 李黎明 on 2020/7/27.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^chipTableListBlock)(NSInteger tag);
@class CustomerInfoFooter;
@interface ChipInfoListTableView : UIView
@property (nonatomic, strong) CustomerInfoFooter *customerFooter;
@property (nonatomic, strong) chipTableListBlock chipTableBlock;
- (void)fellWithInfoList:(NSArray *)infoList WithType:(int)type;
- (void)clearCustomerFooterInfo;
- (void)fellHeaderInfoWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
