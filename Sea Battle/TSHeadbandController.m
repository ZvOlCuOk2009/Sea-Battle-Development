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
#import "TSButton.h"

static NSInteger counter = 1;

@interface TSHeadbandController ()

@property (retain, nonatomic) IBOutlet UIButton *gameCompButton;
@property (retain, nonatomic) IBOutlet UIButton *gameBluetoothButton;
@property (retain, nonatomic) IBOutlet UIView *loadingIndicatorView;
@property (retain, nonatomic) TSFloatingRepresentation *infoBanner;

@end

@implementation TSHeadbandController

-  (void)viewWillAppear:(BOOL)animated
{
    if (counter == 1) {
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
        counter++;
    }
}

- (void)startScene
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

- (void)nextAction
{
    [UIView animateWithDuration:1.0
                     animations:^{
                         _infoBanner.frame = CGRectMake(self.view.bounds.size.width - 497, self.view.bounds.size.height + 280, self.view.bounds.size.width - 142, self.view.bounds.size.height - 80);
                     }];
    [self startScene];
}

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

- (void)dealloc {
    [_gameCompButton release];
    [_gameBluetoothButton release];
    [_loadingIndicatorView release];
    [_infoBanner release];
    [super dealloc];
}
@end
