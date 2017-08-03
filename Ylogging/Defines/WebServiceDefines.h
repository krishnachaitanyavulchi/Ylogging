//
//  WebServiceDefines.h
//  WisdomJobs
//
//  Created by Thrymr on 07/02/17.
//  Copyright © 2017 thrymr. All rights reserved.
//


#import "NLUtils.h"
#import "NSString+stripHtml.h"
#import "NSObject+SafeValue.h"

#ifndef WebServiceDefines_h
#define WebServiceDefines_h

#define NLUserDefaults_getobject(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define NLUserDefaults_setobject(key, object) [[NSUserDefaults standardUserDefaults] setObject:object forKey:key],  [[NSUserDefaults standardUserDefaults] synchronize]
#define NLAuthenticationKey @"NLAuthenticationKey"
#define NLBaseUrl @"NLBASEURL"
#define NLSiteName @"NLSITENAME"
typedef enum webService_method_names
{
    login,
    toxonomies,
    models
    
}wsMethodNames;
#endif /* WebServiceDefines_h */
