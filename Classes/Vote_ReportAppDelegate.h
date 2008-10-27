//
//  Vote_ReportAppDelegate.h
//  Vote Report
//
//  Created by David Troy on 10/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Vote_ReportViewController;

@interface Vote_ReportAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Vote_ReportViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Vote_ReportViewController *viewController;

@end

