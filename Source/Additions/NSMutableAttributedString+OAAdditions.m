//
//  NSMutableAttributedString+OAAdditions.m
//  1188
//
//  Created by Aleksejs Mjaliks on 13.06.20.
//  Copyright (c) 2013. g. A25 SIA. All rights reserved.
//

#import "NSMutableAttributedString+OAAdditions.h"

@implementation NSMutableAttributedString (OAAdditions)

/**
 * Inspired by http://panupan.com/2012/06/04/trim-leading-and-trailing-whitespaces-from-nsmutableattributedstring/
 */
- (void)trimCharactersInSet:(NSCharacterSet *)set
{
    NSRange range = [self.string rangeOfCharacterFromSet:set];
    if (range.location == 0) [self deleteCharactersInRange:range];
    
    range = [self.string rangeOfCharacterFromSet:set options:NSBackwardsSearch];
    if (NSMaxRange(range) == self.length) [self deleteCharactersInRange:range];
}

@end
