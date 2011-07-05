//
//  RootViewController.m
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "ARViewController.h"
#import "MapViewController.h"
#import "DetailViewController.h"
#import "CustomTableViewCell.h"
#import "SP_TourAppDelegate.h"
#import "POIObjects.h"

#define RAD_TO_DEG(r) ((r) * (180 / M_PI))

@implementation RootViewController

- (void)dealloc
{
    [locationManager release];
    [data release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    locationManager =[[CLLocationManager alloc]init];
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
    
    UIBarButtonItem *ARButton = [[UIBarButtonItem alloc] initWithTitle:@"AR" 
                                                                 style:UIBarButtonItemStylePlain 
                                                                target:self 
                                                                action:@selector(AR:)];
    self.navigationItem.leftBarButtonItem = ARButton;
    [ARButton release];
}

- (void) loadData {
    SP_TourAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    // Getting category set from appDelegate
    data = [[NSMutableArray alloc] initWithArray:appDelegate.data];
    [self.tableView reloadData];
}

- (void)MapView:(id)sender {
    MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" 
                                                                               bundle:nil];
    [self.navigationController pushViewController:mapViewController animated:YES];
    [mapViewController release];
}

- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    
    userlocation = newLocation;
    
    // Getting the location coordinate
    userlat = newLocation.coordinate.latitude;
    userlon = newLocation.coordinate.longitude; 
    
    [self.tableView reloadData];
    
}

- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading {
}

- (BOOL)locationManagerShouldDisplayHeadingCalibration:(CLLocationManager *)manager {
    return YES;
}

- (void)AR:(id)sender {
    ARViewController *arViewController = [[ARViewController alloc] initWithNibName:@"ARViewController" 
                                                                            bundle:nil];
    [self.navigationController presentModalViewController:arViewController animated:YES];
    [arViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    CustomCellforListVC *cell = (CustomCellforListVC*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomCellforListVC alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
    
    POIObjects * aPOIObjects = [data objectAtIndex:indexPath.row];
    
    NSString *imageName = [aPOIObjects.title stringByAppendingString:@".png"];
    
    cell.primaryLabel.text = aPOIObjects.title;
    cell.secondaryLabel.text = aPOIObjects.subtitle;
    cell.image.image = [UIImage imageNamed:imageName];
    cell.description.text = aPOIObjects.description;
    
    CLLocation *location;
    
    if (userlat == 0 || userlon == 0) {
        cell.distanceLabel.text = @"N/A";
        return cell;
    }
    else {
        CLLocation *userLocation = [[CLLocation alloc]initWithLatitude:userlat
                                                             longitude:userlon];
        
        NSString *distanceString;
        
        for (int i=0; i<[data count]; i++) {
            double lat = [aPOIObjects.lat doubleValue];
            double lon = [aPOIObjects.lon doubleValue];;
            
            location = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
            
            CLLocationDistance distance = [userLocation distanceFromLocation:location];
            
            distanceString = [NSString stringWithFormat:@"%.0f",distance];
            distanceString = [distanceString stringByAppendingString:@"m"];
            
            cell.distanceLabel.text = distanceString;
            
            [location release];
        }
        [userLocation release];
    }    
    
    if ([CLLocationManager headingAvailable]) {
        CLLocationCoordinate2D coord1 = locationManager.location.coordinate;
        CLLocationCoordinate2D coord2 = userlocation.coordinate;
        
        CLLocationDegrees deltaLong = coord2.longitude - coord1.longitude;
        CLLocationDegrees yComponent = sin(deltaLong) * cos(coord2.latitude);
        CLLocationDegrees xComponent = (cos(coord1.latitude) * sin(coord2.latitude)) - (sin(coord1.latitude) * cos(coord2.latitude) * cos(deltaLong));
        
        CLLocationDegrees radians = atan2(yComponent, xComponent);
        CLLocationDegrees degrees = RAD_TO_DEG(radians) + 360;
        
        double angle = ((degrees - locationManager.heading.trueHeading)*(3.14/180));
        
        [cell.image setTransform:CGAffineTransformMakeRotation(angle)];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController"
                                                                                        bundle:nil];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
