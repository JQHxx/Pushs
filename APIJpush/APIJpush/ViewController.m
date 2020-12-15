//
//  ViewController.m
//  APIJpush
//
//  Created by HJQ on 2020/12/15.
//

#import "ViewController.h"
#import <AFNetworking.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /*
    {
        "platform": "all",
        "audience": "all",
        "notification": {
            "alert": "Hi,JPush !"
        },
        "options": {
            "apns_production": false
        }
    }
     */
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    [contentDict setValue:@"all" forKey:@"platform"];
    [contentDict setValue:@"all" forKey:@"audience"];
    
    NSMutableDictionary *notification = [NSMutableDictionary dictionary];
    [notification setValue:@"Hi,JPush !" forKey:@"alert"];
    
    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    [options setValue:@"false" forKey:@"apns_production"];
    
    [contentDict setValue:notification forKey:@"notification"];
    [contentDict setValue:options forKey:@"options"];
    
    [self sendRequestParams:contentDict url:@"https://api.jpush.cn/v3/push"];
}

- (void)sendRequestParams:(NSDictionary *)params url:(NSString *)url {
    //NSError *error;
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:&error];
    //NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *mrequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    //设置超时时长
    mrequest.timeoutInterval = 15;
    [mrequest setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    [mrequest setValue:@"application/json;charset:utf-8" forHTTPHeaderField:@"content-type"];
    
    NSString *appKey = @"";
    NSString *masterSecret = @"";
    NSString *contentStr = [NSString stringWithFormat:@"%@:%@",appKey,masterSecret];
    NSData *data = [contentStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *stringBase64 = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];// base64格式的字符串
    // 通过 ID ：密码 的格式，用Basic 的方式拼接成字符串
    NSString *authorization = [NSString stringWithFormat:@"Basic %@",stringBase64];
    
    [mrequest setValue:authorization forHTTPHeaderField:@"Authorization"];
    //将对象设置到requestbody中 ,主要是这不操作
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //[mrequest setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    [[manager dataTaskWithRequest:mrequest uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if(error == nil) {
            NSLog(@" === %@",responseObject);
            NSDictionary *result = responseObject;
            if ([result isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)result;
                
            } else {
                
            }
            NSLog(@"%@", result);
        } else {
            NSLog(@"%@", responseObject);
        }
    }] resume];
}

@end
