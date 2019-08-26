//
//  NRTableCollectionViewCell.h
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRTableCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *titleLabel;

- (void)configureWithNumberText:(NSString *)numberText
                      titleText:(NSString *)titleText;

@end

NS_ASSUME_NONNULL_END
