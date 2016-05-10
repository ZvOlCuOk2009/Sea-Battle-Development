//
//  TSCentralManager.m
//  Sea Battle
//
//  Created by Mac on 10.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSCentralManager.h"

@implementation TSCentralManager

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state != CBCentralManagerStatePoweredOn) {
        return;
    }
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [_centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
        NSLog(@"Scanning started");
    }
}

@end
