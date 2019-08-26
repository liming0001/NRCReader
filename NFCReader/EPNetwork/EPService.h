//
//  EPService.h
//  EPEtherDemo
//
//  Created by smarter on 2018/7/14.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import "EPBaseRequest.h"

typedef NS_ENUM(NSInteger, EPSreviceError) {
    EPSreviceSuccess,                           //请求成功
    EPSreviceErrorServiceNet = 500,             //服务器内部错误
    EPSreviceErrorParams = 10000,               //必选参数不能为空
    EPSreviceErrorSS = 10001,                   //交易对SS不支持
    EPSreviceErrorCollectionAddress = 10002,    //平台收款地址不存在
    EPSreviceErrorRefundAddress = 10003,        //平台退款地址不存在
    EPSreviceErrorTransactionAmount = 10004,    //计算交易额失败
    EPSreviceErrorSSTnterface = 10005           //SS接口错误
    
};

@class NRChipInfoModel;
@interface EPService : EPBaseRequest

#pragma mark - 读写器接口
+(void)nr_PublicWithParamter:(NSDictionary *)paramter
                       block:(void(^)(NSDictionary *responseDict,NSString *msg,EPSreviceError error,BOOL suc))block;
+(void)nr_Public_ListWithParamter:(NSDictionary *)paramter
                            block:(void(^)(NSArray *list,NSString *msg,EPSreviceError error,BOOL suc))block;
+(void)nr_String_PublicWithParamter:(NSDictionary *)paramter
                              block:(void(^)(NSString *responseString,NSString *msg,EPSreviceError error,BOOL suc))block;


@end
