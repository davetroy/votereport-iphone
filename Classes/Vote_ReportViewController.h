//
//  Vote_ReportViewController.h
//  Vote Report
//
//  Created by David Troy on 10/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reporter.h"

@interface Vote_ReportViewController : UIViewController <UITextFieldDelegate> {
	IBOutlet UITextField *textField;
	IBOutlet UIActivityIndicatorView *spinner;
	IBOutlet UILabel *locationName;
	IBOutlet UIButton *button;
	IBOutlet UIButton *infoButton;
	IBOutlet UIImageView *splash;
	IBOutlet UIViewController *vote_ReportDetailViewController;
	IBOutlet UIView *creditView;
	IBOutlet UITextView *creditTextView;
	Reporter *reporter;
}

- (IBAction)doPushReportDetailView;
- (void) sendReportWith:(NSMutableDictionary *)params;
- (IBAction)flipCredit;

@end

