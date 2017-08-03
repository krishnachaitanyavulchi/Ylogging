//
//  NLJsonConverter.m
//  WisdomJobs
//
//  Created by Thrymr on 07/02/17.
//  Copyright © 2017 thrymr. All rights reserved.
//

#import "NLJsonConverter.h"
#import "NLUtils.h"

@implementation NLJsonConverter

+ (NLJsonConverter*)sharedInstance
{
    static NLJsonConverter *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^
                  {
                      _sharedInstance = [[NLJsonConverter alloc] init];
                  });
    return _sharedInstance;
}

-(NSData *)convertLoginObjectToJson:(NlLoginStruct *)loginObj
{
    NSMutableDictionary *maindic = [[NSMutableDictionary alloc]init];
    [maindic setObject:loginObj.strUserName forKey:@"email"];
    [maindic setObject:loginObj.strPassword forKey:@"password"];
    
    NSError *error;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:maindic options:kNilOptions error:&error];
    
    return jsonData;
}
@end
