//
//  ViewController.h
//  iPhone_Beacon
//
//  Created by 卢棪 on 9/25/14.
//  Copyright (c) 2014 _Luyan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController : UIViewController<CBPeripheralManagerDelegate>
{
    CBMutableCharacteristic *rx;
    NSMutableString *str;
}

@property (nonatomic, strong) CBPeripheralManager *peripheralManagerBLE;

@end

