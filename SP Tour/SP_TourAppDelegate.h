//
//  SP_TourAppDelegate.h
//  SP Tour
//
//  Created by Richard Yip on 9/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSplitViewController.h"
#import "RootViewController.h"
#import "MapViewController.h"

@class MapViewController;
@class RootViewController;
@class MGSplitViewController;

@interface SP_TourAppDelegate : NSObject <UIApplicationDelegate> {
    MGSplitViewController *_splitViewController;
    RootViewController *_rootViewController;
    MapViewController *_mapViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) MGSplitViewController *splitViewController;
@property (nonatomic, retain) RootViewController *rootViewController;
@property (nonatomic, retain) MapViewController *mapViewController;

- (void)setupiPhone;
- (void)setupiPad;

@end
