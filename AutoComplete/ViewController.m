//
//  ViewController.m
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 08/09/2011.
//  Copyright 2011 http://tetek.me . All rights reserved.
//

#import "ViewController.h"


@implementation ViewController
@synthesize searchField = _searchField;
@synthesize suggList = _suggList;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if ((self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {

        NSArray *array = [NSArray arrayWithObjects:@"Warsaw",@"Wrocław",@"Malmo",@"Oslo",@"Berlin",@"Amsterdam",@"Praha",@"Paris",@"Barcelona",@"Madrid", nil];

        self.suggList = [[[SuggestionsList alloc] initWithArray:array] autorelease];
        
    }
    return self;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    [_suggList showSuggestionsFor:textField shouldChangeCharactersInRange:range replacementString:string];
    
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc
{
    self.suggList = nil;
    [super dealloc];
}
@end
