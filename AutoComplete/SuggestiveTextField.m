//
//  SuggestiveTextField.m
//  SuggestiveTextField
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.wordpress.com . All rights reserved.
//

#import "SuggestiveTextField.h"

#define DEFAULT_TABLEVIEW_MAX_WIDTH 300.0
#define DEFAULT_TABLEVIEW_MAX_HEIGHT 300.0
#define DEFAULT_ROW_HEIGHT 30.0


@interface SuggestiveDelegate : NSObject <UITextFieldDelegate>
@property(weak) SuggestiveTextField *textField;
@end

@implementation SuggestiveDelegate

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
	
	[self.textField matchStrings:text];
	[self.textField showSuggestionTableView];
	
	return YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField
{
	[self.textField dismissSuggestionTableView];
	return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
	return YES;
}


@end



@interface SuggestiveTextField ()

@property(nonatomic, strong) NSArray *stringsArray;
@property(nonatomic, strong) NSArray *matchedStrings;
@property(nonatomic, strong) UITableViewController *controller;
@property (nonatomic, strong) SuggestiveDelegate *midDelegate;

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

  self.midDelegate = [SuggestiveDelegate new];
	self.midDelegate.textField = self;
	self.delegate = self.midDelegate;

  self.matchedStrings = [NSArray array];
  self.controller =
      [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
  _controller.tableView.delegate = self;
  _controller.tableView.dataSource = self;
  self.autocorrectionType = UITextAutocorrectionTypeNo;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
		self.popOver =
      [[UIPopoverController alloc] initWithContentViewController:_controller];
		// Default values
		_popOver.popoverContentSize = CGSizeMake(DEFAULT_TABLEVIEW_MAX_WIDTH, DEFAULT_TABLEVIEW_MAX_HEIGHT);
 }
	
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
	
   self.shouldHideOnSelection = YES;
	
}



- (void) dismissSuggestionTableView
{
	[_popOver dismissPopoverAnimated:YES];
	[self.controller.tableView removeFromSuperview];
	_isTableViewShown = NO;
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
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
		CGRect currentFrame = self.controller.tableView.frame;
		currentFrame.size.height = [self tableHeight];
		self.controller.tableView.frame = currentFrame;
	}
	else
	{
		[self setPopoverSize: CGSizeMake(DEFAULT_TABLEVIEW_MAX_WIDTH, [self tableHeight])];
	}
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
		if (!self.referenceView) { // if the reference view is not set, then it has the default window.
			self.referenceView = self.window;
		}
		CGPoint origin = [self.referenceView convertPoint:self.frame.origin fromView:self.superview];
		CGRect rect;
		rect.origin = CGPointMake(origin.x, origin.y + self.frame.size.height);
		rect.size = CGSizeMake(self.frame.size.width, [self tableHeight]);
		
		self.controller.tableView.frame = rect;
		[self.referenceView addSubview: self.controller.tableView];
		
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
		[self resignFirstResponder];
		
  }
}

@end
