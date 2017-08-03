//
//  NLJsonConverter.h
//  WisdomJobs
//
//  Created by Thrymr on 07/02/17.
//  Copyright © 2017 thrymr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebServiceDefines.h"
#import "NlStructures.h"

@interface NLJsonConverter : NSObject

+ (NLJsonConverter*)sharedInstance;

-(NSData *)convertLoginObjectToJson:(NlLoginStruct *)loginObj;
@end
