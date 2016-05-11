//
//  TSHeadbandController.m
//  Sea Battle
//
//  Created by Mac on 21.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSHeadbandController.h"
#import "TSStarterController.h"
#import "TSFloatingRepresentation.h"
#import "TSAlerts.h"

static NSString *textMessage = @"Поиск уcтройств IPad или IPhone...";
static NSString *buttonCenc = @"Cancel";
static NSInteger sideBotton = 25;
static NSInteger firstInput = 1;

@interface TSHeadbandController ()

@property (retain, nonatomic) IBOutlet UIButton *gameCompButton;
@property (retain, nonatomic) IBOutlet UIButton *gameBluetoothButton;
@property (retain, nonatomic) IBOutlet UIView *loadingIndicatorView;
@property (retain, nonatomic) UIView *alertView;
@property (retain, nonatomic) UIButton *button;
@property (retain, nonatomic) TSFloatingRepresentation *infoBanner;

@end

@implementation TSHeadbandController

#pragma mark - Start screen


- (void)viewWillAppear:(BOOL)animated
{
    if (firstInput == 1) {
        [self callInfoBanner];
        [self firstInputLoad];
        firstInput++;
    } else {
        [self startSceneAnimation];
    }
}

#pragma mark - Info banner

- (void)callInfoBanner
{
    _infoBanner = [[TSFloatingRepresentation alloc] initWithInfoBanner:self.view];
    CGRect frame = CGRectMake(330, 200, 75, 30);
    UIButton *nextButton = [[[UIButton alloc] initWithFrame:frame] autorelease];
    [nextButton setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    [_infoBanner addSubview:nextButton];
    [UIView animateWithDuration:1.0
                     animations:^{
                         _infoBanner.frame = CGRectMake(self.view.bounds.size.width - 497, self.view.bounds.size.height - 280, self.view.bounds.size.width - 142, self.view.bounds.size.height - 80);
                         [self.view addSubview:_infoBanner];
                     }];
}

- (void)startSceneAnimation
{
    [UIView animateWithDuration:3.0
                     animations:^{
                         _loadingIndicatorView.frame = CGRectMake(146, 260, 277, 4);
                     }];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0
                         animations:^{
                             _gameCompButton.frame = CGRectMake(134, 65, 300, 44);
                             _gameBluetoothButton.frame = CGRectMake(134, 130, 300, 49);
                             _gameCompButton.alpha = 1;
                             _gameBluetoothButton.alpha = 1;
                             _loadingIndicatorView.alpha = 0;
                         }];
    });
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self firstInputSave];
}

- (void)nextAction
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         _infoBanner.frame = CGRectMake(self.view.bounds.size.width - 497, self.view.bounds.size.height + 280, self.view.bounds.size.width - 142, self.view.bounds.size.height - 80);
                     }];
    [self startSceneAnimation];
}

#pragma mark - Actions

- (IBAction)startAction:(id)sender
{
    TSStarterController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSStarterController"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:controller animated:NO completion:nil];
    [_loadingIndicatorView removeFromSuperview];
}

- (IBAction)bluetoothAction:(id)sender
{
    _alertView = [TSAlerts sharedAlert:self.view text:textMessage];
    [self viewButtonsOnTheAddition:_alertView];
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]
                                             initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityView.center = CGPointMake(_alertView.frame.size.width / 2.0, _alertView.frame.size.height / 2.0 + 20);
    [activityView startAnimating];
    [_alertView addSubview:activityView];
    [activityView release];
}

- (void)viewButtonsOnTheAddition:(UIView *)parentView
{
    UIButton *buttonCencel = [self buttonSelected:buttonCenc];
    buttonCencel.backgroundColor = [UIColor blueColor];
    [buttonCencel addTarget:self action:@selector(hangleButtonCencel) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:buttonCencel];
    positionButtonStart = NO;
}

- (UIButton *)buttonSelected:(NSString *)answer
{
    _button = [[UIButton alloc] initWithFrame:CGRectMake(sideBotton + 48, sideBotton + 65, sideBotton + 30, sideBotton)];
    _button.backgroundColor = [UIColor blueColor];
    UIImage *image = [UIImage imageNamed:answer];
    [_button setImage:image forState:UIControlStateNormal];
    return _button;
}

- (void)hangleButtonCencel
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         _alertView.frame = CGRectMake(184, 520, 200, 120);
                     }];
}

#pragma mark - Display information banner when you first log

- (void)firstInputSave
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:firstInput forKey:@"firstInput"];
    [userDefaults synchronize];
}

- (void)firstInputLoad
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    firstInput = [userDefaults integerForKey:@"firstInput"];
}

#pragma mark - Destruction of objects

- (void)dealloc {
    [_gameCompButton release];
    [_gameBluetoothButton release];
    [_loadingIndicatorView release];
    [_infoBanner release];
    [_gameCompButton release];
    [_button release];
    [super dealloc];
}
@end
