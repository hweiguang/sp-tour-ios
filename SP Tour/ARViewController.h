//
//  ARViewController.h
//  SP Tour
//
//  Created by Wei Guang on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SM3DAR.h"

@interface ARViewController : UIViewController <SM3DARDelegate> {
    SM3DARController *sm3dar;
}

- (IBAction)closeARView:(id)sender;

@end
