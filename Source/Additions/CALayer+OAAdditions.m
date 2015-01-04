//
// Created by Aleksejs Mjaliks on 04.01.15.
// Copyright (c) 2015 A25 SIA. All rights reserved.
//

#import "CALayer+OAAdditions.h"
#import "CAAnimation+OAAdditions.h"


@implementation CALayer (OAAdditions)

- (void)addFadeTransitionAnimationWithDuration:(NSTimeInterval)duration
{
    [self addAnimation:[CATransition animationWithDuration:duration] forKey:kCATransition];
}

@end