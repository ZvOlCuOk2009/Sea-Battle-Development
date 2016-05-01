//
//  TSAlerts.m
//  Sea Battle
//
//  Created by Mac on 21.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSAlerts.h"

static NSString *alert = @"Закончить игру?";
static NSString *font = @"Savoye LET";
static CGFloat redColor = 113.0 / 255.0;
static CGFloat greenColor = 43.0 / 255.0;
static CGFloat blueColor = 249.0 / 255.0;

@implementation TSAlerts

#pragma mark - Created alert game over

+ (UIView *)createdAlertGameOver:(UIView *)parentView;
{
    CGRect frame = CGRectMake(184, -100, 200, 120);
    UIColor *color = [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:1];
    UIView *alertView = [[UIView alloc] initWithFrame:frame];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.alpha = 0;
    alertView.layer.cornerRadius = 5;
    [parentView addSubview:alertView];
    
    CGRect labelFrame = CGRectMake(20, 15, 170, 50);
    UILabel *label = [[[UILabel alloc] initWithFrame:labelFrame] autorelease];
    [label setTextColor:color];
    [label setFont:[UIFont fontWithName:font size:34.0]];
    [label setText:alert];
    [alertView addSubview:label];
    
    CGRect newFrame = CGRectMake(184, 100, 200, 120);
    [UIView animateWithDuration:0.5
                     animations:^{
                         alertView.frame = newFrame;
                         alertView.alpha = 0.85f;
                     }];
    return alertView;
}

@end
