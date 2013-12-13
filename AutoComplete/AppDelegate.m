//
//  AutoCompleteAppDelegate.m
//  AutoComplete
//
//  Created by Wojciech Mandrysz on 08/09/2011.
//  Copyright 2011 http://tetek.me . All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    ViewController *mainController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    [self.window setRootViewController:mainController];
    [self.window makeKeyAndVisible];

    return YES;
}



@end
