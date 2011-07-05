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

@synthesize primaryLabel,secondaryLabel,distanceLabel,image,compassHeading,description;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //Primary Label for the title
        primaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,0,150,25)];
        primaryLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0];
        primaryLabel.textColor = [UIColor redColor];
        
        //Secondary Label for the subtitle
        secondaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,25,150,15)];
        secondaryLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        
        //Distance Label for displaying distance from user location to POI
        distanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(225,10,50,15)];
        distanceLabel.textAlignment = UITextAlignmentCenter;
        distanceLabel.adjustsFontSizeToFitWidth = YES;
        
        image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, 145, 100)];
        
        //Image for showing direction to POI     
        compassHeading = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CompassHeading.png"]];
        compassHeading.frame = CGRectMake(285, 5, 30, 30);
        
        description = [[UILabel alloc]initWithFrame:CGRectMake(160, 35, 160, 100)];
        description.lineBreakMode = UILineBreakModeWordWrap;
        description.numberOfLines = 0;
        description.font = [UIFont fontWithName:@"Helvetica" size:14.0];
        
        if ([CLLocationManager headingAvailable])
            [self.contentView addSubview:compassHeading];
        
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
    [compassHeading release];
    [super dealloc];
}

@end
