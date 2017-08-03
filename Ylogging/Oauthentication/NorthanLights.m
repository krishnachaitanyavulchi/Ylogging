//
//  NorthanLights.m
//  NorthanLights
//
//  Created by Thrymr Software on 02/08/17.
//  Copyright © 2017 Thrymr_Sravan. All rights reserved.
//

#import "NorthanLights.h"
#import "NLServiceRequestClass.h"

@implementation NorthanLights


#pragma mark - Instance -
+(NorthanLights *)sharedInstance:(NSString *)BaseUrl withSite:(NSString *)siteName
{
    static dispatch_once_t onceDispatch;
    static NorthanLights *sharedInstance;
    dispatch_once(&onceDispatch, ^{
        sharedInstance = [[self alloc] init];
        
        NLUserDefaults_setobject(NLBaseUrl, BaseUrl);
        NLUserDefaults_setobject(NLSiteName, siteName);
        
    });
    return sharedInstance;
}
+(void)NLAuthenticate:(NlLoginStruct *)dicParams completionHandler:(NLCompletionHandlerSuccess)completionHandler
{
    NLServiceRequestClass *objService = [NLServiceRequestClass sharedInstance];
    [objService Service_CallWithData:dicParams withMethodName:login complitionHandler:^(id response, NSError *error) {
        
        if(response == nil || error)
        {
            
            completionHandler(NO, @"Error Occured While getting data from server.");
        }
        else
        {
            NSDictionary *dic = (NSDictionary *)response;
            NLUserDefaults_setobject(NLAuthenticationKey, [dic safeObjectForKey:@"access_token"]);
            completionHandler(YES, @"Success");
        }
    }];
}
@end
