//
//  OASound.m
//  ObjCAdditions-iOS
//
//  Created by Aleksejs Mjaliks on 10.12.30.
//  Copyright 2010 A25. All rights reserved.
//

#import "OASound.h"


@implementation OASound

@synthesize type;
@synthesize name;

@synthesize systemSoundID;
@synthesize aqData;

- (id)initWithType:(OASoundType)newType name:(NSString *)newName {
	self = [self init];
	if (self) {
		self.type = newType;
		self.name = newName;
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
	
	self.name = nil;
}

@end
