//
//  NSDate+OAAdditions.h
//  ObjCAdditions
//
//  Copyright (c) 2013 A25 SIA
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


@interface NSDate (OAAdditions)

/*
 Parses ISO8601 compliant formated string with date and returns NSDate
 */
+ (NSDate *)dateFromISO8601String:(NSString *)string;
/*
 * Convience method for NSDate object create with specific date and time.
 */
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                    hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
+ (NSDate *)tomorrow;

- (BOOL)isToday;
- (BOOL)isTomorrow;
- (BOOL)isSameDay:(NSDate *)date;

- (NSString *)formattedShortDate;

@end
