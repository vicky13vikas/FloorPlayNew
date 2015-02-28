//
//  FPProduct.h
//  FloorPlay
//
//  Created by Vikas Kumar on 06/07/14.
//  Copyright (c) 2014 Vikas Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPProduct : NSObject

@property (nonatomic, retain) NSString* productID;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* productDescription;
@property (nonatomic, retain) NSString* folderName;

@property (nonatomic, retain) NSArray *customProducts;


- (instancetype)initWithAttributes:(NSArray *)productData;

@end
