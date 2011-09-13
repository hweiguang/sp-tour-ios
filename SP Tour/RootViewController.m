//
//  RootViewController.m
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "MapViewController.h"
#import "DetailViewController.h"
#import "CustomTableViewCell.h"
#import "SP_TourAppDelegate.h"
#import "POIObjects.h"
#import "Constants.h"
#import "AboutViewController.h"

@implementation RootViewController

@synthesize tableView = _tableView;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_tableView release];
    [wikitudeAR release];
    [locationManager release];
    [data release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    shouldUpdateLocation = YES;
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.distanceFilter =  kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" 
                                                                  style:UIBarButtonItemStylePlain 
                                                                 target:self 
                                                                 action:@selector(MapView:)];
    self.navigationItem.rightBarButtonItem = mapButton;
    [mapButton release];
    
    //Add ARButton only when camera is available and on iPhone
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)) {	
        UIBarButtonItem *ARButton = [[UIBarButtonItem alloc] initWithTitle:@"AR" 
                                                                     style:UIBarButtonItemStylePlain 
                                                                    target:self 
                                                                    action:@selector(AR:)];
        self.navigationItem.leftBarButtonItem = ARButton;
        [ARButton release];
    }
    else
        self.navigationItem.leftBarButtonItem = nil;
}

- (void) loadData {
    SP_TourAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    data = [[NSMutableArray alloc] initWithArray:appDelegate.data];  
    [self.tableView reloadData];
}

#pragma mark Navigating between Views

- (IBAction)closeARView:(id)sender {
    [wikitudeAR hide];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [ARbackButton removeFromSuperview];
}

- (IBAction)showAbout:(id)sender {
    AboutViewController *aboutViewController = [[AboutViewController alloc]initWithNibName:@"AboutViewController"
                                                                                    bundle:nil];
    aboutViewController.title = @"About";
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"Back";
    self.navigationItem.backBarButtonItem = backbutton;
    [backbutton release];
    
    [self.navigationController pushViewController:aboutViewController animated:YES];
    [aboutViewController release];
}

- (void)MapView:(id)sender {
    MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" 
                                                                               bundle:nil];
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
	backbutton.title = @"Back";
	self.navigationItem.backBarButtonItem = backbutton;
	[backbutton release];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}

- (void)AR:(id)sender {
    if (wikitudeAR == nil) {
        
        loadingHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        [self.navigationController.view addSubview:loadingHUD];
        loadingHUD.mode = MBProgressHUDModeIndeterminate;
        loadingHUD.labelText = @"Loading AR...";
        [loadingHUD show:YES];
        
        wikitudeAR = [[WikitudeARViewController alloc] initWithDelegate:self 
                                                     applicationPackage:wktapplicationPackage 
                                                         applicationKey:wktapplicationKey 
                                                        applicationName:wktapplicationName
                                                          developerName:wktdeveloperName];	  
    }
    else {
        [wikitudeAR show];
        
        SP_TourAppDelegate *appDelegate = (SP_TourAppDelegate *)[[UIApplication sharedApplication] delegate];
        ARbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [ARbackButton addTarget:self action:@selector(closeARView:)forControlEvents:UIControlEventTouchDown];
        [ARbackButton setTitle:@"Back" forState:UIControlStateNormal];
        ARbackButton.frame = CGRectMake(265,0,55,30);
        [appDelegate.window addSubview:ARbackButton]; 
    }
}

#pragma mark Wikitude Delegate Methods

- (void) verificationDidSucceed {
    SP_TourAppDelegate *appDelegate = (SP_TourAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate.window addSubview:[wikitudeAR start]];
    ARbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [ARbackButton addTarget:self action:@selector(closeARView:)forControlEvents:UIControlEventTouchDown];
    [ARbackButton setTitle:@"Back" forState:UIControlStateNormal];
    ARbackButton.frame = CGRectMake(265,0,55,30);
    [appDelegate.window addSubview:ARbackButton];
    [appDelegate.window makeKeyAndVisible];
    [loadingHUD hide:YES];
}

- (void)actionFired:(WTPoi*)POI {
}

- (void) verificationDidFail {
    [loadingHUD hide:YES];
    
    MBProgressHUD *errorHUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:errorHUD];
	errorHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Error.png"]] autorelease];
    errorHUD.mode = MBProgressHUDModeCustomView;
    errorHUD.labelText = @"AR failed to load";
	errorHUD.detailsLabelText = @"Please try again";
    [errorHUD show:YES];
	[errorHUD hide:YES afterDelay:1.5];
    [errorHUD release];
    
    [wikitudeAR release];
    wikitudeAR = nil;
}

