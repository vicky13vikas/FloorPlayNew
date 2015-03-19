//
//  FPImageData.m
//  FloorPlay
//
//  Created by Vikas Kumar on 18/03/15.
//  Copyright (c) 2015 Vikas Kumar. All rights reserved.
//

#import "FPImageData.h"
#import <objc/runtime.h>
#import "Constants.h"


@implementation FPImageData

@dynamic identfier;
@dynamic name;
@dynamic imageDescription;
@dynamic size;
@dynamic color;
@dynamic pattern;
@dynamic price;
@dynamic material;
@dynamic createddate;
@dynamic serailNumber;
@dynamic imageURL1;
@dynamic imageURL2;
@dynamic imageURL3;
@dynamic imageURL4;

- (void)setDataFromImageData:(ImageData*)data
{
    self.identfier = data.identfier;
    self.name = data.name;
    self.imageDescription = data.imageDescription;
    self.size = data.size;
    self.color = data.color;
    self.pattern = data.pattern;
    self.price = data.price;
    self.material = data.material;
    self.createddate = data.createddate;
    
    for (int i = 0; i<data.imageURLs.count ; i++)
    {
        NSString *imageURL = [data.imageURLs objectAtIndex:i];
        
        NSString *propertyName = [NSString stringWithFormat:@"imageURL%d",i+1];
        objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
        if(property)
        {
            [self setValue:[imageURL lastPathComponent] forKey:propertyName];
        }
    }
  
}

- (ImageData*)getImageData
{
    ImageData *image = [[ImageData alloc] initWithID:self.identfier
                                                name:self.name
                                         description:self.imageDescription
                                                size:self.size
                                               color:self.color
                                             pattern:self.pattern
                                            material:self.material
                                               price:self.price
                                         createdDate:self.createddate
                                          imagesURLs:nil];
    
    NSMutableArray *imageURLList = [[NSMutableArray alloc] init];
    NSString *folderPath = [image pathToSaveOffline];
    for (int i = 0; i < RELATIVE_IMAGES_COUNT ; i++)
    {
        NSString *propertyName = [NSString stringWithFormat:@"imageURL%d",i+1];
        objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
        if(property)
        {
            NSString *imageLastPathComponent = [self valueForKey:propertyName];
            if(imageLastPathComponent)
            {
                NSString* constPath = [folderPath stringByAppendingPathComponent:imageLastPathComponent];
                NSURL *imageURL = [NSURL fileURLWithPath:constPath];
                [imageURLList addObject:imageURL];
            }
        }
    }

    image.imageURLs = imageURLList;
    
    return image;
}

@end
