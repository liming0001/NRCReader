//
//  EPService.m
//  EPEtherDemo
//
//  Created by smarter on 2018/7/14.
//  Copyright © 2018年 Ellipal. All rights reserved.
//

#import "EPService.h"
#import "AppDelegate.h"

@implementation EPService

#pragma mark - 读写器接口
+(void)nr_PublicWithParamter:(NSDictionary *)paramter
                                   block:(void(^)(NSDictionary *responseDict,NSString *msg,EPSreviceError error,BOOL suc))block{
    EPService *request = [EPService new];
    request.urlString = [NSString stringWithFormat:@"%@",@""];//请求url
    request.requestParameters = paramter;
    [request startWithCompletionHandle:^(EPBaseRequest *request, id response, BOOL success) {
        if (success) {
            if ([response[@"retid"]intValue]==1) {
                block(response[@"data"],response[@"retmsg"],EPSreviceSuccess,1);
            }else{
                if ([response[@"retid"]intValue]==400) {
                    AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [ad showLoginVC];
                }else{
                   block(nil,response[@"retmsg"],[response[@"retid"]intValue],0);
                }
            }
        }else{
            block(nil,nil,EPSreviceErrorServiceNet,0);
        }
    }];
}

+(void)nr_Public_ListWithParamter:(NSDictionary *)paramter
                       block:(void(^)(NSArray *list,NSString *msg,EPSreviceError error,BOOL suc))block{
    EPService *request = [EPService new];
    request.urlString = [NSString stringWithFormat:@"%@",@""];//请求url
    request.requestParameters = paramter;
    [request startWithCompletionHandle:^(EPBaseRequest *request, id response, BOOL success) {
        if (success) {
            if ([response[@"retid"]intValue]==1) {
                block(response[@"data"],response[@"retmsg"],EPSreviceSuccess,1);
            }else{
                if ([response[@"retid"]intValue]==400) {
                    AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [ad showLoginVC];
                }else{
                   block(nil,response[@"retmsg"],[response[@"retid"]intValue],0);
                }
            }
        }else{
            block(nil,nil,EPSreviceErrorServiceNet,0);
        }
    }];
}

+(void)nr_String_PublicWithParamter:(NSDictionary *)paramter
                       block:(void(^)(NSString *responseString,NSString *msg,EPSreviceError error,BOOL suc))block{
    EPService *request = [EPService new];
    request.urlString = [NSString stringWithFormat:@"%@",@""];//请求url
    request.requestParameters = paramter;
    [request startWithCompletionHandle:^(EPBaseRequest *request, id response, BOOL success) {
        if (success) {
            if ([response[@"retid"]intValue]==1) {
                block(response[@"data"],response[@"retmsg"],EPSreviceSuccess,1);
            }else{
                if ([response[@"retid"]intValue]==400) {
                    AppDelegate *ad = (AppDelegate *)[UIApplication sharedApplication].delegate;
                    [ad showLoginVC];
                }else{
                   block(nil,response[@"retmsg"],[response[@"retid"]intValue],0);
                }
            }
        }else{
            block(nil,nil,EPSreviceErrorServiceNet,0);
        }
    }];
}

@end
