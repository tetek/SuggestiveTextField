//
//  ViewController.h
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 08/09/2011.
//  Copyright 2011 http://blog.idevs.pl . All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestionMenu.h"

@interface ViewController : UIViewController <UITextFieldDelegate> {
    UITextField *searchField;
    SuggestionMenu *sugMenu;
}
@property(retain)UITextField *searchField;
@property(retain)SuggestionMenu *sugMenu;
@end
