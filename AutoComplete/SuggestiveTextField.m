//
//  SuggestiveTextField.m
//  SuggestiveTextField
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.wordpress.com . All rights reserved.
//

#import "SuggestiveTextField.h"

#define DEFAULT_POPOVER_SIZE CGSizeMake(300, 300)

@interface SuggestiveDelegate : NSObject <UITextFieldDelegate>
@property(weak) SuggestiveTextField *textField;
@end

@implementation SuggestiveDelegate

- (BOOL)shouldChangeTextInRange:(UITextRange *)range
                replacementText:(NSString *)text {
  return YES;
}
- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {

  NSMutableString *text = [NSMutableString stringWithString:textField.text];
  [text replaceCharactersInRange:range withString:string];

  [self.textField matchStrings:text];
  [self.textField showPopOverList];

  return YES;
}

@end

@interface SuggestiveTextField ()

@property(strong) NSArray *stringsArray;
@property(strong) NSArray *matchedStrings;
@property(strong) UIPopoverController *popOver;
@property(strong) UITableViewController *controller;

@property SuggestiveDelegate *midDelegate;

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
  self.popOver =
      [[UIPopoverController alloc] initWithContentViewController:_controller];

  // Default values
  _popOver.popoverContentSize = DEFAULT_POPOVER_SIZE;
  self.shouldHideOnSelection = YES;
}

#pragma mark - Modifiers

- (void)setSuggestions:(NSArray *)suggestionStrings {
  self.stringsArray = suggestionStrings;
}
- (void)setPopoverSize:(CGSize)size {
  self.popOver.popoverContentSize = size;
}

#pragma mark - Matching strings and Popover

- (void)matchStrings:(NSString *)letters {
  if (_stringsArray.count > 0) {

    self.matchedStrings = [_stringsArray
        filteredArrayUsingPredicate:
            [NSPredicate predicateWithFormat:@"self contains[cd] %@", letters]];
    [_controller.tableView reloadData];
  }
}

- (void)showPopOverList {

  if (_matchedStrings.count == 0) {
    [_popOver dismissPopoverAnimated:YES];
  } else if (!_popOver.isPopoverVisible) {
    [_popOver presentPopoverFromRect:self.frame
                              inView:self.superview
            permittedArrowDirections:UIPopoverArrowDirectionUp
                            animated:YES];
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
    [_popOver dismissPopoverAnimated:YES];
  }
}

@end
