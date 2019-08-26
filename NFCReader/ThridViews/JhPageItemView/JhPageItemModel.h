//
//  JhPageItemModel.h
//  JhPageItemView
//
//  Created by Jh on 2018/11/16.
//  Copyright © 2018 Jh. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JhPageItemModel : NSObject
@property(nonatomic,copy) NSString *text;
@property(nonatomic,copy) NSString *img;
@property(nonatomic,copy) NSString *colorString;
@property(nonatomic,assign) int luzhuType;

@end

NS_ASSUME_NONNULL_END
