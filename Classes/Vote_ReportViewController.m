//
//  Vote_ReportViewController.m
//  Vote Report
//
//  Created by David Troy on 10/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "Vote_ReportViewController.h"
#import "Vote_ReportAppDelegate.h"

@implementation Vote_ReportViewController

- (id)initWithCoder:(NSCoder*)coder 
{
	if (self = [super initWithCoder:coder]) {
		reporter = [[Reporter alloc] init];
		[reporter addObserver:self forKeyPath:@"locationName" options:NSKeyValueObservingOptionNew context:NULL];
	}
	return self;
}

		
- (void)viewDidLoad {
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
	
	//Get the credit text size right.
	creditTextView.font = [UIFont fontWithName:@"Arial" size:15];	
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


// Open KML link for nearby reports
-(void)openNearbyReports {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:
					[NSString stringWithFormat: VOTEREPORT_REPORTS_KML_URL, reporter.location.coordinate.latitude, reporter.location.coordinate.longitude]]];
}

-(void)reportSubmitted {
	if (!reporter.successful) {
		locationName.text = @"Report Submission Failed";
		[button setTitle:@"Try Again" forState:UIControlStateNormal|UIControlStateNormal];	
		[button setTitle:@"Try Again" forState:UIControlStateNormal|UIControlStateSelected];	
	}
	else
	{
		locationName.text = @"Report Sent Successfully!";
		[button setTitle:@"See Other Reports Nearby" forState:UIControlStateNormal];
		[button setTitle:@"See Other Reports Nearby" forState:UIControlStateSelected];
		[button removeTarget:self action:@selector(doPushReportDetailView) forControlEvents:UIControlEventTouchUpInside];
		[button addTarget:self action:@selector(openNearbyReports) forControlEvents:UIControlEventTouchUpInside];
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

- (IBAction)flipCredit{
	UIWindow *window = ((Vote_ReportAppDelegate *)[[UIApplication sharedApplication] delegate]).window;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationTransition: ([self.view superview] ? UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight) forView:window cache:YES];
	
	if ([self.view superview]){
		[self.view removeFromSuperview];
		[window addSubview:creditView];
	} else {
		[creditView removeFromSuperview];
		[window addSubview:self.view];
	}
	
	[UIView commitAnimations];
    
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
