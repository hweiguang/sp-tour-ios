//
//  RootViewController.m
//  SP Tour
//
//  Created by Wei Guang on 13/9/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"

@implementation RootViewController

@synthesize data = _data;
@synthesize toolbar = _toolbar;
@synthesize tableView = _tableView;
@synthesize shouldUpdateLocation;
@synthesize resetViews;

#pragma mark - View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [wikitudeAR release];
    [locationManager release];
    [_data release];
    [_tableView release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
    [locationManager startUpdatingLocation];
    [locationManager startUpdatingHeading];
}

- (void)viewDidDisappear:(BOOL)animated {
    [locationManager stopUpdatingHeading];
    [locationManager stopUpdatingLocation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"SP Tour";
    
    //Setting up tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                  self.view.frame.origin.y - 20,
                                                                  self.view.frame.size.width,
                                                                  self.view.frame.size.height - 88)
                                                 style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    shouldUpdateLocation = YES;
    
    //Setting up locationManager
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    locationManager.headingFilter = 10;
    
    //Adding toolbar to the bottom of the tableView
    self.toolbar = [UIToolbar new];
    self.toolbar.barStyle = UIBarStyleBlack;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil action:nil];    
    
    UIBarButtonItem *aboutButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"About.png"] 
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(showAbout)];
    [self.toolbar setItems:[NSArray arrayWithObjects:flexibleSpace,aboutButton,nil]];
    [self.view addSubview:self.toolbar];
    [aboutButton release];
    [flexibleSpace release];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.toolbar.frame = CGRectMake(0, 372, 320, 44);
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithTitle:@"Map" 
                                                                      style:UIBarButtonItemStylePlain 
                                                                     target:self 
                                                                     action:@selector(showMapView)];
        self.navigationItem.rightBarButtonItem = mapButton;
        [mapButton release];
        //Add ARButton only when camera is available and on iPhone
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIBarButtonItem *ARButton = [[UIBarButtonItem alloc] initWithTitle:@"AR" 
                                                                         style:UIBarButtonItemStylePlain 
                                                                        target:self 
                                                                        action:@selector(showAR)];
            self.navigationItem.leftBarButtonItem = ARButton;
            [ARButton release];
        }
    }
    else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
        self.toolbar.frame = CGRectMake(0, 916, 320, 44);
    }
    [self loadData];
}

- (void)loadData {
    self.data = [[NSMutableArray alloc]init];
    
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
			[self.data addObject:aPOIObjects];
            [aPOIObjects release];
            
			// find the next sibling element named "location"
			location = [TBXML nextSiblingNamed:@"location" searchFromElement:location];
        }
    }
    // release resources
    [tbxml release];
    [self.tableView reloadData];
}

- (void)showAbout {
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

- (void)showMapView {
    MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" 
                                                                               bundle:nil];
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
    backbutton.title = @"Back";
    self.navigationItem.backBarButtonItem = backbutton;
    [backbutton release];
    
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}

- (void)showAR {
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
        shouldUpdateLocation = NO;
        [wikitudeAR show];
        
        SP_TourAppDelegate *appDelegate = (SP_TourAppDelegate*)[[UIApplication sharedApplication] delegate];
        ARbackButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [ARbackButton addTarget:self action:@selector(closeARView:)forControlEvents:UIControlEventTouchDown];
        [ARbackButton setTitle:@"Back" forState:UIControlStateNormal];
        ARbackButton.frame = CGRectMake(265,0,55,30);
        [appDelegate.window addSubview:ARbackButton]; 
    }
}

#pragma mark Wikitude Delegate Methods
- (IBAction)closeARView:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    shouldUpdateLocation = YES;
    [wikitudeAR hide];
    [ARbackButton removeFromSuperview];
    if (self.resetViews) {
        self.navigationController.view.frame = CGRectMake(0, 20, 320, 460);
        self.resetViews = NO;
    }
}

