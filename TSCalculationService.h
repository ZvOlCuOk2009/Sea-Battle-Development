//
//  TSCalculationService.h
//  Sea Battle
//
//  Created by Mac on 16.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

//  Класс для расчета попадания по вражескому флоту и отображения пораженного участка на поле врага

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const TSServiceColorArrowDidChangeNotification;
extern NSInteger counterSrv;

@protocol TSCalculationServiceDelegate

@required

- (void)calculationResponseView:(CGRect)rect color:(UIColor *)color;

@optional

- (void)transitionProgress;
- (void)alertVictory;

@end

@interface TSCalculationService : NSObject 

@property (assign, nonatomic) id <TSCalculationServiceDelegate> delegate;

- (void)calculateTheAreaForRectangle:(CGPoint)point ships:(NSArray *)collectionShips shots:(NSArray *)shots;

@end

