//
//  CustomTableViewCell.m
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CustomTableViewCell.h"
#import <CoreLocation/CoreLocation.h>

@implementation CustomCellforListVC

@synthesize primaryLabel,secondaryLabel,distanceLabel,image,description,compassHeading;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //Primary Label for the title
        primaryLabel = [[UILabel alloc]init];
        primaryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        primaryLabel.textColor = [UIColor redColor];
        primaryLabel.frame = CGRectMake(10,0,150,25);
        
        //Secondary Label for the subtitle
        secondaryLabel = [[UILabel alloc]init];
        secondaryLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            secondaryLabel.frame = CGRectMake(10,25,150,15);
        else
            secondaryLabel.frame = CGRectMake(10,25,300,15);
        
        //Distance Label for displaying distance from user location to POI
        distanceLabel = [[UILabel alloc]init];
        distanceLabel.textAlignment = UITextAlignmentCenter;
        distanceLabel.adjustsFontSizeToFitWidth = YES;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            distanceLabel.frame = CGRectMake(225,10,50,15);
        else
            distanceLabel.frame = CGRectMake(673,10,50,15);
        
        //Image showing the location
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 145, 100)];
        else
            image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 290, 200)];
        
        //Description on the POI
        description = [[UILabel alloc]init];
        description.lineBreakMode = UILineBreakModeWordWrap;
        description.numberOfLines = 0;
        description.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
            description.frame = CGRectMake(160, 45, 160, 100);
        else
            description.frame = CGRectMake(320, 45, 320, 200);
        
        //Compass Heading Image    
        if ([CLLocationManager headingAvailable]) {
            compassHeading = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CompassHeading.png"]];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                compassHeading.frame = CGRectMake(285, 5, 30, 30);
            else
                compassHeading.frame = CGRectMake(733, 5, 30, 30);
            [self.contentView addSubview:compassHeading];
        }
        
        [self.contentView addSubview:primaryLabel];
        [self.contentView addSubview:secondaryLabel];
        [self.contentView addSubview:distanceLabel];
        [self.contentView addSubview:image];
        [self.contentView addSubview:description]; 
    }
    return self;
}

- (void)dealloc {
    [primaryLabel release];
    [secondaryLabel release];
    [distanceLabel release];
    [image release];
    [description release];
    [compassHeading release];
    [super dealloc];
}

@end
