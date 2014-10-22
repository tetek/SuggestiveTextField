//
//  SuggestiveTextField.h
//  SuggestiveTextField
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.wordpress.com . All rights reserved.
//
#import <UIKit/UIKit.h>

@interface SuggestiveTextField : UITextField 

// Set suggestions list of NSString's.
- (void)setSuggestions:(NSArray *)suggestionStrings;

// Set Custom popover size. Maximum popover size, both for iPad and iPhone.
- (void)setPopoverSize:(CGSize)size;

// Filter array and reload TableView
- (void)matchStrings:(NSString *)letters;

// Present PopOver or Table View
- (void)showSuggestionTableView;


- (void)dismissSuggestionTableView;

// used for alignment of table view position
// it should be set to the parent view that contains the text field
// default: self.window
@property (nonatomic, strong) UIView *referenceView;


// Define if popover should hide after user selects a suggestion.
@property BOOL shouldHideOnSelection;

@end
