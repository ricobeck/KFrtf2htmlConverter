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
#import <CocoaLumberjack/DDFileLogger.h>
#import <CocoaLumberjack/DDASLLogger.h>
#import <KFLogFormatter/KFLogFormatter.h>


@interface KFConverterController ()


@property (nonatomic, strong) NSData *contents;

@property (nonatomic, strong) HTTPServer *httpServer;

@property (nonatomic, strong) DDFileLogger *fileLogger;

@end


@implementation KFConverterController


- (id)init
{
    self = [super init];
    if (self)
    {
        [self initLogging];
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


- (void)initLogging
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setLogFormatter:[KFLogFormatter new]];
    
    self.fileLogger = [[DDFileLogger alloc] init];
    self.fileLogger.rollingFrequency = 60 * 60 * 24;
    self.fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:self.fileLogger];
}


@end
