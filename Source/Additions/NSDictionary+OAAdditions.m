//
//  NSDictionary+OAAdditions.m
//  ObjCAdditions
//
//  Copyright (c) 2010 A25 SIA
//  
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSDictionary+OAAdditions.h"


@implementation NSDictionary (OAAdditions)

+ (NSDictionary *)dictionaryWithCGPointValue:(CGPoint)point {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithFloat:point.x], @"x",
			[NSNumber numberWithFloat:point.y], @"y", nil];
}

+ (NSDictionary *)dictionaryWithCGSizeValue:(CGSize)size {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithFloat:size.width], @"width",
			[NSNumber numberWithFloat:size.height], @"height", nil];
}


- (id)objectForKey:(id)key defaultObject:(id)defaultObject {
	id object = [self objectForKey:key];
	
	if (object) {
		return object;
	} else {
		return defaultObject;
	}
}

- (CGPoint)CGPointValue {
	CGPoint point;
	point.x = [[self valueForKey:@"x"] floatValue];
	point.y = [[self valueForKey:@"y"] floatValue];
	return point;
}

- (CGSize)CGSizeValue {
	CGSize size;
	size.width = [[self valueForKey:@"width"] floatValue];
	size.height = [[self valueForKey:@"height"] floatValue];
	return size;
}

@end
