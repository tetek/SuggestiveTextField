//
//  SuggestionMenu.h
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.me . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestiveTextField : UITextField <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

- (void)setSuggestions:(NSArray*)suggestionStrings;
- (void)setPopoverSize:(CGSize)size;

@property BOOL shouldHideOnSelection;

@end