- (void) verificationDidSucceed {
    shouldUpdateLocation = NO;
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
    
    for (int i=0; i< [_data count]; i++) {
        POIObjects *aPOIObjects = [_data objectAtIndex:i];
        
        //Setting the lat and lon from POIObjects class
        double ptlat = [[aPOIObjects lat] doubleValue];
        double ptlon = [[aPOIObjects lon] doubleValue];
        
        WTPoi *poi = [[WTPoi alloc] initWithName:aPOIObjects.title AndLatitude:ptlat AndLongitude:ptlon];
        
        poi.icon = @"http://www.locanote.org/images/markers/marker-blue.png";
        
        NSString *subtitle = [aPOIObjects.subtitle stringByAppendingString:@"\n"];
        poi.shortDescription = [subtitle stringByAppendingString:aPOIObjects.description];
        
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
    if (shouldUpdateLocation && ![CLLocationManager headingAvailable]) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        [self.tableView reloadRowsAtIndexPaths: visiblePaths
                              withRowAnimation: UITableViewRowAnimationNone];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
    if (shouldUpdateLocation) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        [self.tableView reloadRowsAtIndexPaths: visiblePaths
                              withRowAnimation: UITableViewRowAnimationNone];
    }
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

#pragma mark UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {    
    static NSString *CellIdentifier = @"Cell";
    
    UILabel *primaryLabel;
    UILabel *secondaryLabel;
    UILabel *distanceLabel;
    UIImageView *locationImage;
    UILabel *description;
    UIImageView *compassHeading;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        //Primary Label for the title
        primaryLabel = [[[UILabel alloc]init]autorelease];
        primaryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        primaryLabel.textColor = [UIColor redColor];
        primaryLabel.frame = CGRectMake(10,0,150,25);
        primaryLabel.tag = 1;
        
        //Secondary Label for the subtitle
        secondaryLabel = [[[UILabel alloc]init]autorelease];
        secondaryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14.0];
        secondaryLabel.frame = CGRectMake(10,25,250,15);
        secondaryLabel.tag = 2;
        
        //Distance Label for displaying distance from user location to POI
        distanceLabel = [[[UILabel alloc]init]autorelease];
        distanceLabel.textColor = [UIColor blueColor];
        distanceLabel.textAlignment = UITextAlignmentCenter;
        //distanceLabel.adjustsFontSizeToFitWidth = YES;
        distanceLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        distanceLabel.frame = CGRectMake(225,8,50,15);
        distanceLabel.tag = 3;
        
        //Image showing the location
        locationImage = [[[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 145, 90)]autorelease];
        locationImage.layer.masksToBounds = YES;
        locationImage.layer.cornerRadius = 15;
        locationImage.layer.borderWidth = 3;
        locationImage.layer.borderColor = [UIColor grayColor].CGColor;
        locationImage.tag = 4;
        
        //Description on the POI
        description = [[[UILabel alloc]init]autorelease];
        description.lineBreakMode = UILineBreakModeWordWrap;
        description.numberOfLines = 0;
        description.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        description.frame = CGRectMake(160, 45, 160, 90);
        description.tag = 5;
        
        //Compass Heading Image    
        if ([CLLocationManager headingAvailable]) {
            compassHeading = [[[UIImageView alloc]initWithFrame:CGRectMake(285, 5, 30, 30)]autorelease];
            compassHeading.tag = 6;
            [cell.contentView addSubview:compassHeading];
            
            NSString *fileName = [NSString stringWithFormat: @"%@/CompassHeading.png", [[NSBundle mainBundle] resourcePath]];
            compassHeading.image = [UIImage imageWithContentsOfFile:fileName];
        }
        [cell.contentView addSubview:primaryLabel];
        [cell.contentView addSubview:secondaryLabel];
        [cell.contentView addSubview:distanceLabel];
        [cell.contentView addSubview:locationImage];
        [cell.contentView addSubview:description]; 
    } 
    else {
        primaryLabel = (UILabel *)[cell.contentView viewWithTag:1];
        secondaryLabel = (UILabel *)[cell.contentView viewWithTag:2];
        distanceLabel = (UILabel *)[cell.contentView viewWithTag:3];
        locationImage = (UIImageView *)[cell.contentView viewWithTag:4];
        description = (UILabel *)[cell.contentView viewWithTag:5];
        compassHeading = (UIImageView *)[cell.contentView viewWithTag:6];
    }
    
    POIObjects * aPOIObjects = [_data objectAtIndex:indexPath.row];
    
    primaryLabel.text = aPOIObjects.title;
    secondaryLabel.text = aPOIObjects.subtitle;
    
    NSString *imageName = [aPOIObjects.title stringByAppendingString:@".jpg"];
    NSString *imagePath = [NSString stringWithFormat: @"%@/%@",[[NSBundle mainBundle] resourcePath],imageName];
    locationImage.image = [UIImage imageWithContentsOfFile:imagePath];
    
    description.text = aPOIObjects.description;
    
    if (!locationManager.location)
        distanceLabel.text = @"N/A";
    else {
        double lat = [aPOIObjects.lat doubleValue];
        double lon = [aPOIObjects.lon doubleValue];
        
        CLLocation *location = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
        
        //Calculating distance from user to POI
        CLLocationDistance distance = [locationManager.location distanceFromLocation:location];
        NSString *distanceString = [NSString stringWithFormat:@"%.0f",distance];
        distanceString = [distanceString stringByAppendingString:@"m"];
        
        //Calculating the direction to POI
        CLLocationCoordinate2D coord1 = locationManager.location.coordinate;
        CLLocationCoordinate2D coord2 = location.coordinate;
        
        CLLocationDegrees deltaLong = coord2.longitude - coord1.longitude;
        CLLocationDegrees yComponent = sin(deltaLong) * cos(coord2.latitude);
        CLLocationDegrees xComponent = (cos(coord1.latitude) * sin(coord2.latitude)) - (sin(coord1.latitude) * cos(coord2.latitude) * cos(deltaLong));
        
        CLLocationDegrees radians = atan2(yComponent, xComponent);
        CLLocationDegrees degrees = RAD_TO_DEG(radians) + 360;
        
        double angle = ((degrees - locationManager.heading.trueHeading)*(3.14/180));
        [location release];
        
        distanceLabel.text = distanceString;
        [compassHeading setTransform:CGAffineTransformMakeRotation(angle)];
    }   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    shouldUpdateLocation = NO;
    
    POIObjects * aPOIObjects = [self.data objectAtIndex:indexPath.row];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        NSMutableDictionary *attribs = [NSMutableDictionary dictionaryWithObject:aPOIObjects.title forKey:@"title"];
        [attribs setValue:aPOIObjects.subtitle forKey:@"subtitle"];
        [attribs setValue:aPOIObjects.description forKey:@"description"];
        [attribs setValue:aPOIObjects.panorama forKey:@"panorama"];
        [attribs setValue:aPOIObjects.livecam forKey:@"livecam"];
        [attribs setValue:aPOIObjects.lat forKey:@"lat"];
        [attribs setValue:aPOIObjects.lon forKey:@"lon"];
        
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:@"showCallout"
                                          object:nil
                                        userInfo:attribs];
    }
    
    else {
        DetailViewController *detailViewController = [[DetailViewController alloc]init];
        
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
