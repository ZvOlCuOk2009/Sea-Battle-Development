//
//  TSPeripheral.m
//  Sea Battle
//
//  Created by Mac on 10.05.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSPeripheral.h"

@implementation TSPeripheral

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        self.transferCharacteristic = [[[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID] properties:CBCharacteristicPropertyNotify value:nil permissions:CBAttributePermissionsReadable] autorelease];
        
        CBMutableService *transferService = [[[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID] primary:YES] autorelease];
        transferService.characteristics = @[_transferCharacteristic];
        [_peripheralManager addService:transferService];
    }
}

@end
