//
//  NRChipInfoModel.m
//  NFCReader
//
//  Created by 李黎明 on 2019/4/22.
//  Copyright © 2019 李黎明. All rights reserved.
//

#import "NRChipInfoModel.h"

@implementation NRChipInfoModel

- (instancetype)init {
    self = [super init];
    
    self.chipUID = @"";
    self.chipType = @"";
    self.chipStatus = @"";
    self.chipSerialNumber = @"";
    self.chipDenomination = @"";
    self.chipBatch = @"";
    self.guestWashesNumber = @"";
    self.guestName = @"";
    return self;
}

- (instancetype)initWithChipUID:(NSString *)chipUID
                       ChipType:(NSString *)chipType
                     ChipStatus:(NSString *)chipStatus
               ChipSerialNumber:(NSString *)chipSerialNumber
               ChipDenomination:(NSString *)chipDenomination
                      ChipBatch:(NSString *)chipBatch
              GuestWashesNumber:(NSString *)guestWashesNumber
                      GuestName:(NSString *)guestName{
    self = [super init];
    self.chipUID = chipUID;
    self.chipType = chipType;
    self.chipStatus = chipStatus;
    self.chipSerialNumber = chipSerialNumber;
    self.chipDenomination = chipDenomination;
    self.chipBatch = chipBatch;
    self.guestWashesNumber = guestWashesNumber;
    self.guestName = guestName;
    
    return self;
}

@end
