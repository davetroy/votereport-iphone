//
//  Reporter.m
//  Vote Report
//
//  Created by David Troy on 10/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "Reporter.h"
#import "HTTPManager.h"


@implementation Reporter
@synthesize location;
@synthesize locationName;
@synthesize target;
@synthesize targetSelector;
@synthesize successful;

-(id)init {
	if (self = [super init]) {
		location = nil;
		[self locate];
	}
	return self;
}

// locate the user using CoreLocation
-(void)locate {
	if (nil == locationManager)
		locationManager = [[CLLocationManager alloc] init];
	
    [locationManager stopUpdatingLocation];
    locationManager.delegate = self;
	locationManager.distanceFilter = 0; //kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

// deal with any errors - fail if we are not allowed to use location
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSString *errorMsg;
	if (error.code ==  kCLErrorDenied) {
		errorMsg = @"Vote Report requires access to your location to work properly! Please call our automated phone-based system instead!";
	} else {
		errorMsg = @"Vote Report is unable to determine your location! Be sure you are not in airplane mode and have Wifi enabled, or please call our automated phone-based system!";
	}
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Vote Report" message:errorMsg delegate:[[UIApplication sharedApplication] delegate]  cancelButtonTitle:@"Call Now" otherButtonTitles:nil];
	[alert show];
}	


// Delegate method from the CLLocationManagerDelegate protocol.
// Update a user's location and timezone at the server
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"location timestamp: %@ (%f seconds ago)", [newLocation.timestamp description], [newLocation.timestamp timeIntervalSinceNow]);
	if ([newLocation.timestamp timeIntervalSinceNow] > -5.0) {
		[locationManager stopUpdatingLocation];
		self.location = newLocation;
	}
}

// Setter for the user's location; initiate a HTTP request to get the name of this place
// when the user's location is set
-(void)setLocation:(CLLocation *)newLocation {
	location = newLocation;
	[location retain];
	
	//Update server with new user location
	
	HTTPManager *httpRequest = [[HTTPManager alloc] init];
	httpRequest.target = self;
	httpRequest.targetSelector = @selector(storeLocationName:);
	NSDictionary *params = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%.3f,%.3f", location.coordinate.latitude, location.coordinate.longitude]
													   forKey:@"latlon"];
	[httpRequest performRequestWithMethod:@"GET" toUrl:TWITTERVISION_LOCATION_LOOKUP_URL withParameters:params];
}

// Store the name of the location when we get it back
-(void)storeLocationName:(HTTPManager *)manager
{
	if ([manager successful]) {
		self.locationName = [manager getResponseText];  //implied retain
		printf("location: %s\n", [locationName UTF8String]);
	}
	[manager release];
}

-(void)postReportWithParams:(NSMutableDictionary *)params {
	NSString *udid = [[UIDevice currentDevice] uniqueIdentifier];

	[params addEntriesFromDictionary:
		[NSDictionary dictionaryWithObjectsAndKeys:
		udid, @"reporter[uniqueid]",
		locationName, @"reporter[profile_location]",
		[NSString stringWithFormat:@"%.3f,%.3f:%.0f",
		 location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy ],
		@"reporter[latlon]",
		nil]
	];
	
	HTTPManager *httpRequest = [[HTTPManager alloc] init];
	httpRequest.target = self;
	httpRequest.targetSelector = @selector(reportComplete:);
	NSString *soundfile = [params valueForKey:@"soundfile"];
	if (soundfile)
		[httpRequest uploadFile:soundfile toUrl:VOTEREPORT_REPORTS_URL withParameters:params];
	else
		[httpRequest performRequestWithMethod:@"POST" toUrl:VOTEREPORT_REPORTS_URL withParameters:params];
}	

-(void)reportComplete:(HTTPManager *)manager
{
	successful = manager.successful;

	// Call our target's completion method
	if (target && [target respondsToSelector:targetSelector])
		[target performSelector:targetSelector withObject:self];
}

@end
