//
//  AppDelegate.h
//  SP Tour
//
//  Created by Wei Guang on 13/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"
#import "RootViewController.h"
#import "MapViewController.h"

@class MapViewController;
@class RootViewController;
@class MGSplitViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    MGSplitViewController *_splitViewController;
    RootViewController *_rootViewController;
    MapViewController *_mapViewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) MGSplitViewController *splitViewController;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) MapViewController *mapViewController;

- (void)setupiPhone;
- (void)setupiPad;

@end
