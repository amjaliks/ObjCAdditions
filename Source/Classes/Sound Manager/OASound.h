//
//  OASound.h
//  ObjCAdditions-iOS
//
//  Created by Aleksejs Mjaliks on 10.12.30.
//  Copyright 2010 A25. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

enum {
	OASystemSound,
	OAAudioQueue
} typedef OASoundType;


@interface OASound : NSObject {
	OASoundType type;
	NSString *name;
	
	SystemSoundID systemSoundID;
}

@property (nonatomic) OASoundType type;
@property (nonatomic, retain) NSString *name;

@property (nonatomic) SystemSoundID systemSoundID;

- (id)initWithType:(OASoundType)type name:(NSString *)name;

@end
