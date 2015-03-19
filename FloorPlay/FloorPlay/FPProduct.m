//
//  FPProduct.m
//  FloorPlay
//
//  Created by Vikas Kumar on 06/07/14.
//  Copyright (c) 2014 Vikas Kumar. All rights reserved.
//

#import "FPProduct.h"
#import "ImageData.h"
#import "Constants.h"

@implementation FPProduct

- (instancetype)initWithAttributes:(NSArray *)productData
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSDictionary *productEntry in productData)
    {
        if (!_productID)
        {
            _productID          = [productEntry valueForKeyPath:@"product_id"];
            _name               = [productEntry valueForKeyPath:@"product_name"];
            _productDescription        = [productEntry valueForKeyPath:@"desciption"];
            _folderName         = [productEntry valueForKeyPath:@"folder_name"];
        }
        
        
        NSMutableArray *imageURLs = [[NSMutableArray alloc] init];
        for (int i=0; i < RELATIVE_IMAGES_COUNT; i++)
        {
            NSString *img = [productEntry objectForKey:[NSString stringWithFormat:@"image%d",i+1]];
            if(![img isKindOfClass:[NSNull class]])
            {
                if ([img length] > 0)
                {
                    NSString *imageString = [NSString stringWithFormat:@"%@data/customProduct/%@/%@",SERVER_URL, _folderName, img];
                    NSURL *imageURL = [NSURL URLWithString:[imageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    [imageURLs addObject:imageURL];
                }
            }
        }
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterFullStyle];
        [dateFormatter setDateFormat:@"h:mm a EEE, MMM d, yyyy"];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        
        NSDate *createdDate = [dateFormatter dateFromString:[productEntry objectForKey:@"created_date"]];
        
        ImageData *image = [[ImageData alloc] initWithID:[productEntry valueForKeyPath:@"id"]
                                                    name:[productEntry valueForKeyPath:@"name"]
                                             description:[productEntry valueForKeyPath:@"desc"]
                                                    size:[productEntry valueForKeyPath:@"size"]
                                                   color:[productEntry valueForKeyPath:@"color"]
                                                 pattern:[productEntry valueForKeyPath:@"Pattern"]
                                                material:[productEntry valueForKeyPath:@"material"]
                                                   price:[productEntry valueForKeyPath:@"price"]
                                             createdDate:createdDate
                                              imagesURLs:imageURLs];
        
        [temp addObject:image];
        
    }
    
    _customProducts = [NSArray arrayWithArray:temp];
    return self;

}

@end
