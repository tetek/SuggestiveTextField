//
//  SuggestionMenu.h
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://tetek.me . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionsList : UITableViewController 

-(id)initWithArray:(NSArray*)array;
-(void)showSuggestionsFor:(UITextField*)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString*)string;

@property(retain)NSArray *stringsArray;
@property(retain)NSArray *matchedStrings;
@property(retain)UIPopoverController *popOver;

@property(assign)UITextField *activeTextField;
@end
