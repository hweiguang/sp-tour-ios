//
//  RootViewController.h
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WikitudeARViewController.h"
#import "MBProgressHUD.h"

@interface RootViewController : UIViewController <CLLocationManagerDelegate,WikitudeARViewControllerDelegate,UIScrollViewDelegate> {
    CLLocationManager *locationManager;
    NSMutableArray *data;
    double userlat;
    double userlon;
    WikitudeARViewController *wikitudeAR;
    UIButton *ARbackButton;
    
    MBProgressHUD *loadingHUD;
    
    BOOL shouldUpdateLocation;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

- (void)AR:(id)sender;
- (void)MapView:(id)sender;
- (void)loadData;
- (IBAction)showAbout:(id)sender;

@end
