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

static NSString *backgroundSheet = @"sheet";
static NSString *kKeyPositionSips = @"positionSips";
static BOOL positon = NO;
static BOOL loginID = YES;
BOOL positionButtonStart = NO;

@interface TSStarterController () <TSGeneratedPointDelegate>

@property (retain, nonatomic) IBOutletCollection(UIView) NSArray *collectionShip;
@property (retain, nonatomic) UIView *currentView;
@property (retain, nonatomic) UIView *hitView;
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
    [self loadPositionShips];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [_generationPoint receivingPoint:point view:_currentView tag:_currentView.tag];
}

#pragma mark - TSGeneratedPointDelegate

- (void)pointTransmission:(CGPoint)point
{
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

- (IBAction)nextAction:(id)sender
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
    [self savePositionShips];
    positionButtonStart = YES;
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


- (void)dealloc {
    [_collectionShip release];
    _currentView = nil;
    [_hitView release];
    [super dealloc];
}
@end
