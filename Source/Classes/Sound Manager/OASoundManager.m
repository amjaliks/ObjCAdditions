//
//  OASoundManager.m
//  ObjCAdditions
//
//  Copyright (c) 2011 A25 SIA
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

- (NSNumber *)registerAudioQueue:(NSString *)name {
	// create sound handler
	OASound *sound = [[OASound alloc] initWithType:OAAudioQueue name:name];

	// URL for sound file
	NSURL *soundURL = [[NSBundle mainBundle] URLForResource:name withExtension:@"caf"];
	CFURLRef soundURLRef = (CFURLRef)soundURL;

	// open audio file
	AQPlayerState aqData;
	AudioFileOpenURL(soundURLRef, kAudioFileReadPermission, 0, &aqData.mAudioFile);
	
	// determine file format
	UInt32 audioFormatDataSize = sizeof(AudioStreamBasicDescription);
	AudioFileGetProperty(aqData.mAudioFile, kAudioFilePropertyDataFormat, &audioFormatDataSize, &aqData.mDataFormat);
	
	// determine buffer size
	UInt32 maxPacketSize;
	UInt32 propertySize = sizeof (maxPacketSize);
	AudioFileGetProperty(aqData.mAudioFile, kAudioFilePropertyPacketSizeUpperBound, &propertySize, &maxPacketSize);
	DeriveBufferSize(&aqData.mDataFormat, maxPacketSize, 1, &aqData.bufferByteSize, &aqData.mNumPacketsToRead);
	
	// default values
	aqData.mIsDone = NO;
	aqData.mPacketDescs = nil;
	aqData.mCurrentPacket = 0;
	
	sound.aqData = aqData;

	// assing sound ID
	NSNumber *soundID = [NSNumber numberWithUnsignedInteger:nextSoundID++];
	
	// save sound in cache
	[sounds setObject:sound forKey:soundID];

	return soundID;
}

- (void)playSound:(NSNumber *)soundID {
	OASound *sound = [sounds objectForKey:soundID];
	
	if (sound.type == OASystemSound) {
		AudioServicesPlaySystemSound(sound.systemSoundID);
	} else if (sound.type == OAAudioQueue) {
		AQPlayerState *pAqData = calloc(1, sizeof(AQPlayerState));
		*pAqData = sound.aqData;
		
		AudioQueueNewOutput(&pAqData->mDataFormat, AudioQueueCallback, &pAqData, CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &pAqData->mQueue);
		for (int i = 0; i < kNumberBuffers; ++i) {
			AudioQueueAllocateBuffer(pAqData->mQueue, pAqData->bufferByteSize, &pAqData->mBuffers[i]);
			AudioQueueCallback(pAqData, pAqData->mQueue, pAqData->mBuffers[i]);
		}
		AudioQueueSetParameter(pAqData->mQueue, kAudioQueueParam_Volume, 1.0);
		AudioQueueAddPropertyListener(pAqData->mQueue, kAudioQueueProperty_IsRunning, AudioQueueRunningCallback, pAqData);
		
		AudioQueueStart(pAqData->mQueue, nil);
	}
}

#pragma mark -
#pragma mark Audio Queues

void AudioQueueCallback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer) {
    AQPlayerState *pAqData = (AQPlayerState *)aqData;
    if (pAqData->mIsDone == YES) return;
    UInt32 numBytesReadFromFile;
    UInt32 numPackets = pAqData->mNumPacketsToRead;
    AudioFileReadPackets (pAqData->mAudioFile, false, &numBytesReadFromFile, pAqData->mPacketDescs, pAqData->mCurrentPacket, &numPackets, inBuffer->mAudioData);
    if (numPackets > 0) {
        inBuffer->mAudioDataByteSize = numBytesReadFromFile;
		AudioQueueEnqueueBuffer(pAqData->mQueue, inBuffer, (pAqData->mPacketDescs ? numPackets : 0), pAqData->mPacketDescs);
        pAqData->mCurrentPacket += numPackets; 
    } else {
        AudioQueueStop(pAqData->mQueue, false);
        pAqData->mIsDone = YES; 
    }
	return;
}

void AudioQueueRunningCallback(void *aqData, AudioQueueRef inAQ, AudioQueuePropertyID inID) {
	AQPlayerState *pAqData = (AQPlayerState *)aqData;
	UInt32 size = sizeof(pAqData->mIsRunning);
	OSStatus result = AudioQueueGetProperty(inAQ, kAudioQueueProperty_IsRunning, &pAqData->mIsRunning, &size);
	
	if ((result == noErr) && (!pAqData->mIsRunning) && (pAqData->mIsDone)) { 
		AudioQueueDispose(inAQ, false);
	}
}

void DeriveBufferSize(AudioStreamBasicDescription *ASBDesc, UInt32 maxPacketSize, Float64 seconds, UInt32 *outBufferSize, UInt32 *outNumPacketsToRead) {
    static const int maxBufferSize = 0x50000;
    static const int minBufferSize = 0x4000;
	
    if (ASBDesc->mFramesPerPacket != 0) {
        Float64 numPacketsForTime = ASBDesc->mSampleRate / ASBDesc->mFramesPerPacket * seconds;
        *outBufferSize = numPacketsForTime * maxPacketSize;
    } else {
        *outBufferSize = maxBufferSize > maxPacketSize ? maxBufferSize : maxPacketSize;
    }
	
    if (*outBufferSize > maxBufferSize && *outBufferSize > maxPacketSize) {
        *outBufferSize = maxBufferSize;
    } else if (*outBufferSize < minBufferSize) {
		*outBufferSize = minBufferSize;
    }
	
    *outNumPacketsToRead = *outBufferSize / maxPacketSize;
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
