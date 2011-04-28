//
//  OACalloutView.m
//  ObjCAdditions
//
// Copyright 2011 A25 SIA
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//
// Based on https://github.com/edanuff/MonoTouchCalloutView


#import "OACalloutView.h"
#import <QuartzCore/QuartzCore.h>

#define CENTER_IMAGE_WIDTH 31
#define CALLOUT_HEIGHT 70
#define MIN_LEFT_IMAGE_WIDTH 16
#define MIN_RIGHT_IMAGE_WIDTH 16
#define ANCHOR_X 32
#define ANCHOR_Y 60
#define CENTER_IMAGE_ANCHOR_OFFSET_X 15
#define MIN_ANCHOR_X MIN_LEFT_IMAGE_WIDTH + CENTER_IMAGE_ANCHOR_OFFSET_X
#define TITLE_FONT_SIZE 16.0f
#define SUBTITLE_FONT_SIZE 12.0f


@interface OACalloutView ()

@property (nonatomic,retain) UIImage *calloutLeftImage;
@property (nonatomic,retain) UIImage *calloutCenterImage;
@property (nonatomic,retain) UIImage *calloutRightImage;
@property (nonatomic,retain) UIImageView *calloutLeft;
@property (nonatomic,retain) UIImageView *calloutCenter;
@property (nonatomic,retain) UIImageView *calloutRight;
@property (nonatomic,retain) UILabel *calloutTitleLabel;
@property (nonatomic,retain) UILabel *calloutSubtitleLabel;
@property (nonatomic,retain) UIButton *calloutButton;

- (void)prepareView;
- (void)updateLayout:(BOOL)animated;
- (void)showAnimationWillStart:(NSString *)animationID context:(void *)context;
- (void)showAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

@end


@implementation OACalloutView

#pragma mark -
#pragma mark Synthesized properties

@synthesize anchorPoint;
@synthesize calloutButton;
@synthesize calloutCenter;
@synthesize calloutCenterImage;
@synthesize calloutLeft;
@synthesize calloutLeftImage;
@synthesize calloutRight;
@synthesize calloutRightImage;
@synthesize calloutSubtitleLabel;
@synthesize calloutTitleLabel;
@synthesize labelHeight;
@synthesize labelOriginY;
@synthesize maxWidth;

#pragma mark -
#pragma mark Memory managment

- (id)initWithLeftImage:(UIImage *)leftImage centerImage:(UIImage *)centerImage rightImage:(UIImage *)rightImage {
	self = [super init];
	if (self) {
		self.calloutLeftImage = [leftImage stretchableImageWithLeftCapWidth:leftImage.size.width - 1 topCapHeight:0];
		self.calloutCenterImage = centerImage;
		self.calloutRightImage = [rightImage stretchableImageWithLeftCapWidth:1 topCapHeight:0];
		self.maxWidth = 320.f;
		[self prepareView];
	}
	return self;
}

- (void)dealloc {
    [super dealloc];
}

- (void)prepareView {
	self.backgroundColor = [UIColor clearColor];
	self.opaque = NO;
	
	self.calloutLeft = [[[UIImageView alloc] init] autorelease];
	self.calloutLeft.image = self.calloutLeftImage;
	[self addSubview:self.calloutLeft];

	self.calloutCenter = [[[UIImageView alloc] init] autorelease];
	self.calloutCenter.image = self.calloutCenterImage;
	[self addSubview:self.calloutCenter];
		
	self.calloutRight = [[[UIImageView alloc] init] autorelease];
	self.calloutRight.image = self.calloutRightImage;
	[self addSubview:self.calloutRight];

	self.calloutTitleLabel = [[[UILabel alloc] init] autorelease];
	self.calloutTitleLabel.font = [UIFont boldSystemFontOfSize:TITLE_FONT_SIZE];
	self.calloutTitleLabel.textColor = [UIColor whiteColor];
	self.calloutTitleLabel.backgroundColor = [UIColor clearColor];
	
	self.calloutSubtitleLabel = [[[UILabel alloc] init] autorelease];
	self.calloutSubtitleLabel.font = [UIFont systemFontOfSize:SUBTITLE_FONT_SIZE];
	self.calloutSubtitleLabel.textColor = [UIColor whiteColor];
	self.calloutSubtitleLabel.backgroundColor = [UIColor clearColor];
	
	self.calloutButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
	self.calloutButton.adjustsImageWhenHighlighted = NO;
	[self addSubview:self.calloutButton];
	
	[self updateLayout:NO];
}


#pragma mark -
#pragma mark UIView lifecycle

