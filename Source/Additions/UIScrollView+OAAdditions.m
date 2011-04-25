//
//  UIScrollView+OAAdditions.m
//  ObjCAdditions-iOS
//
//  Created by Aleksejs Mjaliks on 11.04.26.
//  Copyright 2011 A25. All rights reserved.
//

#import "UIScrollView+OAAdditions.h"


@implementation UIScrollView (OAAdditions)

- (CGRect)visibleRect {
	CGPoint contentOffset = self.contentOffset;
	CGSize size = self.bounds.size;
	CGFloat zoomScale = self.zoomScale;
	return CGRectMake(contentOffset.x / zoomScale, contentOffset.y / zoomScale,
					  size.width / zoomScale, size.height / zoomScale);
}

@end
