//
//  NSUserDefaultsAdditions.m
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

#import "NSUserDefaultsAdditions.h"

#define kCenterLat @"centerLat"
#define kCenterLon @"centerLon"
#define kSpanLat @"spanLat"
#define kSpanLon @"spanLon"

@implementation NSUserDefaults (NSUserDefaultsAdditions)

- (MKCoordinateRegion)coordinateRegionForKey:(NSString *)key {
	NSDictionary *regionDictionary = [self dictionaryForKey:key];
	
	CLLocationDegrees lat = [[regionDictionary objectForKey:kCenterLat] doubleValue];
	CLLocationDegrees lon = [[regionDictionary objectForKey:kCenterLon] doubleValue];
	CLLocationDegrees latDelta = [[regionDictionary objectForKey:kSpanLat] doubleValue];
	CLLocationDegrees lonDelta = [[regionDictionary objectForKey:kSpanLon] doubleValue];
	
	CLLocationCoordinate2D center = {lat, lon};
	MKCoordinateSpan span = MKCoordinateSpanMake(latDelta, lonDelta);
	
	return MKCoordinateRegionMake(center, span);
}

- (void)setCoordinateRegion:(MKCoordinateRegion)region forKey:(NSString *)key {
	NSDictionary *regionDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithDouble:region.center.latitude], kCenterLat,
									  [NSNumber numberWithDouble:region.center.longitude], kCenterLon,
									  [NSNumber numberWithDouble:region.span.latitudeDelta], kSpanLat,
									  [NSNumber numberWithDouble:region.span.longitudeDelta], kSpanLon, nil];
	[self setObject:regionDictionary forKey:key];
}

@end
