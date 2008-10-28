//
//  HTTPManager.h
//
//  Created by David Troy on 5/31/08.
//  Copyright 2008 Popvox, LLC. All rights reserved.
//


@interface HTTPManager : NSObject {
	NSURLCache *cache;
	NSMutableData *receivedData;
	int timeout;
	BOOL successful;
	id target;
	SEL targetSelector;
	id userData;
	NSURLConnection *myConnection;
}

-(void)performRequestWithMethod:(NSString *)method
						  toUrl:(NSString *)url
				 withParameters:(NSDictionary *)parameters;
-(NSString*)getResponseText;
-(void)uploadFile:(NSString *)filename
			toUrl:(NSString *)url
   withParameters:(NSDictionary *)parameters;


@property (nonatomic, retain) NSURLCache *cache;
@property (nonatomic, retain) NSData *receivedData;
@property (nonatomic, retain) id userData;
@property (nonatomic, retain) id target;
@property (nonatomic, readonly) BOOL successful;
@property (nonatomic) int timeout;
@property (nonatomic) SEL targetSelector;
@end
