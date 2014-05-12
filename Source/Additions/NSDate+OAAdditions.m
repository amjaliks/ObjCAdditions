//
//  NSDate+OAAdditions.m
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

#import "NSDate+OAAdditions.h"
#import "ISO8601DateFormatter.h"

@implementation NSDate (OAAdditions)

+ (NSDate *)dateFromISO8601String:(NSString *)string {
	ISO8601DateFormatter *formater = [[ISO8601DateFormatter alloc] init];
	return [formater dateFromString:string];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
                    hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = year;
    comps.month = month;
    comps.day = day;
    comps.hour = hour;
    comps.minute = minute;
    comps.second = second;
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
}

+ (NSDate *)tomorrow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *today = [calendar dateFromComponents:[calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[NSDate date]]];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:1];
    return [calendar dateByAddingComponents:components toDate:today options:0];
}

- (BOOL)isToday
{
    return [self isSameDay:[NSDate date]];
}

- (BOOL)isTomorrow
{
    return [self isSameDay:[NSDate tomorrow]];
}

- (BOOL)isSameDay:(NSDate *)day
{
	NSCalendar *calendar = [NSCalendar currentCalendar];
	NSDateComponents *selfComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:self];
	NSDateComponents *dayComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:day];
	
	return selfComponents.year == dayComponents.year && selfComponents.month == dayComponents.month && selfComponents.day == dayComponents.day;
}

- (NSString *)formattedShortDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateStyle = NSDateFormatterShortStyle;
    return [formatter stringFromDate:self];
}

@end
