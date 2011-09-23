//
//  DetailViewController.m
//  SP Tour
//
//  Created by Wei Guang on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DetailViewController.h"
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

- (void)reloadPage:(NSNotification*)notification {
    
    NSDictionary *dictionary = [notification userInfo];
    
    self.panorama = [dictionary objectForKey:@"panorama"];
    self.livecam = [dictionary objectForKey:@"livecam"];
    self.title = [dictionary objectForKey:@"title"];
    self.subtitle = [dictionary objectForKey:@"subtitle"];
    self.description = [dictionary objectForKey:@"description"];
    
    self.subtitle = [[dictionary objectForKey:@"subtitle"] stringByAppendingString:@"\n"];
    label.text = [self.subtitle stringByAppendingString:self.description];
    
    CGRect currentFrame = label.frame;    
    CGSize max = CGSizeMake(437, 10000);
    CGSize expected = [label.text sizeWithFont:label.font constrainedToSize:max lineBreakMode:UILineBreakModeWordWrap]; 
    currentFrame.size.height = expected.height;
    label.frame = currentFrame;
    
    [self setImage];
    [self settoolbar];
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
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            imagescrollView.contentSize = CGSizeMake(447*2,280);
        else
            imagescrollView.contentSize = CGSizeMake(320*2,200);
    }
    else {
        pageControl.numberOfPages = 1;
        NSString *imageName = [self.title stringByAppendingString:@".jpg"];
        imageView.image = [UIImage imageNamed:imageName];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            imagescrollView.contentSize = CGSizeMake(447,280);
        else
            imagescrollView.contentSize = CGSizeMake(320,200);
    }
}

- (void)loadUI {
    toolbar = [UIToolbar new];
    toolbar.barStyle = UIBarStyleBlack;
    [self.view addSubview:toolbar];
    
    label = [[UILabel alloc]init];
    label.numberOfLines = 0;
    self.subtitle = [self.subtitle stringByAppendingString:@"\n"];
    label.text = [self.subtitle stringByAppendingString:self.description];
    [self.view addSubview:label];
    
    imagescrollView = [[UIScrollView alloc]init];
    imagescrollView.pagingEnabled = YES;
    imagescrollView.showsHorizontalScrollIndicator = NO;
    imagescrollView.showsVerticalScrollIndicator = NO;
    imagescrollView.scrollsToTop = NO;
    imagescrollView.delegate = self;
    
    imageView = [[UIImageView alloc]init];    
    [imagescrollView addSubview:imageView];
    
    imageViewA = [[UIImageView alloc]init];    
    [imagescrollView addSubview:imageViewA];
    
    [self.view addSubview:imagescrollView];
    
    pageControl = [[UIPageControl alloc]init];
    pageControl.backgroundColor = [UIColor lightGrayColor];
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        label.frame = CGRectMake(5,315,437,850);        
        CGRect currentFrame = label.frame;    
        CGSize max = CGSizeMake(437, 10000);
        CGSize expected = [label.text sizeWithFont:label.font constrainedToSize:max lineBreakMode:UILineBreakModeWordWrap]; 
        currentFrame.size.height = expected.height ;
        label.frame = currentFrame;
        
        imagescrollView.frame = CGRectMake(0, 0, 447, 280);
        imageView.frame = CGRectMake(0, 0, 447, 280);
        imageViewA.frame = CGRectMake(447, 0, 447, 280);
        pageControl.frame = CGRectMake(0, 280, 768, 30);
        toolbar.frame = CGRectMake(0, 916, 447, 44);
    }
    else {
        label.frame = CGRectMake(5,235,310,850);
        CGRect currentFrame = label.frame;    
        CGSize max = CGSizeMake(310, 10000);
        CGSize expected = [label.text sizeWithFont:label.font constrainedToSize:max lineBreakMode:UILineBreakModeWordWrap]; 
        currentFrame.size.height = expected.height ;
        label.frame = currentFrame;
        
        imagescrollView.frame = CGRectMake(0, 0, 320, 200);
        imageView.frame = CGRectMake(0, 0, 320, 200);
        imageViewA.frame = CGRectMake(320, 0, 320, 200);
        pageControl.frame = CGRectMake(0, 200, 320, 30);  
        toolbar.frame = CGRectMake(0, 372, 320, 44);
        
        if (![self.title isEqualToString:@"Station 10"]) {
            UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" 
                                                                           style:UIBarButtonItemStylePlain 
                                                                          target:self 
                                                                          action:@selector(NextStation:)];
            self.navigationItem.rightBarButtonItem = nextButton;
            [nextButton release];
        }
    }
}

- (void)viewDidAppear:(BOOL)animated {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadPage:)
                                                     name:@"showCallout"
                                                   object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
    [self settoolbar];
    [self setImage];
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
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        UIBarButtonItem *backbutton = [[UIBarButtonItem alloc] initWithTitle:@"Back" 
                                                                       style:UIBarButtonItemStylePlain 
                                                                      target:nil action:nil];
        self.navigationItem.backBarButtonItem = backbutton;
        [backbutton release];
        [self.navigationController pushViewController:webviewController animated:YES];
    }
    else {
        
        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
        
        appDelegate.splitViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        [appDelegate.splitViewController presentModalViewController:webviewController animated:YES];
    }
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
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    
    NSArray *data = appDelegate.rootViewController.data; 
    
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
    
    CGRect currentFrame = label.frame;    
    CGSize max = CGSizeMake(310, 10000);
    
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
