//
//  ViewController.h
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 08/09/2011.
//  Copyright 2011 http://tetek.me . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestionsList.h"

@interface ViewController : UIViewController <UITextFieldDelegate> {

}
@property(assign) IBOutlet UITextField *searchField;
@property(retain)SuggestionsList *suggList;
@end
