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
#import "SynthesizeSingleton.h"

@interface OAStringBundle ()

@property (nonatomic,retain) NSString *loadedLocalization;
@property (nonatomic,retain) NSDictionary *strings;

- (NSString *)preferredLocalization;
- (void)loadLocalization:(NSString *)localization;
- (void)userDefaultsChanged:(NSNotification *)notification;

@end


@implementation OAStringBundle

@synthesize loadedLocalization;
@synthesize strings;

- (NSString *)localizedStringForKey:(NSString *)key {
	NSString *string = [self.strings objectForKey:key];
	return string ? string : key;
}

- (NSString *)preferredLocalization {
	for (NSString *localization in [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"]) {
		if ([[[NSBundle mainBundle] localizations] containsObject:localization]) {
			return localization;
		}
	}
	return @"en";
}

- (void)loadLocalization:(NSString *)localization {
	if (![localization isEqualToString:self.loadedLocalization]) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:localization];
		NSDictionary *tmpStrings = [NSDictionary dictionaryWithContentsOfFile:path];
		if (tmpStrings) {
			self.strings = tmpStrings;
			self.loadedLocalization = localization;
		}
	}
}

- (void)userDefaultsChanged:(NSNotification *)notification {
	[self loadLocalization:[self preferredLocalization]];
}

SYNTHESIZE_SINGLETON_FOR_CLASS_SHARED_NAME(OAStringBundle,bundle)

- (id)init {
	self = [super init];
	if (self) {
		[self loadLocalization:[self preferredLocalization]];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDefaultsChanged:) name:nil object:[NSUserDefaults standardUserDefaults]];
	}
	return self;
}

@end
