//
//  PanoramaViewController.h
//  SPMap
//
//  Created by Wei Guang on 4/8/11.
//  Copyright 2011 Singapore Polytechnic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface WebViewController : UIViewController <UIWebViewDelegate> {
	IBOutlet UIWebView *webView;
    NSString *link;
    MBProgressHUD *loading; 
}

@property (nonatomic, retain) UIWebView *webView;
@property (nonatomic, retain) NSString *link;

- (void)dismiss:(id)sender;

@end
