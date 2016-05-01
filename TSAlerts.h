//
//  TSAlerts.h
//  Sea Battle
//
//  Created by Mac on 21.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//
//   Класс создания всплывающих окон и предупреждений

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TSAlerts : NSObject

+ (UIView *)createdAlertGameOver:(UIView *)parentView;

@end
