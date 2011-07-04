//
//  ARViewController.m
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ARViewController.h"


@implementation ARViewController

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
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    sm3dar = [[SM3DARController alloc]init];
	sm3dar.view.backgroundColor = [UIColor blackColor];
	sm3dar.delegate = self;
	sm3dar.camera.showsCameraControls = NO;
	[self.view addSubview:sm3dar.view];
    [sm3dar startCamera];
	[[UIApplication sharedApplication] setStatusBarHidden:YES];
    /*
     [sm3dar addPointOfInterestWithLatitude:1.311464
     longitude:103.778551
     altitude:0
     title:@"Title" 
     subtitle:@"Subtitle" 
     markerViewClass:[RoundedLabelMarkerView class]
     properties:nil];
     */
    SM3DARPointOfInterest *poi = [[sm3dar initPointOfInterestWithLatitude:1.311464 
                                                                longitude:103.778551
                                                                 altitude:0
                                                                    title:@"Title"
                                                                 subtitle:@"distance" 
                                                          markerViewClass:[SM3DARMarkerView class] 
                                                               properties:nil] autorelease];
    SM3DARMarkerView *poiView = [[[SM3DARMarkerView alloc] initWithPointOfInterest:poi] autorelease];
    [sm3dar addPoint:poiView.poi];
}

- (void)sm3darLogoWasTapped:(SM3DARController *)sm3dar {
    return;
}

- (IBAction)closeARView:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
