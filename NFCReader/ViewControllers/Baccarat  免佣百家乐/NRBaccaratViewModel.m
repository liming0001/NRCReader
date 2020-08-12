//
//  NRBaccaratViewModel.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/15.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRBaccaratViewModel.h"
#import "JhPageItemModel.h"

@implementation NRBaccaratViewModel

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
                if (resultList.count==1) {
                    NSString *resultName = resultList[0];
                    if ([resultName isEqualToString:@"庄"]) {
                        self.zhuangCount +=1;
                        img = @"1";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 1;
                        [luzhuList addObject:model];
                    }else if ([resultName isEqualToString:@"闲"]){
                        self.xianCount +=1;
                        img = @"7";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 1;
                        [luzhuList addObject:model];
                    }else if ([resultName isEqualToString:@"和"]){
                        self.heCount +=1;
                        img = @"0";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 1;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }
                }else if (resultList.count==2){
                    if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]) {
                        self.zhuangCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"2";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 2;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"闲对"]){
                        self.zhuangCount+=1;
                        self.xianDuiCount+=1;
                        img = @"3";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 3;
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"6点赢"]){
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"1";
                        text = @"6";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.colorString = @"#ffffff";
                        model.luzhuType = 3;
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"闲对"]){
                        self.xianCount+=1;
                        self.xianDuiCount+=1;
                        img = @"6";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 4;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"庄对"]){
                        self.xianCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"5";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 5;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"庄对"]){
                        self.heCount+=1;
                        self.zhuangDuiCount+=1;
                        img = @"22";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 5;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"闲对"]){
                        self.heCount+=1;
                        self.xianDuiCount+=1;
                        img = @"21";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 5;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }
                }else if (resultList.count==3){
                    if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"闲对"]) {
                        self.zhuangDuiCount+=1;
                        self.zhuangCount+=1;
                        self.xianDuiCount+=1;
                        img = @"4";
                        text = @"庄";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 6;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"6点赢"]){
                        self.zhuangDuiCount+=1;
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"2";
                        text = @"6";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"6点赢"]){
                        self.xianDuiCount+=1;
                        self.zhuangCount+=1;
                        self.sixCount+=1;
                        img = @"3";
                        text = @"6";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"闲"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"庄对"]){
                        self.xianDuiCount+=1;
                        self.zhuangDuiCount+=1;
                        self.xianCount+=1;
                        img = @"8";
                        text = @"闲";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }else if ([resultList containsObject:@"和"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"庄对"]){
                        self.xianDuiCount+=1;
                        self.zhuangDuiCount+=1;
                        self.heCount+=1;
                        img = @"23";
                        text = @"和";
                        JhPageItemModel *model = [[JhPageItemModel alloc]init];
                        model.img = img;
                        model.text = text;
                        model.luzhuType = 7;
                        model.colorString = @"#ffffff";
                        [luzhuList addObject:model];
                    }
                }else if (resultList.count==4){
                     if ([resultList containsObject:@"庄"]&&[resultList containsObject:@"庄对"]&&[resultList containsObject:@"闲对"]&&[resultList containsObject:@"6点赢"]){
                         self.zhuangDuiCount+=1;
                         self.zhuangCount+=1;
                         self.xianDuiCount+=1;
                         self.sixCount+=1;
                         img = @"4";
                         text = @"6";
                         JhPageItemModel *model = [[JhPageItemModel alloc]init];
                         model.img = img;
                         model.text = text;
                         model.luzhuType = 6;
                         model.colorString = @"#ffffff";
                         [luzhuList addObject:model];
                     }
                }
            }];
            int normalInt = 0;
            if (list&&list.count!=0) {
                normalInt = (int)list.count;
            }
            for (int i=normalInt; i<luzhuMaxCount; i++) {
                NSString *text = @"";
                NSString *img = @"";
                JhPageItemModel *model = [[JhPageItemModel alloc]init];
                model.img = img;
                model.text = text;
                model.luzhuType = 0;
                model.colorString = @"#ffffff";
                [luzhuList addObject:model];
            }
            self.luzhuInfoList = luzhuList;
        }
        block(success, msg,0);
    }];
}

@end
