//
//  TDLoupeOverlay.h
//  iOSTextView
//
//  Created by Joshua Garnham on 02/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TDLoupeOverlay : NSView {
	NSView *viewToMagnify;
	CGPoint touchPoint;
}

@property (nonatomic, retain) IBOutlet NSView *viewToMagnify;
@property (assign) CGPoint touchPoint;

@end
