//
//  TDTextView.m
//  TinyDo
//
//  Created by Joshua Garnham on 31/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TDTextView.h"


@implementation TDTextView

@synthesize ownersOrigin;

/*- (void)drawRect:(NSRect)dirtyRect {
	NSRect corner = NSMakeRect(0, 0, 5, 5);
	[[NSColor redColor] set];
	NSRectFill(corner);
}*/

#pragma mark -
#pragma mark Caret

- (void)drawInsertionPointInRect:(NSRect)aRect color:(NSColor *)aColor turnedOn:(BOOL)flag {
	NSLog(@"draw");
	if (!caret) {
		caret = [[[TDCaret alloc] init] retain];
		[self addSubview:caret];
		[caret setHidden:NO];
	}
	
	if (aRect.origin.x != caret.frame.origin.x && caret.frame.origin.y != 0)
		isMoving = YES;
	else
		isMoving = NO;
	
	NSRect frame = aRect;
	frame.size.width = 2;
	caret.frame = frame;
	
	if (flag == YES && previousRange.location == [[self.selectedRanges objectAtIndex:0] rangeValue].location) {
		// Caret in same place and just blinking 
		[caret setHidden:NO];
		[[NSAnimationContext currentContext] setDuration:0.2];
		[[caret animator] setAlphaValue:1.0];
	} else if (flag == YES && previousRange.location != [[self.selectedRanges objectAtIndex:0] rangeValue].location) {
		[caret setHidden:NO];
		[caret setAlphaValue:1.0];
	} else if (flag == NO && [[self.selectedRanges objectAtIndex:0] rangeValue].length == 0) {
		[caret setHidden:NO];
		[[NSAnimationContext currentContext] setDuration:0.2];
		[[caret animator] setAlphaValue:0.0];
	} else if (flag == NO && [[self.selectedRanges objectAtIndex:0] rangeValue].length > 0) {
		[caret setHidden:YES];
		[caret setAlphaValue:0.0];	
	}
	
	previousRange = [[self.selectedRanges objectAtIndex:0] rangeValue];
}

- (void)_drawInsertionPointInRect:(NSRect)aRect color:(NSColor *)aColor {		
	if (!caret) { // SHOULD NEVER HAPPEN THOUGH!
		caret = [[[TDCaret alloc] init] retain];
	}
	
	if (aRect.origin.x != caret.frame.origin.x)
		isMoving = YES;
		
	if (isMoving) {
		[caret setHidden:NO];
		[[NSAnimationContext currentContext] setDuration:0.2];
		[caret setAlphaValue:1.0];
	}

	previousRange = [[self.selectedRanges objectAtIndex:0] rangeValue];
	
	NSRect frame = aRect;
	frame.size.width = 2;
	caret.frame = frame;	
}

#pragma mark -
#pragma mark Selection

- (void)setSelectedRanges:(NSArray *)ranges affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag {
	if ([[ranges objectAtIndex:0] rangeValue].length > 0) {
		NSRange charRange = [[ranges objectAtIndex:0] rangeValue];
//		NSRect boundsOfSelection = [self boundsForRange:charRange];
		
		if (!startThumb)
			startThumb = [[TDTextThumb alloc] init];
			startThumb.parent = self;
		if (!endThumb) {
			endThumb = [[TDTextThumb alloc] init];
			endThumb.parent = self;
			[endThumb setIsEndThumb:YES];
		}
				
		// Just in case it runs over more than one line ;)
		NSUInteger rectCount;
		NSRectArray lines = [[self layoutManager] rectArrayForCharacterRange:charRange withinSelectedCharacterRange:NSMakeRange(NSNotFound, 0) inTextContainer:[self textContainer] rectCount:&rectCount];
	//	NSLog(@"lines %@", lines);
		NSRect firstLineBounds;
		NSRect lastLineBounds;
		if (lines) {
			firstLineBounds = lines[0];
			lastLineBounds = lines[rectCount-1];
		}/* else {
			firstLineBounds = [self boundsForRange:charRange];
			lastLineBounds = [self boundsForRange:charRange];
		}*/
		firstLineBounds.size.height = caret.frame.size.height;
		lastLineBounds.size.height = caret.frame.size.height;
		[startThumb setCaretRectangle:firstLineBounds];
		[endThumb setCaretRectangle:lastLineBounds];
		
		[self addSubview:startThumb];
		[self addSubview:endThumb];
		
	//	[[[self window] contentView] addSubview:startThumb];
	//	[[[self window] contentView] addSubview:endThumb];
	} else {
		[startThumb removeFromSuperview];
		[endThumb removeFromSuperview];
		[loupe removeFromSuperview];
	}
	[super setSelectedRanges:ranges affinity:affinity stillSelecting:stillSelectingFlag];
}

- (void)thumbMoved:(TDTextThumb *)thumb targetPosition:(NSPoint)pt {
	if (!loupe) {
		loupe = [[TDLoupeOverlay alloc] init];
		loupe.viewToMagnify = self;
	}
	
	loupe.touchPoint = NSMakePoint(thumb.frame.origin.x, thumb.frame.origin.y);
	if (!thumb.isEndThumb)
		loupe.touchPoint = NSMakePoint(thumb.frame.origin.x, thumb.frame.origin.y + 7);
	loupe.frame = NSMakeRect(thumb.frame.origin.x-(75), thumb.frame.origin.y-(28), 150, 58);
	if (thumb.isEndThumb)
		loupe.frame = NSMakeRect(thumb.frame.origin.x-(75), thumb.frame.origin.y-(35), 150, 58);
//	[self addSubview:loupe];
	
	pt.y = self.frame.size.height - pt.y;
	int pp;
	
	if (!thumb.isEndThumb) {
		pt.y += 10;
		pp = [[self layoutManager] characterIndexForPoint:pt inTextContainer:[self textContainer] fractionOfDistanceBetweenInsertionPoints:NULL];
		NSRange newRange = NSMakeRange(pp, [[self.selectedRanges objectAtIndex:0] rangeValue].length + ([[self.selectedRanges objectAtIndex:0] rangeValue].location - pp));
		if (newRange.length > self.string.length)
			newRange = [[self.selectedRanges objectAtIndex:0] rangeValue];
		[self setSelectedRange:newRange];
	} else {
		pt.y -= 10;
		pp = [[self layoutManager] characterIndexForPoint:pt inTextContainer:[self textContainer] fractionOfDistanceBetweenInsertionPoints:NULL];
		NSRange newRange = NSMakeRange([[self.selectedRanges objectAtIndex:0] rangeValue].location, (pp - [[self.selectedRanges objectAtIndex:0] rangeValue].location));
		if (newRange.length > self.string.length)
			newRange = [[self.selectedRanges objectAtIndex:0] rangeValue];
		[self setSelectedRange:newRange];
	}
}

- (NSRect)boundsForRange:(NSRange)range {
	NSLayoutManager *layoutManager = [self layoutManager];
	NSRect paragraphRect = [layoutManager boundingRectForGlyphRange:range inTextContainer:[self textContainer]];
	return paragraphRect;
}

@end
