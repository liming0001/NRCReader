//
//  EPHTTPRequestManager.m
//  EPEtherDemo
//
//  Created by smarter on 2018/7/14.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import "EPHTTPRequestManager.h"
#import "EPNetworkConfig.h"

#if DEBUG
#define EPNetworkLog(...) NSLog(__VA_ARGS__)
#else
#define EPNetworkLog(...) {}
#endif

@interface EPHTTPRequestManager ()
{
    AFHTTPSessionManager *_manager;
    NSLock *_lock;
}
@property (nonatomic, strong) NSMutableArray *requestArray;

@end

@implementation EPHTTPRequestManager

- (instancetype)init
{
    if (self = [super init]) {
        _requestArray = [NSMutableArray array];
        _manager = [AFHTTPSessionManager manager];
        _lock = [[NSLock alloc] init];
    }
    return self;
}

#pragma mark - Public Methods
+ (EPHTTPRequestManager *)manager
{
    static EPHTTPRequestManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[EPHTTPRequestManager alloc] init];
    });
    return manager;
}

- (void)addRequest:(EPBaseRequest *)request
{
    @synchronized(self.requestArray) {
        if (![self isContainedRequest:request]) {
            [self.requestArray addObject:request];
            
            [self startWithRequest:request];
        }
    }
}

- (void)removeRequest:(EPBaseRequest *)request
{
    [request.task cancel];
    
    @synchronized(self.requestArray) {
        [self.requestArray removeObject:request];
    }
}

- (void)startWithRequest:(EPBaseRequest *)request
{
    NSString *path = [request urlString];
    NSString *baseURL = [[EPNetworkConfig defaultConfig] baseURL];
    NSString *url = [NSString stringWithFormat:@"%@%@", baseURL, path];
    
    EPHTTPRequestMethod method = [request httpMethod];
    NSMutableDictionary *param  = [NSMutableDictionary dictionary];
    [param addEntriesFromDictionary:[request requestParameters]];
    [param setObject:@"v2" forKey:@"version"];
    [param setObject:@"20" forKey:@"gVersion"];
    [param setObject:@"" forKey:@"gJpushID"];
    [param setObject:@"en" forKey:@"gLang"];
    [param setObject:@"e7fc45c8b7c05308847700b8cab75a90" forKey:@"gDeviceID"];
    [param setObject:@"e7fc45c8b7c05308847700b8cab75a90" forKey:@"gApikey"];
    [param setObject:@"IOS" forKey:@"gPlatform"];
    switch ([request requestType]) {
        case EPRequestSerializerTypeJson:
            _manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case EPRequestSerializerTypeHTTP:
            _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        default:
            break;
    }
    
    _manager.requestSerializer.timeoutInterval = [request timeoutInterval]; //设置超时时间
    _manager.responseSerializer = [AFJSONResponseSerializer serializer];    //设置json格式接收数据响应
    _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                          @"text/json",
                                                          @"text/javascript",
                                                          @"text/html",
                                                          @"text/plain",
                                                          @"application/xml",
                                                          @"image/jpeg",
                                                          @"image/png",
                                                          @"application/octet-stream", nil]; //设置接收数据的格式
    
    // if api need add custom value to HTTPHeaderField
    NSDictionary *headerFieldValueDictionary = [request httpHeader];
    if (headerFieldValueDictionary != nil) {
        for (id httpHeaderField in headerFieldValueDictionary.allKeys) {
            id value = headerFieldValueDictionary[httpHeaderField];
            if ([httpHeaderField isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]]) {
                [_manager.requestSerializer setValue:(NSString *)value forHTTPHeaderField:(NSString *)httpHeaderField];
            }
            else {
                EPNetworkLog(@"Error, class of key/value in headerFieldValueDictionary should be NSString.");
            }
        }
    }
    
    [self logRequest:request url:url];
    [[EPNetworkConfig defaultConfig] addCookie];
    
    void (^success)() = ^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [self logResponseWithOperation:task error:nil request:request responseObject:responseObject];
        
        NetworkSuccessHandle success = [request successHandle];
        if (success) {
            success(request, responseObject);
        }
        
        NetworkCompletionHandle complete = [request completionHandle];
        if (complete) {
            complete(request, responseObject, YES);
        }
    };
    
    void (^failure)() = ^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        [self logResponseWithOperation:task error:error request:request responseObject:nil];
        
        NetworkFailureHandle failure = [request failureHandle];
        if (failure) {
            failure(request);
        }
        
        NetworkCompletionHandle complete = [request completionHandle];
        if (complete) {
            complete(request, nil, NO);
        }
    };
    
    if (method == EPHTTPRequestMethodGet) {
        request.task = [_manager GET:url parameters:param progress:nil success:success failure:failure];
    }
    else if (method == EPHTTPRequestMethodPost) {
        request.task = [_manager POST:url parameters:param constructingBodyWithBlock:[request constructingBodyBlock] progress:nil success:success failure:failure];
    }
    else if (method == EPHTTPRequestMethodHead) {
        request.task = [_manager HEAD:url parameters:param success:success failure:failure];
    }
    else if (method == EPHTTPRequestMethodPut) {
        request.task = [_manager PUT:url parameters:param success:success failure:failure];
    }
    else if (method == EPHTTPRequestMethodDelete) {
        request.task = [_manager DELETE:url parameters:param success:success failure:failure];
    }
    else if (method == EPHTTPRequestMethodPatch) {
        request.task = [_manager PATCH:url parameters:param success:success failure:failure];
    }
    else {
        EPNetworkLog(@"Error, unsupport http method type!");
    }
}

