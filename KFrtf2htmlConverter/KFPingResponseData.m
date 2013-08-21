//
//  KFPingResponseData.m
//  KFrtf2htmlConverter
//
//  Created by rick on 21.08.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import "KFPingResponseData.h"

@implementation KFPingResponseData


- (NSDictionary *)httpHeaders
{
    return @{@"Access-Control-Allow-Origin" : @"*"};
}


@end
