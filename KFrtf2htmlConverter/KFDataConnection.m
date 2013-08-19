//
//  KFEpubDataConnection.m
//  KFrtf2htmlConverter
//
//  Created by rick on 19.08.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFDataConnection.h"
#import <AppKit/AppKit.h>

#import <CocoaHTTPServer/HTTPLogging.h>
#import <CocoaHTTPServer/HTTPMessage.h>
#import <CocoaHTTPServer/HTTPDataResponse.h>

static const int httpLogLevel = HTTP_LOG_LEVEL_WARN;


@implementation KFDataConnection


- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
    return YES;
    
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/rtf2html"])
    {
        return YES;
    }
    return [super supportsMethod:method atPath:path];
}


- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path
{
    if ([method isEqualToString:@"POST"])
    {
        return YES;
    }
    return [super expectsRequestBodyFromMethod:method atPath:path];
}


- (void)processBodyData:(NSData *)postDataChunk
{
	HTTPLogTrace();

	BOOL result = [request appendData:postDataChunk];
	if (!result)
	{
		HTTPLogError(@"%@[%p]: %@ - Couldn't append bytes!", THIS_FILE, self, THIS_METHOD);
	}
}


- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    if ([method isEqualToString:@"POST"] && [path isEqualToString:@"/rtf2html"])
    {
        NSLog(@"Responding to rtf2html POST request.");
        NSData *postData = [request body];
        
        NSString *plainData = [self decode:[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding]];
        NSDictionary *responseValues;
        
        if (postData)
        {
            NSLog(@"POST data found.");
            NSError *error = nil;
            NSDictionary *requestData = [NSJSONSerialization JSONObjectWithData:[plainData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
            
            NSString *rtfString = nil;
            NSString *errorDescription = nil;
            
            if (error == nil)
            {
                NSLog(@"JSON deserialized.");
                rtfString = requestData[@"data"];
                
                if (rtfString != nil)
                {
                    NSLog(@"Found RTF data.");
                    NSAttributedString *rtf = [[NSAttributedString alloc] initWithRTF:[rtfString dataUsingEncoding:NSUTF8StringEncoding] documentAttributes:nil];
                    
                    if (rtf != nil)
                    {
                        NSLog(@"Converting RTF data");
                        NSDictionary *defaultAttributes = @{NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType};
                        NSString *html = [[NSString alloc] initWithData:[rtf dataFromRange:NSMakeRange(0, rtf.length) documentAttributes:defaultAttributes error:&error] encoding:NSUTF8StringEncoding];
                        
                        if (error == nil)
                        {
                            responseValues = @{@"data" : html, @"success" : @"true"};
                        }
                        else
                        {
                            NSLog(@"Could not convert to HTML: %@", error.description);
                            errorDescription = error.description;
                        }
                    }
                }
                else
                {
                    NSLog(@"No RTF data found");
                    errorDescription = NSLocalizedString(@"No RTF data found", nil);
                }
            }
            else
            {
                NSLog(@"Could not deserialize JSON object.");
                errorDescription = error.description;
            }
            
            if (errorDescription != nil)
            {
                responseValues = @{@"success": @"false", @"error" : error.description};
            }
            else
            {
                NSLog(@"Conversion succeeded.");
            }

            NSData *response = [NSJSONSerialization dataWithJSONObject:responseValues options:kNilOptions error:&error];
            return [[HTTPDataResponse alloc] initWithData:response];
        }
    }
    NSData *response = [@"Request not supported." dataUsingEncoding:NSUTF8StringEncoding];
    return [[HTTPDataResponse alloc] initWithData:response];
}


- (NSString *)decode:(NSString *)encodedString
{
    NSString *result = [encodedString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


@end
