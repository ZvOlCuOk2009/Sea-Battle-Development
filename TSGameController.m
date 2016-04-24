//
//  TSGameController.m
//  Sea Battle
//
//  Created by Mac on 16.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSGameController.h"
#import "TSCalculationService.h"
#import "TSCalculationOfResponseShots.h"
#import "TSGeneratedPoint.h"
#import "TSSoundManager.h"
#import "TSStarterController.h"
#import "TSAlerts.h"
#import "TSSettingsController.h"
#import "TSAutomaticLocationTheFleet.h"

static BOOL userInteractionAlert = NO;
static NSString *backgroundSheet = @"battle";
static NSString *buttonImgYes = @"button yes";
static NSString *buttonImgNo = @"button no";

@interface TSGameController () <TSCalculationServiceDelegate, TSCalculationOfResponseShotsDelegate, TSAutomaticLocationDelegate>

//@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *collectionShip;
@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *collectionEnemyShip;
@property (retain, nonatomic) UIView *hitView;
@property (retain, nonatomic) UIView *alertView;
@property (retain, nonatomic) UIButton *button;

@property (retain, nonatomic) TSCalculationService *servise;
@property (retain, nonatomic) TSCalculationOfResponseShots *responseShots;

@end

@implementation TSGameController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:backgroundSheet];
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (int i = 0; i < self.collectionShip.count; i++) {
        
        UIView * currentShipView = [self.collectionShip objectAtIndex:i];
        NSLog(@"currentShipView %d - x = %1.1f, y = %1.1f, width = %1.1f, height = %1.1f", i, currentShipView.frame.origin.x, currentShipView.frame.origin.y, currentShipView.frame.size.width, currentShipView.frame.size.height);
        [self.view addSubview:currentShipView];
    }
//    [self loadData];
}

#pragma mark -

- (void)transitionLocation:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height
{
    CGRect frame = CGRectMake(x, y, width, height);
    UIView *ship = [[UIView alloc]initWithFrame:frame];
    ship.backgroundColor = [UIColor redColor];
    [self.view addSubview:ship];
//    NSLog(@"Game x = %1.1f, y = %1.1f, wid = %1.1f, hei = %1.1f", x, y, width, height);
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint locationPoint = [touch locationInView:self.view];
    if (positionButtonStart == YES) {
        BOOL verification = CGRectContainsPoint(_hitView.frame, locationPoint); // для предотвращения повторного нажатия
        if (verification == NO) {
            if (userInteractionAlert == NO) {
                _servise = [[TSCalculationService alloc] init];
                _servise.delegate = self;
                [_servise calculateTheAreaForRectangle:locationPoint ships:self.collectionEnemyShip];
                if (soundButton == YES) {
                    [[TSSoundManager sharedManager] shotSound];
                }
            }
        } else {
            NSLog(@"ПОВТОР!");
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    
}

#pragma mark - TSCalculationServiceDelegate

- (void)calculationResponseView:(CGRect)rect color:(UIColor *)color
{
    [self noteShot:rect color:color];
}

#pragma mark - TSCalculationOfResponseShotsDelegate

- (void)calculationEnemyShotView:(CGRect)rect point:(CGPoint)point color:(UIColor *)color
{
    BOOL verification = CGRectContainsPoint(_hitView.frame, point);
//    NSLog(@"HitView.frame x = %ld, y = %ld, width = %ld, height = %ld,", (long)_hitView.frame.origin.x,
//                                                                         (long)_hitView.frame.origin.x,
//                                                                         (long)_hitView.frame.size.width,
//                                                                         (long)_hitView.frame.size.height);
    if (verification == NO) {
        [self noteShot:rect color:color];
    } else {
        NSLog(@"ПОВТОР ПРОТИВНИК!!!");
        [self transitionProgress];
    }
}

#pragma mark - After firing indication

- (void)noteShot:(CGRect)rect color:(UIColor *)color
{
    [TSAlerts viewNoteShot:rect color:color parentVIew:self.view view:_hitView];
}

#pragma mark - Enemy shot

- (void)transitionProgress
{
    _responseShots = [[TSCalculationOfResponseShots alloc] init];
    _responseShots.delegate = self;
    [_responseShots shotRequest:self.collectionShip];
    
    if (soundButton == YES) {
        [[TSSoundManager sharedManager] shotSound];
    }
}

#pragma mark - Actions and alert

- (IBAction)backAtion:(id)sender {
 
    if (userInteractionAlert == NO) {
        _alertView = [TSAlerts createdAlertGameOver:self.view];
        UIButton *buttonYes = [self buttonSelected:buttonImgYes x:40 y:50];
        UIButton *buttonNo = [self buttonSelected:buttonImgNo x:110 y:50];
        [buttonYes addTarget:self action:@selector(hangleButtonYes) forControlEvents:UIControlEventTouchUpInside];
        [buttonNo addTarget:self action:@selector(hangleButtonNo) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:buttonYes];
        [_alertView addSubview:buttonNo];
        userInteractionAlert = YES;
    }
}

- (IBAction)avtoAction:(id)sender {
    
    TSAutomaticLocationTheFleet *autiomatic = [[TSAutomaticLocationTheFleet alloc] init];
    autiomatic.delegate = self;
    [autiomatic requestCollectionShips:self.collectionEnemyShip];
}

- (void)translationLocationFleet:(NSArray *)ships
{
    for (UIView *ship in ships) {
        ship.backgroundColor = [UIColor greenColor];
        [self.view addSubview:ship];
    }
}

#pragma mark - Button Alert Game Over

- (UIButton *)buttonSelected:(NSString *)question  x:(CGFloat)x y:(CGFloat)y
{
    _button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, 50, 50)];
    UIImage *image = [UIImage imageNamed:question];
    [_button setImage:image forState:UIControlStateNormal];
    return _button;
}

- (void)hangleButtonYes
{
    [self dismissViewControllerAnimated:YES completion:nil];
    userInteractionAlert = NO;
}

- (void)hangleButtonNo
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         _alertView.frame = CGRectMake(184, 520, 200, 120);
                         _alertView.alpha = 0;
                     }];
        userInteractionAlert = NO;
}

- (void)userInteractionEnabled
{
    for (UIView *ship in self.collectionShip) {
        ship.userInteractionEnabled = NO;
    }
    for (UIView *ship in self.collectionEnemyShip) {
        ship.userInteractionEnabled = NO;
    }
}

#pragma mark - Destruction of objects

- (void)dealloc {
//    [_collectionShip release];
//    [_collectionEnemyShip release];
//    [_servise release];
//    [_responseShots release];
//    [_alertView release];
//    [_button release];
    [super dealloc];
}

@end
