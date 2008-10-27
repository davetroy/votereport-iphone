//
//  Reporter.h
//  Vote Report
//
//  Created by David Troy on 10/24/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Reporter : NSObject <CLLocationManagerDelegate> {
	CLLocationManager *locationManager;
	CLLocation *location;
	NSString *locationName;
}

@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, retain) NSString *locationName;

-(void)locate;

@end
