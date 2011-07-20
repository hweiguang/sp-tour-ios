//
//  DetailViewController.h
//  SP Tour
//
//  Created by Wei Guang on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface DetailViewController : UIViewController {
    IBOutlet UIImageView *imageView;
	IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UITextView * textView;
    ASIHTTPRequest *request; 
    NSOperationQueue *operationQueue;
    NSString *description;
    NSString *panorama;
    NSString *livecam;
    UIToolbar *toolbar;
    UIPopoverController *popOver;
}

@property (nonatomic, retain) UIActivityIndicatorView *activity;
@property (nonatomic, retain) IBOutlet UITextView * textView;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *panorama;
@property (nonatomic, retain) NSString *livecam;
@property (nonatomic, retain) UIToolbar *toolbar;

- (void)grabImageInTheBackground:(NSString*)imagename;
- (void)NextStation:(id)sender;
- (void)settoolbar;
- (void)showPanorama:(id)sender;
- (void)showLiveCam:(id)sender;

@end
