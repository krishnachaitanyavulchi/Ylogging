//
//  NorthanLights.h
//  NorthanLights
//
//  Created by Thrymr Software on 02/08/17.
//  Copyright © 2017 Thrymr_Sravan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NlStructures.h"
#import "WebServiceDefines.h"
typedef void(^NLComplitionHandler)(id response, NSError *error);
typedef void(^NLCompletionHandlerSuccess)(BOOL isSuccess, NSString *message);

@interface NorthanLights : NSObject
+(NorthanLights *)sharedInstance:(NSString *)BaseUrl withSite:(NSString *)siteName;
+(void)NLAuthenticate:(NlLoginStruct *)dicParams completionHandler:(NLCompletionHandlerSuccess)completionHandler;
@end
