//
//  XPTextView.m
//  XPInputBar
//
//  Created by Xavi R. Pinteño on 25/03/16.
//  Copyright © 2016 Xavi R. Pinteño. All rights reserved.
//

#import "XPTextView.h"

@interface XPTextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeholderLabel;
//@property (nonatomic, assign) CGFloat textViewHeight;

/** Current amount of lines displayed */
@property (nonatomic, assign) NSUInteger lines;

@end

@implementation XPTextView


#pragma mark - Initializers

- (instancetype) initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
	self = [super initWithFrame:frame textContainer:textContainer];

	if (self) {
		[self initialize];
	}

	return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];

	if (self) {
		[self initialize];
	}

	return self;
}

- (void) initialize {
	self.scrollEnabled = YES;
	self.scrollsToTop = NO;

	self.delegate = self;
}


#pragma mark - Lazy views

- (UILabel *) placeholderLabel {
	if (!_placeholderLabel) {
		_placeholderLabel = [[UILabel alloc] init];
		_placeholderLabel.hidden = NO;
		_placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
		_placeholderLabel.font = self.font;
		_placeholderLabel.textColor = [UIColor lightGrayColor];
		_placeholderLabel.backgroundColor = [UIColor clearColor];
		_placeholderLabel.numberOfLines = 1;

		[self addSubview:_placeholderLabel];
	}

	return _placeholderLabel;
}


#pragma mark - Placeholder setters

- (void) setPlaceholderText:(NSString *)placeholderText {
	self.placeholderLabel.text = placeholderText;
}

- (void) setPlaceholderColor:(UIColor *)placeholderColor {
	self.placeholderLabel.textColor = placeholderColor;
}

- (void) setPlaceholderFont:(UIFont *)font {
	self.placeholderLabel.font = (font) ?: self.font;
}


#pragma mark - Textview methods

- (void) setFont:(UIFont *)font {
	[super setFont:font];

	[self setPlaceholderFont:font];
}

- (void) clearText {
	self.text = nil;

	id<XPTextViewDelegate> delegate = self.externalDelegate;
	if ([delegate respondsToSelector:@selector(textViewDidClearText:)]) {
		[delegate textViewDidClearText:self];
	}
}


#pragma mark - Getters

- (NSUInteger) lines {
	CGFloat contentHeight = self.contentSize.height;
	contentHeight -= self.textContainerInset.top;
	contentHeight -= self.textContainerInset.bottom;

	NSUInteger lines = fabs(contentHeight / self.font.lineHeight);

	return (lines == 0) ? 1 : lines;
}

- (CGFloat) textViewHeight {
	NSUInteger lines = self.lines;
	CGFloat height = 0.0;

	if (lines == 1) {
		height = self.font.lineHeight;
	} else if (lines < self.maxLines) {
		height = self.font.lineHeight * lines;
	} else {
		height = self.font.lineHeight * self.maxLines;
	}


	return floorf(height);
}


#pragma mark - UIView overrides

- (CGSize) intrinsicContentSize {
	return CGSizeMake(UIViewNoIntrinsicMetric, self.textViewHeight + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void) updateConstraints {
	NSDictionary *views = @{
									@"placeholder": self.placeholderLabel
									};

	NSDictionary *metrics = @{
									  @"textViewInset": @(self.textContainer.lineFragmentPadding + self.textContainerInset.left)
									  };

	// Center placeholder label vertically to self
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.placeholderLabel
																	 attribute:NSLayoutAttributeCenterY
																	 relatedBy:NSLayoutRelationEqual
																		 toItem:self
																	 attribute:NSLayoutAttributeCenterY
																	multiplier:1
																	  constant:0.25]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(textViewInset)-[placeholder]-|"
																					 options:0
																					 metrics:metrics
																						views:views]];

	[super updateConstraints];
}


#pragma mark - UITextViewDelegate

- (void) textViewDidChange:(UITextView *)textView {
	self.placeholderLabel.hidden = (textView.text.length > 0);

	id<XPTextViewDelegate> delegate = self.externalDelegate;
	if ([delegate respondsToSelector:@selector(textViewDidChange:)]) {
		[delegate textViewDidChange:self];
	}
}


#pragma mark - NSObject overrides

- (void) dealloc {
	_placeholderLabel = nil;
}

@end
