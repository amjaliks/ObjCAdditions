//
//  CGGeometry+OAAdditions.m
//  ObjCAdditions
//
//  Copyright (c) 2011 A25 SIA
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


#import "CGGeometry+OAAdditions.h"

CGRect CGRectCentredInRect(CGRect a, CGRect b, BOOL floor) {
	a.origin.x = b.origin.x + (b.size.width - a.size.width) / 2.0f;
	a.origin.y = b.origin.y + (b.size.height - a.size.height) / 2.0f;
	
	if (floor) {
		a.origin.x = floorf(a.origin.x);
		a.origin.y = floorf(a.origin.y);
	}
	
	return a;
}

CGRect CGRectBottom(CGRect a, CGFloat b) {
	CGFloat dy = a.size.height - b;
	a.origin.y += dy;
	a.size.height = b;
	
	return a;
}

CGRect CGRectScale(CGRect rect, CGFloat scale) {
	CGFloat mult = - (1.0f - scale);
	CGFloat offsetX = rect.size.width * mult;
	CGFloat offsetY = rect.size.height * mult;
	return CGRectMake(rect.origin.x - offsetX / 2.0f, rect.origin.y - offsetY / 2.0f, rect.size.width + offsetX, rect.size.height + offsetY);
}
