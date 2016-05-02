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
#import "TSShotsIndication.h"

static NSString *backgroundSheet = @"battle";
static NSString *buttonImgYes = @"button yes";
static NSString *buttonImgNo = @"button no";
static NSInteger sideBotton = 50;

@interface TSGameController () <TSCalculationServiceDelegate, TSCalculationOfResponseShotsDelegate, TSAutomaticLocationDelegate>

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
    self.shots = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    for (int i = 0; i < self.collectionShip.count; i++) {
        UIView * currentShipView = [self.collectionShip objectAtIndex:i];
        [self.view addSubview:currentShipView];
    }
    _arrowIndication.image = [UIImage imageNamed:@"arrowGreen"];
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(getNotificationTSGameController:)
                               name:TSCalculatResponseColorArrowDidChangeNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(getNotificationTSCalculationService:)
                               name:TSCalculationServiceColorArrowDidChangeNotification
                             object:nil];
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint locationPoint = [touch locationInView:self.view];
    if (positionButtonStart == YES) {
        _servise = [[TSCalculationService alloc] init];
        _servise.delegate = self;
        [_servise calculateTheAreaForRectangle:locationPoint ships:self.collectionEnemyShip shots:self.shots];
    }
}

#pragma mark - TSCalculationServiceDelegate

- (void)calculationResponseView:(CGRect)rect color:(UIColor *)color
{
    [self noteShot:rect color:color];
}

#pragma mark - TSCalculationOfResponseShotsDelegate

- (void)calculationEnemyShotView:(CGRect)rect point:(CGPoint)point color:(UIColor *)color
{
    [self noteShot:rect color:color];
}

#pragma mark - After firing indication

- (void)noteShot:(CGRect)rect color:(UIColor *)color
{
    UIView *shot = [TSShotsIndication viewNoteShot:rect color:color parentVIew:self.view view:_hitView];
    [self.shots addObject:shot];
}

#pragma mark - Enemy shot

- (void)transitionProgress
{
    _responseShots = [[TSCalculationOfResponseShots alloc] init];
    _responseShots.delegate = self;
    [_responseShots shotRequest:self.collectionShip shots:self.shots];
    
    if (soundButton == YES) {
        [[TSSoundManager sharedManager] shotSound];
    }
}

#pragma mark - Notification

- (void)getNotificationTSGameController:(NSNotification*)notification
{
    if ([[notification object] isEqualToString:@"Стрелка зеленая"]) {
         _arrowIndication.image = [UIImage imageNamed:@"arrowGreen"];
    } else if ([[notification object] isEqualToString:@"Стрелка красная"]) {
        _arrowIndication.image = [UIImage imageNamed:@"arrowRed"];
    }
}

- (void)getNotificationTSCalculationService:(NSNotification*)notification
{
     _arrowIndication.image = [UIImage imageNamed:@"arrowRed"];
}

#pragma mark - Actions and alert

- (IBAction)backAtion:(id)sender
{
    _alertView = [TSAlerts createdAlertGameOver:self.view];
    UIButton *buttonYes = [self buttonSelected:buttonImgYes x:40 y:50];
    UIButton *buttonNo = [self buttonSelected:buttonImgNo x:110 y:50];
    [buttonYes addTarget:self action:@selector(hangleButtonYes) forControlEvents:UIControlEventTouchUpInside];
    [buttonNo addTarget:self action:@selector(hangleButtonNo) forControlEvents:UIControlEventTouchUpInside];
    [_alertView addSubview:buttonYes];
    [_alertView addSubview:buttonNo];
}

- (IBAction)settinsAction:(id)sender {
    
    TSSettingsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSSettingsController"];
    [self presentViewController:controller animated:YES completion:nil];
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
    _button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, sideBotton, sideBotton)];
    UIImage *image = [UIImage imageNamed:question];
    [_button setImage:image forState:UIControlStateNormal];
    return _button;
}

- (void)hangleButtonYes
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hangleButtonNo
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         _alertView.frame = CGRectMake(184, 520, 200, 120);
                         _alertView.alpha = 0;
                     }];
}

- (void)userInteractionEnabled
{
    for (UIView *ship in self.collectionEnemyShip) {
        ship.userInteractionEnabled = NO;
    }
}

#pragma mark - Destruction of objects

- (void)dealloc {
    [_collectionShip release];
    [_collectionEnemyShip release];
    [_servise release];
    [_responseShots release];
    [_alertView release];
    [_button release];
    [_arrowIndication release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
