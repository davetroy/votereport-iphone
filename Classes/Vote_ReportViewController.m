//
//  Vote_ReportViewController.m
//  Vote Report
//
//  Created by David Troy on 10/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "Vote_ReportViewController.h"

@implementation Vote_ReportViewController

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	printf("did begin editing textfield\n");
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
	printf("should end\n");
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
	printf("should return\n");
	[theTextField resignFirstResponder];
	return YES;
}

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
		locationName.text = reporter.locationName;
		locationName.hidden = NO;
		button.hidden = NO;
	}
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
    [super dealloc];
}

@end