- (BOOL)isContainedRequest:(EPBaseRequest *)request
{
    if (request.canRepeat) {
        return NO;
    }
    for (EPBaseRequest *item in self.requestArray) {
        if ([[item urlString] isEqualToString:[request urlString]] && [[item parametersString] isEqualToString:[request parametersString]]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Log Info
- (void)logRequest:(EPBaseRequest *)request url:(NSString *)url
{
#ifdef DEBUG
    [_lock lock];
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                          请求开始                           *\n**************************************************************\n"];
    [logString appendFormat:@"请求方式：%@\n", [self stringForMethod:[request httpMethod]]];
    [logString appendFormat:@"超时时间：%@\n", @(request.timeoutInterval)];
    [logString appendFormat:@"请求地址：%@\n", url];
    [logString appendFormat:@"请求参数：%@\n", [request requestParameters]];
    [logString appendFormat:@"httpheader：%@\n", request.httpHeader ? request.httpHeader : @"空"];
    [logString appendFormat:@"**************************************************************\n\n"];
    
    DLOG(@"%@", logString);
    [_lock unlock];
#endif
}

- (void)logResponseWithOperation:(NSURLSessionDataTask *)task error:(NSError *)error request:(EPBaseRequest *)baseRequest responseObject:(id)responseObject
{
    @synchronized(self.requestArray) {
        [self.requestArray removeObject:baseRequest];
    }
    if (error) {
        if ((long)error.code==-1009) {
            [[EPToast makeText:@"网络连接错误!"]showWithType:ShortTime];
        }
    }
#ifdef DEBUG
    [_lock lock];
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                           请求返回                          =\n==============================================================\n"];
    
    NSURLRequest *request = task.originalRequest;
    [logString appendFormat:@"请求地址：%@://%@%@\n\n", request.URL.scheme, request.URL.host, request.URL.path];
    [logString appendFormat:@"请求状态：\n\t%ld\n\n", ((NSHTTPURLResponse *)(task.response)).statusCode];
    [logString appendFormat:@"get子串：\n\t%@\n\n", request.URL.query];
    if (responseObject) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:0 error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [logString appendFormat:@"返回json数据：\n\n%@\n", jsonString];
    }
    
    if (shouldLogError) {
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendFormat:@"==============================================================\n\n"];
    
    DLOG(@"%@", logString);
    [_lock unlock];
#endif
}

- (NSString *)stringForMethod:(EPHTTPRequestMethod)method
{
    switch (method) {
        case EPHTTPRequestMethodGet:
            return @"GET";
            break;
        case EPHTTPRequestMethodPost:
            return @"POST";
            break;
        case EPHTTPRequestMethodHead:
            return @"HEAD";
            break;
        case EPHTTPRequestMethodPut:
            return @"PUT";
            break;
        case EPHTTPRequestMethodDelete:
            return @"DELETE";
            break;
        case EPHTTPRequestMethodPatch:
            return @"PATCH";
            break;
        default:
            break;
    }
}

@end
