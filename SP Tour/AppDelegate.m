//
//  AppDelegate.m
//  SP Tour
//
//  Created by Wei Guang on 13/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;
@synthesize rootViewController = _rootViewController;
@synthesize mapViewController = _mapViewController;

- (void)dealloc
{
    [_window release];
    [self.rootViewController release];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.splitViewController release];
        [self.mapViewController release];
    }
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setupiPhone];
    else
        [self setupiPad];
    return YES;
}

- (void)setupiPhone {
    UINavigationController *_navigationController;
    self.rootViewController = [[RootViewController alloc]init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    _navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.window.rootViewController = self.rootViewController;
    [self.window addSubview:_navigationController.view];
    [self.window makeKeyAndVisible];
}

- (void)setupiPad {
    NSMutableArray *viewControllers = [[NSMutableArray alloc]init];
    
    UINavigationController *_navigationController;
    
    self.rootViewController = [[RootViewController alloc]init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    _navigationController.navigationBar.tintColor = [UIColor blackColor];
    [viewControllers addObject:_navigationController];
    [_navigationController release];
    _navigationController = nil;
    
    self.mapViewController = [[MapViewController alloc]init];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:self.mapViewController];
    _navigationController.navigationBar.tintColor = [UIColor blackColor];
    [viewControllers addObject:_navigationController];
    [_navigationController release];
    _navigationController = nil;
    
    self.splitViewController = [[MGSplitViewController alloc]init];
    self.splitViewController.viewControllers = viewControllers;
    [viewControllers release];
    viewControllers = nil;
    self.splitViewController.showsMasterInPortrait = YES;
    self.window.rootViewController = self.splitViewController;
    
    [self.window addSubview:self.splitViewController.view];
    [self.window makeKeyAndVisible];
}

@end
