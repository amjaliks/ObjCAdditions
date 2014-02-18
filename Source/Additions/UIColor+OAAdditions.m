//
//  UIColor+OAAdditions.m
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

#import "UIColor+OAAdditions.h"

@implementation UIColor (OAAdditions)

+ (instancetype)colorNamed:(NSString *)name
{
    static NSDictionary *colors;
    static NSMutableDictionary *cache;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colors = [NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"Colors"
                                                                                   withExtension:@"plist"]];
        cache = [NSMutableDictionary dictionary];
    });
    
    @synchronized(cache) {
        UIColor *color = cache[name];
        if (color) return color;
        
        NSArray *components = colors[name];
        if (components) {
            color = [UIColor colorWithRed:[components[0] doubleValue] / 255.0
                                    green:[components[1] doubleValue] / 255.0
                                     blue:[components[2] doubleValue] / 255.0
                                    alpha:components.count >= 4 ? ([components[3] doubleValue] / 255.0) : 1.0];
            cache[name] = color;
            return color;
        }
    }
    return nil;
}

@end
