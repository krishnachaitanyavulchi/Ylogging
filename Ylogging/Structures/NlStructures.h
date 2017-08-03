//
//  NlStructures.h
//  NorthanLights
//
//  Created by Thrymr Software on 02/08/17.
//  Copyright © 2017 Thrymr_Sravan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NlStructures : NSObject

@end

@interface NlLoginStruct : NSObject
@property (nonatomic, strong) NSString *strUserName;
@property (nonatomic, strong) NSString *strPassword;
@property (nonatomic, strong) NSString *strSiteName;
@end
