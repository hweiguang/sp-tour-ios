//
//  DetailViewController.h
//  SP Tour
//
//  Created by Wei Guang on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController {
    IBOutlet UIImageView *imageView;
    IBOutlet UITextView * textView;
    NSString *description;
    NSString *panorama;
    NSString *livecam;
    UIToolbar *toolbar;
    UIPopoverController *popOver;
}

@property (nonatomic, retain) IBOutlet UITextView * textView;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *panorama;
@property (nonatomic, retain) NSString *livecam;
@property (nonatomic, retain) UIToolbar *toolbar;

- (void)NextStation:(id)sender;
- (void)settoolbar;
- (void)showPanorama:(id)sender;
- (void)showLiveCam:(id)sender;

@end
