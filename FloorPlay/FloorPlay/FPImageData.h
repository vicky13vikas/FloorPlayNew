//
//  FPImageData.h
//  FloorPlay
//
//  Created by Vikas Kumar on 18/03/15.
//  Copyright (c) 2015 Vikas Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ImageData.h"


@interface FPImageData : NSManagedObject

@property (nonatomic, retain) NSString * identfier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imageDescription;
@property (nonatomic, retain) NSString * size;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * pattern;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * material;
@property (nonatomic, retain) NSDate * createddate;
@property (nonatomic, retain) NSString * imageURL1;
@property (nonatomic, retain) NSString * imageURL2;
@property (nonatomic, retain) NSString * imageURL4;
@property (nonatomic, retain) NSString * imageURL3;

- (void)setDataFromImageData:(ImageData*)data;

@end
