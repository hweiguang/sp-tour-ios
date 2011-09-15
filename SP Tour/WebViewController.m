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
    
    self.title = @"Panorama";
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:link]]];
    webView.delegate = self;
    
    loading = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:loading];
    loading.mode = MBProgressHUDModeIndeterminate;
    loading.labelText = @"Loading...";
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [backButton addTarget:self action:@selector(dismiss:)forControlEvents:UIControlEventTouchDown];
        [backButton setTitle:@"Back" forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0,0,55,30);
        [self.view addSubview:backButton]; 
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [loading show:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [loading hide:YES];
}

- (void)dismiss:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
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
    [loading release];
    [super dealloc];
}

@end
