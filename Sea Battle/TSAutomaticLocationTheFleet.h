//
//  TSAutomaticLocationTheFleet.h
//  Sea Battle
//
//  Created by Mac on 24.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

//  Класс автоматического расположения врежеского флота

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TSAutomaticLocationDelegate

- (void)translationLocationFleet:(NSArray *)ships;

@end

@interface TSAutomaticLocationTheFleet : NSObject

@property (assign, nonatomic) id <TSAutomaticLocationDelegate>delegate;

- (void)requestCollectionShips:(NSArray *)ships;

@end
