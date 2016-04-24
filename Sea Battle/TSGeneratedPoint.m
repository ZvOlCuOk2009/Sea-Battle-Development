//
//  TSGeneratedPoint.m
//  Sea Battle
//
//  Created by Mac on 21.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSGeneratedPoint.h"

static NSInteger cellSize = 22;
static NSInteger correctionValue = 12;

@implementation TSGeneratedPoint

- (void)receivingPoint:(CGPoint)point view:(UIView *) currentView tag:(NSInteger)tag
{
    if (point.x <= 242 && point.x >= 22 && point.y <= 296 && point.y >= 79) {
        NSInteger intermediateResultX = point.x / cellSize;
        NSInteger newOriginX = intermediateResultX * cellSize;
        NSInteger intermediateResultY = point.y / cellSize;
        NSInteger newOriginY = (intermediateResultY * cellSize) + correctionValue;
        CGPoint newPoint = CGPointMake(newOriginX, newOriginY);
        [self.delegate pointTransmission:newPoint];
    } else {
        currentView.frame = [self returnOldPosition:tag];
    }
}

//  Костыльный вариант, дублирование кода, но я не смог его сделать лучше

#pragma mark - Return to the old position

- (CGRect)returnOldPosition:(NSInteger)tag
{
    CGRect frame1 = CGRectMake(309, 101, 88, 22);
    CGRect frame2 = CGRectMake(309, 145, 66, 22);
    CGRect frame3 = CGRectMake(309, 188, 66, 22);
    CGRect frame4 = CGRectMake(309, 232, 44, 22);
    CGRect frame5 = CGRectMake(419, 232, 44, 22);
    CGRect frame6 = CGRectMake(419, 188, 44, 22);
    CGRect frame7 = CGRectMake(419, 145, 22, 22);
    CGRect frame8 = CGRectMake(463, 145, 22, 22);
    CGRect frame9 = CGRectMake(419, 101, 22, 22);
    CGRect frame10 = CGRectMake(463, 101, 22, 22);
    switch (tag) {
        case 1:
            return frame1;
            break;
        case 2:
            return frame2;
            break;
        case 3:
            return frame3;
            break;
        case 4:
            return frame4;
            break;
        case 5:
            return frame5;
            break;
        case 6:
            return frame6;
            break;
        case 7:
            return frame7;
            break;
        case 8:
            return frame8;
            break;
        case 9:
            return frame9;
            break;
        case 10:
            return frame10;
            break;
        default:
            break;
    }
    return frame1;
}

@end