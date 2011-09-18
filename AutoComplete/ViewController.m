//
//  ViewController.m
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 08/09/2011.
//  Copyright 2011 http://blog.idevs.pl . All rights reserved.
//

#import "ViewController.h"


@implementation ViewController

-(id)init{
    if ((self=[super init])) {
        searchField = [[UITextField alloc] initWithFrame:CGRectMake([self.view bounds].size.width/2-150, 200, 300, 30)];
        [searchField setBorderStyle:UITextBorderStyleLine];
        [searchField setTextAlignment:UITextAlignmentCenter];
        [searchField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [searchField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [searchField setPlaceholder:@"Your input goes here..."];
        [searchField setDelegate:self];
        [self.view addSubview:searchField];
        NSArray *array = [NSArray arrayWithObjects:@"Dul",@"Hana",@"Net",@"Set", nil];

        sugMenu = [[SuggestionMenu alloc] initWithSortedArray:array];
        
    }
    return self;
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [sugMenu suggestForText:@"" inField:textField];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *rightText = [NSString stringWithFormat:@"%@%@",textField.text,string];
    [sugMenu suggestForText:rightText inField:textField];
    return YES;
}
- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
