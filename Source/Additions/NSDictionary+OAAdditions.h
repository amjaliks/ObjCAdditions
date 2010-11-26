//
//  NSDictionary+OAAdditions.h
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

#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE == 1
#import <CoreGraphics/CoreGraphics.h>
#endif

@interface NSDictionary (OAAdditions)

/* Creates dictionary with value with keys 'x' and 'y' from CGPoint struct.
 */
+ (NSDictionary *)dictionaryWithCGPointValue:(CGPoint)point;

/* Creates dictionary with value with keys 'width' and 'height' from CGSize struct.
 */
+ (NSDictionary *)dictionaryWithCGSizeValue:(CGSize)size;

/* Returns the value associated with a given key. If no value is associated with the key, returns defaultObject.
 */
- (id)objectForKey:(id)key defaultObject:(id)defaultObject;

/* Creates CGPoint struct from values with keys 'x' and 'y'.
 */
- (CGPoint)CGPointValue;

/* Creates CGSize struct from values with keys 'width' and 'height'.
 */
- (CGSize)CGSizeValue;

@end
