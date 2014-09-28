//
//  ScanViewController.h
//  iPad_Beacon
//
//  Created by 卢棪 on 9/23/14.
//  Copyright (c) 2014 _Luyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLE.h"

@interface ScanViewController : UIViewController<BLEDelegate>
{
    BLE *bleShield;
    UIActivityIndicatorView *activityIndicator;
}

@end
