//
//  OASound.h
//  ObjCAdditions-iOS
//
//  Created by Aleksejs Mjaliks on 10.12.30.
//  Copyright 2010 A25. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

enum OASoundType{
	OASystemSound,
	OAAudioQueue
};
typedef enum OASoundType OASoundType;

#define kNumberBuffers 3

struct AQPlayerState {
	AudioStreamBasicDescription mDataFormat;
    AudioQueueRef mQueue;
    AudioQueueBufferRef mBuffers[kNumberBuffers];
    AudioFileID mAudioFile;
    UInt32 bufferByteSize;
    SInt64 mCurrentPacket;
    UInt32 mNumPacketsToRead;
    AudioStreamPacketDescription *mPacketDescs;
    bool mIsDone;
	UInt32 mIsRunning;
};
typedef struct AQPlayerState AQPlayerState;


@interface OASound : NSObject {
	OASoundType type;
	NSString *name;
	
	SystemSoundID systemSoundID;
	AQPlayerState aqData;
}

@property (nonatomic) OASoundType type;
@property (nonatomic, retain) NSString *name;

@property (nonatomic) SystemSoundID systemSoundID;
@property (nonatomic) AQPlayerState aqData;

- (id)initWithType:(OASoundType)type name:(NSString *)name;

@end
