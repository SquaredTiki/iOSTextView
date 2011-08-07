//
//  TDLoupeOverlay.m
//  iOSTextView
//
//  Created by Joshua Garnham on 02/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TDLoupeOverlay.h"
#import "ScreenshotView.h"

@implementation TDLoupeOverlay

@synthesize viewToMagnify, touchPoint;

- (void)setTouchPoint:(CGPoint)pt {
	touchPoint = pt;
	// whenever touchPoint is set, 
	// update the position of the magnifier (to just above what's being magnified)
}

- (void)drawRect:(NSRect)rect {


	//	[self.viewToMagnify.layer renderInContext:UIGraphicsGetCurrentContext()];
	NSImage *cachedImage = [viewToMagnify focusedScreenshot];
	
	
	[[NSColor redColor] set];
	NSRectFill(rect);
	
/*	cachedImage = [[[NSImage alloc] initWithSize: [self 
													  bounds].size] autorelease];
	NSBitmapImageRep *bitmap;
	
	[self lockFocus];
	bitmap = [[[NSBitmapImageRep alloc] initWithFocusedViewRect: [self 
																  bounds]] autorelease];
	[self unlockFocus];
	
	[cachedImage addRepresentation: bitmap]; */
	NSRect srcRect;
	// ------
	srcRect = NSMakeRect(0, 0, cachedImage.size.width, cachedImage.size.height);
//	srcRect = NSMakeRect(touchPoint.x, touchPoint.y, cachedImage.size.width, cachedImage.size.height);
	NSRect destRect;
//	destRect = NSMakeRect(0, -(viewToMagnify.bounds.size.height-20), viewToMagnify.bounds.size.width, viewToMagnify.bounds.size.height);
	destRect = NSMakeRect(75-touchPoint.x, -(viewToMagnify.bounds.size.height-58) + touchPoint.y, viewToMagnify.bounds.size.width, viewToMagnify.bounds.size.height);
	
	[cachedImage drawInRect:destRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0];

	NSBezierPath *path = [NSBezierPath bezierPathWithRect:self.bounds];
	[path setLineWidth:5];
	[[NSColor greenColor] set];
	[path stroke];
	
	//- ---------------
	
	NSImage *mLeftImage = [NSImage imageNamed:@"OUIRectangularOverlayFrameLeft.png"];
	NSImage *mRightImage = [NSImage imageNamed:@"OUIRectangularOverlayFrameRight.png"];
	NSImage *mMiddleImage = [NSImage imageNamed:@"OUIRectangularOverlayFrameMiddle.png"];
	
	// Draw the left end of the widget
//	[mLeftImage drawAtPoint:NSMakePoint(0, 0) fromRect:CGRectZero operation:NSCompositeSourceOver fraction:1.0];
	
	// Draw the right end of the widget
//	[mRightImage drawAtPoint:NSMakePoint(self.bounds.size.width-mRightImage.size.width, 0) fromRect:CGRectZero operation:NSCompositeSourceOver fraction:1.0];
	
	// Draw the middle section
	NSRect middleImageRect = self.bounds;
	NSSize middleImageSize = [mMiddleImage size];
	
	middleImageRect.origin.x += [mLeftImage size].width;
	middleImageRect.origin.y = self.bounds.origin.y;
	middleImageRect.size.width  = self.bounds.size.width - ([mLeftImage size].width + [mRightImage size].width);
	middleImageRect.size.height = middleImageSize.height;
	
	srcRect = NSMakeRect(0, 0, middleImageSize.width, middleImageSize.height);
//	[mMiddleImage drawInRect:middleImageRect fromRect:srcRect operation:NSCompositeSourceOver fraction:1.0f];
}

- (void)dealloc {
	[viewToMagnify release];
	[super dealloc];
}

@end
