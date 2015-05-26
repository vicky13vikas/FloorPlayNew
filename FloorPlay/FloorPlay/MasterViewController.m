//
//  MasterViewController.m
//  FloorPlay
//
//  Created by Vikas kumar on 12/08/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "UIImageCategories.h"
#import "ImagesDataSource.h"
#import "MainTableViewCell.h"
#import "FBCoreDataManager.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface MasterViewController () <UISearchBarDelegate>
{
    NSMutableArray *_objects;
    NSMutableArray *imageListToShow;
    BOOL isEditing;
    BOOL isSearchMode;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnEdit;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnShowAll;
- (IBAction)ShowAllTapped:(id)sender;
- (IBAction)btnEditTapped:(UITabBarItem*)sender;


@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor]}];

    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    imageListToShow = [[ImagesDataSource singleton] objects];
    
    [self.navigationItem setLeftBarButtonItem:nil];
    isEditing = NO;
    [[self tableView] setEditing:NO animated:YES];

    if(_datasource == DataSourceCustom)
    {
        self.navigationItem.hidesBackButton = NO;
        self.title = @"Custom";
    }
    else if(_datasource == DataSourceInventory)
    {
        self.navigationItem.hidesBackButton = YES;
        self.title = @"Inventory";
    }
    else if(_datasource == DataSourceOffline)
    {
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(btnEditTapped:)];
        [self.navigationItem setLeftBarButtonItem:editButton];
        
        _btnShowAll.enabled = NO;
        _btnEdit.enabled = YES;
        self.title = @"Offline Images";
    }

    [self.tableView reloadData];

    [self.detailViewController updateImage];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    UIImage *barImage = [UIImage imageWithImage:[UIImage imageNamed:@"Topbar.png"] scaledToSize:CGSizeMake(self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20)];
    
    [self.navigationController.navigationBar setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillHide) name:UIKeyboardDidHideNotification object:nil];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imageListToShow count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainTableViewCell" forIndexPath:indexPath];

    ImageData *image = [imageListToShow objectAtIndex:indexPath.row];

//    cell.imagePreview.imageURL = image.imageURLs[0];
    [cell.imagePreview setImageWithURL:image.imageURLs[0] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
        
    }];
    if (image.name) {
        cell.lblName.text = image.name;
    }
    
    if ([image.imageDescription isKindOfClass:[NSString class]]) {
        cell.lblDesc.text = image.imageDescription;
    }

    
    if(isEditing)
    {
        cell.showsReorderControl = YES;
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailViewController.image = imageListToShow[indexPath.row];
    [self.detailViewController updateImage];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [imageListToShow exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
    [[FBCoreDataManager sharedDataManager] swapImageAtIndex:sourceIndexPath.row+1 withImageAtIndex:destinationIndexPath.row+1];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma -mark Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ImageData *image = [imageListToShow objectAtIndex:indexPath.row];
        
        DetailViewController *vc = [segue destinationViewController];
        vc.image = image;
    }
}

-(void)selectionDoneInCategory:(CategoryType)category withString:(NSString *)selectedString
{
    NSArray* itemsInSelectedRange;
    if(category == kCategoryPrice)
    {
        itemsInSelectedRange = [[ImagesDataSource singleton] getItemsInPriceRange:selectedString];
    }
    else
    {
        itemsInSelectedRange = [[ImagesDataSource singleton] getImagesInCategory:category withValue:selectedString];
    }
    if(itemsInSelectedRange.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Floorplay" message:@"No Items found" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        imageListToShow = itemsInSelectedRange;
    }
    [self.tableView reloadData];

    _btnShowAll.enabled = YES;
    isSearchMode = YES;
    _btnEdit.enabled = NO;
    isEditing = NO;
    [[self tableView] setEditing:NO animated:YES];
}

#pragma -mark UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
    isSearchMode = YES;
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    if([self.searchBar.text isEqualToString:@""])
    {
        [self.searchBar resignFirstResponder];
        [self.searchBar setShowsCancelButton:NO animated:YES];
    }
    isSearchMode = NO;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if([searchText isEqualToString:@""])
    {
        [self ShowAllTapped:nil];
    }
    else
    {
        imageListToShow = [[ImagesDataSource singleton] searchImagesWithDetail:searchText];
        _btnShowAll.enabled = YES;
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [searchBar resignFirstResponder];
    [searchBar setText:nil];
    self.searchBar.showsCancelButton = NO;
    [self ShowAllTapped:nil];
}

-(void)KeyboardWillHide
{
    {
        for (UIView *view in self.searchBar.subviews)
        {
            for (id subview in view.subviews)
            {
                if ( [subview isKindOfClass:[UIButton class]] )
                {
                    [subview setEnabled:YES];
                    return;
                }
            }
        }
    }
}

#pragma -mark Orientaion

-(BOOL)shouldAutorotate{
    return  YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskLandscape;
}

-(IBAction)backTapped:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)ShowAllTapped:(id)sender
{
    imageListToShow = [[ImagesDataSource singleton] objects];
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
    [self.searchBar setText:nil];
    
    isSearchMode = NO;
    _btnEdit.enabled = YES;
    _btnShowAll.enabled = NO;
}

- (IBAction)btnEditTapped:(UIBarButtonItem* )sender
{
    if ([self.tableView isEditing])
    {
        isEditing = NO;
        [[self tableView] setEditing:NO animated:YES];
        sender.title = @"Edit";
    }
    else
    {
        isEditing = YES;
        [[self tableView] setEditing:YES animated:YES];
        sender.title = @"Done";
    }
}

@end
