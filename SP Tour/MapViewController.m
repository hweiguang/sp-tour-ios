//
//  MapViewController.m
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "POIObjects.h"
#import "DetailViewController.h"
#import "RootViewController.h"
#import "Constants.h"
#import "Reachability.h"

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize graphicsLayer = _graphicsLayer;
@synthesize CalloutTemplate = _CalloutTemplate;

- (void)dealloc
{
    if (!self.mapView)
        self.mapView = nil;
    if (!self.graphicsLayer)
        self.graphicsLayer = nil;
    if (!self.CalloutTemplate)
        self.CalloutTemplate = nil;
    [locationManager release];
    [super dealloc];
}

- (void)locationManager:(CLLocationManager *)manager 
    didUpdateToLocation:(CLLocation *)newLocation 
           fromLocation:(CLLocation *)oldLocation {
    if (!mapLoaded)
        return;
    //If user location is displayed when accuracy is poor, the map will become unreponsive and has high chances of crashing. Therefore we makes sure we have a accuracy of 100m first before displaying.
    if (newLocation.horizontalAccuracy <= 100)
        [self.mapView.gps start]; //Display user location
    else
        [self.mapView.gps stop]; //Hide user location
}

- (void)showCallout:(NSNotification*)notification {
    
    if (!mapLoaded)
        return;
    
    NSDictionary *dictionary = [notification userInfo];
    
    double ptlat = [[dictionary objectForKey:@"lat"]doubleValue];
    double ptlon = [[dictionary objectForKey:@"lon"]doubleValue];
    
    AGSPoint *pt = [AGSPoint pointWithX:ptlon y:ptlat spatialReference:self.mapView.spatialReference];
    
    NSString *pictureMarker = [[dictionary objectForKey:@"title"] stringByAppendingString:@"P.png"];
    
    //create a marker symbol to use in our graphic
    AGSPictureMarkerSymbol *marker = [AGSPictureMarkerSymbol 
                                      pictureMarkerSymbolWithImageNamed:pictureMarker];
    marker.hotspot = CGPointMake(0,8);
    
    AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:pt
                                                        symbol:marker
                                                    attributes:[NSMutableDictionary dictionaryWithDictionary:dictionary]
                                          infoTemplateDelegate:self.CalloutTemplate];
    
    [self.mapView centerAtPoint:pt animated:YES];
    [self.mapView showCalloutAtPoint:pt forGraphic:graphic animated:YES];
    [graphic release];
}

- (void)viewDidAppear:(BOOL)animated {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showCallout:)
                                                     name:@"showCallout"
                                                   object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Setting up locationManager
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter =  kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    loading = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:loading];
    loading.mode = MBProgressHUDModeIndeterminate;
    loading.labelText = @"Loading...";
    [loading show:YES];
    
    mapLoaded = NO;
    
    Reachability* wifiReach = [[Reachability reachabilityWithHostName:kReachabilityHostname] retain];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];
    
    switch (netStatus) {
        case kNotReachable: {   
            [loading hide:YES];
            MBProgressHUD *errorHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
            [self.navigationController.view addSubview:errorHUD];
            errorHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Error.png"]] autorelease];
            errorHUD.mode = MBProgressHUDModeCustomView;
            errorHUD.labelText = @"No Internet Connection";
            errorHUD.detailsLabelText = @"SP Tour requires Internet connection to load map.";
            [errorHUD show:YES];
            [errorHUD hide:YES afterDelay:1.5];
            [errorHUD release];
        }
            break;
        case kReachableViaWWAN:
            break;
        case kReachableViaWiFi:
            break;
    }
    [wifiReach release];
    
    self.title = @"Map";
    
    //set map view delegate
    self.mapView.layerDelegate = self;
    self.mapView.calloutDelegate = self;
    
    //create and add a base layer to map
	AGSTiledMapServiceLayer *tiledLayer = [[AGSTiledMapServiceLayer alloc]
										   initWithURL:[NSURL URLWithString:kMapServiceURL]];
	[self.mapView addMapLayer:tiledLayer withName:@"SP Map"];
    [tiledLayer release];
    
    //create and add graphics layer to map
	self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
	[self.mapView addMapLayer:self.graphicsLayer withName:@"Graphics Layer"];
    
    // Adding esriLogo watermark
    UIImageView *watermarkIV;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        watermarkIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 979, 43, 25)];
    else
        watermarkIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 391, 43, 25)];
    watermarkIV.image = [UIImage imageNamed:@"esriLogo.png"];
    [self.view addSubview:watermarkIV];
    [watermarkIV release];
}

