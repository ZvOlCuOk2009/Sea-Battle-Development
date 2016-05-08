//
//  TSCalculationOfResponseShots.h
//  Sea Battle
//
//  Created by Mac on 18.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

//  Класс для расчета случайного выстрела по флоту пользователя и отображения пораженного участка на поле пользователя

#import <Foundation/Foundation.h>
#import "TSGameController.h"

extern NSString *const TSResponseColorArrowDidChangeNotification;
extern BOOL resolution;
extern NSInteger counterRsp;

@protocol TSCalculationOfResponseShotsDelegate

@required

- (void)calculationEnemyShotView:(CGRect)rect point:(CGPoint)point color:(UIColor *)color;

@optional

- (void)transitionProgress;
- (void)alertDefeat;

@end

@interface TSCalculationOfResponseShots : NSObject

@property (assign, nonatomic) id <TSCalculationOfResponseShotsDelegate> delegate;

- (void)shotRequest:(NSArray *)collectionShips shots:(NSArray *)shots;

@end
