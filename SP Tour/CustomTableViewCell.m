//
//  CustomTableViewCell.m
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomCellforListVC

@synthesize primaryLabel,secondaryLabel,distanceLabel,image,description,compassHeading;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //Primary Label for the title
        self.primaryLabel = [[UILabel alloc]init];
        self.primaryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        self.primaryLabel.textColor = [UIColor redColor];
        self.primaryLabel.frame = CGRectMake(10,0,150,25);
        
        //Secondary Label for the subtitle
        self.secondaryLabel = [[UILabel alloc]init];
        self.secondaryLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.secondaryLabel.frame = CGRectMake(10,25,250,15);
        else
            self.secondaryLabel.frame = CGRectMake(10,25,300,15);
        
        //Distance Label for displaying distance from user location to POI
        self.distanceLabel = [[UILabel alloc]init];
        self.distanceLabel.textAlignment = UITextAlignmentCenter;
        self.distanceLabel.adjustsFontSizeToFitWidth = YES;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.distanceLabel.frame = CGRectMake(225,10,50,15);
        else
            self.distanceLabel.frame = CGRectMake(673,10,50,15);
        
        //Image showing the location
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 145, 100)];
        else
            self.image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 290, 200)];
        
        //Description on the POI
        self.description = [[UILabel alloc]init];
        self.description.lineBreakMode = UILineBreakModeWordWrap;
        self.description.numberOfLines = 0;
        self.description.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            self.description.frame = CGRectMake(160, 45, 160, 100);
        else
            self.description.frame = CGRectMake(320, 45, 320, 200);
        
        //Compass Heading Image    
        if ([CLLocationManager headingAvailable]) {
            self.compassHeading = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CompassHeading.png"]];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                self.compassHeading.frame = CGRectMake(285, 5, 30, 30);
            else
                self.compassHeading.frame = CGRectMake(733, 5, 30, 30);
            [self.contentView addSubview:self.compassHeading];
        }
        
        [self.contentView addSubview:self.primaryLabel];
        [self.contentView addSubview:self.secondaryLabel];
        [self.contentView addSubview:self.distanceLabel];
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.description]; 
    }
    return self;
}

- (void)dealloc {
    [self.primaryLabel release];
    [self.secondaryLabel release];
    [self.distanceLabel release];
    [self.image release];
    [self.description release];
    [self.compassHeading release];
    [super dealloc];
}

@end
