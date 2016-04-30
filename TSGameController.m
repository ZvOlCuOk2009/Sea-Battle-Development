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
static NSInteger sideBotton = 50;

static NSInteger counter = 1;

static NSString *kKeyPositionSips = @"keyPositionSips";

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
    [self loadPositionShips];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSMutableArray *archivePositionShips = [NSMutableArray array];
    for (UIView *ship in self.collectionShip) {
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
        UIView *currentShipView = [self.collectionShip objectAtIndex:i];
        [self.view addSubview:currentShipView];
    }
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
    BOOL verification = CGRectContainsPoint(_hitView.frame, point);
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
    UIView *shot = [TSAlerts viewNoteShot:rect color:color parentVIew:self.view view:_hitView];
    [self.shots addObject:shot];
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

- (IBAction)backAtion:(id)sender {
 
//    if (userInteractionAlert == NO) {
        _alertView = [TSAlerts createdAlertGameOver:self.view];
        UIButton *buttonYes = [self buttonSelected:buttonImgYes x:40 y:50];
        UIButton *buttonNo = [self buttonSelected:buttonImgNo x:110 y:50];
        [buttonYes addTarget:self action:@selector(hangleButtonYes) forControlEvents:UIControlEventTouchUpInside];
        [buttonNo addTarget:self action:@selector(hangleButtonNo) forControlEvents:UIControlEventTouchUpInside];
        [_alertView addSubview:buttonYes];
        [_alertView addSubview:buttonNo];
//        userInteractionAlert = YES;
//    }
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
        NSLog(@"Point %ld - x = %1.1f, y = %1.1f", (long)counter++, ship.frame.origin.x, ship.frame.origin.y);
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
//    userInteractionAlert = NO;
}

- (void)hangleButtonNo
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         _alertView.frame = CGRectMake(184, 520, 200, 120);
                         _alertView.alpha = 0;
                     }];
//        userInteractionAlert = NO;
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
