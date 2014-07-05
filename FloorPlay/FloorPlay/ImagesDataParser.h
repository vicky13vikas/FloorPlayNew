//
//  ImagesDataParser.h
//  HomeDemo
//
//  Created by Vikas Kumar on 16/09/13.
//  Copyright (c) 2013 Vikas Kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageData.h"

@interface ImagesDataParser : NSObject

+ (NSArray*) parseImagesFromData: (NSData*)data andCacheDataSource:(BOOL)toCache;


@end
