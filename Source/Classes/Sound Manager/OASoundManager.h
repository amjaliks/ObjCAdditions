//
//  OASoundManager.h
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

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface OASoundManager : NSObject {
	NSUInteger nextSoundID;
	NSMutableDictionary *sounds;
}

+ (OASoundManager *)defaultManager;

- (NSURL *)URLForSoundNamed:(NSString *)name;
- (NSURL *)URLFOrSoundNamed:(NSString *)name withExtension:(NSString *)ext;
- (NSNumber *)registerSystemSound:(NSString *)name;
- (NSNumber *)registerAudioPlayer:(NSString *)name;
- (NSNumber *)registerAudioQueue:(NSString *)name;

- (void)playSound:(NSNumber *)soundID;
- (void)playSound:(NSNumber *)soundID numberOfLoops:(NSInteger)numberOfLoops;

- (void)stopSound:(NSNumber *)soundID;

void AudioQueueCallback(void *aqData, AudioQueueRef inAQ, AudioQueueBufferRef inBuffer);
void AudioQueueRunningCallback(void *aqData, AudioQueueRef inAQ, AudioQueuePropertyID inID);
void DeriveBufferSize (AudioStreamBasicDescription *ASBDesc, UInt32 maxPacketSize, Float64 seconds, UInt32 *outBufferSize, UInt32 *outNumPacketsToRead);

@end
