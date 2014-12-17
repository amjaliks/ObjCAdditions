//
//  UIView+OAAdditions.m
//  ObjCAdditions
//
//  Copyright (c) 2014 Aleksejs Mjaliks
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

#import "UIView+OAAdditions.h"

@implementation UIView (OAAdditions)

+ (instancetype)viewWithBackgroundColor:(UIColor *)color
{
    UIView *view = [[self alloc] init];
    view.backgroundColor = color;
    return view;
}

- (void)alignVerticallyView:(UIView *)view left:(CGFloat)left
{
	[view sizeToFit];
	
	CGSize viewSize = view.frame.size;
	view.frame = CGRectMake(left, floorf((self.bounds.size.height - viewSize.height) / 2.0f), viewSize.width, viewSize.height);
}

- (void)alignVerticallyView:(UIView *)view right:(CGFloat)right
{
	[view sizeToFit];
	
	CGSize viewSize = view.frame.size;
	view.frame = CGRectMake(self.bounds.size.width - viewSize.width - right, floorf((self.bounds.size.height - viewSize.height) / 2.0f), viewSize.width, viewSize.height);
}

- (UIView *)findFirstResponder
{
    if (self.isFirstResponder) return self;
    for (UIView *subview in self.subviews) {
        return [subview findFirstResponder];
    }
    return nil;
}

@end
