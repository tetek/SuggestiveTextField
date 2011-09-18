//
//  SuggestionMenu.m
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://blog.idevs.pl . All rights reserved.
//

#import "SuggestionMenu.h"


@implementation SuggestionMenu
@synthesize sortedStringsArray, matchedStrings, popOver, activeTextField;
- (id)initWithSortedArray:(NSArray*)array
{
    self = [super init];
    if (self) {
        self.sortedStringsArray = array;
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:self];
        self.popOver.popoverContentSize = CGSizeMake(250, 260);
        self.matchedStrings = [NSArray array];
    }
    return self;
}
-(void)matchString:(NSString *)letters {
    if ( sortedStringsArray != nil ) {
        NSComparator comparator = ^(id obj1, id obj2) {    
            return [obj1 compare: obj2 options:NSCaseInsensitiveSearch range:NSMakeRange(0, [letters length]) locale:[NSLocale currentLocale] ];
        };
        int start = [sortedStringsArray indexOfObject:letters inSortedRange:NSMakeRange(0, [sortedStringsArray count]) options:NSBinarySearchingFirstEqual usingComparator:comparator];
        int end = [sortedStringsArray indexOfObject:letters inSortedRange:NSMakeRange(0, [sortedStringsArray count]) options:NSBinarySearchingLastEqual usingComparator:comparator];
        if (!(start > [sortedStringsArray count] || end > [sortedStringsArray count]))
            self.matchedStrings = [sortedStringsArray subarrayWithRange:NSMakeRange(start, end-start + 1)];
    }
    [self.tableView reloadData];
}
-(void)showPopOverListFor:(UITextField*)textField{
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionUp;
    if ([self.matchedStrings count] == 0) {
        [popOver dismissPopoverAnimated:YES];
    }
    else if(!popOver.isPopoverVisible){
            [popOver presentPopoverFromRect:textField.frame inView:textField.superview permittedArrowDirections:arrowDirection animated:YES];
        
    }
}
-(void)suggestForText:(NSString *)text inField:(UITextField*)field{
    [self matchString:text];
    [self showPopOverListFor:field];
    self.activeTextField = field;
}
- (void)dealloc
{
    [sortedStringsArray release];
    [matchedStrings release];
    [popOver release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.matchedStrings count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [self.matchedStrings objectAtIndex:indexPath.row];
    
    return cell;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.activeTextField setText:[self.matchedStrings objectAtIndex:indexPath.row]];
    [self.popOver dismissPopoverAnimated:YES];
}


@end