- (void)mapViewDidLoad:(AGSMapView *)mapView {
    [self loadPoints];
    mapLoaded = YES;
    [loading hide:YES];
}

- (void)loadPoints {
    
    [self.graphicsLayer removeAllGraphics];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    NSMutableArray *data = appDelegate.rootViewController.data;
    
    //use these to calculate extent of results
    double xmin = DBL_MAX;
    double ymin = DBL_MAX;
    double xmax = -DBL_MAX;
    double ymax = -DBL_MAX;
    
    //create the callout template, used when the user displays the callout
    self.CalloutTemplate = [[[AGSCalloutTemplate alloc]init] autorelease];
    
    //loop through all locations and add to graphics layer
    for (int i=0; i< [data count]; i++)
    {
        POIObjects *aPOIObjects = [data objectAtIndex:i];
        
        //Setting the lat and lon from POIObjects class
        double ptlat = [[aPOIObjects lat] doubleValue];
        double ptlon = [[aPOIObjects lon] doubleValue];
        
        //Adding coordinates to the point
        AGSPoint *pt = [AGSPoint pointWithX:ptlon y:ptlat spatialReference:self.mapView.spatialReference];
        
        //accumulate the min/max
        if (pt.x  < xmin)
            xmin = pt.x;
        
        if (pt.x > xmax)
            xmax = pt.x;
        
        if (pt.y < ymin)
            ymin = pt.y;
        
        if (pt.y > ymax)
            ymax = pt.y;
        
        NSString *pictureMarker = [aPOIObjects.title stringByAppendingString:@"P.png"];
        
        //create a marker symbol to use in our graphic
        AGSPictureMarkerSymbol *marker = [AGSPictureMarkerSymbol 
                                          pictureMarkerSymbolWithImageNamed:pictureMarker];
        marker.hotspot = CGPointMake(0,8);
        
        //creating an attribute for the callouts
        NSMutableDictionary *attribs = [NSMutableDictionary dictionaryWithObject:aPOIObjects.title forKey:@"title"];
        [attribs setValue:aPOIObjects.subtitle forKey:@"subtitle"];
        [attribs setValue:aPOIObjects.description forKey:@"description"];
        [attribs setValue:aPOIObjects.panorama forKey:@"panorama"];
        [attribs setValue:aPOIObjects.livecam forKey:@"livecam"];
        
        //set the title and subtitle of the callout
        self.CalloutTemplate.titleTemplate = @"${title}";
        self.CalloutTemplate.detailTemplate = @"${subtitle}";
        
        //create the graphic
        AGSGraphic *graphic = [[AGSGraphic alloc] initWithGeometry:pt
                                                            symbol:marker
                                                        attributes:attribs
                                              infoTemplateDelegate:self.CalloutTemplate];
        
        //add the graphic to the graphics layer
        [self.graphicsLayer addGraphic:graphic];
        
        //Redraw map
        [self.graphicsLayer dataChanged];
    }    
    
    AGSMutableEnvelope *extent = [AGSMutableEnvelope envelopeWithXmin:xmin
                                                                 ymin:ymin
                                                                 xmax:xmax
                                                                 ymax:ymax
                                                     spatialReference:self.mapView.spatialReference];
    [extent expandByFactor:1.5];
    [self.mapView zoomToEnvelope:extent animated:YES];
}

- (void)mapView:(AGSMapView *) mapView didClickCalloutAccessoryButtonForGraphic:(AGSGraphic *)graphic {
    NSDictionary *attribs =[NSDictionary dictionaryWithDictionary:graphic.attributes];
    NSString *title = [attribs valueForKey:@"title"];
    NSString *description = [attribs valueForKey:@"description"];
    NSString *panorama = [attribs valueForKey:@"panorama"];
    NSString *livecam = [attribs valueForKey:@"livecam"];
    NSString *subtitle = [attribs valueForKey:@"subtitle"];
    
    DetailViewController *detailViewController = [[DetailViewController alloc]init];
    detailViewController.title = title;
    detailViewController.description = description;
    detailViewController.panorama = panorama;
    detailViewController.livecam = livecam;
    detailViewController.subtitle = subtitle;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
        backbutton.title = @"Back";
        self.navigationItem.backBarButtonItem = backbutton;
        [backbutton release];
    }
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
