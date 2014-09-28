//
//  PopView.h
//  iPad_Beacon
//
//  Created by 卢棪 on 9/23/14.
//  Copyright (c) 2014 _Luyan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonTapBlock)(id param);

@interface PopView : UIImageView

@property (strong, nonatomic) UIButton *userInfoBtn;
@property (strong, nonatomic) UIButton *checkOutBtn;

@property (copy, nonatomic) ButtonTapBlock whenUserInfoTap;
@property (copy, nonatomic) ButtonTapBlock whenCheckOutTap;

@end
