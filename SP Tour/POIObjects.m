//
//  POIObjects.m
//  SP Tour
//
//  Created by Wei Guang on 7/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "POIObjects.h"

@implementation POIObjects

@synthesize title;
@synthesize subtitle;
@synthesize lat;
@synthesize lon;
@synthesize description;
@synthesize photos;

- (id)init
{
    self = [super init];
    if (self) {
        title = [[NSString alloc] init];
        subtitle = [[NSString alloc] init];
        lat = [[NSNumber alloc] initWithDouble:0];
        lon = [[NSNumber alloc] initWithDouble:0];
        description = [[NSString alloc] init];
        photos = [[NSString alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [title release];
	[subtitle release];
	[lat release];
	[lon release];
    [description release];
    [photos release];
    [super dealloc];
}

@end
