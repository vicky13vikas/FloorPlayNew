//
//  FullScreenViewController.m
//  FloorPlay
//
//  Created by Vikas kumar on 17/11/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import "FullScreenViewController.h"

@interface FullScreenViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *doneButon;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)doneButtonClicked:(id)sender;
- (IBAction)singleTapGesture:(id)sender;

@end

@implementation FullScreenViewController

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
    
    self.imageView.image = self.image;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [self.scrollView addGestureRecognizer:doubleTap];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)doneButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
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
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    if(self.scrollView.zoomScale == 1.0)
        [self.scrollView setZoomScale:2.0];
    else if(self.scrollView.zoomScale == 2.0)
        [self.scrollView setZoomScale:3.0];
    else
        [self.scrollView setZoomScale:4.0];
}

-(void)takeSingleTap
{
    self.doneButon.hidden = NO;
    [self.doneButon performSelector:@selector(setHidden:) withObject:[NSNumber numberWithBool:YES] afterDelay:3];
}

- (IBAction)singleTapGesture:(id)sender
{
    [self performSelector:@selector(takeSingleTap) withObject:Nil afterDelay:0.5];
}


@end
