//
//  EPBaseRequest.h
//  EPEtherDemo
//
//  Created by smarter on 2018/7/14.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef NS_ENUM(NSInteger, EPHTTPRequestMethod) {
    EPHTTPRequestMethodGet,         //GET
    EPHTTPRequestMethodPost,        //POST
    EPHTTPRequestMethodHead,        //HEAD
    EPHTTPRequestMethodPut,         //PUT
    EPHTTPRequestMethodDelete,      //DELETE
    EPHTTPRequestMethodPatch        //PATCH
};

typedef NS_ENUM(NSInteger, EPRequestSerializerType) {
    EPRequestSerializerTypeJson,    //请求参数为json
    EPRequestSerializerTypeHTTP     //请求参数为http格式
};

@class EPBaseRequest, AFMultipartFormData;
typedef void (^NetworkSuccessHandle)(EPBaseRequest *request, id response);
typedef void (^NetworkFailureHandle)(EPBaseRequest *request);
typedef void (^NetworkCompletionHandle)(EPBaseRequest *request, id response, BOOL success);
typedef void (^ConstructingBodyBlock)(id <AFMultipartFormData> formData);

@interface EPBaseRequest : NSObject

@property (nonatomic, assign) BOOL canRepeat;   //是否可以同时请求
@property (nonatomic, strong) NSURLSessionDataTask *task;

@property (nonatomic, copy) NSString *urlString;//请求的url字符串
@property (nonatomic, strong) NSDictionary *requestParameters;//请求参数,子类不重载的话，将转化子类的属性，生成包含子类属性的字典

///** 请求的url字符串 */
//- (NSString *)urlString;

/** 请求的超时时间，default is 15 seconds. */
- (NSTimeInterval)timeoutInterval;

/** 请求的缓存策略 */
- (NSURLRequestCachePolicy)cachePolicy;

/** http请求的方法,默认post */
- (EPHTTPRequestMethod)httpMethod;

/** 请求头 */
- (NSDictionary *)httpHeader;

///** 请求参数,子类不重载的话，将转化子类的属性，生成包含子类属性的字典 */
//- (NSDictionary *)requestParameters;

/** 请求的get字符串, 按升序排列 */
- (NSString *)parametersString;

/**
 *  请求类型，默认是HTTP
 */
- (EPRequestSerializerType)requestType;

/** 开始请求，请求完成后成功回调，失败回调 */
- (void)startWithCompletionBlockWithSuccess:(NetworkSuccessHandle)success
                                    failure:(NetworkFailureHandle)failure;

/**
 *  请求网络，成功和失败在一个block里面
 *
 *  @param complete 成功、失败的处理block
 */
- (void)startWithCompletionHandle:(NetworkCompletionHandle)complete;


/** 取消网络请求 */
- (void)cancelRequest;


- (NetworkSuccessHandle)successHandle;
- (NetworkFailureHandle)failureHandle;
- (NetworkCompletionHandle)completionHandle;
- (ConstructingBodyBlock)constructingBodyBlock;

/**
 *  获取requst的属性组成的字典，尽量不要使用，仅在- (NSDictionary *)requestParameters;中使用
 *
 *  @return 字典
 */
- (NSDictionary *)dictionaryForPropertyList;

@property (nonatomic, strong) NSData *imageData;

@end
