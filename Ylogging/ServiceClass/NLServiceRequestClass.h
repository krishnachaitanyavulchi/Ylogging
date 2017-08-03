//
//  NLServiceRequestClass.h
//  NorthanLights
//
//  Created by Thrymr Software on 02/08/17.
//  Copyright © 2017 Thrymr_Sravan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDefines.h"
#import "NLUtils.h"

typedef void(^ComplitionHandler)(id response, NSError *error);

@interface NLServiceRequestClass : NSObject


+(NLServiceRequestClass *)sharedInstance;

-(void)Service_CallWithData:(id)dicParameters withMethodName:(wsMethodNames)methodName complitionHandler:(ComplitionHandler)complitionHandler;





@end
