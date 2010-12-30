//
//  OASoundManager.m
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

#import "OASoundManager.h"
#import "OASound.h"
#import "SynthesizeSingleton.h"

@implementation OASoundManager

- (NSNumber *)registerSystemSound:(NSString *)name {
	// create sound handler
	OASound *sound = [[OASound alloc] initWithType:OASystemSound name:name];
	
	// URL for sound file
	NSURL *soundURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"caf"];
	CFURLRef soundURLRef = (CFURLRef) soundURL;
	SystemSoundID systemSoundID;
	
	// register system sound
	AudioServicesCreateSystemSoundID(soundURLRef, &systemSoundID);
	sound.systemSoundID = systemSoundID;
	
	// assing sound ID
	NSNumber *soundID = [NSNumber numberWithUnsignedInteger:nextSoundID++];
	
	// save sound in cache
	[sounds setObject:sound forKey:soundID];
	
	return soundID;
}

- (void)playSound:(NSNumber *)soundID {
	OASound *sound = [sounds objectForKey:soundID];
	
	if (sound) {
		AudioServicesPlaySystemSound(sound.systemSoundID);
	}
}

#pragma mark -
#pragma mark Memory managment

- (id)init {
	self = [super init];
	if (self) {
		nextSoundID = 1;
		sounds = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void)dealloc {
	[super dealloc];
	
	[sounds release];
}

SYNTHESIZE_SINGLETON_FOR_CLASS_SHARED_NAME(OASoundManager,defaultManager)

@end
