//
//  SearchCategoryViewController.m
//  FloorPlay
//
//  Created by Vikas kumar on 06/12/13.
//  Copyright (c) 2013 Vikas kumar. All rights reserved.
//

#import "SearchCategoryViewController.h"
#import "ImagesDataSource.h"
#import "Constants.h"
#import "SelectedCategoryViewController.h"

@interface SearchCategoryViewController (){
    NSArray         *categories;
}

@end

@implementation SearchCategoryViewController

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

    categories = [[NSArray alloc] initWithObjects:@"By Color", @"By Size", @"By Pattern", @"By Material", @"By Price", nil];
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
   return categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [categories objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    return cell;
}

-(CategoryType)selectedCategoryAtRow:(NSInteger)row
{
    switch (row) {
        case 0:
            return kCategoryColor;
            break;
        case 1:
            return kCategorySize;
            break;
        case 2:
            return kCategoryPattern;
            break;
        case 3:
            return kCategoryMaterial;
            break;
        case 4:
            return kCategoryPrice;
            break;
        case 5:
            return kCategoryColor;
            break;
        default:
            break;
    }
    return kCategoryOther;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectedCategoryViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectedCategoryViewController"];
    vc.categoryType = [self selectedCategoryAtRow:indexPath.row];
    vc.materTableDelegate = self.masterTableViewController;
    vc.detailControllerDelegate = self.detailViewController;
    [self.navigationController pushViewController:vc animated:YES];
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
