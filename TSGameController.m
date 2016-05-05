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
static NSString *victory = @"Вы победили!!!\n Играть еще?";
static NSString *defeat = @"Вы проиграли!!!\n Играть еще?";
static NSString *alert = @"Закончить игру?";

@interface TSGameController () <TSCalculationServiceDelegate,TSCalculationOfResponseShotsDelegate,TSAutomaticLocationDelegate>

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
                               name:TSResponseColorArrowDidChangeNotification
                             object:nil];
    
    [notificationCenter addObserver:self
                           selector:@selector(getNotificationTSCalculationService:)
                               name:TSServiceColorArrowDidChangeNotification
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

#pragma mark - TSAutomaticLocationDelegate

- (void)translationLocationFleet:(NSArray *)ships
{
    for (UIView *ship in ships) {
        ship.backgroundColor = [UIColor greenColor];
        [self.view addSubview:ship];
    }
}

#pragma mark - After firing indication

- (void)noteShot:(CGRect)rect color:(UIColor *)color
{
    UIView *shot = [TSShotsIndication viewNoteShot:rect color:color parentVIew:self.view view:_hitView];
    [_shots addObject:shot];
}

#pragma mark - Enemy shot

- (void)transitionProgress
{
    if (positionButtonStart == YES) {
        _responseShots = [[TSCalculationOfResponseShots alloc] init];
        _responseShots.delegate = self;
        [_responseShots shotRequest:self.collectionShip shots:self.shots];
        
        if (soundButton == YES) {
            [[TSSoundManager sharedManager] shotSound];
        }
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

#pragma mark - Alerts

- (IBAction)backAtion:(id)sender
{
    _alertView = [TSAlerts sharedAlert:self.view text:alert];
    [self viewButtonsOnTheAddition:_alertView coordinateXValue:50];
}

- (void)alertVictory
{
    _alertView = [TSAlerts sharedAlert:self.view text:victory];
    [self viewButtonsOnTheAddition:_alertView coordinateXValue:65];
}

- (void)alertDefeat
{
    _alertView = [TSAlerts sharedAlert:self.view text:defeat];
    [self viewButtonsOnTheAddition:_alertView coordinateXValue:65];
}

#pragma mark - Actions

- (IBAction)settinsAction:(id)sender {
    
    TSSettingsController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"TSSettingsController"];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)avtoAction:(id)sender {
    
    TSAutomaticLocationTheFleet *autiomatic = [[TSAutomaticLocationTheFleet alloc] init];
    autiomatic.delegate = self;
    [autiomatic requestCollectionShips:self.collectionEnemyShip];
}

- (void)viewButtonsOnTheAddition:(UIView *)parentView coordinateXValue:(NSInteger)coordinateXValue
{
    UIButton *buttonYes = [self buttonSelected:buttonImgYes x:40 y:coordinateXValue];
    UIButton *buttonNo = [self buttonSelected:buttonImgNo x:110 y:coordinateXValue];
    [buttonYes addTarget:self action:@selector(hangleButtonYes) forControlEvents:UIControlEventTouchUpInside];
    [buttonNo addTarget:self action:@selector(hangleButtonNo) forControlEvents:UIControlEventTouchUpInside];
    [parentView addSubview:buttonYes];
    [parentView addSubview:buttonNo];
    positionButtonStart = NO;
}

#pragma mark - Button Alert

- (UIButton *)buttonSelected:(NSString *)question  x:(CGFloat)x y:(CGFloat)y
{
    _button = [[UIButton alloc] initWithFrame:CGRectMake(x, y, sideBotton, sideBotton)];
    UIImage *image = [UIImage imageNamed:question];
    [_button setImage:image forState:UIControlStateNormal];
    return _button;
}

#pragma mark - Selectors

- (void)hangleButtonYes
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)hangleButtonNo
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         _alertView.frame = CGRectMake(184, 520, 200, 120);
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
    _shots = nil;
    [super dealloc];
}

@end