- (void) didUpdateToLocation: (CLLocation*) newLocation
				fromLocation: (CLLocation*) oldLocation {
}

- (void) APIFinishedLoading {
    NSMutableArray *pois = [[NSMutableArray alloc] init];
    
    for (int i=0; i< [data count]; i++) {
        POIObjects *aPOIObjects = [data objectAtIndex:i];
        
        //Setting the lat and lon from POIObjects class
        double ptlat = [[aPOIObjects lat] doubleValue];
        double ptlon = [[aPOIObjects lon] doubleValue];
        
        WTPoi *poi = [[WTPoi alloc] initWithName:aPOIObjects.title AndLatitude:ptlat AndLongitude:ptlon];
        
        poi.icon = @"http://www.locanote.org/images/markers/marker-blue.png";
        poi.shortDescription = aPOIObjects.description;
        
        [pois addObject:poi];
        [poi release];
    }
    [[WikitudeARViewController sharedInstance] addPOIs:pois];
    [pois release];
}

#pragma mark Location Manager

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {    
    // Getting the location coordinate
    userlat = newLocation.coordinate.latitude;
    userlon = newLocation.coordinate.longitude; 
    if (shouldUpdateLocation)
        [self.tableView reloadData];
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    if (shouldUpdateLocation)
        [self.tableView reloadData];
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Cell";
    
    CustomCellforListVC *cell = (CustomCellforListVC*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomCellforListVC alloc]initWithFrame:CGRectZero]autorelease];
    }
    
    POIObjects * aPOIObjects = [data objectAtIndex:indexPath.row];
    
    cell.primaryLabel.text = aPOIObjects.title;
    cell.secondaryLabel.text = aPOIObjects.subtitle;
    
    NSString *imageName = [aPOIObjects.title stringByAppendingString:@".jpg"];
    
    if (!cell.image.image)
        cell.image.image = [UIImage imageNamed:imageName];
    
    cell.description.text = aPOIObjects.description;
    
    CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:userlat
                                                         longitude:userlon];
    if (userlat == 0 || userlon == 0)
        cell.distanceLabel.text = @"N/A";
    else {
        for (int i=0; i<[data count]; i++) {
            double lat = [aPOIObjects.lat doubleValue];
            double lon = [aPOIObjects.lon doubleValue];
            
            CLLocation *location = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
            
            //Calculating distance from user to POI
            CLLocationDistance distance = [userLocation distanceFromLocation:location];
            NSString *distanceString = [NSString stringWithFormat:@"%.0f",distance];
            distanceString = [distanceString stringByAppendingString:@"m"];
            
            //Calculating the direction to POI
            CLLocationCoordinate2D coord1 = userLocation.coordinate;
            CLLocationCoordinate2D coord2 = location.coordinate;
            
            CLLocationDegrees deltaLong = coord2.longitude - coord1.longitude;
            CLLocationDegrees yComponent = sin(deltaLong) * cos(coord2.latitude);
            CLLocationDegrees xComponent = (cos(coord1.latitude) * sin(coord2.latitude)) - (sin(coord1.latitude) * cos(coord2.latitude) * cos(deltaLong));
            
            CLLocationDegrees radians = atan2(yComponent, xComponent);
            CLLocationDegrees degrees = RAD_TO_DEG(radians) + 360;
            
            double angle = ((degrees - locationManager.heading.trueHeading)*(3.14/180));
            
            [location release];
            
            cell.distanceLabel.text = distanceString;
            [cell.compassHeading setTransform:CGAffineTransformMakeRotation(angle)];
        }
    }   
    [userLocation release];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        return 150;
    else
        return 250;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController"
                                                                                        bundle:nil];    
    POIObjects * aPOIObjects = [data objectAtIndex:indexPath.row];
    
    detailViewController.title = aPOIObjects.title;
    detailViewController.description = aPOIObjects.description;
    detailViewController.panorama = aPOIObjects.panorama;
    detailViewController.livecam = aPOIObjects.livecam;
    detailViewController.subtitle = aPOIObjects.subtitle;
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
	backbutton.title = @"Back";
	self.navigationItem.backBarButtonItem = backbutton;
	[backbutton release];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate)
        shouldUpdateLocation = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    shouldUpdateLocation = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {	
    shouldUpdateLocation = NO;
}

@end
