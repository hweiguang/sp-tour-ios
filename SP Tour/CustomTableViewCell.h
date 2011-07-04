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
}
@property(nonatomic,retain) UILabel *primaryLabel;
@property(nonatomic,retain) UILabel *secondaryLabel;
@property(nonatomic,retain) UILabel *distanceLabel;

@end
