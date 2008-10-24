//
//  Vote_ReportAppDelegate.m
//  Vote Report
//
//  Created by David Troy on 10/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "Vote_ReportAppDelegate.h"
#import "Vote_ReportViewController.h"
#import "Reporter.h"

@implementation Vote_ReportAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	Reporter *reporter = [[Reporter alloc] init];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
