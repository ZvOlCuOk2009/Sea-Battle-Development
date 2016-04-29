//
//  TSFloatingRepresentation.m
//  Sea Battle
//
//  Created by Mac on 27.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSFloatingRepresentation.h"
#import "TSButton.h"

static NSString *font = @"Savoye LET";
static CGFloat redColor = 113.0 / 255.0;
static CGFloat greenColor = 43.0 / 255.0;
static CGFloat blueColor = 249.0 / 255.0;
static NSString *infoText = @"Разместите корабли на поле так, что бы при размещении они не касались друг друга углами. При двойном нажатии, корабль разворачивается на 90 градусов. Стреляйте когда стрелка становится зеленого цвета. Убитый или раненный корабль отмечается красным квадратом, выстрел мимо - серым...\n                               Удачи!!!";

@implementation TSFloatingRepresentation

- (id)initWithInfoBanner:(UIView *)parentView
{
    self = [super init];
    if (self) {
        self = [[TSFloatingRepresentation alloc] initWithFrame:[self frameBanner:parentView]];
        self.backgroundColor = [UIColor whiteColor];
        self.alpha = 0.85;
        self.layer.cornerRadius = 5;
        [self addSubview:[self textLabel]];
    }
    return self;
}

- (UILabel *)textLabel
{
    CGRect labelFrame = CGRectMake(23, 0, 390, 240);
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setTextColor:[self color]];
    [label setFont:[UIFont fontWithName:font size:25.0]];
    [label setText:infoText];
    label.numberOfLines = 0;
    return label;
}

- (CGRect)frameBanner:(UIView *)view
{
    return CGRectMake(view.bounds.size.width - 497, view.bounds.size.height - 560,
                      view.bounds.size.width - 142, view.bounds.size.height - 200);
}

- (UIColor *)color
{
    return [UIColor colorWithRed:redColor green:greenColor blue:blueColor alpha:1];
}

@end