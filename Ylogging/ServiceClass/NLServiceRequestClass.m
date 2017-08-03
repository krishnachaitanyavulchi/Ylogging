//
//  NLServiceRequestClass.m
//  NorthanLights
//
//  Created by Thrymr Software on 02/08/17.
//  Copyright © 2017 Thrymr_Sravan. All rights reserved.
//
#include <ifaddrs.h>
#include <arpa/inet.h>

#import "NLServiceRequestClass.h"
#import "NLJsonConverter.h"
#import "NorthanLights.h"

@interface NLServiceRequestClass()

@property (nonatomic, weak) NSHTTPCookieStorage *storage;

@end

@implementation NLServiceRequestClass

#pragma mark - Instance -
+(NLServiceRequestClass *)sharedInstance
{
    static dispatch_once_t onceDispatch;
    static NLServiceRequestClass *sharedInstance;
    dispatch_once(&onceDispatch, ^{
        sharedInstance = [[self alloc] init];
        
    });
    
    return sharedInstance;
}
#pragma mark - AfNetworking Methods -
-(NSURLSessionConfiguration *)defaultSessionConfiguration
{
    return [NSURLSessionConfiguration defaultSessionConfiguration];
}
-(NSString *)getUrlForMethodName:(wsMethodNames)methodName
{
    NSString *strUrl = @"";
    switch (methodName)
    {
        case login:
            strUrl = [NSString stringWithFormat:@"%@%@/authenticate", NLUserDefaults_getobject(NLBaseUrl), NLUserDefaults_getobject(NLSiteName)];
            break;
            
        default:
            break;
    }
    return strUrl;
}
-(void)Service_CallWithData:(id)dicParameters withMethodName:(wsMethodNames)methodName complitionHandler:(ComplitionHandler)complitionHandler
{
    if(![NLUtils checkNet])
    {
        NSMutableDictionary *responseObject = [[NSMutableDictionary alloc] init];
        [responseObject setObject:@"No internet connection." forKey:@"message"];
        [responseObject setObject:@"false" forKey:@"status"];
        complitionHandler(responseObject,nil);
        return;
    }
    
    NSURLSessionConfiguration *configuration = [self defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSData *jsonData = [self sendRequestToServer:methodName withObject:dicParameters];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *urlString = [self getUrlForMethodName:login];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    request.timeoutInterval = .0f;
    [request setHTTPBody:jsonData];
    [request addValue:[NSString stringWithFormat:@"%lu",(unsigned long)jsonString.length] forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    NSLog(@"**********************************************************************");
    NSLog(@"JSON summary: Url :%@\n Request: %@", urlString,jsonString);
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                      {
                                          if(error || response == nil)
                                          {
                                                  NSMutableDictionary *responseObjectLocal = [[NSMutableDictionary alloc] init];
                                                  [responseObjectLocal setObject:@"No data Found." forKey:@"message"];
                                                  [responseObjectLocal setObject:@"false" forKey:@"status"];
                                              
                                              if (complitionHandler)
                                                  complitionHandler(responseObjectLocal, error);
                                              
                                          }
                                          else
                                          {
                                              NSDictionary *responseObject=[NSJSONSerialization JSONObjectWithData:data  options:NSJSONReadingAllowFragments error:nil];
                                              
                                              NSError *errorLocal;
                                              if([responseObject isKindOfClass:[NSDictionary class]])
                                              {
                                                  NSData *jsonData = [NSJSONSerialization dataWithJSONObject:(NSDictionary *)responseObject options:NSJSONWritingPrettyPrinted error:&errorLocal];
                                                  
                                                  if (jsonData)
                                                  {
                                                      NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                                                      NSLog(@"responseObject:%@",jsonString);
                                                  }
                                                  if (complitionHandler)
                                                      complitionHandler(responseObject, nil);
                                              }
                                              else
                                              {
                                                  NSMutableDictionary *responseObjectLocal = [[NSMutableDictionary alloc] init];
                                                  [responseObjectLocal setObject:@"No data Found." forKey:@"message"];
                                                  [responseObjectLocal setObject:@"false" forKey:@"status"];
                                                  if (complitionHandler)
                                                      complitionHandler(responseObjectLocal, error);
                                                  
                                              }
                                              NSLog(@"**********************************************************************");
                                              
                                          }
                                      }];
    [dataTask resume];
}
-(NSData *)sendRequestToServer:(wsMethodNames)methodName withObject:(id)Object
{
    NLJsonConverter *jsonHandler = [NLJsonConverter sharedInstance];
    NSData *data = nil ;
    switch(methodName)
    {
        case login:
        {
            return [jsonHandler convertLoginObjectToJson:Object];
            break;
        }
        default:
            break;
    };
    return data;
}

@end
