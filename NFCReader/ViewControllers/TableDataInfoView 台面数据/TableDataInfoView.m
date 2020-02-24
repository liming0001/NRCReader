//
//  TableDataInfoView.m
//  NFCReader
//
//  Created by 李黎明 on 2019/9/4.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "TableDataInfoView.h"
#import "NRTableDataModel.h"

@interface TableDataInfoView ()

@property (nonatomic, strong) NSDictionary *curTableDict;

@end

@implementation TableDataInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)closeAction:(id)sender {
    [self removeFromSuperview];
}

- (void)fellTableInfoDataWithTableList:(NSDictionary *)tableDict{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.curTableDict = tableDict;
        NSArray *tableList = [NSArray yy_modelArrayWithClass:[NRTableDataModel class] json:self.curTableDict[@"table_money"]];
        [tableList enumerateObjectsUsingBlock:^(NRTableDataModel *tableData, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([tableData.fcmtype intValue]==1) {//人命币筹码
                self.rmbChipValueLab.text = [NSString stringWithFormat:@"%@",tableData.finit_money];
                self.rmbCurrentValueLab.text = [NSString stringWithFormat:@"%@",tableData.fcur_money];
                if ([tableData.finit_money integerValue]<[tableData.fcur_money integerValue]) {
                    self.rmbCurrentValueUpOrDownImg.image = [UIImage imageNamed:@"上升箭头ICO"];
                }else if ([tableData.finit_money integerValue]>[tableData.fcur_money integerValue]){
                    self.rmbCurrentValueUpOrDownImg.image = [UIImage imageNamed:@"下降箭头ICO"];
                }else{
                    self.rmbCurrentValueUpOrDownImg.hidden = YES;
                }
            }else if ([tableData.fcmtype intValue]==7){//美金现金
                self.usdCashValueLab.text = [NSString stringWithFormat:@"%@",tableData.finit_money];
                self.usdCashCurrentValueLab.text = [NSString stringWithFormat:@"%@",tableData.fcur_money];
                if ([tableData.finit_money integerValue]<[tableData.fcur_money integerValue]) {
                    self.usdCashUpOrDownImg.image = [UIImage imageNamed:@"上升箭头ICO"];
                }else if ([tableData.finit_money integerValue]>[tableData.fcur_money integerValue]){
                    self.usdCashUpOrDownImg.image = [UIImage imageNamed:@"下降箭头ICO"];
                }else{
                    self.rmbCurrentValueUpOrDownImg.hidden = YES;
                }
            }else if ([tableData.fcmtype intValue]==2){//美金筹码
                self.usdChipValueLab.text = [NSString stringWithFormat:@"%@",tableData.finit_money];
                self.usdChipCurrentValueLab.text = [NSString stringWithFormat:@"%@",tableData.fcur_money];
                if ([tableData.finit_money integerValue]<[tableData.fcur_money integerValue]) {
                    self.usdChipUpOrDownImg.image = [UIImage imageNamed:@"上升箭头ICO"];
                }else if ([tableData.finit_money integerValue]>[tableData.fcur_money integerValue]){
                    self.usdChipUpOrDownImg.image = [UIImage imageNamed:@"下降箭头ICO"];
                }else{
                    self.rmbCurrentValueUpOrDownImg.hidden = YES;
                }
            }else if ([tableData.fcmtype intValue]==6){//人命币现金
                self.rmbCashValueLab.text = [NSString stringWithFormat:@"%@",tableData.finit_money];
                self.rmbCashCurrentValuelab.text = [NSString stringWithFormat:@"%@",tableData.fcur_money];
                if ([tableData.finit_money integerValue]<[tableData.fcur_money integerValue]) {
                    self.rmbCashUpOrDownImg.image = [UIImage imageNamed:@"上升箭头ICO"];
                }else if ([tableData.finit_money integerValue]>[tableData.fcur_money integerValue]){
                    self.rmbCashUpOrDownImg.image = [UIImage imageNamed:@"下降箭头ICO"];
                }else{
                    self.rmbCurrentValueUpOrDownImg.hidden = YES;
                }
            }
        }];
        
        NSArray *xcsxsList = [NSArray yy_modelArrayWithClass:[NRTableDataModel class] json:self.curTableDict[@"xcsxs"]];
        [xcsxsList enumerateObjectsUsingBlock:^(NRTableDataModel *tableData, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([tableData.fcmtype intValue]==1) {//人命币筹码
                self.rmbChipBootValueLab.text = [NSString stringWithFormat:@"%@",tableData.fmoney];
            }else if ([tableData.fcmtype intValue]==7){//美金现金
                self.usdCashBootValueLab.text = [NSString stringWithFormat:@"%@",tableData.fmoney];
            }else if ([tableData.fcmtype intValue]==2){//美金筹码
                self.usdChipBootValueLab.text = [NSString stringWithFormat:@"%@",tableData.fmoney];
            }else if ([tableData.fcmtype intValue]==6){//人命币现金
                self.rmbCashBootValueLab.text = [NSString stringWithFormat:@"%@",tableData.fmoney];
            }
        }];
    });
}

@end
