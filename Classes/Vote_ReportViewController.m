//
//  Vote_ReportViewController.m
//  Vote Report
//
//  Created by David Troy on 10/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "Vote_ReportViewController.h"

@implementation Vote_ReportViewController

- (void)viewDidLoad {
	printf("view did load\n");
	reporter = [[Reporter alloc] init];

	// Set up view
	[spinner startAnimating];
	[reporter addObserver:self forKeyPath:@"locationName" options:NSKeyValueObservingOptionNew context:NULL];
	UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
	UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];

	buttonBackground = [UIImage imageNamed:@"blueButton.png"];
	newImage = [buttonBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateSelected];
	button.hidden = YES;
	infoButton.hidden = YES;
	
	textField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	textField.returnKeyType = UIReturnKeyDone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	textField.delegate = self;
}


// We must be getting notified of a location name update - it's all we Observe for
- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)myUser
                        change:(NSDictionary *)change
                       context:(void *)context {
	
	printf("observed locationName update\n");
	if (reporter.locationName) {
		[spinner stopAnimating];
		button.hidden = NO;
		button.alpha = 0.0;
		infoButton.hidden = NO;
		infoButton.alpha = 0.0;
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		locationName.text = reporter.locationName;
		locationName.hidden = NO;
		splash.alpha = 0.0;
		button.alpha = 1.0;
		infoButton.alpha = 1.0;
 		[UIView commitAnimations];
	}
}

-(void)reportSubmitted {
	if (!reporter.successful) {
		locationName.text = @"Report Submission Failed";
		[button setTitle:@"Try Again" forState:UIControlStateNormal|UIControlStateSelected];	
	}
	else
	{
		locationName.text = @"Report Sent Successfully!";
		[button setTitle:@"See Other Reports Nearby" forState:UIControlStateNormal|UIControlStateSelected];
		[button removeTarget:self action:@selector(doPushReportDetailView) forControlEvents:UIControlEventTouchUpInside];
	}	
	button.enabled = YES;
}

-(void) sendReportWith:(NSMutableDictionary *)params {
	reporter.target = self;
	reporter.targetSelector = @selector(reportSubmitted);
	[button setTitle:@"Sending Report..." forState:UIControlStateDisabled];
	button.enabled = NO;
	printf("sending report...\n");
	[reporter postReportWithParams:params];
}

- (IBAction) doPushReportDetailView{
	[self presentModalViewController:vote_ReportDetailViewController animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[reporter dealloc];
    [super dealloc];
}

@end
