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

#define HEADER_HEIGHT 30

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
    
    self.title = @"Products";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
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
    [header setBackgroundColor:[UIColor lightGrayColor]];
    
    UILabel * headerTitle = [[UILabel alloc] init];
    [headerTitle setTextAlignment:NSTextAlignmentCenter];
    [headerTitle setText:NSLocalizedString(@"SELECT ANY CUSTOM PRODUCT", nil)];
    [headerTitle setTextColor:[UIColor blackColor]];
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
    cell.detailTextLabel.text= product.productDescription;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FPProduct *product = _productsList[indexPath.row];
     [[ImagesDataSource singleton] cacheData:[product customProducts]];
    
    MasterViewController *vc= [self.storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    vc.datasource = DataSourceCustom;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
