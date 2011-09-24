//
//  MapViewController.h
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArcGIS.h"
#import "SP_TourAppDelegate.h"
#import "RootViewController.h"

@interface MapViewController : UIViewController <AGSMapViewCalloutDelegate,AGSMapViewLayerDelegate,CLLocationManagerDelegate> {
    AGSMapView *_mapView;
    AGSGraphicsLayer *_graphicsLayer;
	AGSCalloutTemplate *_CalloutTemplate;
    
    BOOL mapLoaded;
    
    MBProgressHUD *loading; 
}

@property (nonatomic, retain) IBOutlet AGSMapView *mapView;
@property (nonatomic, retain) AGSGraphicsLayer *graphicsLayer;
@property (nonatomic, retain) AGSCalloutTemplate *CalloutTemplate;

- (void)loadPoints;

- (void)showCallout:(NSNotification*)notification;

@end
