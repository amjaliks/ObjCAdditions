//
//  OAStringBundle.m
//  ObjCAdditions
//
// Copyright 2011 A25 SIA
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "OAStringBundle.h"

NSString * const OAStringBundleDidLoadStringsNotification = @"OAStringBundleDidLoadStringsNotification";
NSString * const OAStringBundleDidReloadStringsNotification = @"OAStringBundleDidReloadStringsNotification";


@interface OAStringBundle ()

@property (copy, nonatomic) NSString *defaultLocalization;

- (NSString *)preferredLocalization;
- (void)loadLocalization:(NSString *)localization;

@end


@implementation OAStringBundle

+ (OAStringBundle *)bundle
{
	static dispatch_once_t pred;
	static OAStringBundle *bundle = nil;
	dispatch_once(&pred, ^{ bundle = [[self alloc] init]; });
	
	return bundle;
}

+ (NSString *)localization
{
    return [self bundle].localization;
}

+ (NSString *)localizedStringForKey:(NSString *)key
{
    return [[self bundle] localizedStringForKey:key];
}

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value
{
	return [[self bundle] localizedStringForKey:key value:value];
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_defaultLocalization = @"en";
	}
	return self;
}

- (NSString *)localization
{
	return localization;
}

- (NSString *)localizedStringForKey:(NSString *)key
{
	return [self localizedStringForKey:key value:key];
}

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value
{
	NSString *string = strings[key];
	return string ? string : value;
}

- (NSString *)preferredLocalization {
	for (NSString *preferred in [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]) {
		for (NSString *available in [[NSBundle mainBundle] localizations]) {
			if ([preferred hasPrefix:available]) {
				return available;
			}
		}
	}
	return self.defaultLocalization;
}

- (void)loadLocalization:(NSString *)newLocalization {
	if (![newLocalization isEqualToString:localization]) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:newLocalization];
		NSDictionary *tmpStrings = [NSDictionary dictionaryWithContentsOfFile:path];
		if (tmpStrings) {
			strings = tmpStrings;
			localization = newLocalization;
		}
        [[NSNotificationCenter defaultCenter] postNotificationName:OAStringBundleDidLoadStringsNotification object:self];
	}
}

- (void)reloadStrings {
	[self loadLocalization:[self preferredLocalization]];
	[[NSNotificationCenter defaultCenter] postNotificationName:OAStringBundleDidReloadStringsNotification object:self];
}

@end
