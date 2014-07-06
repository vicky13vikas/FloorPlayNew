//
//  CustomDataSource.h
//  FloorPlay
//
//  Created by Vikas Kumar on 06/07/14.
//  Copyright (c) 2014 Vikas Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPProduct.h"

@interface CustomDataSource : NSObject

@property (nonatomic, retain) NSMutableArray *objects;


+ (instancetype)sharedData;

- (void) cacheData: (NSArray*) products;

- (NSArray*)getProductMasterList;

@end
