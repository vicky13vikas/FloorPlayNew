//
//  ProductMasterViewController.m
//  FloorPlay
//
//  Created by Vikas Kumar on 06/07/14.
//  Copyright (c) 2014 Vikas Kumar. All rights reserved.
//

#import "ProductMasterViewController.h"
#import "CustomDataSource.h"
#import "MasterViewController.h"
#import "ImagesDataSource.h"

#define HEADER_HEIGHT 50

@interface ProductMasterViewController ()
{
    NSMutableArray *_productsList;
}

@end

@implementation ProductMasterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _productsList = [NSMutableArray arrayWithArray:[[CustomDataSource sharedData] getProductMasterList]];
    
    MasterViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    [self.navigationController pushViewController:vc animated:NO];
    
    self.title = @"PRODUCTS";
}

-(void)viewWillAppear:(BOOL)animated
{
    _productsList = [NSMutableArray arrayWithArray:[[CustomDataSource sharedData] getProductMasterList]];
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _productsList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * header = nil;
    
    header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), HEADER_HEIGHT)];
    [header setBackgroundColor:[UIColor colorWithRed:30.0/255.0 green:35.0/255.0 blue:54.0/255.0 alpha:1]];
    
    UILabel * headerTitle = [[UILabel alloc] init];
    [headerTitle setTextAlignment:NSTextAlignmentCenter];
    [headerTitle setText:NSLocalizedString(@"SELECT ANY CUSTOM PRODUCT", nil)];
    [headerTitle setTextColor:[UIColor whiteColor]];
    [headerTitle setFont:[UIFont systemFontOfSize:12]];
    [header addSubview:headerTitle];
    [headerTitle setFrame:CGRectMake(0, 0, CGRectGetWidth(tableView.frame), HEADER_HEIGHT)];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProductMasterCell" forIndexPath:indexPath];
    
    FPProduct *product = _productsList[indexPath.row];
    cell.textLabel.text = product.name;
    cell.detailTextLabel.text= product.description;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [self dismissViewControllerAnimated:NO completion:^{
//        FPProduct *product = _productsList[indexPath.row];
//        
//        if(_productMasterDelegate && [_productMasterDelegate respondsToSelector:@selector(productMasterController:didSelectProduct:)])
//        {
//            [_productMasterDelegate productMasterController:self didSelectProduct:product];
//        }
//    }];
    
    FPProduct *product = _productsList[indexPath.row];
     [[ImagesDataSource singleton] cacheData:[product customProducts]];
    
    MasterViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    vc.isCustom = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
