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

@end

NS_ASSUME_NONNULL_END
