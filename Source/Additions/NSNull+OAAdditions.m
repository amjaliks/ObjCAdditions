//
//  NSNull+OAAdditions.m
//  ObjCAdditions-iOS
//
//  Created by Aleksejs Mjaliks on 11.03.19.
//  Copyright 2011 A25. All rights reserved.
//

#import "NSNull+OAAdditions.h"


@implementation NSNull (OAAdditions)

+ (id)isNull:(id)object {
	return object == [NSNull null] ? nil : object;
}

@end
