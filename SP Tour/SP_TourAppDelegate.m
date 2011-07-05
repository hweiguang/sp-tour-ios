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

@implementation SP_TourAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize data;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
    
    data = [[NSMutableArray alloc]init];
    
    [self loadData];
    
    return YES;
}

- (void)loadData {
    
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
            
			//Extracting all the attribute in element location
			aPOIObjects.title = [TBXML valueOfAttributeNamed:@"title" forElement:location];
			aPOIObjects.subtitle = [TBXML valueOfAttributeNamed:@"subtitle" forElement:location];
            aPOIObjects.description = [TBXML valueOfAttributeNamed:@"description" forElement:location];
            aPOIObjects.photos = [TBXML valueOfAttributeNamed:@"photos" forElement:location];
            
            NSString * lat = [TBXML valueOfAttributeNamed:@"lat" forElement:location];
            aPOIObjects.lat = [NSNumber numberWithFloat:[lat floatValue]];
            NSString * lon = [TBXML valueOfAttributeNamed:@"lon" forElement:location];
            aPOIObjects.lon = [NSNumber numberWithFloat:[lon floatValue]];
            
            // add our location object to the locations array and release the resource
			[data addObject:aPOIObjects];
            [aPOIObjects release];
            
			// find the next sibling element named "location"
			location = [TBXML nextSiblingNamed:@"location" searchFromElement:location];
        }
    }
    // release resources
    [tbxml release];
    
    SP_TourAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    RootViewController *rootVC = (RootViewController*)[appDelegate.navigationController.viewControllers objectAtIndex:0];
    [rootVC loadData];
}

- (void)dealloc
{
    [_window release];
    [_navigationController release];
    [super dealloc];
}

@end
