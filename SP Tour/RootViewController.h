//
//  RootViewController.h
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface RootViewController : UITableViewController <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
    NSMutableArray *data;
    double userlat;
    double userlon;
    CLLocation *userlocation;
}

- (void)AR:(id)sender;
- (void)MapView:(id)sender;
- (void)loadData;

@end
