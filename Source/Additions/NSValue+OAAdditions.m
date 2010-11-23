//
//  NSValue+OAAdditions.m
//  ACConsole
//
//  Created by Aleksejs Mjaliks on 10.11.22.
//  Copyright 2010 A25. All rights reserved.
//

#import "NSValue+OAAdditions.h"


@implementation NSValue (OAAdditions)

#if TARGET_OS_IPHONE != 1

+ (NSValue *)valueWithCGPoint:(CGPoint)point {
	return [NSValue valueWithPoint:point];
}

- (CGPoint)CGPointValue {
	return [self pointValue];
}

#endif

@end
