//
//  SelectedCategoryViewController.m
//  FloorPlay
//
//  Created by Vikas kumar on 14/12/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import "SelectedCategoryViewController.h"
#import "ImagesDataSource.h"

@interface SelectedCategoryViewController ()

@property(nonatomic, retain) NSArray *itemsInCategory;

@end

@implementation SelectedCategoryViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = [self getTitle];
    [self initiateWithItemscategory];
}

-(void)initiateWithItemscategory
{
    switch (self.categoryType) {
        case kCategoryColor:
            self.itemsInCategory = [[NSArray alloc] initWithArray:[[ImagesDataSource singleton] getAvailableColors]];
            break;
        case kCategoryPrice:
//            self.itemsInCategory = [[NSArray alloc] initWithArray:[[ImagesDataSource singleton] getAvailablePrice]];
            self.itemsInCategory = kPriceRange;
            break;
        case kCategoryPattern:
            self.itemsInCategory = [[NSArray alloc] initWithArray:[[ImagesDataSource singleton] getAvailablePattern]];
            break;
        case kCategoryMaterial:
            self.itemsInCategory = [[NSArray alloc] initWithArray:[[ImagesDataSource singleton] getAvailableMaterial]];
            break;
        case kCategorySize:
            self.itemsInCategory = [[NSArray alloc] initWithArray:[[ImagesDataSource singleton] getAvailableSize]];
            break;
        default:
            break;
    }
}

-(NSString*)getTitle
{
    switch (self.categoryType) {
        case kCategoryColor:
            return @"Select Color";
            break;
        case kCategoryPrice:
            return @"Select Price";
            break;
        case kCategoryPattern:
            return @"Select Pattern";
            break;
        case kCategoryMaterial:
            return @"Select Material";
            break;
        case kCategorySize:
            return @"Select Size";
            break;
        default:
            break;
    }
    return @"";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.itemsInCategory.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.itemsInCategory  objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedString = [self.itemsInCategory objectAtIndex:indexPath.row];
    [self.materTableDelegate selectionDoneInCategory:self.categoryType withString:selectedString];
    [self.detailControllerDelegate selectionDoneInCategory:self.categoryType withString:selectedString];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
