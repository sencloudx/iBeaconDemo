//
//  ViewController.m
//  iPad_Beacon
//
//  Created by 卢棪 on 9/23/14.
//  Copyright (c) 2014 _Luyan. All rights reserved.
//

#import "ViewController.h"
#import "PopView.h"
#import "SlideTableView.h"
#import "ScanViewController.h"
#import "APLDefaults.h"

#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController ()<CLLocationManagerDelegate>

//用户信息弹出
@property (strong, nonatomic) IBOutlet UIView *userInfoAlertView;

//可发现设备信息
@property NSMutableDictionary *beacons;
@property CLLocationManager *locationManager;
@property NSMutableDictionary *rangedRegions;

/*
 *immediate的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *immediateButton_1;
@property (weak, nonatomic) IBOutlet UIButton *immediateButton_2;
@property (weak, nonatomic) IBOutlet UIButton *immediateButton_3;

/*
 *near的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *nearButton_1;
@property (weak, nonatomic) IBOutlet UIButton *nearButton_2;
@property (weak, nonatomic) IBOutlet UIButton *nearButton_3;
@property (weak, nonatomic) IBOutlet UIButton *nearButton_4;
@property (weak, nonatomic) IBOutlet UIButton *nearButton_5;

/*
 *far的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *farButton_1;
@property (weak, nonatomic) IBOutlet UIButton *farButton_2;
@property (weak, nonatomic) IBOutlet UIButton *farButton_3;
@property (weak, nonatomic) IBOutlet UIButton *farButton_4;
@property (weak, nonatomic) IBOutlet UIButton *farButton_5;

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) SlideTableView *slideTableView;
@property (strong, nonatomic) PopView *popView;
@property (assign, nonatomic) BOOL isHidden;

@property (assign, nonatomic) NSInteger tag;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.popView = [[PopView alloc] init];
    self.list = [NSMutableArray array];
    self.list = @[@"发送最新促销",@"从建议列表选择"];
    self.isHidden = YES;
    self.tag = 0;
    
    self.immediateButton_1.hidden = YES;
    self.immediateButton_2.hidden = YES;
    self.immediateButton_3.hidden = YES;
    
    self.nearButton_1.hidden = YES;
    self.nearButton_2.hidden = YES;
    self.nearButton_3.hidden = YES;
    self.nearButton_4.hidden = YES;
    self.nearButton_5.hidden = YES;
    
    self.farButton_1.hidden = YES;
    self.farButton_2.hidden = YES;
    self.farButton_3.hidden = YES;
    self.farButton_4.hidden = YES;
    self.farButton_5.hidden = YES;
    
    self.slideTableView = [[SlideTableView alloc] init];
    self.slideTableView.delegate = self;
    self.slideTableView.dataSource = self;
    self.slideTableView.bounces = NO;
    self.slideTableView.frame = CGRectMake(1024, 20, 240, 748);
    self.slideTableView.backgroundColor = [UIColor colorWithRed:29.0f/255.0f green:39.0f/255.0f blue:72.0f/255.0f alpha:0.9f];
    self.slideTableView.separatorInset = UIEdgeInsetsZero;
    
    [self.view addSubview:self.slideTableView];
    
    [self checkoutRangedRegion];

}

//查找可发现设备
- (void)checkoutRangedRegion{
    self.beacons = [[NSMutableDictionary alloc] init];
    
    // This location manager will be used to demonstrate how to range beacons.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    //ios8需要加这段代码
    [self.locationManager requestAlwaysAuthorization];
    
    // Populate the regions we will range once.
    self.rangedRegions = [[NSMutableDictionary alloc] init];
    
    for (NSUUID *uuid in [APLDefaults sharedDefaults].supportedProximityUUIDs)
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
        self.rangedRegions[region] = [NSArray array];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Start ranging when the view appears.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager startRangingBeaconsInRegion:region];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    // Stop ranging when the view goes away.
    for (CLBeaconRegion *region in self.rangedRegions)
    {
        [self.locationManager stopRangingBeaconsInRegion:region];
    }
    
}

//获取用户信息
- (CLBeacon *)getTheUserInfo:(NSInteger)index{
    switch (index) {
        case 1:
            if ([self.beacons[@(1)] count] == 2 ) {
                return self.beacons[@(1)][0];
            } else if ([self.beacons[@(1)] count] == 3) {
                return self.beacons[@(1)][1];
            } else {
                return nil;
            }
            
            break;
        
        case 2:
            if ([self.beacons[@(1)] count] == 1 ) {
                return self.beacons[@(1)][0];
            } else if ([self.beacons[@(1)] count] == 3) {
                return self.beacons[@(1)][1];
            } else {
                return nil;
            }
            
            break;
            
        case 3:
            if ([self.beacons[@(1)] count] == 2 ) {
                return self.beacons[@(1)][1];
            } else if ([self.beacons[@(1)] count] == 3) {
                return self.beacons[@(1)][2];
            } else {
                return nil;
            }

            break;
            
        case 4:
            if ([self.beacons[@(2)] count] == 4 ) {
                return self.beacons[@(2)][0];
            } else if ([self.beacons[@(2)] count] == 5) {
                return self.beacons[@(2)][0];
            } else {
                return nil;
            }

            break;
            
        case 5:
            if ([self.beacons[@(2)] count] == 2 ) {
                return self.beacons[@(2)][0];
            } else if ([self.beacons[@(2)] count] == 4) {
                return self.beacons[@(2)][1];
            } else if ([self.beacons[@(2)] count] == 5) {
                return self.beacons[@(2)][1];
            } else {
                return nil;
            }
            
            break;
            
        case 6:
            if ([self.beacons[@(2)] count] == 1 ) {
                return self.beacons[@(2)][0];
            } else if ([self.beacons[@(2)] count] == 3) {
                return self.beacons[@(2)][1];
            } else if ([self.beacons[@(2)] count] == 4) {
                return self.beacons[@(2)][2];
            } else if ([self.beacons[@(2)] count] == 5) {
                return self.beacons[@(2)][2];
            } else {
                return nil;
            }

            break;
            
        case 7:
            if ([self.beacons[@(2)] count] == 2 ) {
                return self.beacons[@(2)][1];
            } else if ([self.beacons[@(2)] count] == 3) {
                return self.beacons[@(2)][2];
            } else if ([self.beacons[@(2)] count] == 4) {
                return self.beacons[@(2)][3];
            } else if ([self.beacons[@(2)] count] == 5) {
                return self.beacons[@(2)][3];
            } else {
                return nil;
            }

            break;
            
        case 8:
            return self.beacons[@(2)][4];
            break;
            
        case 9:
            if ([self.beacons[@(3)] count] == 4 ) {
                return self.beacons[@(3)][0];
            } else if ([self.beacons[@(3)] count] == 5) {
                return self.beacons[@(3)][0];
            } else {
                return nil;
            }

            break;
            
        case 10:
            if ([self.beacons[@(3)] count] == 2 ) {
                return self.beacons[@(3)][0];
            } else if ([self.beacons[@(3)] count] == 4) {
                return self.beacons[@(3)][1];
            } else if ([self.beacons[@(3)] count] == 5) {
                return self.beacons[@(3)][1];
            } else {
                return nil;
            }

            break;
            
        case 11:
            if ([self.beacons[@(3)] count] == 1 ) {
                return self.beacons[@(3)][0];
            } else if ([self.beacons[@(3)] count] == 3) {
                return self.beacons[@(3)][1];
            } else if ([self.beacons[@(3)] count] == 4) {
                return self.beacons[@(3)][2];
            } else if ([self.beacons[@(3)] count] == 5) {
                return self.beacons[@(3)][2];
            } else {
                return nil;
            }

            break;
            
        case 12:
            if ([self.beacons[@(3)] count] == 2 ) {
                return self.beacons[@(3)][1];
            } else if ([self.beacons[@(3)] count] == 3) {
                return self.beacons[@(3)][2];
            } else if ([self.beacons[@(3)] count] == 4) {
                return self.beacons[@(3)][3];
            } else if ([self.beacons[@(2)] count] == 5) {
                return self.beacons[@(3)][3];
            } else {
                return nil;
            }

            break;
            
        case 13:
            return self.beacons[@(3)][4];
            break;
            
        default:
            return nil;
            break;
    }
}

- (IBAction)dismissAlertView:(UIButton *)sender {
    if (sender.tag == 20) {
        [self.userInfoAlertView removeFromSuperview];
    }
}

- (IBAction)avatar:(UIButton *)sender {
    
    CLBeacon *beaconInfo = [self getTheUserInfo:sender.tag];
    NSLog(@"major:%@", beaconInfo.major);
    
    if ( self.tag != sender.tag && self.isHidden == NO) {
        self.isHidden = YES;
        [self.popView removeFromSuperview];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.popView.alpha = 0;
        [UIView commitAnimations];
    }
    
    if ( self.isHidden == YES) {
        self.isHidden = NO;
        self.popView.frame = CGRectMake(sender.frame.origin.x+sender.frame.size.width/2-136, sender.frame.origin.y-90, 272, 87);
        
        if (!self.popView.superview) {
            [self.view addSubview:self.popView];
        }
        
        __block ViewController* shadow = self;//防止block循环
        self.popView.whenUserInfoTap = ^(id param){
//            [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                shadow.slideTableView.frame = CGRectMake(787, 20, 240, 748);
//            } completion:^(BOOL finished) {
//            }];
            shadow.userInfoAlertView.center = shadow.view.center;
            [shadow.view addSubview:shadow.userInfoAlertView];
            CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            popAnimation.duration = 0.4;
            popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                    [NSValue valueWithCATransform3D:CATransform3DIdentity]];
            popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
            popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                             [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [shadow.userInfoAlertView.layer addAnimation:popAnimation forKey:nil];

        };
        
        self.popView.whenCheckOutTap = ^(id param){
            [shadow presentViewController:[[ScanViewController alloc] init] animated:YES completion:nil];
        };
        
        self.popView.alpha = 0.0;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.popView.alpha = 1.0;
        [UIView commitAnimations];
    } else {
        self.isHidden = YES;
        [self.popView removeFromSuperview];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.popView.alpha = 0;
        [UIView commitAnimations];
    }
    
    self.tag = sender.tag;
}

#pragma mark - buttonAnimation
- (void)buttonAnimation:(UIButton *)button{
    CAKeyframeAnimation *centerZoom = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    centerZoom.duration = 1.0f;
    centerZoom.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    centerZoom.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [button.layer addAnimation:centerZoom forKey:@"buttonScale"];
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.list.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];

    if (indexPath.row == 0) {
        UIImageView *backCoin = [[UIImageView alloc] initWithFrame:CGRectMake(100, 15, 40, 40)];
        backCoin.image = [UIImage imageNamed:@"back_right.png"];
        [cell addSubview:backCoin];
    } else {
        NSString *fontName = self.list[indexPath.row-1];
        cell.textLabel.text = fontName;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        [UIView animateWithDuration:.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.slideTableView.frame = CGRectMake(1024, 20, 240, 748);
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

#pragma mark - Location manager delegate
- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region{
    self.rangedRegions[region] = beacons;
    [self.beacons removeAllObjects];
    
    NSMutableArray *allBeacons = [NSMutableArray array];
    
    for (NSArray *regionResult in [self.rangedRegions allValues])
    {
        [allBeacons addObjectsFromArray:regionResult];
    }
    
    for (NSNumber *range in @[@(CLProximityUnknown), @(CLProximityImmediate), @(CLProximityNear), @(CLProximityFar)])
    {
        NSArray *proximityBeacons = [allBeacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d", [range intValue]]];
        if([proximityBeacons count])
        {
            self.beacons[range] = proximityBeacons;
        }
    }
    
    [self reloadDevice];

}

- (void)reloadDevice{
    
    self.immediateButton_1.hidden = YES;
    self.immediateButton_2.hidden = YES;
    self.immediateButton_3.hidden = YES;
    self.nearButton_1.hidden = YES;
    self.nearButton_2.hidden = YES;
    self.nearButton_3.hidden = YES;
    self.nearButton_4.hidden = YES;
    self.nearButton_5.hidden = YES;
    self.farButton_1.hidden = YES;
    self.farButton_2.hidden = YES;
    self.farButton_3.hidden = YES;
    self.farButton_4.hidden = YES;
    self.farButton_5.hidden = YES;

    NSArray *sectionKeys = [self.beacons allKeys];
    if (sectionKeys.count == 0) {
        return;
    }
    
    if (![sectionKeys containsObject:@(1)]) {
        self.immediateButton_1.hidden = YES;
        self.immediateButton_2.hidden = YES;
        self.immediateButton_3.hidden = YES;
    }
    
    if (![sectionKeys containsObject:@(2)]) {
        self.nearButton_1.hidden = YES;
        self.nearButton_2.hidden = YES;
        self.nearButton_3.hidden = YES;
        self.nearButton_4.hidden = YES;
        self.nearButton_5.hidden = YES;

    }

    if (![sectionKeys containsObject:@(3)]) {
        self.farButton_1.hidden = YES;
        self.farButton_2.hidden = YES;
        self.farButton_3.hidden = YES;
        self.farButton_4.hidden = YES;
        self.farButton_5.hidden = YES;
    }

    for (NSNumber *sectionKey in sectionKeys) {
        
        switch([sectionKey integerValue])
        {
            case CLProximityImmediate:
                if ([self.beacons[sectionKey] count] == 1) {
                    self.immediateButton_1.hidden = YES;
                    self.immediateButton_2.hidden = NO;
                    [self buttonAnimation:self.immediateButton_2];
                    self.immediateButton_3.hidden = YES;
                } else if ([self.beacons[sectionKey] count] == 2) {
                    self.immediateButton_1.hidden = NO;
                    [self buttonAnimation:self.immediateButton_1];
                    self.immediateButton_2.hidden = YES;
                    self.immediateButton_3.hidden = NO;
                    [self buttonAnimation:self.immediateButton_3];
                } else if ([self.beacons[sectionKey] count] == 3) {
                    self.immediateButton_1.hidden = YES;
                    [self buttonAnimation:self.immediateButton_1];
                    self.immediateButton_2.hidden = YES;
                    [self buttonAnimation:self.immediateButton_2];
                    self.immediateButton_3.hidden = YES;
                    [self buttonAnimation:self.immediateButton_3];
                }

                break;
                
            case CLProximityNear:
                
                if ([self.beacons[sectionKey] count] == 1) {
                    self.nearButton_1.hidden = YES;
                    self.nearButton_2.hidden = YES;
                    self.nearButton_3.hidden = NO;
                    [self buttonAnimation:self.nearButton_3];
                    self.nearButton_4.hidden = YES;
                    self.nearButton_5.hidden = YES;
                } else if ([self.beacons[sectionKey] count] == 2) {
                    self.nearButton_1.hidden = YES;
                    self.nearButton_2.hidden = NO;
                    [self buttonAnimation:self.nearButton_2];
                    self.nearButton_3.hidden = YES;
                    self.nearButton_4.hidden = NO;
                    [self buttonAnimation:self.nearButton_4];
                    self.nearButton_5.hidden = YES;
                } else if ([self.beacons[sectionKey] count] == 3) {
                    self.nearButton_1.hidden = YES;
                    self.nearButton_2.hidden = NO;
                    [self buttonAnimation:self.nearButton_2];
                    self.nearButton_3.hidden = NO;
                    [self buttonAnimation:self.nearButton_3];
                    self.nearButton_4.hidden = NO;
                    [self buttonAnimation:self.nearButton_4];
                    self.nearButton_5.hidden = YES;
                } else if ([self.beacons[sectionKey] count] == 4) {
                    self.nearButton_1.hidden = NO;
                    [self buttonAnimation:self.nearButton_1];
                    self.nearButton_2.hidden = NO;
                    [self buttonAnimation:self.nearButton_2];
                    self.nearButton_3.hidden = NO;
                    [self buttonAnimation:self.nearButton_3];
                    self.nearButton_4.hidden = NO;
                    [self buttonAnimation:self.nearButton_4];
                    self.nearButton_5.hidden = YES;
                } else if ([self.beacons[sectionKey] count] == 5) {
                    self.nearButton_1.hidden = NO;
                    [self buttonAnimation:self.nearButton_1];
                    self.nearButton_2.hidden = NO;
                    [self buttonAnimation:self.nearButton_2];
                    self.nearButton_3.hidden = NO;
                    [self buttonAnimation:self.nearButton_3];
                    self.nearButton_4.hidden = NO;
                    [self buttonAnimation:self.nearButton_4];
                    self.nearButton_5.hidden = NO;
                    [self buttonAnimation:self.nearButton_5];
                }

                break;
                
            case CLProximityFar:
                if ([self.beacons[sectionKey] count] == 1) {
                    self.farButton_1.hidden = YES;
                    self.farButton_2.hidden = YES;
                    self.farButton_3.hidden = NO;
                    [self buttonAnimation:self.farButton_3];
                    self.farButton_4.hidden = YES;
                    self.farButton_5.hidden = YES;
                } else if ([self.beacons[sectionKey] count] == 2) {
                    self.farButton_1.hidden = YES;
                    self.farButton_2.hidden = NO;
                    [self buttonAnimation:self.farButton_2];
                    self.farButton_3.hidden = YES;
                    self.farButton_4.hidden = NO;
                    [self buttonAnimation:self.farButton_4];
                    self.farButton_5.hidden = YES;
                } else if ([self.beacons[sectionKey] count] == 3) {
                    self.farButton_1.hidden = YES;
                    self.farButton_2.hidden = NO;
                    [self buttonAnimation:self.farButton_2];
                    self.farButton_3.hidden = NO;
                    [self buttonAnimation:self.farButton_3];
                    self.farButton_4.hidden = NO;
                    [self buttonAnimation:self.farButton_4];
                    self.farButton_5.hidden = YES;
                } else if ([self.beacons[sectionKey] count] == 4) {
                    self.farButton_1.hidden = NO;
                    [self buttonAnimation:self.farButton_1];
                    self.farButton_2.hidden = NO;
                    [self buttonAnimation:self.farButton_2];
                    self.farButton_3.hidden = NO;
                    [self buttonAnimation:self.farButton_3];
                    self.farButton_4.hidden = NO;
                    [self buttonAnimation:self.farButton_4];
                    self.farButton_5.hidden = YES;
                } else if ([self.beacons[sectionKey] count] == 5) {
                    self.farButton_1.hidden = NO;
                    [self buttonAnimation:self.farButton_1];
                    self.farButton_2.hidden = NO;
                    [self buttonAnimation:self.farButton_2];
                    self.farButton_3.hidden = NO;
                    [self buttonAnimation:self.farButton_3];
                    self.farButton_4.hidden = NO;
                    [self buttonAnimation:self.farButton_4];
                    self.farButton_5.hidden = NO;
                    [self buttonAnimation:self.farButton_5];
                }
                break;
                
            default:
                break;
        }
        
    }
    
}

@end
