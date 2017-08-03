//
//  NLUtils.h
//  DateAndTime
//
//  Created by sravan.vodnala on 31/03/14.
//  Copyright (c) 2014 sravan.vodnala. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import <UIKit/UIKit.h>

@interface NLUtils : NSObject
+(NSString *)RetrieveDate:(NSString *)str;
+(NSString *)retriveTime:(NSString *)str;
+(NSString *)retriveDate:(double)postDate;
+ (NSString *)compareWithCurrentDate:(NSDate *)date;
+(NSString *) getLocalizedString:(NSString *)name;
+(BOOL)isExpaired:(NSString *)strDate;
+(BOOL)checkNet;
+(void)addLayer:(id)view;
+(NSString *)getNormalString:(NSString *)stringTemp;
+(CGFloat )getHeightOfString:(NSString *)string withFont:(UIFont *)fontType withWidth:(CGFloat)width;
+(CGSize )getSizeOfString:(NSString *)string withFont:(UIFont *)fontType withWidth:(CGFloat)width;
+(CGFloat )getHeightOfHTMLstringFormat:(NSString *)string withFont:(UIFont *)fontType withWidth:(CGFloat)width withFontSize:(CGFloat)fontSizeHeight;
+(NSString*)replacePattern:(NSString*)pattern withReplacement:(NSString*)replacement forString:(NSString*)string usingCharacterSet:(NSCharacterSet*)characterSetOrNil;
+ (NSString *)GetDeviceID;
+(void)setDeviceID;
+(void) setObject:(NSString*) object forKey:(NSString*) key;
+(NSString*) objectForKey:(NSString*) key;
+ (NSString *)getIPAddress;
+(CGPathRef)renderRect:(UIView*)imgView;
+ (CGPathRef)renderTrapezoid:(UIView*)imgView;
+ (CGPathRef)renderEllipse:(UIView*)imgView;
+(CGPathRef)renderPaperCurl:(UIView*)imgView;
+(NSString *)returnBinaryString:(id)strDic;
+(NSString *)returnTypeString:(id)strDic;
+(NSString *)removeNullValues:(NSString *)strValue;
@end


