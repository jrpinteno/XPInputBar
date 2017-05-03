//
//  XPTextView.h
//  XPInputBar
//
//  Created by Xavi R. Pinteño on 25/03/16.
//  Copyright © 2016 Xavi R. Pinteño. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XPTextView;

@protocol XPTextViewDelegate <NSObject>
@optional

- (void) textViewDidChange:(XPTextView *)textView;
- (void) textViewDidClearText:(XPTextView *)textView;

@end


@interface XPTextView : UITextView

/**
 * Maximum number of lines textview can grow to.
 * If content spans over more lines, show scroll
 */
@property (nonatomic, assign) NSUInteger maxLines;

@property (nonatomic, weak) id<XPTextViewDelegate> externalDelegate;

#pragma mark - Placeholder setters

/**
 * Set text for placeholder when there is no user input in textView
 */
- (void) setPlaceholderText:(NSString *)placeholderText;

/**
 * Set placeholder text color. Default is lightGray
 */
- (void) setPlaceholderColor:(UIColor *)placeholderColor;

/**
 * Set placeholder font. If no font is supplied, will use textView font
 */
- (void) setPlaceholderFont:(UIFont *)font;


#pragma mark - Textview methods

/**
 * Clear text in textView
 */
- (void) clearText;

@end
