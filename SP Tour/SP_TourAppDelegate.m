//
//  SP_TourAppDelegate.m
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SP_TourAppDelegate.h"

@implementation SP_TourAppDelegate


@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
