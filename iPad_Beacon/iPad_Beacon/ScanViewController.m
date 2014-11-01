//
//  ScanViewController.m
//  iPad_Beacon
//
//  Created by 卢棪 on 9/23/14.
//  Copyright (c) 2014 _Luyan. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()<UIAlertViewDelegate>

@property (assign, nonatomic) BOOL isSearch;//判断是否正在搜索

@end

@implementation ScanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isSearch = NO;
    
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(500, 500, 30, 30);
    [self.view addSubview:activityIndicator];
}

-(void) connectionTimer:(NSTimer *)timer
{
    if(bleShield.peripherals.count > 0)
    {
        [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        [activityIndicator stopAnimating];
        self.navigationItem.leftBarButtonItem.enabled = YES;
    }
}

- (IBAction)minus:(UIButton *)sender {
}

- (IBAction)plus:(UIButton *)sender {
}

- (IBAction)back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)closeToiPhone:(UIButton *)sender {
    if (self.isSearch == NO) {
        if (bleShield.activePeripheral)
            if(bleShield.activePeripheral.state == CBPeripheralStateConnected)
            {
                [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
                return;
            }
        
        if (bleShield.peripherals)
            bleShield.peripherals = nil;
        
        [bleShield findBLEPeripherals:3];
        
        [NSTimer scheduledTimerWithTimeInterval:(float)3.0 target:self selector:@selector(connectionTimer:) userInfo:nil repeats:NO];
        
        [activityIndicator startAnimating];
        
        self.isSearch = YES;
    }
}

#pragma mark - BLE Delegate
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
        [bleShield write:[@"2" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [activityIndicator stopAnimating];
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    
    NSString *title = @"提示";
    NSString *message = @"支付成功"; 
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Cancel button title in configuration Save Changes");
    UIAlertView *succeedAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [succeedAlert show];

    NSLog(@"%@", s);
}

#pragma mark - UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void) bleDidConnect
{
    NSData *d = [@"1" dataUsingEncoding:NSUTF8StringEncoding];
    if (bleShield.activePeripheral.state == CBPeripheralStateConnected) {
        [bleShield write:d];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
