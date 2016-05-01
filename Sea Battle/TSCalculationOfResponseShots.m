//
//  TSCalculationOfResponseShots.m
//  Sea Battle
//
//  Created by Mac on 18.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSCalculationOfResponseShots.h"

static CGFloat sideRect = 22;
static CGFloat correctionValueX = 22;
static CGFloat correctionValueY = 12;
static NSInteger indentationOnX = 21;
static NSInteger indentationOnY = 79;
static int fieldSide = 219;
static BOOL counter = YES;
BOOL resolution = YES;

NSString *const TSCalculatResponseColorArrowDidChangeNotification = @"TSCalculatResponseColorArrowDidChangeNotification";

@interface TSCalculationOfResponseShots ()

@property (assign, nonatomic) CGPoint overallPoint;
@property (assign, nonatomic) CGRect rect;

@end

@implementation TSCalculationOfResponseShots

- (void)shotRequest:(NSArray *)collectionShips shots:(NSArray *)shots
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    _overallPoint = [self randomPoint];
    _rect = [self generationOfRectangleBasedOnRandomPoint];
    if ([[self inspectionOfTheAffectedAreaEnemy:shots point:_overallPoint] isEqualToString:@"NO"]) {
        NSLog(@"Противник НЕТ");
        [self.delegate transitionProgress];
    } else {
        for (UIView *ship in collectionShips) {
            if (CGRectContainsPoint(ship.frame, _overallPoint)) {
                [self.delegate calculationEnemyShotView:_rect point:_overallPoint color:[self redBackgroundColor]];
                [notificationCenter postNotificationName:TSCalculatResponseColorArrowDidChangeNotification
                                                  object:@"Стрелка красная"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.delegate transitionProgress];
                });
                counter = NO;
            }
        }
        if (counter == YES) {
            [self.delegate calculationEnemyShotView:_rect point:_overallPoint color:[self grayBackgroundColor]];
            [notificationCenter postNotificationName:TSCalculatResponseColorArrowDidChangeNotification
                                              object:@"Стрелка зеленая"];
            resolution = YES;
        } else {
            counter = YES;
        }
    }
}

#pragma mark - Inspection of the affected area enemy

- (NSString *)inspectionOfTheAffectedAreaEnemy:(NSArray *)shots point:(CGPoint)point
{
    NSString *searchTheAffectedArea = nil;
    for (UIView *view in shots) {
        if (CGRectContainsPoint(view.frame, point)) {
            searchTheAffectedArea = @"NO";
        }
    }
    return searchTheAffectedArea;
}

#pragma mark - Background Color View

- (UIColor *)redBackgroundColor
{
    return [UIColor redColor];
}

- (UIColor *)grayBackgroundColor
{
    return [UIColor lightGrayColor];
}

#pragma mark - Random shot and calculation of the damaged area

- (CGRect)generationOfRectangleBasedOnRandomPoint
{
    CGRect rect = CGRectMake([self calculationValuePositionX:_overallPoint],
                             [self calculationValuePositionY:_overallPoint], sideRect, sideRect);
    return rect;
}

- (CGPoint)randomPoint
{
    NSInteger pointX = arc4random_uniform(fieldSide) + indentationOnX;
    NSInteger pointY = arc4random_uniform(fieldSide) + indentationOnY;
    CGPoint point = CGPointMake(pointX, pointY);
    return point;
}

- (NSInteger)calculationValuePositionX:(CGPoint)point
{
    NSInteger result = point.x - correctionValueX;
    NSInteger intermediateResult = result / sideRect;
    NSInteger positionX = (intermediateResult * sideRect) + correctionValueX;
    return positionX;
}

- (NSInteger)calculationValuePositionY:(CGPoint)point
{
    NSInteger result = point.y - correctionValueY;
    NSInteger intermediateResult = result / sideRect;
    NSInteger positionY = (intermediateResult * sideRect) + correctionValueY;
    return positionY;
}

@end
