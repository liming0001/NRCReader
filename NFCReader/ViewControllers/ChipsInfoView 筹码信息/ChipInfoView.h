//
//  ChipInfoView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/11/3.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChipInfoView : UIView

@property(nonatomic,copy)void (^sureActionBlock)(NSInteger killConfirmType);
@property (weak, nonatomic) IBOutlet UILabel *nubsLab;
@property (weak, nonatomic) IBOutlet UIButton *readChipBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *midCloseBtn;

- (void)fellChipViewWithChipList:(NSArray *)chipInfoList;
- (void)fellChipViewDetailWithChipList:(NSArray *)chipInfoList;
- (void)clearCurChipInfos;

@end

NS_ASSUME_NONNULL_END
