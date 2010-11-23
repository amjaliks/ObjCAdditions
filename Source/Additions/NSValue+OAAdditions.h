//
//  NSValue+OAAdditions.h
//  ACConsole
//
//  Created by Aleksejs Mjaliks on 10.11.22.
//  Copyright 2010 A25. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSValue (OAAdditions)

#if TARGET_OS_IPHONE != 1

/**
 Compatibillity with iOS SDK
 */
+ (NSValue *)valueWithCGPoint:(CGPoint)point;

#endif

@end
