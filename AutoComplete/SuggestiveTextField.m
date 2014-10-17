//
//  SuggestiveTextField.m
//  SuggestiveTextField
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.wordpress.com . All rights reserved.
//

#import "SuggestiveTextField.h"

#define DEFAULT_POPOVER_SIZE CGSizeMake(300, 300)
#define DEFAULT_TABLEVIEW_MAX_HEIGHT 300.0
#define DEFAULT_ROW_HEIGHT 30.0


@interface SuggestiveTextField ()

@property(nonatomic, strong) NSArray *stringsArray;
@property(nonatomic, strong) NSArray *matchedStrings;
@property(nonatomic, strong) UITableViewController *controller;

// ipad
@property(nonatomic, strong) UIPopoverController *popOver;

// iphone
@property (nonatomic) BOOL isTableViewShown;

@end

@implementation SuggestiveTextField

#pragma mark - Setup

- (id)initWithCoder:(NSCoder *)aDecoder {

  if ((self = [super initWithCoder:aDecoder])) {
    [self setup];
  }
  return self;
}
- (id)initWithFrame:(CGRect)frame {

  if ((self = [super initWithFrame:frame])) {
    [self setup];
  }
  return self;
}
- (id)init {

  if ((self = [super init])) {
    [self setup];
  }
  return self;
}

- (void)setup {

  self.delegate = self;

  self.matchedStrings = [NSArray array];
  self.controller =
      [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
  _controller.tableView.delegate = self;
  _controller.tableView.dataSource = self;
  self.autocorrectionType = UITextAutocorrectionTypeNo;
  self.popOver =
      [[UIPopoverController alloc] initWithContentViewController:_controller];
	
	// Table view configs
	self.controller.tableView.backgroundColor = [UIColor whiteColor];
	self.controller.tableView.layer.cornerRadius = 5;
	self.controller.tableView.layer.borderWidth = 0.2;
	self.controller.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
	self.controller.tableView.bounces = YES;
	self.controller.tableView.alwaysBounceVertical = YES;
	self.controller.tableView.showsVerticalScrollIndicator = YES;
	self.controller.tableView.showsHorizontalScrollIndicator = NO;
	self.controller.tableView.rowHeight = DEFAULT_ROW_HEIGHT;
	self.controller.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; // Hide the unnecessary separator lines
	_isTableViewShown = NO;
	
  // Default values
  _popOver.popoverContentSize = DEFAULT_POPOVER_SIZE;
  self.shouldHideOnSelection = YES;
	
}


#pragma mark - TextField delegates

- (BOOL)shouldChangeTextInRange:(UITextRange *)range
								replacementText:(NSString *)text
{
	return YES;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
	
	NSMutableString *text = [NSMutableString stringWithString:textField.text];
	[text replaceCharactersInRange:range withString:string];
	
	[self matchStrings:text];
	[self showSuggestionTableView];
	
	return YES;
}

- (void) dismissSuggestionTableView
{
	[_popOver dismissPopoverAnimated:YES];
	[self.controller.tableView removeFromSuperview];
	_isTableViewShown = NO;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	[self dismissSuggestionTableView];
	return YES;
}

#pragma mark - Modifiers

- (void)setSuggestions:(NSArray *)suggestionStrings {
  self.stringsArray = suggestionStrings;
}
- (void)setPopoverSize:(CGSize)size {
  self.popOver.popoverContentSize = size;
}

#pragma mark - Matching strings and Popover

- (CGFloat)tableHeight
{
	return [self.matchedStrings count] * DEFAULT_ROW_HEIGHT > DEFAULT_TABLEVIEW_MAX_HEIGHT ? DEFAULT_TABLEVIEW_MAX_HEIGHT : [self.matchedStrings count] * DEFAULT_ROW_HEIGHT;
}

- (void)updateTableViewFrameHeight
{
	CGRect currentFrame = self.controller.tableView.frame;
	currentFrame.size.height = [self tableHeight];
	self.controller.tableView.frame = currentFrame;
}

- (void)matchStrings:(NSString *)letters {
  if (_stringsArray.count > 0) {

    self.matchedStrings = [_stringsArray
        filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat:@"self contains[cd] %@", letters]];
    [_controller.tableView reloadData];

		[self updateTableViewFrameHeight];
  }
}

- (void)showSuggestionTableView {
	if (_matchedStrings.count == 0)
	{
		[self dismissSuggestionTableView];
	}
	else if (!_popOver.isPopoverVisible && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) 	{
			[_popOver presentPopoverFromRect:self.frame
																inView:self.superview
							permittedArrowDirections:UIPopoverArrowDirectionUp
															animated:YES];
	}
	else if (!_isTableViewShown && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
	{
		CGRect rect;
		rect.origin = CGPointMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height);
		rect.size = CGSizeMake(self.frame.size.width, [self tableHeight]);
		self.controller.tableView.frame = rect;
		[self.window addSubview: self.controller.tableView];
		_isTableViewShown = YES;
	}
}

#pragma mark - TableView Delegate & DataSource

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return _matchedStrings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Cell";

  UITableViewCell *cell =
      [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CellIdentifier];
  }

  cell.textLabel.text = [_matchedStrings objectAtIndex:indexPath.row];

  return cell;
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [self setText:[_matchedStrings objectAtIndex:indexPath.row]];
  if (_shouldHideOnSelection) {
		[self dismissSuggestionTableView];
  }
}

@end
