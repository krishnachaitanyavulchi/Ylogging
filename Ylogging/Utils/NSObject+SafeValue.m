//
//  NSObject+SafeValue.m
//  Mavy
//
//  Created by sravan.vodnala on 12/01/16.
//  Copyright (c) 2016 Datamatics. All rights reserved.
//

#import "NSObject+SafeValue.h"

@implementation NSObject (SafeValue)
-(id)safeObjectForKey:(NSString *)key
{
    if([[self valueForKey:key] isKindOfClass:[NSNull class]])
        return nil;
    return [self valueForKey:key];
}
@end
