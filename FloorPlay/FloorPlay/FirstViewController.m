//
//  FirstViewController.m
//  FloorPlay
//
//  Created by Vikas kumar on 16/08/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import "FirstViewController.h"
#import "Constants.h"
#import "UIViewControllerCategories.h"
#import "AFHTTPRequestOperation.h"
#import "ImagesDataParser.h"
#import "ImagesDataSource.h"
#import "FPAFNetworking.h"
#import "ProductMasterViewController.h"
#import "CustomDataSource.h"

@interface FirstViewController () <ProductMasterDelegate>

@property (nonatomic) NSInteger imageDownloadCount;
@property (nonatomic) DataSource dataSource;

@property (nonatomic, retain) NSMutableArray *imagesList;
@property (nonatomic, retain) NSMutableArray *bgImagesList;

- (IBAction)dateSourceSelected:(id)sender;
- (IBAction)offlineTapped:(id)sender;
- (IBAction)customTapped:(id)sender;
- (IBAction)inventoryTapped:(id)sender;

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
    
    _imageDownloadCount = 0;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dateSourceSelected:(id)sender
{

    if([[[_splitViewController.viewControllers objectAtIndex:0] viewControllers] count] == 2)
    {
        _master = (MasterViewController*)[[_splitViewController.viewControllers objectAtIndex:0] topViewController];
    }
        
    if(_dataSource == DataSourceCustom)
    {
        self.master.datasource = DataSourceCustom;
        [self dismissViewControllerAnimated:NO completion:^{
            [[_splitViewController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:NO];
        }];
        
    }
    else
    {
        self.master.datasource = DataSourceInventory;
        [self dismissViewControllerAnimated:NO completion:^{
            if([[[_splitViewController.viewControllers objectAtIndex:0] viewControllers] count] == 1)
            {
                [[_splitViewController.viewControllers objectAtIndex:0] pushViewController:_master animated:NO];
            }
        }];
    }
}

- (IBAction)offlineTapped:(id)sender
{
    
}

- (IBAction)customTapped:(id)sender
{
    _dataFrom = @"Custom";
    _dataSource = DataSourceCustom;
    [self fetchData:DataSourceCustom];
}

- (IBAction)inventoryTapped:(id)sender
{
    _dataSource = DataSourceInventory;
    [self fetchData:DataSourceInventory];
}

-(void) fetchData:(DataSource)source
{
    
    NSString *url;
    if(source == DataSourceInventory)
        url = [NSString stringWithFormat:@"api/getImage.php"];
    else
        url = [NSString stringWithFormat:@"api/getCustomProduct.php"];
    
    FPAFNetworking * client = [FPAFNetworking client];
    [client GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject)
     {
         if(_dataSource == DataSourceInventory)
            self.imagesList = [[NSMutableArray alloc] initWithArray:[ImagesDataParser parseImagesFromDict:(NSDictionary*)responseObject andCacheDataSource:YES]];
         else
             [[CustomDataSource sharedData] setDict:(NSDictionary*)responseObject];

         [self hideLoadingScreen];
         [self dateSourceSelected:nil];
         
     } failure:^(NSURLSessionDataTask *task, NSError *error)
     {
         [self showAlertWithMessage:[error localizedDescription] andTitle:@"Error"];
         [self hideLoadingScreen];
         
     }];
    
    [self showLoadingScreenWithMessage:@"Downloading..."];
}

#pragma -mark Orientaion

-(BOOL)shouldAutorotate{
    return  YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskLandscape;
}

#pragma mark - ProductMasterDelegate -

-(void)productMasterController:(ProductMasterViewController*) controller didSelectProduct:(FPProduct*)product
{
    self.imagesList = [NSMutableArray arrayWithArray:[product customProducts]];
    [[ImagesDataSource singleton] cacheData:self.imagesList];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
