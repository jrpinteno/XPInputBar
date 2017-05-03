//
//  XPInputBar.h
//  XPInputBar
//
//  Created by Xavi R. Pinteño on 26/03/16.
//  Copyright © 2016 Xavi R. Pinteño. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPTextView;
@protocol XPInputBarViewDelegate;

IB_DESIGNABLE
@interface XPInputBar : UIView

/** Text color, designable in Storyboards*/
@property (nonatomic, strong) IBInspectable UIColor *textColor;

/** Color for placeholder */
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;

/** Placeholder text when TextView doesn't have user text */
@property (nonatomic, copy) IBInspectable NSString *placeholderText;

/** Textview text */
@property (nonatomic, copy, readonly) NSString *text;

/** Button at the left side of input bar, usually for secondary action */
@property (nonatomic, strong, readonly) UIButton *leftButton;

/** Button at the right side of input bar, usually for primary action. i.e sending textView content */
@property (nonatomic, strong, readonly) UIButton *rightButton;

@property (nonatomic, weak) id <XPInputBarViewDelegate> delegate;

- (void) setFont:(UIFont *)font;


/**
 * Clear text in textView
 */
- (void) clearText;

@end


@protocol XPInputBarViewDelegate <NSObject>
@optional

- (void) inputBarViewDidTouchRightButton:(XPInputBar *)inputBarView;
- (void) inputBarViewDidTouchLeftButton:(XPInputBar *)inputBarView;

@end
