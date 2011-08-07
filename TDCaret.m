//
//  TDCaret.m
//  TinyDo
//
//  Created by Joshua Garnham on 31/05/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TDCaret.h"


@implementation TDCaret

- (void)drawRect:(NSRect)dirtyRect {
	[[NSColor colorWithDeviceRed:0.125 green:0.627 blue:0.918 alpha:1.000] set];
	NSRectFill([self bounds]);
}

@end
