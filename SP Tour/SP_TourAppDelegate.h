//
//  SP_TourAppDelegate.h
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TBXML.h"

@interface SP_TourAppDelegate : NSObject <UIApplicationDelegate> {
    NSMutableArray *data;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) NSMutableArray *data;

- (void)loadData;

@end
