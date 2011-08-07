//
//  TDTextThumb.m
//  TinyDo
//
//  Created by Joshua Garnham on 01/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TDTextThumb.h"

#define THUMB_TOP_GAP (-2)     // The gap between the thumb image and the caret bar (pixels)
#define THUMB_BOT_GAP ( 0)     // Same, for the end-thumb
#define THUMB_TOUCH_RADIUS 35  // How many pixels from the ring should we be sensitive to touches?

@implementation TDTextThumb

@synthesize isEndThumb, parent;

- (void)setCaretRectangle:(NSRect)r;
{
	NSRect frame = self.frame;
	frame.size.width = 15;
	frame.size.height = r.size.height + 15;
	
	if (!isEndThumb) {
		frame.origin.x = NSMinX(r) - 6;
		frame.origin.y = NSMinY(r) - 11;
	} else {
		frame.origin.x = NSMaxX(r) - 7;
		frame.origin.y = NSMinY(r) - 4;
	}

	self.frame = frame;
	
	caretRectange = r;
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent {

}

- (void)mouseDragged:(NSEvent *)theEvent {
	NSLog(@"dragged!");
	NSPoint theEventLoc = [theEvent locationInWindow];
//	theEventLoc.y = [self window].frame.size.height - theEventLoc.y;
//	theEventLoc.y += (self.frame.origin.y - theEventLoc.y);
	
//	NSRect frame = self.frame;
//	frame.origin = theEventLoc;
//	self.frame = frame;
	[parent thumbMoved:self targetPosition:theEventLoc];
}

- (void)drawRect:(NSRect)rect;
{   	
//	[[NSColor redColor] set];
//	NSRectFill(self.bounds);
	
	NSRect drawRect = self.bounds;
	drawRect.size.width = 15;
	drawRect.size.height = 15;
	if (!isEndThumb) {
		drawRect.origin.y = NSMaxY(drawRect) + 5;
		drawRect.origin.x -= 1;
	}
	
    NSImage *thumbImage = [NSImage imageNamed:@"OUITextSelectionHandle.png"];
   [thumbImage drawInRect:drawRect fromRect:NSZeroRect operation:NSCompositeSourceOver  fraction:1.0];
	
	NSRect bounds = self.bounds;
	bounds.size.height = caretRectange.size.height - 3;
	bounds.size.width = 2;
	if (!isEndThumb) {
		bounds.origin.y = 4;
		bounds.origin.x += 6;
	} else {
		bounds.origin.y += 14;
		bounds.origin.x += 6;
	}
	[[NSColor colorWithDeviceRed:0.125 green:0.627 blue:0.918 alpha:1.00] set];
	NSRectFill(bounds);
}

@end
