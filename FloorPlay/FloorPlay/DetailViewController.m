//
//  DetailViewController.m
//  FloorPlay
//
//  Created by Vikas kumar on 12/08/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import "DetailViewController.h"
#import "FirstViewController.h"
#import "UIImageCategories.h"
#import "ImagesDataSource.h"
#import "FullScreenViewController.h"
#import "SearchCategoryViewController.h"
#import "SelectedCategoryViewController.h"
#import "MWPhotoBrowser.h"
#import "AGQuadControlViewController.h"
#import <AsyncImageView/AsyncImageView.h>
#import "FBCoreDataManager.h"
#import "UIViewControllerCategories.h"

@interface DetailViewController () <selectCategoryDelegate, UIPopoverControllerDelegate, MWPhotoBrowserDelegate>
{
    BOOL isAppearFirstTime;
    NSIndexPath *selectedIndexPath;
}

@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) UIPopoverController *popOverController;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet AsyncImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *filmStripCollection;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;
@property (weak, nonatomic) IBOutlet UIButton *btnPrevious;

@property (weak, nonatomic) IBOutlet UITextView *detailTextView;
- (IBAction)fullScreentapped:(id)sender;
- (IBAction)btnPreviousImage:(id)sender;
- (IBAction)btnNextImage:(id)sender;
- (IBAction)homeButtonTapped:(id)sender;
- (IBAction)virtualTryoutClicked:(id)sender;
- (IBAction)saveOfflineTapped:(id)sender;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _firstViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"FirstViewController"];
    _firstViewController.master = (MasterViewController*)[[[self.splitViewController.viewControllers objectAtIndex:0] viewControllers] objectAtIndex:1];
    _firstViewController.splitViewController = (UISplitViewController*)self.splitViewController;
    [self presentViewController:_firstViewController animated:NO completion:nil];
        
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [self.scrollView addGestureRecognizer:doubleTap];
    
    _imageView.crossfadeDuration = 0.0;
    isAppearFirstTime = YES;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    if(isAppearFirstTime)
//    {
        isAppearFirstTime = NO;
        self.image = [[[ImagesDataSource singleton] objects] firstObject];
//    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:20.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.0];
    label.textAlignment = NSTextAlignmentCenter;
    // ^-Use UITextAlignmentCenter for older SDKs.
    label.textColor = [UIColor whiteColor]; // change this color
    self.navigationItem.titleView = label;
    label.text = NSLocalizedString(@"Floor Play", @"");
    [label sizeToFit];
    
    UIImage *barImage = [UIImage imageWithImage:[UIImage imageNamed:@"Topbar.png"] scaledToSize:CGSizeMake(self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height+20)];
    
    [self.navigationController.navigationBar setBackgroundImage:barImage forBarMetrics:UIBarMetricsDefault];
    
    self.imageView.imageURL = _image.imageURLs[0];
    [self.filmStripCollection reloadData];
    [self setDescription];
    
    _filmStripCollection.allowsSelection = YES;
    
//    _imageView.layer.shadowColor = [UIColor blackColor].CGColor;
//    _imageView.layer.shadowOffset = CGSizeMake(0, 0);
//    _imageView.layer.shadowOpacity = 1.0;
//    _imageView.layer.shadowRadius = 3.0;
    
    if(selectedIndexPath.row <= 0)
    {
        [_btnPrevious setEnabled:NO];
    }
    if(self.image.imageURLs.count > 1)
    {
        _btnNext.enabled = YES;
    }
    else
    {
        _btnNext.enabled = NO;
    }
}

-(void)setDescription
{
    NSString *description = [NSString stringWithFormat:@"Name     : %@\nSize       : %@\nColor     : %@\nPattern   : %@\nPrice      : %@\nMaterial  : %@\nDescription : %@", self.image.name, self.image.size, self.image.color, self.image.pattern, self.image.price, self.image.material, self.image.imageDescription];
    [self.detailTextView setText:description];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


#pragma -mark UIScrollView delegates

-(UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    NSLog(@"Zoom Started");
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    NSLog(@"Zoom Will Begin");
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    NSLog(@"Zoom ends");
//    [self.scrollView setZoomScale:8.0];

}

-(void)doubleTapAction:(UIGestureRecognizer*)gesture
{
    if(self.scrollView.zoomScale == 1.0)
    {
        [self.scrollView setZoomScale:2.0];
    }
    else if(self.scrollView.zoomScale == 2.0)
        [self.scrollView setZoomScale:3.0];
    else
        [self.scrollView setZoomScale:4.0];
}

-(void)updateImage
{
    self.imageView.imageURL = self.image.imageURLs[0];
    selectedIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];

    [self.filmStripCollection reloadData];
    UICollectionViewCell *cell = [_filmStripCollection cellForItemAtIndexPath:selectedIndexPath];
    cell.backgroundColor = [UIColor blueColor];
    [self setDescription];
    self.scrollView.zoomScale = 1.0;
    
    if(selectedIndexPath.row <= 0)
    {
        [_btnPrevious setEnabled:NO];
    }
    if(self.image.imageURLs.count > 1)
    {
        _btnNext.enabled = YES;
    }
    else
    {
        _btnNext.enabled = NO;
    }
}

