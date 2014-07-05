//
//  ImagesDataSource.h
//  HomeDemo
//
//  Created by Vikas Kumar on 16/09/13.
//  Copyright (c) 2013 Vikas Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageData.h"
#import "Constants.h"

@interface ImagesDataSource : NSObject

@property (nonatomic, retain) NSMutableArray *objects;

+ (ImagesDataSource *) singleton;

- (void) cacheData: (NSArray*) _events;

- (BOOL) hasCacheData;

- (ImageData*)getImageDataWithID:(NSString*) image_id;

-(void)addImage:(ImageData*)imageItem;

-(void)update;

-(UIImage*) getImageAtIndex:(NSInteger)index forImage:(ImageData *)image;
-(UIImage*)getImageFromImageName:(NSString*)imageName;

-(NSArray*)getAvailableColors;
-(NSArray*)getAvailablePattern;
-(NSArray*)getAvailableSize;
-(NSArray*)getAvailableMaterial;
-(NSArray*)getAvailablePrice;

-(NSArray*)getImagesInCategory:(CategoryType)category withValue:(NSString*)selectedString;
-(NSArray*)getItemsInPriceRange:(NSString*)selectedString;

-(NSArray*)searchImagesWithDetail:(NSString*)selectedString;

@end
