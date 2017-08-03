//
//  Utils.m
//  DateAndTime
//
//  Created by sravan.vodnala on 31/03/14.
//  Copyright (c) 2014 sravan.vodnala. All rights reserved.
//

#import "NLUtils.h"
#import <CommonCrypto/CommonHMAC.h>
#import "NSString+stripHtml.h"
#import "NSObject+SafeValue.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation NLUtils
+(NSString *)removeNullValues:(NSString *)strValue
{
    if ([strValue isKindOfClass:(id)[NSNull class]] || strValue.length ==0 || [strValue isEqualToString:@""] || strValue == nil || [strValue isEqualToString:@"(null)"])
        return @"";
    return strValue;
}

+(NSString *)RetrieveDate:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSArray *temp = [[arr objectAtIndex:1] componentsSeparatedByString:@"."];
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[temp objectAtIndex:0]];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter1 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];

//    NSDate *formatedDate = [dateFormatter1 dateFromString:dateStr];
//    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
//    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
//    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:formatedDate];
//    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:formatedDate];
//    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
//    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:formatedDate];
    
//    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
//    [dateFormatters setDateStyle:NSDateFormatterMediumStyle];
//    [dateFormatters setTimeStyle:NSDateFormatterNoStyle];
//    [dateFormatters setDoesRelativeDateFormatting:NO];
//    [dateFormatters setTimeZone:[NSTimeZone systemTimeZone]];
//    
//    dateStr = [dateFormatters stringFromDate:destinationDate];
    
