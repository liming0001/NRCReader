//
//  TableDataInfoView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/4.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableDataInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *rmbChipValueLab;
@property (weak, nonatomic) IBOutlet UILabel *rmbCurrentValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *rmbCurrentValueUpOrDownImg;

@property (weak, nonatomic) IBOutlet UILabel *usdCashValueLab;
@property (weak, nonatomic) IBOutlet UILabel *usdCashCurrentValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *usdCashUpOrDownImg;

@property (weak, nonatomic) IBOutlet UILabel *usdChipValueLab;
@property (weak, nonatomic) IBOutlet UILabel *usdChipCurrentValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *usdChipUpOrDownImg;

@property (weak, nonatomic) IBOutlet UILabel *rmbCashValueLab;
@property (weak, nonatomic) IBOutlet UILabel *rmbCashCurrentValuelab;
@property (weak, nonatomic) IBOutlet UIImageView *rmbCashUpOrDownImg;

@property (weak, nonatomic) IBOutlet UILabel *rmbChipBootValueLab;
@property (weak, nonatomic) IBOutlet UILabel *usdChipBootValueLab;
@property (weak, nonatomic) IBOutlet UILabel *rmbCashBootValueLab;
@property (weak, nonatomic) IBOutlet UILabel *usdCashBootValueLab;
@property (weak, nonatomic) IBOutlet UILabel *rmbMupBootValueLab;
@property (weak, nonatomic) IBOutlet UILabel *usdMupBootValueLab;


@property (weak, nonatomic) IBOutlet UILabel *usdMupValueLab;
@property (weak, nonatomic) IBOutlet UILabel *usdMupCurrentValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *usdMupUpOrDownImg;


@property (weak, nonatomic) IBOutlet UILabel *rmbMupValueLab;
@property (weak, nonatomic) IBOutlet UILabel *rmbMupCurrentValueLab;
@property (weak, nonatomic) IBOutlet UIImageView *mupUpOrDownImg;




- (void)fellTableInfoDataWithTableList:(NSDictionary *)tableDict;

@end

NS_ASSUME_NONNULL_END
