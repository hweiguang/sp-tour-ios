//
//  DetailViewController.m
//  SP Tour
//
//  Created by Wei Guang on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
#import "Constants.h"
#import "SP_TourAppDelegate.h"
#import "POIObjects.h"
#import "WebViewController.h"
#import "LiveCamViewController.h"

@implementation DetailViewController

@synthesize textView,activity,description,panorama,livecam,toolbar;

- (void)dealloc
{
    [textView release];
    [description release];
    [panorama release];
    [livecam release];
    [imageView release];
	[activity release];
    [toolbar release];
    [request clearDelegatesAndCancel];
    [request release];
    [operationQueue cancelAllOperations];
    [operationQueue release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    toolbar = [UIToolbar new];
    toolbar.barStyle = UIBarStyleBlack;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        toolbar.frame = CGRectMake(0, 372, 320, 44);
    else
        toolbar.frame = CGRectMake(0, 916, 768, 44);
    
    [self.view addSubview:toolbar];
    
    [self settoolbar];
    
    [self.textView setText:description];
    
    if (![self.title isEqualToString:@"Station 8"]) {
        UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" 
                                                                       style:UIBarButtonItemStylePlain 
                                                                      target:self 
                                                                      action:@selector(NextStation:)];
        self.navigationItem.rightBarButtonItem = nextButton;
        [nextButton release];
    }
}

- (void)settoolbar {
    
    NSMutableArray *items = [[NSMutableArray alloc]init];
    
    if (panorama != nil) {
        UIBarButtonItem *showPanoramaButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Panorama.png"]
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(showPanorama:)];
        [items addObject:showPanoramaButtonItem];
        [showPanoramaButtonItem release];
    }
    
    if (livecam != nil) {
        UIBarButtonItem *showLiveCamButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LiveCam.png"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(showLiveCam:)];        
        [items addObject:showLiveCamButtonItem];
        [showLiveCamButtonItem release];
    }
    [self.toolbar setItems:items animated:YES]; 
    [items release];
}

- (void)showPanorama:(id)sender {
    WebViewController *webviewController = [[WebViewController alloc] 
                                            initWithNibName:@"WebViewController"
                                            bundle:nil];
    
    webviewController.link = [panoramaHostname stringByAppendingString:panorama];
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                   style:UIBarButtonItemStylePlain 
                                                                  target:nil action:nil];
	self.navigationItem.backBarButtonItem = backbutton;
    [backbutton release];
    
    webviewController.title = @"Panorama";
    [self.navigationController pushViewController:webviewController animated:YES];
	[webviewController release];
    
}

- (void)showLiveCam:(id)sender {
    LiveCamViewController *livecamViewController = [[LiveCamViewController alloc] 
                                                    initWithNibName:@"LiveCamViewController"
                                                    bundle:nil];
    
    livecamViewController.selectedLiveCam = livecam;
    livecamViewController.title = @"Live Cam";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (popOver == nil) {
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:livecamViewController];
            //Creating a popover with categoriesVC as RootVC
            popOver = [[UIPopoverController alloc] initWithContentViewController:navController];
            [navController release];
        }
        [popOver presentPopoverFromBarButtonItem:sender 
                        permittedArrowDirections:UIPopoverArrowDirectionAny 
                                        animated:YES];
    }
    else {
        UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] init];
        backbutton.title = @"Back";
        self.navigationItem.backBarButtonItem = backbutton;
        [backbutton release];
        [self.navigationController pushViewController:livecamViewController animated:YES];
    }
    [livecamViewController release];
}

- (void)NextStation:(id)sender { 
    
    [request clearDelegatesAndCancel];
    [operationQueue cancelAllOperations];
    
    SP_TourAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    imageView.image = nil;
    panorama = nil;
    livecam = nil;
    
    NSArray *data = appDelegate.data; 
    
    POIObjects * aPOIObjects;
    
    if ([self.title isEqualToString:@"Station 1"]) {
        aPOIObjects = [data objectAtIndex:1]; 
    } else if ([self.title isEqualToString:@"Station 2"]) {
        aPOIObjects = [data objectAtIndex:2];
    }  
    else if ([self.title isEqualToString:@"Station 3"]) {
        aPOIObjects = [data objectAtIndex:3];
    } 
    else if ([self.title isEqualToString:@"Station 4"]) {
        aPOIObjects = [data objectAtIndex:4];
    } 
    else if ([self.title isEqualToString:@"Station 5"]) {
        aPOIObjects = [data objectAtIndex:5];
    } 
    else if ([self.title isEqualToString:@"Station 6"]) {
        aPOIObjects = [data objectAtIndex:6];   
    } 
    else if ([self.title isEqualToString:@"Station 7"]) {
        aPOIObjects = [data objectAtIndex:7];
        self.navigationItem.rightBarButtonItem = nil;
    } 
    panorama = aPOIObjects.panorama;
    livecam = aPOIObjects.livecam;
    
    [self settoolbar];
    
    self.title = aPOIObjects.title;
    [self.textView setText:aPOIObjects.description];
    NSString *imagename = aPOIObjects.photos;
    [self grabImageInTheBackground:imagename];
}

- (void)grabImageInTheBackground:(NSString*)imagename {
    
    [activity startAnimating];
    
    if (!operationQueue)
        operationQueue = [[NSOperationQueue alloc] init];
    if (imagename != nil) {
        NSString *imglink = [imageHostname stringByAppendingString:imagename];
        NSURL *url = [NSURL URLWithString:imglink];
        request = [[ASIHTTPRequest alloc] initWithURL:url];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestDone:)];
        [request setDidFailSelector:@selector(requestWentWrong:)];
        [operationQueue addOperation:request];  // request is an NSOperationQueue
    }
    
    //  no photo defined, use default image not found
    else {
        imageView.image = [UIImage imageNamed:@"UnavailableImage.png"];        
        [activity stopAnimating];
    }
}

//  connected
- (void)requestDone:(ASIHTTPRequest *)theRequest
{
    NSData *responseData = [theRequest responseData];
    int statusCode = [theRequest responseStatusCode];
    
    //  file not found
    if (statusCode == 404) {
        imageView.image = [UIImage imageNamed:@"UnavailableImage.png"];
    }
    //  image is nil
    else if (responseData == nil)
        imageView.image = [UIImage imageNamed:@"UnavailableImage.png"];
    //  image found
    else
        imageView.image = [UIImage imageWithData:responseData];
    [activity stopAnimating];    
}

//  unable to connect, image not found; i.e use default image not found
- (void)requestWentWrong:(ASIHTTPRequest *)theRequest {
    //  set image not found
    imageView.image = [UIImage imageNamed:@"UnavailableImage.png"];        
    [activity stopAnimating];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
