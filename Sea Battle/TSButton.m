//
//  TSButton.m
//  Sea Battle
//
//  Created by Mac on 27.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSButton.h"

static NSString *font = @"Savoye LET";
static CGFloat redColor = 113.0 / 255.0;
static CGFloat greenColor = 43.0 / 255.0;
static CGFloat blueColor = 249.0 / 255.0;

@implementation TSButton

- (id)initWithButton
{
    self = [super init];
    if (self) {
        self = [[TSButton alloc] initWithFrame:[self frameButton]];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (UILabel *)textButton
{
    CGRect labelFrame = CGRectMake(0, 0, 50, 20);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setTextColor:[self color]];
    [label setFont:[UIFont fontWithName:font size:26.0]];
    label.numberOfLines = 0;
    return label;
}

- (CGRect)frameButton
{
    return CGRectMake(400, 225, 50, 50);
}

- (UIColor *)color
{
    return [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:1];
}

@end
