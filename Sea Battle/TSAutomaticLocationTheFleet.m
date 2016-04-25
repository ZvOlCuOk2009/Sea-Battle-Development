//
//  TSAutomaticLocationTheFleet.m
//  Sea Battle
//
//  Created by Mac on 24.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

//  Автоматическое рвзмещение вражеского флота 

#import "TSAutomaticLocationTheFleet.h"

static NSInteger cellSize = 22;
static NSInteger correctionValue = 12;

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
                                 CGPoint point = [self calculationOfNearestCells:ship.frame.origin];
                                 CGRect frame = CGRectMake(point.x, point.y, ship.frame.size.width, ship.frame.size.height);
                                 ship.frame = frame;
                             } else {
                                 ship.transform = CGAffineTransformMakeRotation(M_PI);
                                 CGPoint point = [self calculationOfNearestCells:ship.frame.origin];
                                 CGRect frame = CGRectMake(point.x, point.y, ship.frame.size.width, ship.frame.size.height);
                                 ship.frame = frame;
                                 [self.delegate translationLocationFleet:ships];
                             }
                         }];
    }
}

- (CGPoint)calculationOfNearestCells:(CGPoint)point
{
    NSInteger intermediateResultX = point.x / cellSize;
    NSInteger newOriginX = intermediateResultX * cellSize;
    NSInteger intermediateResultY = point.y / cellSize;
    NSInteger newOriginY = (intermediateResultY * cellSize) + correctionValue;
    CGPoint newPoint = CGPointMake(newOriginX, newOriginY);
    return newPoint;
}

- (BOOL)randomRatation
{
    BOOL rotate = arc4random_uniform(100) / 50;
    return rotate;
}

- (NSInteger)randomXvalue
{
    NSInteger xValue = arc4random_uniform(110) + 353;
    return xValue;
}

- (NSInteger)randomYvalue
{
    NSInteger yValue = arc4random_uniform(110) + 101;
    return yValue;
}

@end
