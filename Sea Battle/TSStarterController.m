//
//  TSStarterController.m
//  Sea Battle
//
//  Created by Mac on 21.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSStarterController.h"
#import "TSGameController.h"
#import "TSGeneratedPoint.h"
#import "TSCalculationOfResponseShots.h"
#import "TSAlerts.h"

static NSString *backgroundSheet = @"sheet";
static NSString *kKeyPositionSips = @"positionSips";
static NSString *warning = @"Расставьте пожалуйста все корабли на поле...";
static NSString *buttonImgOk = @"button Ok";
static BOOL positon = NO;
static BOOL loginID = YES;
static NSInteger called = 1;
static NSInteger sideBotton = 50;
BOOL positionButtonStart = NO;


@interface TSStarterController () <TSGeneratedPointDelegate>

@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *collectionShip;
@property (retain, nonatomic) UIView *currentView;
@property (retain, nonatomic) UIView *hitView;
@property (retain, nonatomic) UIView *alertView;
@property (retain, nonatomic) UIButton *button;
@property (retain, nonatomic) NSMutableArray *strings;
@property (retain, nonatomic) TSGeneratedPoint *generationPoint;

@end

@implementation TSStarterController

- (void)viewDidLoad
{
    UIImage *image = [UIImage imageNamed:backgroundSheet];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture release];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadPositionShips];
    if (loginID == YES) {
        loginID = NO;
        [self loadPositionShips];
    } else {
        [self loadPositionShips];
        loginID = YES;
    }
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint locationPoint = [touch locationInView:self.view];
    _currentView = [self.view hitTest:locationPoint withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    CGPoint locationPoint = [[touches anyObject] locationInView:self.view];
    _currentView.center = locationPoint;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    CGPoint point = _currentView.frame.origin;
    _generationPoint = [[TSGeneratedPoint alloc] init];
    _generationPoint.delegate = self;
    [_generationPoint correctPlacementShip:point view:_currentView tag:_currentView.tag ships:self.collectionShip];
}

#pragma mark - TSGeneratedPointDelegate

- (void)pointTransmission:(CGPoint)point
{
    for (UIView *ship in self.collectionShip) {
        if (CGRectContainsRect(ship.frame, _currentView.frame)) {
            CGRect frame = CGRectMake(point.x + 22, point.y,
                                     _currentView.frame.size.width, _currentView.frame.size.height);
            _currentView.frame = frame;
        }
    }
    CGRect frame = CGRectMake(point.x, point.y, _currentView.frame.size.width, _currentView.frame.size.height);
    _currentView.frame = frame;
}

#pragma mark - UITapGestureRecognizer

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGesture
{
    if (positon == NO) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             _currentView.transform = CGAffineTransformMakeRotation(M_PI / 2);
                         }];
        positon = YES;
    } else {
        [UIView animateWithDuration:0.2
                         animations:^{
                             _currentView.transform = CGAffineTransformMakeRotation(M_PI);
                         }];
        positon = NO;
    }
}

#pragma mark - Actions

- (IBAction)nextAction:(id)sender
{
    for (UIView *ship in self.collectionShip) {
        NSString *identifier = nil;
        if (ship.frame.origin.x > 300) {
                identifier = @"ship";
            } else {
                identifier = @"next";
            }
        _strings = [[NSMutableArray alloc] init];
        [_strings addObject:identifier];
    }
    [self determineThePositionOfShips];
}

- (void)determineThePositionOfShips
{
    for (NSString *stringIdent in _strings) {
        
            if ([stringIdent isEqualToString:@"next"]) {
                [self transitionToTheNextController];
                called++;
        } else {
            if (called == 1) {
                _alertView = [TSAlerts sharedAlert:self.view text:warning];
                [self viewButtonsOnTheAddition:_alertView];
                called++;
            }
        }
    }
    called = 1;
    _strings = nil;
}

- (void)viewButtonsOnTheAddition:(UIView *)parentView
{
    UIButton *buttonNo = [self buttonSelected:buttonImgOk];
    [buttonNo addTarget:self action:@selector(hangleButtonOk) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:buttonNo];
    positionButtonStart = NO;
}

- (UIButton *)buttonSelected:(NSString *)answer
{
    _button = [[UIButton alloc] initWithFrame:CGRectMake(sideBotton + 25, sideBotton + 20, sideBotton, sideBotton)];
    _button.backgroundColor = [UIColor blueColor];
    UIImage *image = [UIImage imageNamed:answer];
    [_button setImage:image forState:UIControlStateNormal];
    return _button;
}

- (void)hangleButtonOk
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         _alertView.frame = CGRectMake(184, 520, 200, 120);
                     }];
}

- (void)transitionToTheNextController
{
    TSGameController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSGameController"];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self presentViewController:controller animated:NO completion:nil];
    controller.collectionShip = self.collectionShip;
    positionButtonStart = YES;
    resolution = YES;
}

//  код дублировал что бы сохранить анимацию перехода екрана как с навигейшн контроллером

- (IBAction)backAction:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Save and load position ships

- (void)savePositionShips
{
    NSMutableArray *archivePositionShips = [NSMutableArray arrayWithCapacity:self.collectionShip.count];
    for (UIView * ship in self.collectionShip) {
        NSData * encodedObjectShip = [NSKeyedArchiver archivedDataWithRootObject:ship];
        [archivePositionShips addObject:encodedObjectShip];
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:archivePositionShips forKey:kKeyPositionSips];
    [userDefaults synchronize];
}

- (void)loadPositionShips
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *positionShips = [userDefaults objectForKey:kKeyPositionSips];
    for (int i = 0; i < positionShips.count; i++) {
        UIView * currentShipView = [self.collectionShip objectAtIndex:i];
        [self.view addSubview:currentShipView];
    }
}

#pragma mark - Destruction of objects

- (void)dealloc {
    [_collectionShip release];
    [_hitView release];
    [_alertView release];
    [_button release];
    _currentView = nil;
    [super dealloc];
}
@end
