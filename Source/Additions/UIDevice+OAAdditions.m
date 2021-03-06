//
//  UIDevice+OAAdditions.m
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

#import "UIDevice+OAAdditions.h"
#import "NSString+MD5.h"
#import <sys/sysctl.h>
#import <sys/socket.h>
#import <net/if.h>
#import <net/if_dl.h>

@implementation UIDevice (OAAdditions)

/*
 System version check is taken from GLES2Sample:
 https://developer.apple.com/library/ios/#samplecode/GLES2Sample/Listings/Classes_EAGLView_m.html%23//apple_ref/doc/uid/DTS40009188-Classes_EAGLView_m-DontLinkElementID_4
 */
- (BOOL)systemVersionEqualsOrLater:(NSString *)requiredVersion {
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	return ([systemVersion compare:requiredVersion options:NSNumericSearch] != NSOrderedAscending);
}

- (NSString *)UUID
{
    static NSString *identifier;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        identifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"UIDeviceUUID"];
        if (!identifier) {
            CFUUIDRef UUID = CFUUIDCreate(NULL);
            CFStringRef string = CFUUIDCreateString(NULL, UUID);
            
            identifier = (__bridge NSString *)string;
            [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:@"UIDeviceUUID"];
            
            CFRelease(string);
            CFRelease(UUID);
        }
    });
    
    return identifier;
}

- (NSString *)hardwareModel {
    static NSString *hardwareModel = nil;
    if (!hardwareModel) {
        char buffer[128];
        size_t length = sizeof(buffer);
        if (sysctlbyname("hw.machine", &buffer, &length, NULL, 0) == 0) {
            hardwareModel = [[NSString allocWithZone:NULL] initWithCString:buffer encoding:NSASCIIStringEncoding];
        }
        if (!hardwareModel || [hardwareModel length] == 0) {
            hardwareModel = @"unknown";
        }
    }
    return hardwareModel;
}

@end
