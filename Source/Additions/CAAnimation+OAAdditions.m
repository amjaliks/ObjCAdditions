//
// Created by Aleksejs Mjaliks on 04.01.15.
// Copyright (c) 2015 A25 SIA. All rights reserved.
//

#import "CAAnimation+OAAdditions.h"


@implementation CAAnimation (OAAdditions)

+ (instancetype)animationWithDuration:(NSTimeInterval)duration
{
    CAAnimation *animation = [[self alloc] init];
    animation.duration = duration;
    return animation;
}

@end