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

static NSInteger minXvalue = 309;
static NSInteger minYvalue = 101;

static NSInteger widthShip = 22;
static NSInteger lengthShipOneDecks = 22;
static NSInteger lengthShipTwoDecks = 44;
static NSInteger lengthShipThreeDecks = 66;
static NSInteger lengthShipFourDecks = 88;

@interface TSGeneratedPoint ()

@property (retain, nonatomic) UIView *theShip;


@end

@implementation TSGeneratedPoint

#pragma mark - Fixation of ships in a grid

- (void)correctPlacementShip:(CGPoint)point view:(UIView *)currentView tag:(NSInteger)tag ships:(NSArray *)ships
{
    if (point.x <= 242 && point.x >= 22 && point.y <= 296 && point.y >= 79) {
        
        CGPoint newPoint = CGPointMake([self newOriginX:point], [self newOriginY:point]);
        if ((currentView.frame.origin.x + currentView.frame.size.width) < 264) {
            if ([self shipIntersectsWithAnotherShip:ships selectedView:currentView]) {
                NSLog(@"ПЕРЕСЕЧЕНИЕ!!!");
                [currentView hitTest:point withEvent:nil];
                CGPoint correctionPoint = CGPointMake(((newPoint.x + self.theShip.frame.size.width) + 22), newPoint.y);
                [self.delegate pointTransmission:correctionPoint];
            } else {
                NSLog(@"НЕТУ ПЕРЕСЕЧЕНИЯ!!!");
                [self.delegate pointTransmission:newPoint];
            }
        } else {
            currentView.frame = [self returnOldPosition:tag];
        }
    } else {
        currentView.frame = [self returnOldPosition:tag];
    }
}

- (BOOL)shipIntersectsWithAnotherShip:(NSArray *)ships selectedView:(UIView *)selectedShip
{
    NSArray *subViewsInView = ships;
    for(UIView *theShip in subViewsInView) {
        self.theShip = theShip;
        if (![selectedShip isEqual:theShip])
            if(CGRectIntersectsRect(selectedShip.frame, theShip.frame))
                return YES;
    }
    return NO;
}

- (NSInteger)newOriginX:(CGPoint)point
{
    NSInteger intermediateResultX = point.x / cellSize;
    NSInteger newOriginX = intermediateResultX * cellSize;
    return newOriginX;
}

- (NSInteger)newOriginY:(CGPoint)point
{
    NSInteger intermediateResultY = point.y / cellSize;
    NSInteger newOriginY = (intermediateResultY * cellSize) + correctionValue;
    return newOriginY;
}

//  Заведомо не верный вариант имплементации, дублирование кода, но я не смог додуматься сделать правильнее

#pragma mark - Return to the old position

- (CGRect)returnOldPosition:(NSInteger)tag
{
    CGRect frame1, frame2, frame3,  frame4, frame5, frame6, frame7, frame8, frame9, frame10, mainFrame;
    frame1 = CGRectMake(minXvalue, minYvalue, lengthShipFourDecks, widthShip);
    frame2 = CGRectMake(minXvalue, minYvalue + 44, lengthShipThreeDecks, widthShip);
    frame3 = CGRectMake(minXvalue, minYvalue + 87, lengthShipThreeDecks, widthShip);
    frame4 = CGRectMake(minXvalue, minYvalue + 131, lengthShipTwoDecks, widthShip);
    frame5 = CGRectMake(minXvalue + 110, minYvalue + 131, lengthShipTwoDecks, widthShip);
    frame6 = CGRectMake(minXvalue + 110, minYvalue + 87, lengthShipTwoDecks, widthShip);
    frame7 = CGRectMake(minXvalue + 110, minYvalue + 44, lengthShipOneDecks, widthShip);
    frame8 = CGRectMake(minXvalue + 154, minYvalue + 44, lengthShipOneDecks, widthShip);
    frame9 = CGRectMake(minXvalue + 110, minYvalue, lengthShipOneDecks, widthShip);
    frame10 = CGRectMake(minXvalue + 154, minYvalue, lengthShipOneDecks, widthShip);
    mainFrame = CGRectMake(0, 0, 568, 320);
    
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
    return mainFrame;
}

-(void)dealloc
{
    [super dealloc];
    self.theShip = nil;
}

@end
