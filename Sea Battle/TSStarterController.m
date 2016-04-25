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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (loginID == YES) {
       // [self savePositionShips];
        loginID = NO;
    } else {
        [self loadPositionShips];
        loginID = YES;
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [self savePositionShips];
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
    positionButtonStart = YES;
}

#pragma mark - Save of locations of ships

- (void)savePositionShips
{
    /*
    for (int i = 0; i < [self.collectionShip count]; ++i) {
        UIView *ship = [self.collectionShip objectAtIndex:i];
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *keyX = [NSString stringWithFormat:@"origin.x %d", i];
        NSString *keyY = [NSString stringWithFormat:@"origin.y %d", i];
        NSString *keyWidth = [NSString stringWithFormat:@"width %d", i];
        NSString *keyHeight = [NSString stringWithFormat:@"height %d", i];

        [userDefaults setFloat:ship.frame.origin.x forKey:keyX];
        [userDefaults setFloat:ship.frame.origin.y forKey:keyY];
        [userDefaults setFloat:ship.frame.size.width forKey:keyWidth];
        [userDefaults setFloat:ship.frame.size.height forKey:keyHeight];
        [userDefaults synchronize];
    }
     */
    
    NSMutableArray *archivePositionShips = [NSMutableArray arrayWithCapacity:self.collectionShip.count];
    for (UIView * ship in self.collectionShip) {
        NSData * encodedObjectShip = [NSKeyedArchiver archivedDataWithRootObject:ship];
        [archivePositionShips addObject:encodedObjectShip];
        NSLog(@"ship - x = %1.1f, y = %1.1f, width = %1.1f, height = %1.1f", ship.frame.origin.x, ship.frame.origin.y,
              ship.frame.size.width, ship.frame.size.height);
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:archivePositionShips forKey:kKeyPositionSips];
    [userDefaults synchronize];
}

- (void)loadPositionShips
{
    /*
     for (int i = 0; i < [self.collectionShip count]; ++i) {
     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
     NSString *keyX = [NSString stringWithFormat:@"origin.x %d", i];
     NSString *keyY = [NSString stringWithFormat:@"origin.y %d", i];
     NSString *keyWidth = [NSString stringWithFormat:@"width %d", i];
     NSString *keyHeight = [NSString stringWithFormat:@"height %d", i];
     
     CGFloat x = [[userDefaults objectForKey:keyX] floatValue];
     CGFloat y = [[userDefaults objectForKey:keyY] floatValue];
     CGFloat width = [[userDefaults objectForKey:keyWidth] floatValue];
     CGFloat height = [[userDefaults objectForKey:keyHeight] floatValue];
     
     CGRect frame = CGRectMake(x, y, width, height);
     UIView *view = [self.collectionShip objectAtIndex:i];
     view.frame = frame;
     }
     */
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *positionShips = [userDefaults objectForKey:kKeyPositionSips];
    for (int i = 0; i < positionShips.count; i++) {
        UIView * currentShipView = [self.collectionShip objectAtIndex:i];
        [self.view addSubview:currentShipView];
    }
}


- (void)dealloc {
//    [_collectionShip release];
//    [_currentView release];
//    [_hitView release];
    [super dealloc];
}
@end
