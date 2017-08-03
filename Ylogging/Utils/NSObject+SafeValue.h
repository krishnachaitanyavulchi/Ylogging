//
//  NSObject+SafeValue.h
//  Mavy
//
//  Created by sravan.vodnala on 12/01/16.
//  Copyright (c) 2016 Datamatics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafeValue)
-(id)safeObjectForKey:(NSString *)key;
@end
