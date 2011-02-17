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


#define CENTER_IMAGE_WIDTH 31
#define CALLOUT_HEIGHT 70
#define MIN_LEFT_IMAGE_WIDTH 16
#define MIN_RIGHT_IMAGE_WIDTH 16
#define ANCHOR_X 32
#define ANCHOR_Y 60
#define CENTER_IMAGE_ANCHOR_OFFSET_X 15
#define MIN_ANCHOR_X MIN_LEFT_IMAGE_WIDTH + CENTER_IMAGE_ANCHOR_OFFSET_X
#define BUTTON_WIDTH 29
#define BUTTON_Y 10
#define LABEL_HEIGHT 48
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

@end


@implementation OACalloutView

#pragma mark -
#pragma mark Synthesized properties

@synthesize calloutButton;
@synthesize calloutCenter;
@synthesize calloutCenterImage;
@synthesize calloutLeft;
@synthesize calloutLeftImage;
@synthesize calloutRight;
@synthesize calloutRightImage;
@synthesize calloutSubtitleLabel;
@synthesize calloutTitleLabel;

#pragma mark -
#pragma mark Memory managment

- (id)initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self prepareView];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
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
	
	self.calloutLeftImage = [[UIImage imageNamed:@"OACalloutLeft.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
	self.calloutCenterImage = [UIImage imageNamed:@"OACalloutCenter.png"];
	self.calloutRightImage = [[UIImage imageNamed:@"OACalloutRight.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
				
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
	
	[self layoutSubviews];
}


#pragma mark -
#pragma mark UIView lifecycle

- (void)layoutSubviews {
	[super layoutSubviews];
	
	CGSize titleSize = [self.calloutTitleLabel.text sizeWithFont:self.calloutTitleLabel.font];
	CGSize subtitleSize = [self.calloutSubtitleLabel.text sizeWithFont:self.calloutSubtitleLabel.font];
	
	CGFloat labelWidth = MAX(titleSize.width, subtitleSize.width);
	CGFloat titleOffset = roundf((LABEL_HEIGHT - titleSize.height - subtitleSize.height) / 2.0f);
				   
	CGRect frame = self.frame;
	frame.size.height = CALLOUT_HEIGHT;
	frame.size.width = labelWidth + MIN_LEFT_IMAGE_WIDTH + self.calloutButton.frame.size.width + MIN_RIGHT_IMAGE_WIDTH + 3.0f;
	self.frame = frame;	
	
	CGFloat leftWidth = ANCHOR_X - CENTER_IMAGE_ANCHOR_OFFSET_X;
	CGFloat rightWidth = frame.size.width - leftWidth - CENTER_IMAGE_WIDTH;
	
	self.calloutLeft.frame = CGRectMake(0.0f, 0.0f, leftWidth, CALLOUT_HEIGHT);
	self.calloutCenter.frame = CGRectMake(leftWidth, 0.0f, CENTER_IMAGE_WIDTH, CALLOUT_HEIGHT);
	self.calloutRight.frame = CGRectMake(leftWidth + CENTER_IMAGE_WIDTH, 0.0f, rightWidth, CALLOUT_HEIGHT);
	self.calloutTitleLabel.frame = CGRectMake(MIN_LEFT_IMAGE_WIDTH, titleOffset, labelWidth, titleSize.height);
	self.calloutSubtitleLabel.frame = CGRectMake(MIN_LEFT_IMAGE_WIDTH, titleOffset + titleSize.height, labelWidth, subtitleSize.height);
	
	CGRect buttonFrame = self.calloutButton.frame;
	buttonFrame.origin.x = frame.size.width - self.calloutButton.frame.size.width - MIN_RIGHT_IMAGE_WIDTH + 4.0f;
	buttonFrame.origin.y = BUTTON_Y;
	self.calloutButton.frame = buttonFrame;
}

   
#pragma mark -
#pragma mark Control methods

- (void)showAnimated:(UIView *)parent {
	self.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationWillStartSelector:@selector(animationWillStart:context:)];
	[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView setAnimationDuration:0.1];
	
	[parent addSubview:self];
	self.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark Animation handlers

- (void)animationDidStart:(NSString *)animationID context:(void *)context {
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	self.transform = CGAffineTransformIdentity;
}


#pragma mark -
#pragma mark Properties

- (void)setTitle:(NSString *)title {
	self.calloutTitleLabel.text = title;
	if (title) {
		[self addSubview:self.calloutTitleLabel];
	}
	[self layoutSubviews];
}

- (NSString *)title {
	return self.calloutTitleLabel.text;
}

- (void)setSubtitle:(NSString *)subtitle {
	self.calloutSubtitleLabel.text = subtitle;
	if (subtitle) {
		[self addSubview:self.calloutSubtitleLabel];
	}
	[self layoutSubviews];
}

- (NSString *)subtitle {
	return self.calloutSubtitleLabel.text;
}

- (void)setAnchorPoint:(CGPoint)point {
	CGRect frame = self.frame;
	frame.origin.x = point.x - ANCHOR_X;
	frame.origin.y = point.y - ANCHOR_Y;
	self.frame = frame;
}

- (void)addButtonTarget:(id)target action:(SEL)action {
	[self.calloutButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
