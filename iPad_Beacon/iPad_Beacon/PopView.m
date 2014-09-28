//
//  PopView.m
//  iPad_Beacon
//
//  Created by 卢棪 on 9/23/14.
//  Copyright (c) 2014 _Luyan. All rights reserved.
//

#import "PopView.h"

@interface PopView ()

@end

@implementation PopView

@synthesize userInfoBtn = _userInfoBtn;
@synthesize checkOutBtn = _checkOutBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.image = [UIImage imageNamed:@"pop_button.png"];
        self.userInteractionEnabled = YES;
        
        self.userInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.userInfoBtn.frame = CGRectMake(frame.origin.x, frame.origin.y+5, 131, 61);
        [self.userInfoBtn setBackgroundImage:[UIImage imageNamed:@"userInfo.png"] forState:UIControlStateNormal];
        [self.userInfoBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.userInfoBtn];
        
        self.checkOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.checkOutBtn.frame = CGRectMake(frame.origin.x+131, frame.origin.y+5, 131, 61);
        [self.checkOutBtn setBackgroundImage:[UIImage imageNamed:@"checkout.png"] forState:UIControlStateNormal];
        [self.checkOutBtn addTarget:self action:@selector(btnTap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.checkOutBtn];
    }
    return self;
}

- (void)btnTap:(UIButton *)sender{
    if (sender == self.userInfoBtn) {
        if (self.whenUserInfoTap) {
            self.whenUserInfoTap(nil);
        }
    } else if (sender == self.checkOutBtn) {
        if (self.whenCheckOutTap) {
            self.whenCheckOutTap(nil);
        }
    }
}

@end
