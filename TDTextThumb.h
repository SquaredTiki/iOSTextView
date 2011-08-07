//
//  TDTextThumb.h
//  TinyDo
//
//  Created by Joshua Garnham on 01/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TDTextView.h"

@class TDTextView;

@interface TDTextThumb : NSView {
	CGFloat ascent;          // Line ascent at the point of selection
    CGFloat width;           // Visual width of caret bar
    CGPoint touchdownPoint;  // Used during drag to compute touch deltas
    BOOL isEndThumb;         // Are we the start-thumb or the end-thumb?
	TDTextView *parent;
	CGRect caretRectange;
}

@property (nonatomic, readwrite) BOOL isEndThumb;
@property (nonatomic, retain) TDTextView *parent;

- (void)setCaretRectangle:(CGRect)r;

@end
