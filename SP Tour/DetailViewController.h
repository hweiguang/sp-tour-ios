//
//  DetailViewController.h
//  SP Tour
//
//  Created by Wei Guang on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SP_TourAppDelegate.h"
#import "RootViewController.h"
#import "Constants.h"
#import "MBProgressHUD.h"

@interface DetailViewController : UIViewController <UIScrollViewDelegate> {  
    UIScrollView *imagescrollView;
    UIPageControl *pageControl;
    UILabel *label;
    
    UIImageView *imageView;
    UIImageView *imageViewA;

    NSString *description;
    NSString *panorama;
    NSString *livecam;
    NSString *subtitle;
    UIToolbar *toolbar;
    UIPopoverController *popOver;
}

@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *panorama;
@property (nonatomic, retain) NSString *livecam;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) NSString *subtitle;

- (void)changePage:(id)sender;
- (void)NextStation:(id)sender;
- (void)showPanorama:(id)sender;
- (void)showLiveCam:(id)sender;

- (void)loadUI;

- (void)settoolbar;
- (void)setImage;

- (void)reloadPage:(NSNotification*)notification;

@end
