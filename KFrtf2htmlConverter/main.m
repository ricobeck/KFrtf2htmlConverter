//
//  main.m
//  KFrtf2htmlConverter
//
//  Created by rick on 19.08.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFConverterController.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        KFConverterController *converter = [[KFConverterController alloc] init];
        [converter start];
        
        [[NSRunLoop currentRunLoop] run];
    }
    return 0;
}

