//
//  ViewController.m
//  UMAPIPush
//
//  Created by HJQ on 2020/10/29.
//

#import "ViewController.h"
#import "MD5Encrypt.h"
#import <AFNetworking.h>
#import <MJExtension.h>

#define PUSH_API_HTTP @"http://msg.umeng.com/api/send"
//#define PUSH_API_HTTPS @"https://msgapi.umeng.com/api/send"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self testPush];
}

- (void)testPush {
    NSString *appkey = @"5f98d74333bd1851f689337d";
    NSString *timestamp = [self getNowTimeTimestamp];
    NSString *method = @"POST";
    NSString *url = PUSH_API_HTTP;
    
    NSString *device_token = @"";
    // 消息类型
    NSString *type = @"broadcast";
    
    /*
     {
         "production_mode": "false",
         "payload": {
             "display_type": "notification",
             "aps": {
                 "alert": {
                     "title": "标题"
                 }
             },
             "body": {
                 "title": "你好",
                 "after_open": "go_app",
                 "ticker": "Hello World",
                 "text": "来自友盟推送"
             }
         },
         "timestamp": "1607997648677",
         "appkey": "5f98d74333bd1851f689337d",
         "device_tokens": "",
         "type": "broadcast"
     }
     */
    
    NSMutableDictionary *body = [NSMutableDictionary dictionary];
    [body setValue:@"Hello World" forKey:@"ticker"];
    [body setValue:@"你好" forKey:@"title"];
    [body setValue:@"来自友盟推送" forKey:@"text"];
    [body setValue:@"go_app" forKey:@"after_open"];
    
    NSMutableDictionary *payload = [NSMutableDictionary dictionary];
    [payload setValue:body forKey:@"body"];
    [payload setValue:@"notification" forKey:@"display_type"];
    
    NSMutableDictionary *aps = [NSMutableDictionary dictionary];
    NSMutableDictionary *alert = [NSMutableDictionary dictionary];
    [alert setValue:@"标题" forKey:@"title"];
    [aps setValue:alert forKey:@"alert"];
    [payload setValue:aps forKey:@"aps"];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:appkey forKey:@"appkey"];
    [params setValue:timestamp forKey:@"timestamp"];
    [params setValue:device_token forKey:@"device_tokens"];
    [params setValue:type forKey:@"type"];
    [params setValue:payload forKey:@"payload"];
    [params setValue:@"false" forKey:@"production_mode"];
    
    NSString *sign = [self getSign:params method:method url:url];
    NSString *requestURL = [NSString stringWithFormat:@"%@?sign=%@", url, sign];
    [self sendRequestParams:params url:requestURL];
}

- (NSString *)getSign:(NSDictionary *)dict method:(NSString *)method url:(NSString *)url  {
    
    NSString *app_master_secret = @"gdrpscfknbygbgnsx0abs6baeisd4lig";
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:kNilOptions error:NULL];
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *paramStr = [NSString stringWithFormat:@"%@%@%@%@", method, url, jsonStr, app_master_secret];
    // 32位小写
    NSString *sign = [MD5Encrypt MD5ForLower32Bate:paramStr];
    return sign;
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

-(NSString *)getNowTimeTimestamp
{
    double currentTime =  [[NSDate date] timeIntervalSince1970] * 1000;
    NSString *strTime = [NSString stringWithFormat:@"%.0f",currentTime];
    return strTime;
}

@end
