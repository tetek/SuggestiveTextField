//
//  SuggestionMenu.h
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 19/09/2011.
//  Copyright 2011 http://blog.idevs.pl . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionMenu : UITableViewController {
    
}
-(id)initWithSortedArray:(NSArray*)array;
-(void)suggestForText:(NSString *)text inField:(UITextField*)field;
@property(retain)NSArray *sortedStringsArray;
@property(retain)NSArray *matchedStrings;
@property(retain)UIPopoverController *popOver;
@property(retain)UITextField *activeTextField;

@end
