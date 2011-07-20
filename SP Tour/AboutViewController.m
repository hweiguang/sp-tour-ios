//
//  AboutViewController.m
//  SPMap
//
//  Created by Wei Guang on 4/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AboutViewController.h"

@implementation AboutViewController

@synthesize webView;

- (void)dealloc
{
    [webView release];
    [super dealloc];
}

- (void)viewDidLoad {
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
	
	NSString *filePath = [[NSBundle mainBundle] pathForResource:@"aboutData" ofType:@"html"];
    
	NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
	[webView setDelegate:self];
	[webView loadHTMLString:htmlString baseURL:nil];
	
	//prevent bounce in UIWebView
	UIScrollView* sv = nil;
	for(UIView* v in webView.subviews){
		if([v isKindOfClass:[UIScrollView class] ]){
			sv = (UIScrollView*) v;
			sv.scrollEnabled = YES;
			sv.bounces = NO;
		}
	}
	
	webView.backgroundColor = [UIColor blueColor];
	[super viewDidLoad];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return false;
    }
    return true;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
