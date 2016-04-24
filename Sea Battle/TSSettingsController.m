//
//  TSSettingsController.m
//  Sea Battle
//
//  Created by Mac on 24.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSSettingsController.h"

BOOL soundButton = YES;
static NSString *soundOn = @"sound-2";
static NSString *soundOff = @"multimedia-2";

@interface TSSettingsController ()

@property (retain, nonatomic) IBOutlet UIButton *offSoundButton;

@end

@implementation TSSettingsController

- (IBAction)backAction:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)offSoundAction:(id)sender
{
    if (soundButton == YES) {
        soundButton = NO;
        UIImage *imgOff = [UIImage imageNamed:soundOff];
        [_offSoundButton setImage:imgOff forState:UIControlStateNormal];
    } else {
        soundButton = YES;
        UIImage *imgOff = [UIImage imageNamed:soundOn];
        [_offSoundButton setImage:imgOff forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    [_offSoundButton release];
    [super dealloc];
}
@end
