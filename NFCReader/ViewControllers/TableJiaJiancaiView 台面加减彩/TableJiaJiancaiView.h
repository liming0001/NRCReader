//
//  TableJiaJiancaiView.h
//  NFCReader
//
//  Created by 李黎明 on 2019/9/4.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableJiaJiancaiView : UIView<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

- (void)fellListWithType:(int)type;

- (void)fellViewDataWithLoginID:(NSString *)loginId TableID:(NSString *)tableId ChipFmeList:(NSArray *)chipFmeList;

@property (nonatomic, strong) void (^kaiShoutaiBock)(int hasKaitaiStatus);

@end

NS_ASSUME_NONNULL_END
