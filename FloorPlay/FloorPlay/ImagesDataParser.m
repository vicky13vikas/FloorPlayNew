//
//  ImagesDataParser.m
//  HomeDemo
//
//  Created by Vikas Kumar on 16/09/13.
//  Copyright (c) 2013 Vikas Kumar. All rights reserved.
//

#import "ImagesDataParser.h"
#import "ImagesDataSource.h"
#import "ImageData.h"
#import "Constants.h"

@implementation ImagesDataParser

+ (NSArray*) parseImagesFromData: (NSData*)data andCacheDataSource:(BOOL)toCache
{
    NSMutableArray* imagesObjectArray = [NSMutableArray array];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeStyle:NSDateFormatterFullStyle];
    //Force to read the date as en_US
//    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
	//10:06 AM Thu, Nov 18, 2010
	[dateFormatter setDateFormat:@"h:mm a EEE, MMM d, yyyy"];
	[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];

    NSError *error = nil;
    NSArray *imagesArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    if(!error)
    {
//        NSArray *imagesArray = [response objectForKey:@"image"];
        if(imagesArray.count > 0)
        {
            for(id image in imagesArray)
            {
                NSString *imageID = [image objectForKey:@"id"];
                NSString *imageName = [image objectForKey:@"name"];
                NSString *imageSize = [image objectForKey:@"size"];
                NSString *imageDesc = [image objectForKey:@"desc"];
                NSString *imagepattern = [image objectForKey:@"Pattern"];
                NSString *imageColor = [image objectForKey:@"color"];
                NSString *imageMaterial = [image objectForKey:@"material"];
                NSString *imagePrice = [image objectForKey:@"price"];
                
                NSMutableArray *imageArray = [[NSMutableArray alloc] init];
                for (int i=0; i < RELATIVE_IMAGES_COUNT; i++)
                {
                    NSString *img = [image objectForKey:[NSString stringWithFormat:@"image%d",i+1]];
                    if(![img isKindOfClass:[NSNull class]])
                    {
                        if ([img length] > 0)
                        {
                            [imageArray addObject:img];
                        }
                    }
                }
                
                NSDate *createdDate = [dateFormatter dateFromString:[image objectForKey:@"created_date"]];
                
                ImageData *imageItem = [[ImageData alloc] initWithID:imageID name:imageName description:imageDesc size:imageSize color:imageColor pattern:imagepattern material:imageMaterial price:imagePrice createdDate:createdDate imagesList:imageArray];
                
                [imagesObjectArray addObject:imageItem];
                
            }
        }
    }
    if(imagesObjectArray.count > 0 && toCache)
    {
        [[ImagesDataSource singleton] cacheData:imagesObjectArray];
    }
    return imagesObjectArray;
}

@end
