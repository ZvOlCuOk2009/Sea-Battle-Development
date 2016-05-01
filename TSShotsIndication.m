//
//  TSShotsIndication.m
//  Sea Battle
//
//  Created by Mac on 30.04.16.
//  Copyright © 2016 Tsvigun Alexandr. All rights reserved.
//

#import "TSShotsIndication.h"

@implementation TSShotsIndication

#pragma mark - Created view note shot

+ (UIView *)viewNoteShot:(CGRect)frame color:(UIColor *)color parentVIew:(UIView *)parentVIew view:(UIView *)view
{
    view = [[[UIView alloc] initWithFrame:frame] autorelease];
    view.backgroundColor = color;
    view.alpha = 0.7f;
    view.userInteractionEnabled = NO;
    [parentVIew bringSubviewToFront:view];
    [parentVIew addSubview:view];
    return view;
}

@end