//    NSArray *arrmain = [dateStr componentsSeparatedByString:@" at "];
//    dateStr = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:0]];
//    
//    NSArray *arrDate = [dateStr componentsSeparatedByString:@"/"];
//     dateStr = [NSString stringWithFormat:@"%@- %@- %@",[arrDate objectAtIndex:0],[arrDate objectAtIndex:1],[arrDate objectAtIndex:2]];
  
    NSArray *arrmain = [dateStr componentsSeparatedByString:@" "];
    dateStr = [NSString stringWithFormat:@"%@",[arrmain objectAtIndex:0]];
    
    NSArray *arrDate = [dateStr componentsSeparatedByString:@"-"];
    dateStr = [NSString stringWithFormat:@"%@-%@-%@",[arrDate objectAtIndex:1],[arrDate objectAtIndex:2],[arrDate objectAtIndex:0]];

    return dateStr;
}
+(NSString *)retriveTime:(NSString *)str
{
    NSArray *arr = [str componentsSeparatedByString:@"T"];
    NSArray *temp = [[arr objectAtIndex:1] componentsSeparatedByString:@"."];
    NSString *dateStr = [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[temp objectAtIndex:0]];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter1 setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];

    NSDate *formatedDate = [dateFormatter1 dateFromString:dateStr];
    NSTimeZone *currentTimeZone = [NSTimeZone localTimeZone];
    NSTimeZone *utcTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    
    NSInteger currentGMTOffset = [currentTimeZone secondsFromGMTForDate:formatedDate];
    NSInteger gmtOffset = [utcTimeZone secondsFromGMTForDate:formatedDate];
    NSTimeInterval gmtInterval = currentGMTOffset - gmtOffset;
    
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:gmtInterval sinceDate:formatedDate];
    
    NSDateFormatter *dateFormatters = [[NSDateFormatter alloc] init];
    [dateFormatters setDateStyle:NSDateFormatterNoStyle];
    [dateFormatters setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatters setDoesRelativeDateFormatting:NO];
    [dateFormatters setTimeZone:[NSTimeZone systemTimeZone]];

    dateStr = [dateFormatters stringFromDate:destinationDate];
   
    NSArray *arrTime = [dateStr componentsSeparatedByString:@":"];
    if([[arrTime objectAtIndex:0] length] == 1)
        dateStr = [NSString stringWithFormat:@"0%@:%@",[arrTime objectAtIndex:0],[arrTime objectAtIndex:1]];
    return dateStr;
}
+(NSString *)retriveDate:(double)postDate
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:postDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    
    return [dateFormatter stringFromDate:date];
}
+(NSString *)compareWithCurrentDate:(NSDate* )date
{
    NSCalendarUnit units = NSCalendarUnitDay | NSCalendarUnitWeekOfYear |
    NSCalendarUnitMonth | NSCalendarUnitYear;
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekOfYear) fromDate:[NSDate date]];
    
    NSDate *today = [cal dateFromComponents:components1];
    
    components1 = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:date];
    NSDate *thatdate = [cal dateFromComponents:components1];
    
    // if `date` is before "now" (i.e. in the past) then the components will be positive
    NSDateComponents *components = [[NSCalendar currentCalendar] components:units
                                                                   fromDate:thatdate
                                                                     toDate:today
                                                                    options:0];
    
    if ( labs(components.year) > 0)
    {
        if (components.year > 0)
        {
            if(components.year==1)
                return @"1 year ago";
            else
                // in the past
                return [NSString stringWithFormat:@"%ld years ago", (long)components.year];
        }
        else
        {
            // in the future
            return [NSString stringWithFormat:@"In %ld years", (long)components.year];
        }
    }
    else if (labs(components.month) > 0)
    {
        if (components.month > 0)
        {
            
            if(components.month==1)
                return @"1 month ago";
            else
                // in the past
                return [NSString stringWithFormat:@"%ld months ago", (long)components.month];
        }
        else
        {
            // in the future
            return [NSString stringWithFormat:@"%ld months", labs(components.month)];
        }
    }
    else if (labs(components.weekOfYear) > 0)
    {
        if (components.weekOfYear > 0)
        {
            // in the past
            if( components.weekOfYear==1)
                return @"1 week ago";
            else
                return [NSString stringWithFormat:@"%ld weeks ago", (long)components.weekOfYear];
        }
        else
        {
            // in the future
            return [NSString stringWithFormat:@"%ld weeks", (long)components.weekOfYear];
        }
    }
    else if (labs(components.day) > 0)
    {
        if (components.day > 0)
        {
            if (components.day > 1)
                return @"This week";
            else
                return @"Yesterday";
        }
        else
        {
            if (components.day < -1)
            {
                return @"Next week";//[NSString stringWithFormat:@"%ld days ago", (long)components.day];
            }
            else
            {
                return @"Tomorrow";
            }
        }
    }
    else
    {
        return @"Today";
    }
}
+(NSString *) getLocalizedString:(NSString *)name
{
 @synchronized(self)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString * languageSelected = [defaults objectForKey:@"Language"];
        NSString *fname = [[NSBundle mainBundle] pathForResource:languageSelected ofType:@"strings"];
        NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:fname];
        NSString *message = [d objectForKey:name];
        return message;
    }
    return name;
}

+(BOOL)isExpaired:(NSString *)strDate
{
    NSArray *arr = [strDate componentsSeparatedByString:@"T"];
    NSArray *temp = [[arr objectAtIndex:1] componentsSeparatedByString:@"."];
    NSString *dateString = [NSString stringWithFormat:@"%@ %@",[arr objectAtIndex:0],[temp objectAtIndex:0]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
    
    NSDate *date = [dateFormatter dateFromString: dateString];
    
    NSDate * today = [NSDate date];
    NSComparisonResult result = [today compare:date];
    
    BOOL isNotExpired = NO;
    switch (result)
    {
        case NSOrderedAscending:
            break;
        case NSOrderedDescending:
        {
            isNotExpired = YES;
            break;
        }
        case NSOrderedSame:
            break;
        default:
            break;
    }
    return isNotExpired;
}

+(NSString *)aaa:(NSString*)name
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString * languageSelected = [defaults objectForKey:@"Language"];
    NSString *fname = [[NSBundle mainBundle] pathForResource:languageSelected ofType:@"strings"];
    NSDictionary *d = [NSDictionary dictionaryWithContentsOfFile:fname];
    NSString *message = [d objectForKey:name];
    
    return message;
}
+(void)addLayer:(id)view
{
    CALayer * layer = [view layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:10.0];
}

