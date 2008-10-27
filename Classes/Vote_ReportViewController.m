//
//  Vote_ReportViewController.m
//  Vote Report
//
//  Created by David Troy on 10/23/08.
//  Copyright __MyCompanyName__ 2008. All rights reserved.
//

#import "Vote_ReportViewController.h"
#define kSliderHeight			7.0

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
	infoButton.hidden = YES;
	
	textField.font = [UIFont fontWithName:@"Helvetica" size:15.0];
	textField.returnKeyType = UIReturnKeyDone;
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	textField.delegate = self;
}

// record the slider value
- (void)sliderAction:(UISlider *)sender
{
	sliderValue.text = [NSString stringWithFormat:@"%2.0f", sender.value];
}

-(void)addslider {
	// Custom slider
	CGRect frame = CGRectMake(0.0, 0.0, 120.0, kSliderHeight);
	UISlider *customSlider = [[UISlider alloc] initWithFrame:frame];
	[customSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
	// in case the parent view draws with a custom color or gradient, use a transparent color
	customSlider.backgroundColor = [UIColor clearColor];
	UIImage *stretchLeftTrack = [[UIImage imageNamed:@"greenslide.png"]
								 stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	UIImage *stretchRightTrack = [[UIImage imageNamed:@"redslide.png"]
								  stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0];
	[customSlider setThumbImage: [UIImage imageNamed:@"slider_ball.png"] forState:UIControlStateNormal];
	[customSlider setMinimumTrackImage:stretchLeftTrack forState:UIControlStateNormal];
	[customSlider setMaximumTrackImage:stretchRightTrack forState:UIControlStateNormal];
	customSlider.minimumValue = 0.0;
	customSlider.maximumValue = 100.0;
	customSlider.continuous = YES;
	customSlider.value = 50.0;
	
	[self.view addSubview:customSlider];	
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
	[self addslider];
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
    [super dealloc];
}

@end
