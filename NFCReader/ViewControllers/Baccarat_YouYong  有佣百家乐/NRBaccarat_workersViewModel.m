//
//  NRBaccaratViewModel.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRBaccarat_workersViewModel.h"
#import "JhPageItemModel.h"

@implementation NRBaccarat_workersViewModel

- (instancetype)init{
    self = [super init];
    [self clearCount];
    return self;
}

- (void)clearCount{
    self.zhuangCount = 0;
    self.zhuangDuiCount = 0;
    self.sixCount = 0;
    self.xianCount = 0;
    self.xianDuiCount = 0;
    self.heCount = 0;
}

#pragma mark - 获取露珠
- (void)getLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    [PublicHttpTool getLuzhuWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            [self clearCount];
            NSArray *list = (NSArray *)data;
            self.realLuzhuList = list;
            NSMutableArray *luzhuList = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(NSDictionary *luzhiDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *resultS =  luzhiDict[@"fkpresult"];
                NSArray *resultList = [resultS componentsSeparatedByString:@","];
                NSString *text = @"";
                NSString *img = @"";
                int luzhuType = 0;
                if (resultList.count==1) {
                    NSString *resultName = resultList[0];
                    if ([resultName isEqualToString:@"庄"]) {
                        self.zhuangCount +=1;
                        img = @"1";
                        text = @"庄";
                        luzhuType = 0;
                    }else if ([resultName isEqualToString:@"闲"]){
                        self.xianCount +=1;
                        img = @"7";
                        text = @"闲";
                        luzhuType = 1;
                    }else if ([resultName isEqualToString:@"和"]){
                        self.heCount +=1;
                        img = @"0";
                        text = @"和";
                        luzhuType = 1;
                    }
                }else if (resultList.count==2){
                    if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]) {
                        self.zhuangCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"2";
                        text = @"庄";
                        luzhuType = 2;
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"闲对"]){
                        self.zhuangCount+=1;
                        self.xianDuiCount+=1;
                        img = @"3";
                        text = @"庄";
                        luzhuType = 3;
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"Lucky6"]){
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"1";
                        text = @"6";
                        luzhuType = 3;
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"闲对"]){
                        self.xianCount+=1;
                        self.xianDuiCount+=1;
                        img = @"6";
                        text = @"闲";
                        luzhuType = 4;
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"庄对"]){
                        self.xianCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"5";
                        text = @"闲";
                        luzhuType = 5;
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"庄对"]){
                        self.heCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"22";
                        text = @"和";
                        luzhuType = 5;
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"闲对"]){
                        self.heCount+=1;
                        self.xianDuiCount+=1;
                        img = @"21";
                        text = @"和";
                        luzhuType = 5;
                    }
                }else if (resultList.count==3){
                    if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"闲对"]) {
                        self.zhuangDuiCount+=1;
                        self.zhuangCount+=1;
                        self.xianDuiCount+=1;
                        img = @"4";
                        text = @"庄";
                        luzhuType = 6;
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"Lucky6"]){
                        self.zhuangDuiCount+=1;
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"2";
                        text = @"6";
                        luzhuType = 7;
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"Lucky6"]){
                        self.xianDuiCount+=1;
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"3";
                        text = @"6";
                        luzhuType = 7;
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"庄对"]){
                        self.xianDuiCount+=1;
                        self.zhuangDuiCount+=1;
                        self.xianCount+=1;
                        img = @"8";
                        text = @"闲";
                        luzhuType = 7;
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"庄对"]){
                        self.xianDuiCount+=1;
                        self.zhuangDuiCount+=1;
                        self.heCount+=1;
                        img = @"23";
                        text = @"和";
                        luzhuType = 7;
                    }
                }else if (resultList.count==4){
                     if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"Lucky6"]){
                         self.zhuangDuiCount+=1;
                         self.zhuangCount+=1;
                         self.xianDuiCount+=1;
                         self.sixCount+=1;
                         img = @"4";
                         text = @"6";
                         luzhuType = 6;
                     }
                }
                JhPageItemModel *model = [[JhPageItemModel alloc]init];
                model.img = img;
                model.text = text;
                model.colorString = @"#ffffff";
                model.luzhuType = luzhuType;
                [luzhuList addObject:model];
            }];
            int normalInt = 0;
            if (list&&list.count!=0) {
                normalInt = (int)list.count;
            }
            for (int i=normalInt; i<luzhuMaxCount; i++) {
                JhPageItemModel *model = [[JhPageItemModel alloc]init];
                model.img = @"";
                model.text = @"";
                model.colorString = @"#ffffff";
                [luzhuList addObject:model];
            }
            self.luzhuInfoList = luzhuList;
        }
        block(success, msg,0);
    }];
}

@end
