//
//  PanoramaViewController.h
//  SPMap
//
//  Created by Wei Guang on 4/8/11.
//  Copyright 2011 Singapore Polytechnic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController {
	IBOutlet UIWebView *webView;
	NSTimer *timer;
    NSString *link;
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *link;

@end
