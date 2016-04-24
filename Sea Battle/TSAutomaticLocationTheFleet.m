//
//  TSAutomaticLocationTheFleet.m
//  Sea Battle
//
//  Created by Mac on 24.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

//  Автоматическок рвзмещение вражеского флота 

#import "TSAutomaticLocationTheFleet.h"

@implementation TSAutomaticLocationTheFleet

- (void)requestCollectionShips:(NSArray *)ships
{
    for (UIView *ship in ships) {
        CGRect rect = CGRectMake([self randomXvalue], [self randomYvalue], ship.frame.size.width, ship.frame.size.height);
        [UIView animateWithDuration:0.35
                         animations:^{
                             ship.frame = rect;
                             if ([self randomRatation] == YES) {
                                 ship.transform = CGAffineTransformMakeRotation(M_PI_2);
                                 [self.delegate translationLocationFleet:ships];
                             } else {
                                 ship.transform = CGAffineTransformMakeRotation(M_PI);
                                 [self.delegate translationLocationFleet:ships];
                             }
                         }];
    }
}

- (BOOL)randomRatation
{
    BOOL rotate = arc4random_uniform(100) / 50;
    return rotate;
}

- (NSInteger)randomXvalue
{
    NSInteger xValue = arc4random_uniform(220) + 330;
    return xValue;
}

- (NSInteger)randomYvalue
{
    NSInteger yValue = arc4random_uniform(220) + 79;
    return yValue;
}

@end
