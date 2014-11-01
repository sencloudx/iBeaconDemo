//
//  ViewController.m
//  iPhone_Beacon
//
//  Created by 卢棪 on 9/25/14.
//  Copyright (c) 2014 _Luyan. All rights reserved.
//

#import "ViewController.h"

@import CoreLocation;
@import CoreBluetooth;

CBPeripheralManager *peripheralManager = nil;
CLBeaconRegion *region = nil;
NSNumber *power = nil;

@interface ViewController ()

//支付提示框
@property (strong, nonatomic) IBOutlet UIView *payAlertView;

#define RBL_SERVICE_UUID                    @"713d0000-503e-4c75-ba94-3148f18d941e"
#define RBL_TX_UUID                         @"713d0003-503e-4c75-ba94-3148f18d941e"
#define RBL_RX_UUID                         @"713d0002-503e-4c75-ba94-3148f18d941e"

@property BOOL enabled;
@property NSUUID *uuid;
@property NSNumber *major;
@property NSNumber *minor;

@property (strong, nonatomic) UISwitch *isOn;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.uuid = [[NSUUID alloc] initWithUUIDString:@"74278BDA-B644-4520-8F0C-720EAF059935"];
    self.major = [NSNumber numberWithShort:0];
    self.minor = [NSNumber numberWithShort:0];
    
    if(!power)
    {
        power = @-59;
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!peripheralManager)
    {
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
    else
    {
        peripheralManager.delegate = self;
    }
    
    // Refresh the enabled switch.
    self.enabled = YES;
    
    [self performSelector:@selector(updateAdvertisedRegion) withObject:nil afterDelay:2.0f];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    peripheralManager.delegate = nil;
}

//iBeacon
- (void)updateAdvertisedRegion
{
    if(peripheralManager.state < CBPeripheralManagerStatePoweredOn)
    {
        NSString *title = NSLocalizedString(@"Bluetooth must be enabled", @"");
        NSString *message = NSLocalizedString(@"To configure your device as a beacon", @"");
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Cancel button title in configuration Save Changes");
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [errorAlert show];
        
        return;
    }
    
    if(self.enabled)
    {
        // We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
        NSDictionary *peripheralData = nil;
        
        NSString *BeaconIdentifier = @"com.example.apple-samplecode.AirLocate";
        region = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:[self.major shortValue] minor:[self.minor shortValue] identifier:BeaconIdentifier];
        peripheralData = [region peripheralDataWithMeasuredPower:power];
        
        // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
        if(peripheralData)
        {
            [peripheralManager startAdvertising:peripheralData];
        }
        NSLog(@"iBeacon has opened");
    } else {
        [peripheralManager stopAdvertising];
        self.peripheralManagerBLE = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
    }
}

- (void)openBeacon{
    self.enabled = YES;
    [self updateAdvertisedRegion];
}

- (IBAction)prepareCheckout:(UIButton *)sender {
    self.enabled = NO;
    [self updateAdvertisedRegion];
    [self performSelector:@selector(openBeacon) withObject:nil afterDelay:180.0f];
}

- (IBAction)wechatPay:(UIButton *)sender {
    NSData *data = [@"0" dataUsingEncoding:NSUTF8StringEncoding];
    [self.peripheralManagerBLE updateValue:data forCharacteristic:rx onSubscribedCentrals:nil];
}

- (IBAction)aliPay:(UIButton *)sender {
    NSData *data = [@"0" dataUsingEncoding:NSUTF8StringEncoding];
    [self.peripheralManagerBLE updateValue:data forCharacteristic:rx onSubscribedCentrals:nil];
}

- (IBAction)back:(UIButton *)sender {
    [self.payAlertView removeFromSuperview];
}

#pragma mark - Peripheral Delegate
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    NSLog(@"self.peripheralManager powered on.");
    
    CBMutableCharacteristic *tx = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:RBL_TX_UUID] properties:CBCharacteristicPropertyWriteWithoutResponse value:nil permissions:CBAttributePermissionsWriteable];
    rx = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:RBL_RX_UUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable];
    
    CBMutableService *s = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:RBL_SERVICE_UUID] primary:YES];
    s.characteristics = @[tx, rx];
    
    [self.peripheralManagerBLE addService:s];
    
    NSDictionary *advertisingData = @{CBAdvertisementDataLocalNameKey : @"iPhone", CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:RBL_SERVICE_UUID]]};
    [self.peripheralManagerBLE startAdvertising:advertisingData];
}

#pragma mark - CBPeripheralManager Delegate
- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray *)requests
{
    NSLog(@"didReceiveWriteRequests");
    
    CBATTRequest*       request = [requests  objectAtIndex: 0];
    NSData*             request_data = request.value;
    
    uint8_t buf[request_data.length];
    [request_data getBytes:buf length:request_data.length];
    
    NSMutableString *temp = [[NSMutableString alloc] init];
    for (int i = 0; i < request_data.length; i++) {
        [temp appendFormat:@"%c", buf[i]];
    }
    
    if (temp) {
        str = [NSMutableString stringWithFormat:@"%@", temp];
    }
    
    if ([str isEqualToString:@"1"]){
        self.payAlertView.center = self.view.center;
        [self.view addSubview:self.payAlertView];
    }
    
    if ([str isEqualToString:@"2"]){
        [self.payAlertView removeFromSuperview];
    }
}

@end