- (void)updateLayout:(BOOL)animated {
	if (animated && self.superview) {
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationBeginsFromCurrentState:YES];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationWillStartSelector:@selector(showAnimationWillStart:context:)];
		[UIView setAnimationDidStopSelector:@selector(showAnimationDidStop:finished:context:)];
		[UIView setAnimationDuration:0.1f];
	}

	CGSize titleSize = [self.calloutTitleLabel.text length] ? [self.calloutTitleLabel.text sizeWithFont:self.calloutTitleLabel.font] : CGSizeZero;
	CGSize subtitleSize = [self.calloutSubtitleLabel.text length] ? [self.calloutSubtitleLabel.text sizeWithFont:self.calloutSubtitleLabel.font] : CGSizeZero;
	
	CGFloat maxLabelWidth = self.maxWidth - (MIN_LEFT_IMAGE_WIDTH + self.calloutButton.frame.size.width + MIN_RIGHT_IMAGE_WIDTH + 3.0f);
	CGFloat labelWidth = MAX(titleSize.width, subtitleSize.width);
	labelWidth = MIN(labelWidth, maxLabelWidth);
	CGFloat titleOffset = self.labelOriginY + floorf((self.labelHeight - titleSize.height - subtitleSize.height) / 2.0f);
				   
	CGRect frame = self.frame;
	frame.size.height = CALLOUT_HEIGHT;
	frame.size.width = labelWidth + MIN_LEFT_IMAGE_WIDTH + self.calloutButton.frame.size.width + MIN_RIGHT_IMAGE_WIDTH + 3.0f;
	self.frame = frame;	
	
	CGFloat leftWidth = ANCHOR_X - CENTER_IMAGE_ANCHOR_OFFSET_X;
	CGFloat rightWidth = frame.size.width - leftWidth - CENTER_IMAGE_WIDTH;
	
	CGRect titleLabelFrame = CGRectMake(MIN_LEFT_IMAGE_WIDTH, titleOffset, labelWidth, titleSize.height);
	CGRect subtitleLabelFrame = CGRectMake(MIN_LEFT_IMAGE_WIDTH, titleOffset + titleSize.height, labelWidth, subtitleSize.height);
	
	self.calloutLeft.frame = CGRectMake(0.0f, 0.0f, leftWidth, CALLOUT_HEIGHT);
	self.calloutCenter.frame = CGRectMake(leftWidth, 0.0f, CENTER_IMAGE_WIDTH, CALLOUT_HEIGHT);
	self.calloutRight.frame = CGRectMake(leftWidth + CENTER_IMAGE_WIDTH, 0.0f, rightWidth, CALLOUT_HEIGHT);
	self.calloutTitleLabel.frame = titleLabelFrame;
	self.calloutSubtitleLabel.frame = subtitleLabelFrame;
	
	CGRect buttonFrame = self.calloutButton.frame;
	buttonFrame.origin.x = frame.size.width - buttonFrame.size.width - MIN_RIGHT_IMAGE_WIDTH + 4.0f;
	buttonFrame.origin.y = self.labelOriginY + floorf((self.labelHeight - buttonFrame.size.height) / 2.0f);
	self.calloutButton.frame = buttonFrame;
	
	self.layer.anchorPoint = CGPointMake(ANCHOR_X / self.frame.size.width, ANCHOR_Y / self.frame.size.height);
	self.center = anchorPoint;
	
	if (animated && self.superview) {
		[UIView commitAnimations];
	}
}

   
#pragma mark -
#pragma mark Control methods

- (void)showAnimated:(UIView *)parent {
	self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationWillStartSelector:@selector(showAnimationWillStart:context:)];
	[UIView setAnimationDidStopSelector:@selector(showAnimationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.1f];
	[parent addSubview:self];
	
	self.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Animation handlers

- (void)showAnimationWillStart:(NSString *)animationID context:(void *)context {
	animationInProgress = YES;
}

- (void)showAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	animationInProgress = NO;
	self.transform = CGAffineTransformIdentity;
}


#pragma mark -
#pragma mark Properties

- (void)setTitle:(NSString *)title {
	if ([title length]) {
		self.calloutTitleLabel.text = title;
		[self addSubview:self.calloutTitleLabel];
	} else {
		self.calloutTitleLabel.text = nil;
		[self.calloutTitleLabel removeFromSuperview];
	}
	[self updateLayout:YES];
}

- (NSString *)title {
	return self.calloutTitleLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle {
	if ([subtitle length]) {
		self.calloutSubtitleLabel.text = subtitle;
		[self addSubview:self.calloutSubtitleLabel];
	} else {
		self.calloutSubtitleLabel.text = nil;
		[self.calloutSubtitleLabel removeFromSuperview];
	}	
	[self updateLayout:YES];
}

- (NSString *)subtitle {
	return self.calloutSubtitleLabel.text;
}

- (void)setAnchorPoint:(CGPoint)point {
	anchorPoint = point;
	[self updateLayout:NO];
}

- (void)addButtonTarget:(id)target action:(SEL)action {
	[self.calloutButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
