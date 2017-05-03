//
//  XPInputBar.m
//  XPInputBar
//
//  Created by Xavi R. Pinteño on 26/03/16.
//  Copyright © 2016 Xavi R. Pinteño. All rights reserved.
//

#import "XPInputBar.h"

#import "XPTextView.h"

@interface XPInputBar () <XPTextViewDelegate>

/** Custom textview with placeholder */
@property (nonatomic, strong) XPTextView *textView;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIView *separatorView;

@end

@implementation XPInputBar

#pragma mark - Initializers

- (instancetype) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];

	if (self) {
		[self setupView];
	}

	return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];

	if (self) {
		[self setupView];
	}

	return self;
}

- (void) setupView {
	NSDictionary *views = @{
									@"textview": self.textView,
									@"rightButton": self.rightButton,
									@"leftButton": self.leftButton,
									@"separator": self.separatorView
									};

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.rightButton
																	 attribute:NSLayoutAttributeCenterY
																	 relatedBy:NSLayoutRelationEqual
																		 toItem:self
																	 attribute:NSLayoutAttributeCenterY
																	multiplier:1
																	  constant:0]];

	[self addConstraint:[NSLayoutConstraint constraintWithItem:self.leftButton
																	 attribute:NSLayoutAttributeCenterY
																	 relatedBy:NSLayoutRelationEqual
																		 toItem:self
																	 attribute:NSLayoutAttributeCenterY
																	multiplier:1
																	  constant:0]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(12)-[leftButton]-[textview]-[rightButton]-(12)-|"
																					 options:0
																					 metrics:nil
																						views:views]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[separator(1)]"
																					 options:0
																					 metrics:nil
																						views:views]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[textview]-|"
																					 options:0
																					 metrics:nil
																						views:views]];

	[self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[separator]|"
																					 options:0
																					 metrics:nil
																						views:views]];

	[self setNeedsUpdateConstraints];
}


#pragma mark - Setters

- (void) setTextColor:(UIColor *)textColor {
	self.textView.textColor = textColor;
}

- (void) setFont:(UIFont *)font {
	self.textView.font = font;
}


#pragma mark - XPTextView placeholder setters

- (void) setPlaceholderText:(NSString *)placeholderText {
	[self.textView setPlaceholderText:placeholderText];
}

- (void) setPlaceholderColor:(UIColor *)placeholderColor {
	[self.textView setPlaceholderColor:placeholderColor];
}

- (BOOL) resignFirstResponder {
	[super resignFirstResponder];

	return [self.textView resignFirstResponder];
}


#pragma mark - Getters

- (NSString *) text {
	return self.textView.text;
}


#pragma mark - Lazy views

- (XPTextView *) textView {
	if (!_textView) {
		_textView = [[XPTextView alloc] init];
		_textView.externalDelegate = self;
		_textView.maxLines = 4;
		_textView.backgroundColor = [UIColor clearColor];
		_textView.translatesAutoresizingMaskIntoConstraints = NO;

		[self addSubview:_textView];
	}

	return _textView;
}

- (UIButton *) rightButton {
	if (!_rightButton) {
		_rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_rightButton.translatesAutoresizingMaskIntoConstraints = NO;
		_rightButton.enabled = NO;
		[_rightButton addTarget:self action:@selector(didTouchRightButton) forControlEvents:UIControlEventTouchUpInside];

		[self addSubview:_rightButton];
	}

	return _rightButton;
}

- (UIButton *) leftButton {
	if (!_leftButton) {
		_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
		_leftButton.translatesAutoresizingMaskIntoConstraints = NO;
		_leftButton.enabled = YES;
		[_leftButton addTarget:self action:@selector(didTouchLeftButton) forControlEvents:UIControlEventTouchUpInside];

		[self addSubview:_leftButton];
	}

	return _leftButton;
}

- (UIView *) separatorView {
	if (!_separatorView) {
		_separatorView = [[UIView alloc] init];
		_separatorView.translatesAutoresizingMaskIntoConstraints = NO;
		_separatorView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.15];

		[self addSubview:_separatorView];
	}

	return _separatorView;
}


#pragma mark - Helpers

- (void) clearText {
	[self.textView clearText];
}


#pragma mark - UIView overrides

- (CGSize) intrinsicContentSize {
	CGFloat height = self.textView.intrinsicContentSize.height;

	return CGSizeMake(UIViewNoIntrinsicMetric, height + 16.0);
}


#pragma mark - Actions

- (void) didTouchRightButton {
	id<XPInputBarViewDelegate> delegate = self.delegate;

	if ([delegate respondsToSelector:@selector(inputBarViewDidTouchRightButton:)]) {
		[delegate inputBarViewDidTouchRightButton:self];
	}
}

- (void) didTouchLeftButton {
	id<XPInputBarViewDelegate> delegate = self.delegate;

	if ([delegate respondsToSelector:@selector(inputBarViewDidTouchLeftButton:)]) {
		[delegate inputBarViewDidTouchLeftButton:self];
	}
}


#pragma mark - XPTextViewDelegate

- (void) textViewDidClearText:(XPTextView *)textView {
	self.rightButton.enabled = NO;
}

- (void) textViewDidChange:(XPTextView *)textView {
	self.rightButton.enabled = (![textView.text isEqualToString:@""]);
}

- (void) dealloc {
	_rightButton = nil;
	_leftButton = nil;
	_textView = nil;
}

@end
