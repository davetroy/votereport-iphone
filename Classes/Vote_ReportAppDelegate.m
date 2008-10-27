//
//  Vote_ReportAppDelegate.m
//  Vote Report
//
//  Created by David Troy on 10/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "Vote_ReportAppDelegate.h"
#import "Vote_ReportViewController.h"


@implementation Vote_ReportAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}

// this gets called by the Reporter if access to location is denied or fails
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:2067773333"]];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
