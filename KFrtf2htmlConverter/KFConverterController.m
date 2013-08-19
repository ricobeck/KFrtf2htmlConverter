//
//  KFConverterController.m
//  KFrtf2htmlConverter
//
//  Created by rick on 19.08.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFConverterController.h"
#import "KFDataConnection.h"

#import <CocoaHTTPServer/HTTPServer.h>
#import <CocoaLumberjack/DDLog.h>
#import <CocoaLumberjack/DDTTYLogger.h>


@interface KFConverterController ()


@property (nonatomic, strong) NSData *contents;

@property (nonatomic, strong) HTTPServer *httpServer;


@end


@implementation KFConverterController


- (id)init
{
    self = [super init];
    if (self)
    {
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
    }
    return self;
}


- (void)start
{
    self.httpServer = [[HTTPServer alloc] init];
    [self.httpServer setType:@"_http._tcp."];
    self.httpServer.connectionClass = [KFDataConnection class];
    [self.httpServer setPort:13337];
    
    NSString *webPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"web"];
    self.httpServer.documentRoot = webPath;
    
    NSError *error = nil;
    [self.httpServer start:&error];
}


@end
