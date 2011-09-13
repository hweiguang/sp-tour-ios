//
//  PanoramaViewController.m
//  SPMap
//
//  Created by Wei Guang on 4/8/11.
//  Copyright 2011 Singapore Polytechnic. All rights reserved.
//

#import "WebViewController.h"
#import "Constants.h"

@implementation WebViewController

@synthesize webView,link;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
    
    //Timer to to check the status of webView
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                             target:self 
                                           selector:@selector(loading) 
                                           userInfo:nil 
                                            repeats:YES];
}

- (void) loading {
	if (!webView.loading){
		self.title = @"Panorama";
        [timer invalidate];
    }
	else
		self.title = @"Loading...";
}

- (void)viewDidDisappear:(BOOL)animated {
    if ([webView isLoading])
        [webView stopLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [webView release];
    [link release];
    [super dealloc];
}

@end
