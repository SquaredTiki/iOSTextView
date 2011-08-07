//
//  iOSTextViewAppDelegate.h
//  iOSTextView
//
//  Created by Joshua Garnham on 01/06/2011.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface iOSTextViewAppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
