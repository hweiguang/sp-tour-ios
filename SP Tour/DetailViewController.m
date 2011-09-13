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

@synthesize description,panorama,livecam,toolbar,subtitle;

- (void)dealloc
{
    [subtitle release];
    [description release];
    [panorama release];
    [livecam release];
    [imageView release];
    imageView = nil;
    [imageViewA release];
    imageViewA = nil;
    [label release];
    [toolbar release];
    [imagescrollView release];
    [pageControl release];
    [super dealloc];
}

- (void)setImage {
    if ([self.title isEqualToString:@"Station 3"] || 
        [self.title isEqualToString:@"Station 6"] ||
        [self.title isEqualToString:@"Station 9"]) {
        
        NSString *imageName = [self.title stringByAppendingString:@".jpg"];
        imageView.image = [UIImage imageNamed:imageName];
        imageName = [self.title stringByAppendingString:@"A.jpg"];
        imageViewA.image = [UIImage imageNamed:imageName];
        pageControl.numberOfPages = 2;
        [self.view addSubview:pageControl];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            imagescrollView.contentSize = CGSizeMake(768*2,480);
        else
            imagescrollView.contentSize = CGSizeMake(320*2,200);
    }
    else {
        [pageControl removeFromSuperview];
        
        NSString *imageName = [self.title stringByAppendingString:@".jpg"];
        imageView.image = [UIImage imageNamed:imageName];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            imagescrollView.contentSize = CGSizeMake(768,480);
        else
            imagescrollView.contentSize = CGSizeMake(320,200);
    }
}

- (void)loadiPhone {
    label = [[UILabel alloc]initWithFrame:CGRectMake(10,205,300,250)];
    label.numberOfLines = 0;
    
    self.subtitle = [self.subtitle stringByAppendingString:@"\n"];
    label.text = [self.subtitle stringByAppendingString:self.description];
    
    CGRect currentFrame = label.frame;    
    CGSize max = CGSizeMake(300, 10000);
    CGSize expected = [label.text sizeWithFont:label.font constrainedToSize:max lineBreakMode:UILineBreakModeWordWrap]; 
    currentFrame.size.height = expected.height ;
    label.frame = currentFrame;
    [self.view addSubview:label];
    
    imagescrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];
    imagescrollView.pagingEnabled = YES;
    imagescrollView.showsHorizontalScrollIndicator = NO;
    imagescrollView.showsVerticalScrollIndicator = NO;
    imagescrollView.scrollsToTop = NO;
    imagescrollView.delegate = self;
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 200)];    
    [imagescrollView addSubview:imageView];
    
    imageViewA = [[UIImageView alloc]initWithFrame:CGRectMake(320, 0, 320, 200)];    
    [imagescrollView addSubview:imageViewA];
    
    [self.view addSubview:imagescrollView];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(140, 170, 40, 30)];
    
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

- (void)loadiPad {
    label = [[UILabel alloc]initWithFrame:CGRectMake(5,485,758,850)];
    label.numberOfLines = 0;
    self.subtitle = [self.subtitle stringByAppendingString:@"\n"];
    label.text = [self.subtitle stringByAppendingString:self.description];
    
    CGRect currentFrame = label.frame;    
    CGSize max = CGSizeMake(758, 10000);
    CGSize expected = [label.text sizeWithFont:label.font constrainedToSize:max lineBreakMode:UILineBreakModeWordWrap]; 
    currentFrame.size.height = expected.height ;
    label.frame = currentFrame;
    [self.view addSubview:label];
    
    imagescrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 768, 480)];
    imagescrollView.pagingEnabled = YES;
    imagescrollView.showsHorizontalScrollIndicator = NO;
    imagescrollView.showsVerticalScrollIndicator = NO;
    imagescrollView.scrollsToTop = NO;
    imagescrollView.delegate = self;
    
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 768, 480)];
    [imagescrollView addSubview:imageView];
    
    imageViewA = [[UIImageView alloc]initWithFrame:CGRectMake(768, 0, 768, 480)];    
    [imagescrollView addSubview:imageViewA];
    
    [self.view addSubview:imagescrollView];
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(150, 450, 40, 30)];
    
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    toolbar = [UIToolbar new];
    toolbar.barStyle = UIBarStyleBlack;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        toolbar.frame = CGRectMake(0, 372, 320, 44);
        [self loadiPhone];
    }
    else {
        toolbar.frame = CGRectMake(0, 916, 768, 44);
        [self loadiPad];
    }
    
    [self.view addSubview:toolbar];
    
    [self settoolbar];
    [self setImage];
    
    if (![self.title isEqualToString:@"Station 10"]) {
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
    if (![panorama isEqualToString:@""]) {
        UIBarButtonItem *showPanoramaButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Panorama.png"]
                                                                                   style:UIBarButtonItemStylePlain
                                                                                  target:self
                                                                                  action:@selector(showPanorama:)];
        [items addObject:showPanoramaButtonItem];
        [showPanoramaButtonItem release];
    }
    
    if (![livecam isEqualToString:@""]) {
        UIBarButtonItem *showLiveCamButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"LiveCam.png"]
                                                                                  style:UIBarButtonItemStylePlain
                                                                                 target:self
                                                                                 action:@selector(showLiveCam:)];        
        [items addObject:showLiveCamButtonItem];
        [showLiveCamButtonItem release];
    }
    [self.toolbar setItems:items animated:YES]; 
    [items release];
    items = nil;
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
    SP_TourAppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    imageView.image = nil;
    imageViewA.image = nil;
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
    }
    else if ([self.title isEqualToString:@"Station 8"]) {
        aPOIObjects = [data objectAtIndex:8];
    }
    else if ([self.title isEqualToString:@"Station 9"]) {
        aPOIObjects = [data objectAtIndex:9];
        self.navigationItem.rightBarButtonItem = nil;
    }
    else
        return;
    
    self.panorama = aPOIObjects.panorama;
    self.livecam = aPOIObjects.livecam;
    self.title = aPOIObjects.title;
    self.subtitle = aPOIObjects.subtitle;
    self.description = aPOIObjects.description;
    
    self.subtitle = [self.subtitle stringByAppendingString:@"\n"];
    label.text = [self.subtitle stringByAppendingString:self.description];
    
    CGSize max;
    
    CGRect currentFrame = label.frame;    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        max = CGSizeMake(758, 10000);
    else
        max = CGSizeMake(300, 10000);
    
    CGSize expected = [label.text sizeWithFont:label.font constrainedToSize:max lineBreakMode:UILineBreakModeWordWrap]; 
    currentFrame.size.height = expected.height;
    label.frame = currentFrame;
    
    [self setImage];
    [self settoolbar];    
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    CGFloat pageWidth = _scrollView.frame.size.width;
    int page = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
}

- (void)changePage:(id)sender {
    // update the scroll view to the appropriate page
    CGRect frame;
    frame.origin.x = imagescrollView.frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    frame.size = imagescrollView.frame.size;
    [imagescrollView scrollRectToVisible:frame animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
