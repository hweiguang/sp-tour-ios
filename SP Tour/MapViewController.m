//
//  MapViewController.m
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "POIObjects.h"
#import "SP_TourAppDelegate.h"

@implementation MapViewController

@synthesize mapView = _mapView;
@synthesize graphicsLayer = _graphicsLayer;
@synthesize CalloutTemplate = _CalloutTemplate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.mapView = nil;
    self.graphicsLayer = nil;
    self.CalloutTemplate = nil;
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Map";
    
    //set map view delegate
    self.mapView.mapViewDelegate = self;
    
    //create and add a base layer to map
	AGSTiledMapServiceLayer *tiledLayer = [[AGSTiledMapServiceLayer alloc]
										   initWithURL:[NSURL URLWithString:@"http://www.whereto.sg/WMGIS01/rest/services/WhereTo/Island_Base/MapServer"]];
	[self.mapView addMapLayer:tiledLayer withName:@"SP Map"];
    [tiledLayer release];
    
    //create and add graphics layer to map
	self.graphicsLayer = [AGSGraphicsLayer graphicsLayer];
	[self.mapView addMapLayer:self.graphicsLayer withName:@"Graphics Layer"];
    
    // Adding esriLogo watermark
    UIImageView *watermarkIV;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        watermarkIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 935, 43, 25)];
    else
        watermarkIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 391, 43, 25)];
    watermarkIV.image = [UIImage imageNamed:@"esriLogo.png"];
    [self.view addSubview:watermarkIV];
    [watermarkIV release];
}

- (void)mapViewDidLoad:(AGSMapView *)mapView {
    [self loadPoints];
    [self.mapView.gps start];
}

- (void)loadPoints {    
    
    SP_TourAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    // Getting category set from appDelegate
    NSMutableArray *data = [[NSMutableArray alloc] initWithArray:appDelegate.data];
    
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
        
        //create a marker symbol to use in our graphic
        AGSPictureMarkerSymbol *marker = [AGSPictureMarkerSymbol 
                                          pictureMarkerSymbolWithImageNamed:@"MapMarker.png"];
        marker.xoffset = 9;
        marker.yoffset = -16;
        marker.hotspot = CGPointMake(-9, -11);
        
        //creating an attribute for the callOuts
        NSMutableDictionary *attribs = [NSMutableDictionary dictionaryWithObject:aPOIObjects.title forKey:@"title"];
        [attribs setValue:aPOIObjects.subtitle forKey:@"subtitle"];
        [attribs setValue:aPOIObjects.description forKey:@"description"];
        [attribs setValue:aPOIObjects.photos forKey:@"photos"];
        
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
        
        //release the graphic
        [graphic release];
    }
    //Redraw map
    [self.graphicsLayer dataChanged];
    
    AGSMutableEnvelope *extent = [AGSMutableEnvelope envelopeWithXmin:xmin
                                                                 ymin:ymin
                                                                 xmax:xmax
                                                                 ymax:ymax
                                                     spatialReference:self.mapView.spatialReference];
    [extent expandByFactor:1.5];
    [self.mapView zoomToEnvelope:extent animated:NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