+(BOOL)checkNet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable)
    {
        NSLog(@"NO NET");
        return NO;
    }
    else
    {
        NSLog(@"YES NET");
        return YES;
    }
}
+(NSString *)getNormalString:(NSString *)stringTemp
{
    NSString *stringReplay = [[stringTemp stripHtml] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    return [self replacePattern:@"[View:" withReplacement:@"" forString:stringReplay usingCharacterSet:nil];
}
+(NSString*)replacePattern:(NSString*)pattern withReplacement:(NSString*)replacement forString:(NSString*)string usingCharacterSet:(NSCharacterSet*)characterSetOrNil
{
    if (!characterSetOrNil)
    characterSetOrNil = [NSCharacterSet characterSetWithCharactersInString:@" !?,()]"];
    if(string == nil)
        string = @"";
    // Create a mutable copy of the string supplied, setup all the default variables we'll need to use
    NSMutableString *mutableString = [[NSMutableString alloc] initWithString:string] ;
    NSString *beforePatternString = nil;
    NSRange outputrange = NSMakeRange(0, 0);
    
    // Check if the string contains the "pattern" you're looking for, otherwise simply return it.
    NSRange containsPattern = [mutableString rangeOfString:pattern];
    while (containsPattern.location != NSNotFound)
    // Found the pattern, let's run with the changes
    {
        // Firstly, we grab the full string range
        NSRange stringrange = NSMakeRange(0, [mutableString length]);
        NSScanner *scanner = [[NSScanner alloc] initWithString:mutableString];
        
        // Now we use NSScanner to scan UP TO the pattern provided
        [scanner scanUpToString:pattern intoString:&beforePatternString];
        
        // Check for nil here otherwise you will crash - you will get nil if the pattern is at the very beginning of the string
        // outputrange represents the range of the string right BEFORE your pattern
        // We need this to know where to start searching for our characterset (i.e. end of output range = beginning of our pattern)
        if (beforePatternString != nil)
        outputrange = [mutableString rangeOfString:beforePatternString];
        
        // Search for any of the character sets supplied to know where to stop.
        // i.e. for a URL you'd be looking at non-URL friendly characters, including spaces (this may need a bit more research for an exhaustive list)
        NSRange characterAfterPatternRange = [mutableString rangeOfCharacterFromSet:characterSetOrNil options:NSLiteralSearch range:NSMakeRange(outputrange.length, stringrange.length-outputrange.length)];
        
        // Check if the link is not at the very end of the string, in which case there will be no characters AFTER it so set the NSRage location to the end of the string (== it's length)
        if (characterAfterPatternRange.location == NSNotFound)
        characterAfterPatternRange.location = [mutableString length];
        
        // Assign the pattern's start position and length, and then replace it with the pattern
        NSInteger patternStartPosition = outputrange.length;
        NSInteger patternLength = characterAfterPatternRange.location - outputrange.length;
        [mutableString replaceCharactersInRange:NSMakeRange(patternStartPosition, patternLength) withString:replacement];
        
        // Reset containsPattern for new mutablestring and let the loop continue
        containsPattern = [mutableString rangeOfString:pattern];
    }
    return [mutableString copy] ;
}

+(CGFloat )getHeightOfString:(NSString *)string withFont:(UIFont *)fontType withWidth:(CGFloat)width
{
    if([string isEqualToString:@""] || string == nil)
        return 0.0;
    else
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSAttributedString *attVal = [[NSAttributedString alloc] initWithString:string attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName : fontType}];
        CGRect textRect = [attVal boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return ceilf(textRect.size.height);
    }
}
+(CGSize )getSizeOfString:(NSString *)string withFont:(UIFont *)fontType withWidth:(CGFloat)width
{
    CGSize sizeValue = CGSizeMake(0.0, 0.0);
    if([string isEqualToString:@""] || string == nil)
        return sizeValue;
    else
    {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSAttributedString *attVal = [[NSAttributedString alloc] initWithString:[self getNormalString:string] attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName : fontType}];
        CGRect textRect = [attVal boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        sizeValue.width = ceilf(textRect.size.width);
                sizeValue.height = ceilf(textRect.size.height);
        return sizeValue;
    }
}
+(void)setDeviceID
{
        [self setObject:[self GetDeviceID] forKey:@"Mavy_deviceID"];
}

