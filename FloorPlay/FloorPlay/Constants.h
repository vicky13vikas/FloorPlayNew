//
//  Constants.h
//  FloorPlay
//
//  Created by Vikas kumar on 28/09/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//


#define IS_FIRST_TIME_LAUNCH @"isAppLauchedFirstTime"

//#define SERVER_URL @"http://sysbiam.com//ImageMSys/api/"
#define SERVER_URL @"http://floorplayrugs.com/ImageSrc/"

//#define SERVER_URL_FOR_FILE @"http://www.sysbiam.com//ImageMSys/images/"

//#define SERVER_URL_FOR_FILE @"http://www.sysbiam.com/ImageSrc/data/images/"

//#define SERVER_URL_FOR_FILE @"http://www.mobiminds.co.in/ImageSrc/data/images/"
#define SERVER_URL_FOR_FILE @"http://floorplayrugs.com/ImageSrc/data/images/"




#define RELATIVE_IMAGES_COUNT 4

#define SAVED_JSON_FILE @"JsonData.plist"
#define SAVED_JSON_PRODUCT_MASTER @"ProductMaster.plist"
#define SAVED_BG_IMAGES_JSON_FILE @"BGImagesJsonData.plist"

#define kCategories @[@"By Color", @"By Size", @"By Pattern", @"By Material", @"By Price"]

#define kPriceRange @[@"Below 10,000", @"10,001 to 25,000", @"25,001 to 45,000", @"45,001 to 90,000", @"Greater than 90,000"]


typedef NS_ENUM(NSInteger, DataSource)
{
    DataSourceInventory,
    DataSourceCustom
};

typedef enum {
    kCategoryColor = 0,
    kCategorySize = 1,
    kCategoryPattern = 2,
    kCategoryMaterial = 3,
    kCategoryPrice = 4,
    kCategoryOther =5
}CategoryType;