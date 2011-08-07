//
//  TDTextView.h
//  TinyDo
//
//  Created by Joshua Garnham on 31/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TDCaret.h"
#import "TDTextThumb.h"
#import "TDLoupeOverlay.h"

@class TDTextThumb;
@class TDLoupeOverlay;

#define cEqualFloats(f1, f2, epsilon)    ( fabs( (f1) - (f2) ) < epsilon )

@interface TDTextView : NSTextView {
	TDCaret *caret;
	BOOL isMoving;
	NSRange previousRange;
	
	NSPoint ownersOrigin; // Only used for field editor
	
	TDTextThumb *startThumb, *endThumb;
	TDLoupeOverlay *loupe;
}

@property (nonatomic, assign) NSPoint ownersOrigin;

- (NSRect)boundsForRange:(NSRange)range;
- (void)thumbMoved:(TDTextThumb *)thumb targetPosition:(NSPoint)pt;

@end
