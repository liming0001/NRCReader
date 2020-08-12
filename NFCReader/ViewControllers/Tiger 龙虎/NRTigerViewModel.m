//
//  NRTigerViewModel.m
//  NFCReader
//
//  Created by 李黎明 on 2019/5/6.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRTigerViewModel.h"
#import "NRLoginInfo.h"
#import "NRTableInfo.h"
#import "NRGameInfo.h"
#import "NRUpdateInfo.h"
#import "JhPageItemModel.h"
#import "NRTableDataModel.h"

@implementation NRTigerViewModel

- (instancetype)init{
    self = [super init];
    [self clearCount];
    return self;
}

- (void)clearCount{
    self.dragonCount = 0;
    self.tigerCount = 0;
    self.heCount = 0;
}

#pragma mark - 获取露珠
- (void)getLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    [PublicHttpTool getLuzhuWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            self.realLuzhuList = (NSArray *)data;
            [self clearCount];
            NSMutableArray *luzhuList = [NSMutableArray array];
            [self.realLuzhuList enumerateObjectsUsingBlock:^(NSDictionary *luzhiDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *resultS =  luzhiDict[@"fkpresult"];
                NSString *text = @"";
                NSString *img = @"";
                if ([resultS isEqualToString:@"龙"]) {
                    img = @"1";
                    text = @"龙";
                    JhPageItemModel *model = [[JhPageItemModel alloc]init];
                    model.img = img;
                    model.text = text;
                    model.colorString = @"#ffffff";
                    model.luzhuType = 1;
                    [luzhuList addObject:model];
                    self.dragonCount +=1;
                }else if ([resultS isEqualToString:@"虎"]){
                    img = @"7";
                    text = @"虎";
                    JhPageItemModel *model = [[JhPageItemModel alloc]init];
                    model.img = img;
                    model.text = text;
                    model.colorString = @"#ffffff";
                    model.luzhuType = 1;
                    [luzhuList addObject:model];
                    self.tigerCount +=1;
                }else if ([resultS isEqualToString:@"和"]){
                    img = @"0";
                    text = @"和";
                    JhPageItemModel *model = [[JhPageItemModel alloc]init];
                    model.img = img;
                    model.text = text;
                    model.luzhuType = 1;
                    model.colorString = @"#ffffff";
                    [luzhuList addObject:model];
                    self.heCount +=1;
                }
            }];
            int normalInt = 0;
            if (self.realLuzhuList&&self.realLuzhuList.count!=0) {
                normalInt = (int)self.realLuzhuList.count;
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
            self.luzhuUpList = luzhuList;
        }
        block(success, msg,0);
    }];
}

@end
