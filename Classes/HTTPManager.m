//
//  HTTPManager.m
//
//  Created by David Troy on 5/31/08.
//  Copyright 2008 Popvox, LLC. All rights reserved.
//

#import "HTTPManager.h"

@implementation HTTPManager

@synthesize receivedData;
@synthesize timeout;
@synthesize cache;
@synthesize successful;
@synthesize target;
@synthesize targetSelector;
@synthesize userData;

- (id)init
{
	self = [super init];
	if (self) {
		receivedData = [[NSMutableData alloc] init];
		timeout = 30;
		cache = [NSURLCache sharedURLCache];
	}
	return self;
}

-(void)uploadFile:(NSString *)filename
			toUrl:(NSString *)url
   withParameters:(NSDictionary *)parameters
{
	NSString *boundary = [[UIDevice currentDevice] uniqueIdentifier];
	
	NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
	[urlRequest setHTTPMethod:@"POST"];
	[urlRequest setValue: [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];

	NSMutableString* params = [[[NSMutableString alloc] init] autorelease];  
	for (id key in parameters)  
	{  
		[params appendFormat:@"--%@\r\n", boundary];
		[params appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", key];
		[params appendString:[parameters objectForKey:key]];
	}  

	NSData *data = [NSData dataWithContentsOfFile:filename];
	NSMutableData *postData = [NSMutableData dataWithCapacity: [data length] + [params length] + 512];
	[postData appendData: [params dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData: [[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData: [[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n", @"uploaded", filename] dataUsingEncoding:NSUTF8StringEncoding]];
	[postData appendData:data];
	[postData appendData: [[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

	[urlRequest setHTTPBody:postData];
	
	printf("http upload: %s [POST]\n", [url UTF8String]);
	myConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
}

- (void)performRequestWithMethod:(NSString *)method
						   toUrl:(NSString *)url
				  withParameters:(NSDictionary *)parameters
{
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:timeout];
	if (parameters) {
		NSMutableString* params = [[[NSMutableString alloc] init] autorelease];  
		for (id key in parameters)  
		{  
			[params appendFormat:@"%@=%@&",   
			 [key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],   
			 [[parameters objectForKey:key]   
			  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];  
		}  
		[params deleteCharactersInRange:NSMakeRange([params length] - 1, 1)];  
		
		if ([method isEqual:@"GET"]) {
			NSMutableString* urlWithParams = [NSMutableString stringWithString:url];
			[urlWithParams appendFormat:@"?%@", params];
			[theRequest setURL:[NSURL URLWithString:urlWithParams]];
		} else {				
			NSData* body = [params dataUsingEncoding:NSUTF8StringEncoding];
			[theRequest setHTTPBody:body];
			printf("params: %s\n", [body bytes]);
		}
	}
	
	[theRequest setHTTPMethod:method];
	
	// PUT does not set form data header correctly; address this
	if ([method isEqual:@"PUT"])
		[theRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	
	printf("http async: %s [%s]\n", [url UTF8String], [method UTF8String]);
	myConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self startImmediately:YES];
	if (myConnection)
		self.receivedData = [NSMutableData data];  // Note: retain is implied
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    printf("Succeeded! Received %d bytes of data\n",[receivedData length]);
	successful = YES;
	
    // release the connection
    [connection release];
	
	// Call our target's completion method
	if (target && [target respondsToSelector:targetSelector])
		[target performSelector:targetSelector withObject:self];
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if (connection) {
		// release the connection, and the data object
		[connection release];
	}
	
	successful = NO;
	
	// Call our target's completion method
	if (target && [target respondsToSelector:targetSelector])
		[target performSelector:targetSelector withObject:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}


-(NSString*)getResponseText {  
    NSString *responseText = [[[NSString alloc]
							   initWithData:receivedData   
							   encoding:NSUTF8StringEncoding] autorelease];
	return responseText;
}  

- (void)dealloc {
	[myConnection cancel];
	[receivedData release];
	[super dealloc];
}

@end
