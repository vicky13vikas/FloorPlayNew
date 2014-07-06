//
//  CustomDataSource.m
//  FloorPlay
//
//  Created by Vikas Kumar on 06/07/14.
//  Copyright (c) 2014 Vikas Kumar. All rights reserved.
//

#import "CustomDataSource.h"
#import "Constants.h"

@implementation CustomDataSource

+ (instancetype)sharedData
{
    static CustomDataSource *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
        
        [sharedInstance updateProductsList];
    });
    return sharedInstance;
}


- (NSArray*)getProductMasterList
{
    return [NSArray arrayWithArray:_objects];
}

-(void)updateProductsList
{
    if(!_objects)
    {
        _objects = [[NSMutableArray alloc] init];
    }
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentDirPath = [documentDirPath stringByAppendingString:@"/"];
    documentDirPath = [documentDirPath stringByAppendingString:SAVED_JSON_PRODUCT_MASTER];
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:documentDirPath];

    for ( NSArray *productname in dictionary)
    {
        FPProduct *product = [[FPProduct alloc] initWithAttributes:[dictionary objectForKey:productname]];
        [_objects addObject:product];
    }
}

@end
