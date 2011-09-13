//
//  SP_TourAppDelegate.m
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SP_TourAppDelegate.h"
#import "POIObjects.h"
#import "RootViewController.h"
#import "Constants.h"

@implementation SP_TourAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize data;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    [NSThread detachNewThreadSelector:@selector(loadData) toTarget:self withObject:nil];
    return YES;
}

- (void)loadData {
 
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 
    
    data = [[NSMutableArray alloc]init];
    
    TBXML *tbxml = [[TBXML tbxmlWithXMLFile:@"SPTour.xml"] retain];
    
	// Obtain root element
	TBXMLElement * root = tbxml.rootXMLElement;
	
	// if root element is valid
	if (root) {
		// search for the first category element within the root element's children
		TBXMLElement * location = [TBXML childElementNamed:@"location" parentElement:root];
		
		// if an location element was found
		while (location != nil) {
            // instantiate an location object
            POIObjects * aPOIObjects = [[POIObjects alloc] init];
            
            TBXMLElement * title = [TBXML childElementNamed:@"title" parentElement:location];
            aPOIObjects.title = [TBXML textForElement:title];
            
            TBXMLElement *subtitle = [TBXML childElementNamed:@"subtitle" parentElement:location];
            aPOIObjects.subtitle = [TBXML textForElement:subtitle];
            
            TBXMLElement *description = [TBXML childElementNamed:@"description" parentElement:location]; 
            aPOIObjects.description = [TBXML textForElement:description];
            
            TBXMLElement *panorama = [TBXML childElementNamed:@"panorama" parentElement:location];
            aPOIObjects.panorama = [TBXML textForElement:panorama];
            
            TBXMLElement *livecam = [TBXML childElementNamed:@"livecam" parentElement:location];
            aPOIObjects.livecam = [TBXML textForElement:livecam];
            
            TBXMLElement *lat = [TBXML childElementNamed:@"lat" parentElement:location];
            NSString *_lat = [TBXML textForElement:lat];
            aPOIObjects.lat = [NSNumber numberWithFloat:[_lat floatValue]];
            
            TBXMLElement *lon = [TBXML childElementNamed:@"lon" parentElement:location];
            NSString *_lon = [TBXML textForElement:lon];
            aPOIObjects.lon = [NSNumber numberWithFloat:[_lon floatValue]];
            
            // add our location object to the locations array and release the resource
			[data addObject:aPOIObjects];
            [aPOIObjects release];
            
			// find the next sibling element named "location"
			location = [TBXML nextSiblingNamed:@"location" searchFromElement:location];
        }
    }
    // release resources
    [tbxml release];
    
    RootViewController *rootVC = (RootViewController*)[self.navigationController.viewControllers objectAtIndex:0];
    [rootVC loadData];
    
    [pool release];
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [data release];
    [super dealloc];
}

@end
