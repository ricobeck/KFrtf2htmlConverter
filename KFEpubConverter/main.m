//
//  main.m
//  KFEpubConverter
//
//  Created by rick on 19.08.13.
//  Copyright (c) 2013 KF Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KFEpubConverter.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        
        // insert code here...
        NSLog(@"Hello, World!");
        
        KFEpubConverter *converter = [[KFEpubConverter alloc] init];
        NSString *html = [converter convert];
    }
    return 0;
}

