//
//  FloorPlayServices.m
//  FloorPlay
//
//  Created by Vikas kumar on 28/09/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import "FloorPlayServices.h"

@implementation FloorPlayServices

+ (FloorPlayServices *) singleton
{
    static FloorPlayServices *sharedSingleton;
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[FloorPlayServices alloc] init];
        return sharedSingleton;
    }
}

- (id) init
{
    self = [super init];
    self.preferences = [NSUserDefaults standardUserDefaults];
    return self;
}


-(void)startApplication
{

}


@end
