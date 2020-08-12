//
//  ChipIssueView.h
//  NFCReader
//
//  Created by 李黎明 on 2020/7/27.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^IssueBtnActionBlock)(NSDictionary *issueDict);
@interface ChipIssueView : UIView

@property (nonatomic, strong) IssueBtnActionBlock issueBtnBlock;

@end

NS_ASSUME_NONNULL_END
