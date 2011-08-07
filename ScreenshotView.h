//
//  ScreenshotView.h
//  iOSTextView
//
//  Created by Joshua Garnham on 02/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSView (ScreenshotView)

// These methods demonstrate various approaches to creating an NSImage 
// from an NSView.

// This method runs very slowly.
- (NSImage *) pdfScreenshot;

// This method runs quickly but produces an image that, when scaled, 
// doesn't use anti-aliasing.
// It will also crash for views that are not on screen.
- (NSImage *) focusedScreenshot;

// This method doesn't capture subviews.
- (NSImage *) screenshotByDrawing;

// This method captures subviews,
// but has as bug that causes all subviews to be drawn
// with their origin at the image's origin.
// This is probably easy to fix.
- (NSImage *) screenshotByDrawingRecursively;
- (void) drawWithSubviews;

@end
