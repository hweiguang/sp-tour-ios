//
//  POIObjects.h
//  SP Tour
//
//  Created by Wei Guang on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POIObjects : NSObject {
    NSString *title; //Title for callout
	NSString *subtitle; //Subtitle for callout
	NSNumber *lat; //Latitude for callout
	NSNumber *lon; //Longitude for callout
    NSString *description; //Description to be display in detail view
    NSString *panorama; //Link to panorama
    NSString *livecam; //Link to livecam image
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subtitle;
@property (nonatomic, retain) NSNumber *lat;
@property (nonatomic, retain) NSNumber *lon;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *panorama;
@property (nonatomic, retain) NSString *livecam;

@end
