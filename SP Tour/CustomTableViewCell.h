//
//  CustomTableViewCell.h
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellforListVC : UITableViewCell {
    UILabel *primaryLabel;
    UILabel *secondaryLabel;
    UILabel *distanceLabel;
    UIImageView *image;
    UIImageView *compassHeading;
    UILabel *description;
}
@property(nonatomic,retain) UILabel *primaryLabel;
@property(nonatomic,retain) UILabel *secondaryLabel;
@property(nonatomic,retain) UILabel *distanceLabel;
@property(nonatomic,retain) UIImageView *image;
@property(nonatomic,retain) UIImageView *compassHeading;
@property(nonatomic,retain) UILabel *description;

@end
