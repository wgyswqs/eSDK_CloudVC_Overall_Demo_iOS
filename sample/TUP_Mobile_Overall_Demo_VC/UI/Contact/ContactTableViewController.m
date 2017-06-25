//
//  ContactTableViewController.m
//  TUP_Mobile_Overall_Demo_VC
//
//  Created by swx326173 on 2017/4/6.
//  Copyright © 2017年 esdk. All rights reserved.
//

#import "ContactTableViewController.h"
#import "UIUtils.h"
#import "ContactViewController.h"

@interface ContactTableViewController ()<UISearchDisplayDelegate,UISearchBarDelegate>
{
    NSMutableArray *_searchContacts;
    NSMutableArray *_contacts;
    NSMutableArray *_records;
    UISegmentedControl *_segment;
    BOOL _canLoadMore;
}

@end

@implementation ContactTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _segment =[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Contact",@"Record", nil ]];
    _segment.selectedSegmentIndex = 0;
    [_segment addTarget:self action:@selector(segmentChange) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _segment;
    
    _searchContacts = [[NSMutableArray alloc] init];
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}

-(void)segmentChange
{
    if (_segment.selectedSegmentIndex == 0)
    {
        if (_contacts != nil)
        {
            [_contacts removeAllObjects];
        }
        _contacts = [NSMutableArray arrayWithArray:[[TupContactsSDK sharedInstance] getAllLocalContacts]];
    }
    else
    {
        if (_records != nil)
        {
            [_records removeAllObjects];
        }
        _records =  [NSMutableArray arrayWithArray:[[TupContactsSDK sharedInstance] getAllCallRecords]];
    }
    [self.tableView reloadData];
}

-(void)addContact
{
    NSLog(@"addContact");
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    ContactViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
    viewController.flag = 0;
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)searchLdap:(NSString *)keywords isClear:(BOOL)isClear
{
    ContactsErrorId error =[[TupContactsSDK sharedInstance] searchLdapContact:keywords
                                                                isClearCookie:isClear
                                                            searchResultBlock:^(BOOL result, BOOL canLoadMore, NSArray *resultArray)
                            {
                                if (result)
                                {
                                    [_searchContacts addObjectsFromArray:resultArray];
                                    _canLoadMore = canLoadMore;
                                    NSLog(@"_searchContacts = %@",_searchContacts);
                                    //refersh UI
                                    [[self.searchDisplayController searchResultsTableView] reloadData];
                                }
                                else
                                {
                                    NSLog(@"search result is nil");
                                    [UIUtils showAlert:@"search result is nil"];
                                }
                                
                            }];
    
    NSLog(@"searchLdap error %u",error);
}

-(void)viewWillAppear:(BOOL)animated
{
    [self segmentChange];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //#warning Incomplete implementation, return the number of sections
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //#warning Incomplete implementation, return the number of rows
    
    if (self.searchDisplayController.searchResultsTableView == tableView)
    {
        return _searchContacts.count;
    }
    
    if (_segment.selectedSegmentIndex == 0 && _contacts != nil)
    {
        return _contacts.count;
    }
    else if (_segment.selectedSegmentIndex == 1 && _records != nil)
    {
        return _records.count;
    }
    
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchDisplayController.searchResultsTableView == tableView)
    {
        return;
    }
    if (_segment.selectedSegmentIndex == 0)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        ContactViewController *viewController = [mainStoryboard instantiateViewControllerWithIdentifier:@"ContactViewController"];
        viewController.flag = 1;
        viewController.contact = [_contacts objectAtIndex:indexPath.row];
        [self presentViewController:viewController animated:YES completion:nil];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cellIdentifier"];
    }
    
    // Configure the cell...
    if (self.searchDisplayController.searchResultsTableView == tableView)
    {
        cell.textLabel.text = ((TupContact *)[_searchContacts objectAtIndex:indexPath.row]).name;
    }
    else if (_segment.selectedSegmentIndex == 0)
    {
        indexPath.row < [_contacts count] ? cell.textLabel.text = ((TupContact *)[_contacts objectAtIndex:indexPath.row]).name:cell.textLabel.text;
    }
    else if (_segment.selectedSegmentIndex == 1)
    {
        indexPath.row < [_records count] ?cell.textLabel.text = ((TupHistory *)[_records objectAtIndex:indexPath.row]).phoneNumber:cell.textLabel.text;
    }
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        ContactsErrorId result = ContactsSuccess;
        if (_segment.selectedSegmentIndex == 0)
        {
            result = [[TupContactsSDK sharedInstance] delLocalContact:[_contacts objectAtIndex:indexPath.row]];
            
            NSLog(@"delLocalContact result :%d",result);
            if (result == 0)
            {
                [_contacts removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        else if (_segment.selectedSegmentIndex == 1)
        {
            
            result = [[TupContactsSDK sharedInstance] delCallRecord:[_records objectAtIndex:indexPath.row]];
            
            NSLog(@"delLocalContact result :%d",result);
            if (result == 0)
            {
                [_records removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

#pragma searchbardelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"searchBarSearchButtonClicked");
    [_searchContacts removeAllObjects];
    [[self.searchDisplayController searchResultsTableView] reloadData];
    [self searchLdap:searchBar.text isClear:YES];
}


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
