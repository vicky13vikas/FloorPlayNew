//
//  FloorPlayServices.h
//  FloorPlay
//
//  Created by Vikas kumar on 28/09/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FloorPlayServices : NSObject

@property (nonatomic, retain) NSUserDefaults *preferences;


+ (FloorPlayServices *) singleton;

-(void)startApplication;


@end
