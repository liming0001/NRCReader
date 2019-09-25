//
//  EPWebViewController.h
//  Ellipal
//
//  Created by cyl on 2018/7/26.
//  Copyright © 2018年 afuiot. All rights reserved.
//

#import "NRBaseViewController.h"

@interface EPWebViewController : NRBaseViewController

@property (nonatomic, strong) NSString *webTitle;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, assign) BOOL isLocalLink;

@end
