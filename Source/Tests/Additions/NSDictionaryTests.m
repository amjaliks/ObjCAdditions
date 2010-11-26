//
//  NSDictionaryTests.m
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

#import "NSDictionaryTests.h"
#import "NSDictionary+OAAdditions.h"

@implementation NSDictionaryTests

- (void)testDictionaryWithCGPointValue {
	NSDictionary *dictionary = [NSDictionary dictionaryWithCGPointValue:CGPointMake(1.0f, 2.0f)];
	STAssertEqualObjects([dictionary valueForKey:@"x"], [NSNumber numberWithFloat:1.0f], nil);
	STAssertEqualObjects([dictionary valueForKey:@"y"], [NSNumber numberWithFloat:2.0f], nil);
}

- (void)testDictionaryWithCGSizeValue {
	NSDictionary *dictionary = [NSDictionary dictionaryWithCGSizeValue:CGSizeMake(1.0f, 2.0f)];
	STAssertEqualObjects([dictionary valueForKey:@"width"], [NSNumber numberWithFloat:1.0f], nil);
	STAssertEqualObjects([dictionary valueForKey:@"height"], [NSNumber numberWithFloat:2.0f], nil);
}

- (void)testObjectForKeyDefaultObject {
	NSDictionary *dictionary = [NSDictionary dictionaryWithObject:@"testvalue" forKey:@"testkey"];
	STAssertEqualObjects([dictionary objectForKey:@"testkey" defaultObject:@"othervalue"], @"testvalue", nil);
	STAssertEqualObjects([dictionary objectForKey:@"otherkey" defaultObject:@"othervalue"], @"othervalue", nil);
}

- (void)testCGPointValue {
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithFloat:1.0f], @"x",
								[NSNumber numberWithFloat:2.0f], @"y", nil];
	STAssertTrue(CGPointEqualToPoint([dictionary CGPointValue], CGPointMake(1.0f, 2.0f)), nil);
}

- (void)testCGSizeValue {
	NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
								[NSNumber numberWithFloat:1.0f], @"width",
								[NSNumber numberWithFloat:2.0f], @"height", nil];
	STAssertTrue(CGSizeEqualToSize([dictionary CGSizeValue], CGSizeMake(1.0f, 2.0f)), nil);
}

@end
