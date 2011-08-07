//
//  ScreenshotView.m
//  iOSTextView
//
//  Created by Joshua Garnham on 02/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScreenshotView.h"


@implementation NSView (ScreenshotView)

// This method runs very slowly.
- (NSImage *) pdfScreenshot {
	NSData *imageData = [self dataWithPDFInsideRect: [self bounds]];
	return [[[NSImage alloc] initWithData: imageData] autorelease];
}

// This method runs quickly but produces an image that, when scaled, 
// doesn't use anti-aliasing.
// It will also crash for views that are not on screen.
- (NSImage *) focusedScreenshot {
NSImage *image = [[[NSImage alloc] initWithSize: [self 
bounds].size] autorelease];
NSBitmapImageRep *bitmap;

[self lockFocus];
bitmap = [[[NSBitmapImageRep alloc] initWithFocusedViewRect: [self 
bounds]] autorelease];
[self unlockFocus];

[image addRepresentation: bitmap];
return image;
}

// This method doesn't capture subviews.
- (NSImage *) screenshotByDrawing {
	NSImage *screenshot = [[[NSImage alloc] initWithSize: [self 
														   bounds].size] autorelease];
	[screenshot lockFocus];
	[self drawRect: [self frame]];
	[screenshot unlockFocus];
	return screenshot;
}

// This method captures subviews,
// but has as bug that causes all subviews to be drawn
// with their origin at the image's origin.
// This is probably easy to fix.
- (NSImage *) screenshotByDrawingRecursively {
	NSImage *screenshot = [[[NSImage alloc] initWithSize: [self 
														   bounds].size] autorelease];
	[screenshot lockFocus];
	[self drawWithSubviews];
	[screenshot unlockFocus];
	return screenshot;
}

// Used by screenshotByDrawingRecursively to recurse through subviews.
- (void) drawWithSubviews {
	NSArray *subviews = [self subviews];
	int i;
	
	[self drawRect: [self frame]];
	for (i = 0; i < [subviews count]; i++) {
		NSView *subview = [subviews objectAtIndex: i];
		[subview drawWithSubviews];
	}	
}

 @end