#pragma -mark UICollectionVew Delegates and datasource

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.image.imageURLs.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"flimStripCell" forIndexPath:indexPath];
    AsyncImageView * imageView = (AsyncImageView*)[cell viewWithTag:444];
    imageView.image = nil;
    imageView.imageURL = nil;
    imageView.crossfadeDuration = 0.0;
    
    imageView.imageURL = _image.imageURLs[indexPath.row];
    
    cell.backgroundColor = [UIColor whiteColor];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    self.imageView.imageURL = _image.imageURLs[indexPath.row];
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    self.scrollView.zoomScale = 1.0;
    selectedIndexPath = indexPath;
}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if(!self.popOverController)
        return YES;
    else
    {
        return NO;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"fullscreenViewController"])
    {
        FullScreenViewController   *vc = [segue destinationViewController];
        vc.image = self.imageView.image;
    }
    else if ([[segue identifier] isEqualToString:@"searchViewController"])
    {
        self.popOverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        self.popOverController.delegate = self;
        UINavigationController *navVC = [segue destinationViewController];
        SearchCategoryViewController   *vc = (SearchCategoryViewController*)[navVC topViewController];
        vc.masterTableViewController = (MasterViewController*)[[self.splitViewController.viewControllers objectAtIndex:0] topViewController];
        vc.detailViewController = self;
    }
}

-(void)selectionDoneInCategory:(CategoryType)category withString:(NSString *)selectedString
{
    [self.popOverController dismissPopoverAnimated:YES];
    self.popOverController = nil;
}

#pragma -mark UIPopOverDelegate

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return YES;
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.popOverController = nil;
}

#pragma -mark Orientaion

-(BOOL)shouldAutorotate{
    return  YES;
}

- (NSUInteger)supportedInterfaceOrientations{
    return  UIInterfaceOrientationMaskLandscape;
}

- (IBAction)fullScreentapped:(id)sender
{
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = YES;
    browser.wantsFullScreenLayout = NO;
    browser.zoomPhotosToFill = YES;
    [browser setCurrentPhotoIndex:0];

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];
}

-(void)deselectAllCells
{
    for(int i = 0; i < [_filmStripCollection numberOfItemsInSection:0]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:selectedIndexPath.section];
        UICollectionViewCell *cell = [_filmStripCollection cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor whiteColor];
    }
}
- (IBAction)btnPreviousImage:(UIButton*)sender
{
    [self deselectAllCells];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedIndexPath.row-1 inSection:selectedIndexPath.section];
    UICollectionViewCell *cell = [_filmStripCollection cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    
    selectedIndexPath = indexPath;

    self.imageView.imageURL = _image.imageURLs[indexPath.row];
    if(selectedIndexPath.row <= 0)
    {
        [sender setEnabled:NO];
    }
    if(self.image.imageURLs.count > 1)
    {
        _btnNext.enabled = YES;
    }
    else
    {
        _btnNext.enabled = NO;
    }
}

- (IBAction)btnNextImage:(id)sender
{
    [self deselectAllCells];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:selectedIndexPath.row+1 inSection:selectedIndexPath.section];
    UICollectionViewCell *cell = [_filmStripCollection cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    
    selectedIndexPath = indexPath;
    
    self.imageView.imageURL = _image.imageURLs[indexPath.row];
    if(selectedIndexPath.row >= self.image.imageURLs.count - 1)
    {
        [sender setEnabled:NO];
    }
    if(self.image.imageURLs.count > 1)
    {
        _btnPrevious.enabled = YES;
    }
    else
    {
        _btnPrevious.enabled = NO;
    }
}

- (IBAction)homeButtonTapped:(id)sender
{
    [self presentViewController:_firstViewController animated:NO completion:nil];
}

- (IBAction)virtualTryoutClicked:(id)sender
{
    AGQuadControlViewController *vc = [[self storyboard] instantiateViewControllerWithIdentifier:@"AGQuadControlViewController"];
    vc.image = _imageView.image;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)saveOfflineTapped:(id)sender
{
    [self showLoadingScreenWithMessage:@"Saving Images..."];
    [[FBCoreDataManager sharedDataManager] saveImageData:self.image withCompletionHandler:^(bool success) {
        if(success)
            [self hideLoadingScreen];
    }];
}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _image.imageURLs.count;
}

- (MWPhoto *)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _image.imageURLs.count)
    {
        MWPhoto *photo = [MWPhoto photoWithURL:_image.imageURLs[index]];
        return photo;   
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index
{
    
}

@end
