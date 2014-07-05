//
//  FirstViewController.m
//  FloorPlay
//
//  Created by Vikas kumar on 16/08/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import "FirstViewController.h"
#import "Constants.h"
//#import "AFHTTPClient.h"
#import "UIViewControllerCategories.h"
#import "AFHTTPRequestOperation.h"
#import "ImagesDataParser.h"
#import "ImagesDataSource.h"
#import "FPAFNetworking.h"

@interface FirstViewController ()

@property (nonatomic) NSInteger processCount;
@property (nonatomic) NSInteger processCountBG;

@property (nonatomic, retain) NSMutableArray *imagesList;
@property (nonatomic, retain) NSMutableArray *bgImagesList;

- (IBAction)dateSourceSelected:(id)sender;
- (IBAction)updateTapped:(id)sender;

@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(![[[FloorPlayServices singleton] preferences] objectForKey:IS_FIRST_TIME_LAUNCH])
    {
        [self downloadImagesListFirstTime];
        [self downloadBackgroundImages];
    }
    else
    {
        [self loadDataFromSavedJson];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateSourceSelected:(id)sender
{
    _dataFrom = [sender restorationIdentifier];
    
    if([_dataFrom isEqualToString:@"Custom"])
    {
        self.master.isCustom = YES;
    }
    else
        self.master.isCustom = NO;
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)updateTapped:(id)sender
{
    [self downloadImagesListFirstTime];
    [self downloadBackgroundImages];
}



-(void)downloadImagesListFirstTime
{
    NSString *url = [NSString stringWithFormat:@"api/getImage.php"];
    
    FPAFNetworking * client = [FPAFNetworking client];    
    [client GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
    {
        [self saveJsonData:responseObject];
        [self loadDataFromSavedJson];
        [self downloadInventoryImages];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error)
    {
        [self showAlertWithMessage:[error localizedDescription] andTitle:@"Error"];
        [self hideLoadingScreen];

    }];
    
    [self showLoadingScreenWithMessage:@"Downloading..."];
}


-(void)downloadBackgroundImages
{
    NSString *url = [NSString stringWithFormat:@"getBackgroundImage.php"];
    
    FPAFNetworking * client = [FPAFNetworking client];
    [client GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         [self saveBackgroundJsonData:responseObject];
         [self loadDataFromSavedJsonBGList];
         [self downloadAllImagesBG];
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self showAlertWithMessage:[error localizedDescription] andTitle:@"Error"];
         [self hideLoadingScreen];
     }];
    
    [self showLoadingScreenWithMessage:@"Downloading..."];

    
}

-(void)saveJsonData:(NSData*)data
{
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentDirPath = [documentDirPath stringByAppendingString:@"/"];
    documentDirPath = [documentDirPath stringByAppendingString:SAVED_JSON_FILE];
    
    [data writeToFile:documentDirPath atomically:YES];
    
    [[[FloorPlayServices singleton] preferences] setObject:@"YES" forKey:IS_FIRST_TIME_LAUNCH];
}

-(void)saveBackgroundJsonData:(NSData*)data
{
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentDirPath = [documentDirPath stringByAppendingString:@"/"];
    documentDirPath = [documentDirPath stringByAppendingString:SAVED_BG_IMAGES_JSON_FILE];
    
    [[NSFileManager defaultManager] createFileAtPath:documentDirPath contents:data attributes:nil];
    
}

-(void)loadDataFromSavedJson
{
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentDirPath = [documentDirPath stringByAppendingString:@"/"];
    documentDirPath = [documentDirPath stringByAppendingString:SAVED_JSON_FILE];
    
    NSData *data = [NSData dataWithContentsOfFile:documentDirPath];
    if (data)
        self.imagesList = [[NSMutableArray alloc] initWithArray:[ImagesDataParser parseImagesFromData:data andCacheDataSource:YES]];
}

-(void)loadDataFromSavedJsonBGList
{
    NSString *documentDirPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentDirPath = [documentDirPath stringByAppendingString:@"/"];
    documentDirPath = [documentDirPath stringByAppendingString:SAVED_BG_IMAGES_JSON_FILE];
    
    NSData *data = [NSData dataWithContentsOfFile:documentDirPath];
    if (data)
    {
        NSError *error = nil;
        self.bgImagesList = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
;
}


-(void)downloadInventoryImages
{
    for (ImageData *image in self.imagesList)
    {
        for (NSString *imageName in image.imagesList)
        {
            if(imageName.length > 0)
            {
                [self downloadImageNamed:imageName];
            }
        }
    }
}

-(void)downloadImageNamed:(NSString*)imageName
{
        NSString *url = [[NSString stringWithFormat:@"data/images/%@", imageName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        FPAFNetworking *client = [FPAFNetworking imageDownloadClient];
        
        [client GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
        {
            [self saveImage:responseObject forURL:task.response.URL];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error);
        }];
        
        [self showLoadingScreenWithMessage:@"Downloading Images..."];
}

- (void)saveImage:(UIImage*)image forURL:(NSURL*)url
{
    NSArray *dirPathSearch = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = [dirPathSearch objectAtIndex:0];
    NSString *dirPath = [docDirPath stringByAppendingPathComponent:@"Images/"];
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:dirPath])
    {
        if (![fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error])
            NSLog(@"errormsg:%@", [error description]);
    }
    
    
    NSString *filePath = [dirPath stringByAppendingPathComponent:[url lastPathComponent]];
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

-(void)downloadAllImagesBG
{
    NSArray *dirPathSearch = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirPath = [dirPathSearch objectAtIndex:0];
    NSString *dirPath = [docDirPath stringByAppendingPathComponent:@"BGImages/"];
    
    // if the sub directory does not exist, create it
    NSError *error = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:dirPath])
    {
        NSLog(@"%@: does not exists...will attempt to create", dirPath);
        
        if (![fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error])
            NSLog(@"errormsg:%@", [error description]);
    }
 
    self.processCountBG = 0;
    
    for (int i = 0; i < _bgImagesList.count; i++)
    {
        NSString *urlPath = _bgImagesList[i];
        //        urlPath = [urlPath stringByReplacingOccurrencesOfString:@"jpeg" withString:@"jpg"];
        NSString *filePath = [dirPath stringByAppendingPathComponent:[(NSString*)_bgImagesList[i] lastPathComponent]];
        
        // download the song file and save them directly to docdir
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlPath]];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             self.processCountBG++;
             NSLog(@"File :%d Success!", _processCountBG);
             
             // all the files have been saved, now update the playlist
             if (self.processCountBG == [_bgImagesList count])
             {
                 [self hideLoadingScreen];
                 [[ImagesDataSource singleton] update];
             }
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error)
         {
             self.processCountBG++;
             NSLog(@"ERROR ERROR ERROR:%@ - could not save to path:%@", error, filePath);
             if (self.processCountBG == [_bgImagesList count])
             {
                 [self hideLoadingScreen];
             }
         } ];
        [self showLoadingScreenWithMessage:@"Downloading Images..."];
        [operation start];
        
    }

}

#pragma -mark Orientaion

-(BOOL)shouldAutorotate{
    return  YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskLandscape;
}


@end
