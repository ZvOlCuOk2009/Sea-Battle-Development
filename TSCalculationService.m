//
//  TSCalculationService.m
//  Sea Battle
//
//  Created by Mac on 16.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSCalculationService.h"
#import "TSSoundManager.h"
#import "TSSettingsController.h"
#import "TSGameController.h"
#import "TSCalculationOfResponseShots.h"

static CGFloat sideRect = 22;
static CGFloat correctionValueX = 23;
static CGFloat correctionValueY = 12;
static BOOL resultIdentifier = YES;

NSString *const TSCalculationServiceColorArrowDidChangeNotification = @"TSCalculationServiceColorArrowDidChangeNotification";

@interface TSCalculationService ()

@property (assign, nonatomic) CGRect rect;
@property (assign, nonatomic) BOOL inspection;

@end

@implementation TSCalculationService

#pragma mark - Calculate The Area For Rectangle

- (void)calculateTheAreaForRectangle:(CGPoint)transmittedPoint ships:(NSArray *)collectionShips shots:(NSArray *)shots
{
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    if (CGRectContainsPoint([self afterShelling], transmittedPoint)) {
        _rect = CGRectMake((long)[self calculationValuePositionX:transmittedPoint],
                           (long)[self calculationValuePositionY:transmittedPoint], sideRect, sideRect);
        if (resolution == YES) {
            if ([[self inspectionOfTheAffectedArea:shots point:transmittedPoint] isEqualToString:@"NO"]) {
                NSLog(@"НЕТ");
            } else {
                NSLog(@"ДА");
                for (UIView *ship in collectionShips) {
                    if (CGRectContainsPoint(ship.frame, transmittedPoint)) {
                        [self.delegate calculationResponseView:_rect color:[self redBackgroundColor]];
                        resultIdentifier = NO;
                    }
                }
                if (resultIdentifier == YES) {
                    [self.delegate calculationResponseView:_rect color:[self grayBackgroundColor]];
                    [notificationCenter postNotificationName:TSCalculationServiceColorArrowDidChangeNotification
                                                      object:@"Стрелка красная!!!"];
                    resolution = NO;
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.delegate transitionProgress];
                    });
                } else {
                    resultIdentifier = YES;
                }
                if (soundButton == YES) {
                    [[TSSoundManager sharedManager] shotSound];
                }
            }
        }
    }
}

#pragma mark - Field

- (CGRect)afterShelling
{
    return CGRectMake(331, 79, 220, 219);
}

#pragma mark - Inspection of the affected area

- (NSString *)inspectionOfTheAffectedArea:(NSArray *)shots point:(CGPoint)point
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

#pragma mark - Сalculation of the affected area

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
