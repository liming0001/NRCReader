//
//  NRChipResultInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2019/5/13.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRChipResultInfo : NSObject

@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *firstColor;
@property (nonatomic, strong) NSString *secondName;
@property (nonatomic, strong) NSString *secondColor;
@property (nonatomic, strong) NSString *thirdName;
@property (nonatomic, strong) NSString *thirdColor;
@property (nonatomic, strong) NSString *forthName;
@property (nonatomic, strong) NSString *forthColor;
@property (nonatomic, strong) NSString *fiveName;
@property (nonatomic, strong) NSString *fiveColor;
@property (nonatomic, strong) NSString *tips;

@property (nonatomic, strong) NSArray *topTitleList;
@property (nonatomic, strong) NSArray *bottomTitleList;

@property (nonatomic, assign) int hasMore;

@end

NS_ASSUME_NONNULL_END
