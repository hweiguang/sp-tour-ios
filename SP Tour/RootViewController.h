//
//  RootViewController.h
//  SP Tour
//
//  Created by Wei Guang on 13/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "TBXML.h"
#import "POIObjects.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "DetailViewController.h"
#import "WikitudeARViewController.h"
#import "AboutViewController.h"

@interface RootViewController : UIViewController <CLLocationManagerDelegate,WikitudeARViewControllerDelegate,UITableViewDelegate, UITableViewDataSource> {
    CLLocationManager *locationManager;
    NSMutableArray *_data;
    
    UITableView *_tableView;
    
    WikitudeARViewController *wikitudeAR;
    UIButton *ARbackButton;
    
    MBProgressHUD *loadingHUD;
    
    BOOL shouldUpdateLocation;
    
    UIToolbar *_toolbar;
}

@property (nonatomic,retain) NSMutableArray *data;
@property (nonatomic,retain) UIToolbar *toolbar;
@property (nonatomic, retain) UITableView *tableView;
@property BOOL shouldUpdateLocation;
@property BOOL resetViews;


- (void)loadData;
- (void)showAR;
- (void)showMapView;
- (void)showAbout;

@end
