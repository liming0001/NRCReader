//
//  ModificationResultsView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/4.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModificationResultsView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tableIDlab;
@property (weak, nonatomic) IBOutlet UILabel *dateValueLab;
@property (weak, nonatomic) IBOutlet UILabel *xueciValueLab;
@property (weak, nonatomic) IBOutlet UILabel *puciValueLab;

@property (weak, nonatomic) IBOutlet UIButton *zhuangBtn;
@property (weak, nonatomic) IBOutlet UIButton *xianBtn;
@property (weak, nonatomic) IBOutlet UIButton *heBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhuangDuiBtn;
@property (weak, nonatomic) IBOutlet UIButton *xianDuiBtn;

@property(nonatomic,copy)void (^sureActionBlock)(BOOL isUpdateStatus);

- (void)updateBottomViewBtnWithTag:(BOOL)isLonghu;
- (void)fellViewDataWithLoginID:(NSString *)loginId TableID:(NSString *)tableId Xueci:(int)xueci List:(NSArray *)infoList Xz_setting:(NSArray *)xz_setting;

@end

NS_ASSUME_NONNULL_END
