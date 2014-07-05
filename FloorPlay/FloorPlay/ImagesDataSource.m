//
//  ImagesDataSource.m
//  HomeDemo
//
//  Created by Vikas Kumar on 16/09/13.
//  Copyright (c) 2013 Vikas Kumar. All rights reserved.
//

#import "ImagesDataSource.h"

@implementation ImagesDataSource

+ (ImagesDataSource *) singleton
{
    static ImagesDataSource *sharedSingleton;
    @synchronized(self)
    {
        if (!sharedSingleton)
        {
            sharedSingleton = [[ImagesDataSource alloc] init];
        }
        return sharedSingleton;
    }
}

- (id) init
{
    self = [super init];
    if (self)
    {
        self.objects = [NSMutableArray array];
    }
    return self;
}

- (void) cacheData: (NSArray*) _events;
{
    [self.objects removeAllObjects];
    [self.objects addObjectsFromArray:_events];
}

- (BOOL) hasCacheData
{
    if([self.objects count]>0)
        return true;
    else
        return false;
}


- (ImageData*)getImageDataWithID:(NSString*) image_id
{
    NSEnumerator *e = [_objects objectEnumerator];
    id ob;
    while ((ob = [e nextObject]))
    {
        ImageData* imageItem = ob;
        if ([imageItem.identfier isEqualToString:image_id])
            return imageItem;
    }
    return nil;
}

-(void)addImage:(ImageData*)imageItem
{
    [_objects insertObject:imageItem atIndex:0];
}


-(void)update
{
    NSEnumerator *e = [_objects objectEnumerator];
    id ob;
    while ((ob = [e nextObject]))
    {
//        ImageData* imageItem = ob;
//        imageItem.image = [self getImageFromImageName:imageItem.name];
    }
}

-(UIImage*)getImageFromImageName:(NSString*)imageName
{
    NSArray *dirPathSearch = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = [dirPathSearch objectAtIndex:0];
    NSString *dirPath = [docDirPath stringByAppendingPathComponent:@"Images/"];
    NSString *filePath = [dirPath stringByAppendingPathComponent:imageName];
    
    return [UIImage imageWithContentsOfFile:filePath];
}

-(UIImage*) getImageAtIndex:(NSInteger)index forImage:(ImageData *)image
{
    NSEnumerator *e = [_objects objectEnumerator];
    id ob;
    UIImage *imageToReturn ;
    while ((ob = [e nextObject]))
    {
        ImageData* imageItem = ob;
        if ([imageItem isEqual:image])
        {
            NSArray *dirPathSearch = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docDirPath = [dirPathSearch objectAtIndex:0];
            NSString *dirPath = [docDirPath stringByAppendingPathComponent:@"Images/"];
            NSString *filePath;
            if(imageItem.imagesList.count > 0)
                filePath = [dirPath stringByAppendingPathComponent:[imageItem.imagesList objectAtIndex:index]];
            
            imageToReturn = [UIImage imageWithContentsOfFile:filePath];
        }
    }
    return imageToReturn;
}

-(NSArray*)getAvailableListForcategory:(CategoryType)category
{
    NSEnumerator *e = [_objects objectEnumerator];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    ImageData *ob;
    
    while (ob = [e nextObject]) {
        NSString *item;
        
        switch (category) {
            case kCategoryColor:
                item = ob.color;
                break;
            case kCategoryPrice:
                item = ob.price;
                break;
            case kCategoryPattern:
                item = ob.pattern;
                break;
            case kCategoryMaterial:
                item = ob.material;
                break;
            case kCategorySize:
                item = ob.size;
                break;
            default:
                break;
        }
        
        BOOL isAdded = NO;
        for(NSString *string in result)
        {
            if([string isEqualToString:item])
            {
                isAdded = YES;
            }
        }
        if(!isAdded && item)
            [result addObject:item];
    }
    return result;

}

-(NSArray*)getAvailableColors;
{
    return [self getAvailableListForcategory:kCategoryColor];
}

