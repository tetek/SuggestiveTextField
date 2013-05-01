//
//  SuggestionMenu.m
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.me . All rights reserved.
//

#import "SuggestionsList.h"

#define POPOVER_WIDTH 250
#define POPOVER_HEIGHT 260

@implementation SuggestionsList

@synthesize stringsArray = _stringsArray;
@synthesize  matchedStrings = _matchedStrings;
@synthesize popOver = _popOver;
@synthesize activeTextField = _activeTextField;

- (id)initWithArray:(NSArray*)array
{
    self = [super init];
    if (self) {
        
        self.stringsArray = array;
        self.matchedStrings = [NSArray array];
        
        //Initializing PopOver
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:self];
        self.popOver.popoverContentSize = CGSizeMake(POPOVER_WIDTH, POPOVER_HEIGHT);
    }
    return self;
}
#pragma mark Main Suggestions Methods
-(void)matchString:(NSString *)letters {
    self.matchedStrings = nil;
    
    if (_stringsArray == nil) {
        @throw [NSException exceptionWithName:@"Please set an array to stringsArray" reason:@"No array specified" userInfo:nil];
    }
    
    self.matchedStrings = [_stringsArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self contains[cd] %@",letters]];
    [self.tableView reloadData];
}

-(void)showPopOverListFor:(UITextField*)textField{
    UIPopoverArrowDirection arrowDirection = UIPopoverArrowDirectionUp;
    if ([self.matchedStrings count] == 0) {
        [_popOver dismissPopoverAnimated:YES];
    }
    else if(!_popOver.isPopoverVisible){
        [_popOver presentPopoverFromRect:textField.frame inView:textField.superview permittedArrowDirections:arrowDirection animated:YES];
        
    }
}
-(void)showSuggestionsFor:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSMutableString *rightText;
    
    if (textField.text) {
        rightText = [NSMutableString stringWithString:textField.text];
        [rightText replaceCharactersInRange:range withString:string];
    }
    else {
        rightText = [NSMutableString stringWithString:string];
    }
    
    [self matchString:rightText];
    [self showPopOverListFor:textField];
    self.activeTextField = textField;
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.textLabel.text = [self.matchedStrings objectAtIndex:indexPath.row];
    
    return cell;
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.activeTextField setText:[self.matchedStrings objectAtIndex:indexPath.row]];
    [self.popOver dismissPopoverAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

@end
