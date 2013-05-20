//
//  OANetworkActivityIndicator.m
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

#import "OANetworkActivityIndicator.h"

@implementation OANetworkActivityIndicator

+ (OANetworkActivityIndicator *)networkActivityIndicator
{
	static dispatch_once_t pred;
	static OANetworkActivityIndicator *networkActivityIndicator = nil;
	dispatch_once(&pred, ^{ networkActivityIndicator = [[self alloc] init]; });
	
	return networkActivityIndicator;
}

- (void)show {
    dispatch_async(dispatch_get_main_queue(), ^{
		showCount++;
		if (showCount > 0) [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
}

- (void)hide {
    [self hideAfterDelay:0.0f];
}

- (void)hideAfterDelay:(NSTimeInterval)interval {
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
		showCount--;
		if (showCount <= 0) [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
}

@end