-(NSArray*)getAvailablePattern
{
    return [self getAvailableListForcategory:kCategoryPattern];
}

-(NSArray*)getAvailableSize
{
    return [self getAvailableListForcategory:kCategorySize];
}

-(NSArray*)getAvailableMaterial
{
    return [self getAvailableListForcategory:kCategoryMaterial];
}

-(NSArray*)getAvailablePrice
{
    return [self getAvailableListForcategory:kCategoryPrice];
}


-(NSArray*)getImagesInCategory:(CategoryType)category withValue:(NSString*)selectedString
{
    NSEnumerator *e = [_objects objectEnumerator];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    ImageData *ob;
    
    while (ob = [e nextObject]) {
        NSString *item;
        
        switch (category) {
            case kCategoryColor:
                item = ob.color;
                break;
            case kCategoryPrice:
                item = ob.price;
                break;
            case kCategoryPattern:
                item = ob.pattern;
                break;
            case kCategoryMaterial:
                item = ob.material;
                break;
            case kCategorySize:
                item = ob.size;
                break;
            default:
                break;
        }
        if ([item rangeOfString:selectedString].location != NSNotFound) {
            [result addObject:ob];
        }
    }
    return result;
}

-(CGFloat)minimumRangeInString:(NSString*)selectedString
{
    if([selectedString isEqualToString:kPriceRange[0]])
    {
        return 0.00;
    }
    else if([selectedString isEqualToString:kPriceRange[1]])
    {
        return 10001.00;
    }
    else if([selectedString isEqualToString:kPriceRange[2]])
    {
        return 25001.00;
    }
    else if([selectedString isEqualToString:kPriceRange[3]])
    {
        return 45001.00;
    }
    else
        return 90001;
}

-(CGFloat)maximumRangeInString:(NSString*)selectedString
{
    if([selectedString isEqualToString:kPriceRange[0]])
    {
        return 10000.00;
    }
    else if([selectedString isEqualToString:kPriceRange[1]])
    {
        return 25000.00;
    }
    else if([selectedString isEqualToString:kPriceRange[2]])
    {
        return 45000.00;
    }
    else if([selectedString isEqualToString:kPriceRange[3]])
    {
        return 90000.00;
    }
    else
        return 9999999.00;
}

-(NSArray*)getItemsInPriceRange:(NSString*)selectedString
{
    NSEnumerator *e = [_objects objectEnumerator];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    ImageData *ob;
    
    CGFloat minimumRange = [self minimumRangeInString:selectedString];
    CGFloat maximumRange = [self maximumRangeInString:selectedString];
    
    while (ob = [e nextObject]) {
       if([ob.price floatValue] >= minimumRange && [ob.price floatValue] <= maximumRange)
       {
           [result addObject:ob];
       }
    }
    return result;

}


-(NSArray*)searchImagesWithDetail:(NSString*)selectedString
{
    NSEnumerator *e = [_objects objectEnumerator];
    NSMutableArray *result = [[NSMutableArray alloc] init];
    ImageData *ob;
    
    while (ob = [e nextObject]) {
        if ([ob.color rangeOfString:selectedString].location != NSNotFound) {
            [result addObject:ob];
            continue;
        }
        if ([ob.price rangeOfString:selectedString].location != NSNotFound) {
            [result addObject:ob];
            continue;
        }
        if ([ob.pattern rangeOfString:selectedString].location != NSNotFound) {
            [result addObject:ob];
            continue;
        }
        if ([ob.material rangeOfString:selectedString].location != NSNotFound) {
            [result addObject:ob];
            continue;
        }
        if ([ob.size rangeOfString:selectedString].location != NSNotFound) {
            [result addObject:ob];
            continue;
        }
        if ([ob.description rangeOfString:selectedString].location != NSNotFound) {
            [result addObject:ob];
            continue;
        }
        if ([ob.name rangeOfString:selectedString].location != NSNotFound) {
            [result addObject:ob];
            continue;
        }
    }
    return result;
}

@end