+ (NSString *)GetDeviceID
{
    NSString *udidString;
    udidString = [self objectForKey:@"Mavy_deviceID"];
    if(!udidString || [udidString isEqualToString:@""])
    {
        NSUserDefaults *userdefaults = [NSUserDefaults standardUserDefaults];
        udidString = [NSString stringWithFormat:@"1002367600#%@",[userdefaults objectForKey:@"username"]];
        
    }
    return udidString;
}

+(void) setObject:(NSString*) object forKey:(NSString*) key
{
   // NSString *objectString = object;
    NSError *error = nil;
//    [SFHFKeychainUtils storeUsername:key
//                         andPassword:objectString
//                      forServiceName:@"LIB"
//                      updateExisting:YES
//                               error:&error];
    
    if(error)
        NSLog(@"%@", [error localizedDescription]);
}

+(NSString*) objectForKey:(NSString*) key
{
    NSError *error = nil;
//    NSString *object = [SFHFKeychainUtils getPasswordForUsername:key
//                                                  andServiceName:@"LIB"
//                                                           error:&error];
    if(error)
        NSLog(@"%@", [error localizedDescription]);
    
    return nil;
}
#pragma mark - Shadow rect
+(CGPathRef)renderRect:(UIView*)imgView
{
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imgView.bounds];
    return path.CGPath;
}

+ (CGPathRef)renderTrapezoid:(UIView*)imgView
{
    CGSize size = imgView.bounds.size;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(size.width * 0.33f, size.height * 0.66f)];
    [path addLineToPoint:CGPointMake(size.width * 0.66f, size.height * 0.66f)];
    [path addLineToPoint:CGPointMake(size.width * 1.15f, size.height * 1.15f)];
    [path addLineToPoint:CGPointMake(size.width * -0.15f, size.height * 1.15f)];
    
    return path.CGPath;
}

+ (CGPathRef)renderEllipse:(UIView*)imgView
{
    CGSize size = imgView.bounds.size;
    
    CGRect ovalRect = CGRectMake(0.0f, size.height + 5, size.width - 10, 15);
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:ovalRect];
    
    return path.CGPath;
}

+(CGPathRef)renderPaperCurl:(UIView*)imgView
{
    CGSize size = imgView.bounds.size;
    CGFloat curlFactor = 15.0f;
    CGFloat shadowDepth = 5.0f;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0f, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, 0.0f)];
    [path addLineToPoint:CGPointMake(size.width, size.height + shadowDepth)];
    [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
            controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
            controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
    
    return path.CGPath;
}
+(CGFloat )getHeightOfHTMLstringFormat:(NSString *)string withFont:(UIFont *)fontType withWidth:(CGFloat)width withFontSize:(CGFloat)fontSizeHeight
{
    if([string isEqualToString:@""] || string == nil)
        return 0.0;
    else
    {
//        string = [string stringByReplacingOccurrencesOfString:@"<a href" withString:@"<a> href"];

        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentLeft;
        NSAttributedString *attVal = [[NSAttributedString alloc] initWithString:[self getNormalString:string] attributes:@{NSParagraphStyleAttributeName:paragraphStyle,NSFontAttributeName : fontType}];
        CGRect textRect = [attVal boundingRectWithSize:CGSizeMake(width, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        NSInteger index=0;
        
        NSArray *arrPara = [string componentsSeparatedByString:@"p>"];
        NSArray *arrDiv = [string componentsSeparatedByString:@"div>"];
        NSArray *arrStrong = [string componentsSeparatedByString:@"<strong>"];
        
        index = arrPara.count + arrDiv.count + arrStrong.count  -1;
        return ceilf(textRect.size.height) + (index*  fontSizeHeight);
    }
}
+(NSString *)returnBinaryString:(id)strDic
{
    if([strDic isKindOfClass:[NSDictionary class]])
        return [strDic safeObjectForKey:@"$binary"];
    else
        return strDic;
}
+(NSString *)returnTypeString:(id)strDic
{
    if([strDic isKindOfClass:[NSDictionary class]])
        return [strDic safeObjectForKey:@"$type"];
    else
        return strDic;
}
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    
                }
                
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
@end
