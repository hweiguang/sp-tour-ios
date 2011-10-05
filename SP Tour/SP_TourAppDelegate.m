//
//  SP_TourAppDelegate.m
//  SP Tour
//
//  Created by Richard Yip on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SP_TourAppDelegate.h"

@implementation SP_TourAppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;
@synthesize rootViewController = _rootViewController;
@synthesize mapViewController = _mapViewController;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        [self setupiPhone];
    else
        [self setupiPad];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    self.rootViewController.resetViews = YES;
}

- (void)setupiPhone {
    self.rootViewController = [[[RootViewController alloc]init]autorelease];
    UINavigationController *_navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    _navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.window addSubview:_navigationController.view];
    [self.window makeKeyAndVisible];
    self.rootViewController.resetViews = NO;
}

- (void)setupiPad {
    NSMutableArray *viewControllers = [[NSMutableArray alloc]init];
    
    UINavigationController *_navigationController;
    
    self.rootViewController = [[[RootViewController alloc]init]autorelease];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    _navigationController.navigationBar.tintColor = [UIColor blackColor];
    [viewControllers addObject:_navigationController];
    [_navigationController release];
    _navigationController = nil;
    
    self.mapViewController = [[[MapViewController alloc]init]autorelease];
    _navigationController = [[UINavigationController alloc] initWithRootViewController:self.mapViewController];
    _navigationController.navigationBar.tintColor = [UIColor blackColor];
    [viewControllers addObject:_navigationController];
    [_navigationController release];
    _navigationController = nil;
    
    self.splitViewController = [[[MGSplitViewController alloc]init]autorelease];
    self.splitViewController.viewControllers = viewControllers;
    [viewControllers release];
    viewControllers = nil;
    self.splitViewController.showsMasterInPortrait = YES;
    [self.window addSubview:self.splitViewController.view];
    [self.window makeKeyAndVisible];
}

@end
