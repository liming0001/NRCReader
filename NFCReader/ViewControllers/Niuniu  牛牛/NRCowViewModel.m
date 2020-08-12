//
//  NRCowViewModel.m
//  NFCReader
//
//  Created by 李黎明 on 2019/5/8.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRCowViewModel.h"
#import "JhPageItemModel.h"

@implementation NRCowViewModel

#pragma mark - 获取露珠
- (void)getLuzhuWithBlock:(EPFeedbackWithErrorCodeBlock)block{
    [PublicHttpTool getLuzhuWithBlock:^(BOOL success, id  _Nonnull data, NSString * _Nonnull msg) {
        if (success) {
            NSArray *list = (NSArray *)data;
            self.realLuzhuList = list;
            NSMutableArray *luzhuList = [NSMutableArray array];
            [list enumerateObjectsUsingBlock:^(NSDictionary *luzhiDict, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *resultS =  luzhiDict[@"fkpresult"];
                NSString *text = @"";
                NSString *img = @"";
                img = @"1";
                text = resultS;
                JhPageItemModel *model = [[JhPageItemModel alloc]init];
                model.img = img;
                model.text = text;
                model.colorString = @"#ffffff";
                model.luzhuType = 1;
                [luzhuList addObject:model];
            }];

            for (int i=(int)list.count; i<luzhuMaxCount; i++) {
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
