//
//  ViewController.m
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 08/09/2011.
//  Copyright 2011 http://tetek.me . All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(assign) IBOutlet SuggestiveTextField *textField;

@end

@implementation ViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    //Defining suggestions to use
    NSArray *array = [NSArray arrayWithObjects:@"Warsaw",@"Wrocław",@"Malmo",@"Oslo",@"Berlin",@"Amsterdam",@"Praha",@"Paris",@"Barcelona",@"Madrid", nil];

    //Assigning to searchfield
    [_textField setSuggestions:array];

}



@end
