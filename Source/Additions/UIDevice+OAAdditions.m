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

- (NSString *)macAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X", 
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString *)hashedMacAddress
{
    return [[[UIDevice currentDevice] macAddress] MD5Hash];
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

@end
