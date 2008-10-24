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

-(void)storeLocationName:(HTTPManager *)manager
{
	if ([manager successful]) {
		self.locationName = [manager getResponseText];  //implied retain
		printf("location: %s\n", [locationName UTF8String]);
	}
	[manager release];
}

@end
