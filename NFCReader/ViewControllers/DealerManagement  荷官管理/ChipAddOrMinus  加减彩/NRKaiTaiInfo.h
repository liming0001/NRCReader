//
//  NRKaiTaiInfo.h
//  NFCReader
//
//  Created by 李黎明 on 2020/9/8.
//  Copyright © 2020 李黎明. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NRKaiTaiInfo : NSObject

@property (nonatomic, strong) NSString *ftype;
@property (nonatomic, strong) NSString *pfid;
@property (nonatomic, strong) NSArray *femp_num;
@property (nonatomic, strong) NSString *fstatus;
@property (nonatomic, strong) NSString *fid;
@property (nonatomic, strong) NSString *fdesc;
@property (nonatomic, strong) NSString *fqr_emp_num;
@property (nonatomic, strong) NSString *tbtag;
@property (nonatomic, strong) NSString *fadd_time;
@property (nonatomic, strong) NSString *totalmoney;
@property (nonatomic, strong) NSString *femp_id;
@property (nonatomic, strong) NSString *ftable_id;
@property (nonatomic, strong) NSString *fcmtype;
@property (nonatomic, strong) NSString *fkt;
@property (nonatomic, strong) NSString *fqr_emp_id;
@property (nonatomic, strong) NSString *snumber;
@property (nonatomic, strong) NSString *tablename;

@end

NS_ASSUME_NONNULL_END
