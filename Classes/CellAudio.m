//
//  CellAudio.m
//  Vote Report
//
//  Created by David Troy on 10/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CellAudio.h"
#import "Constants.h"

#define kLevelMeterLeft		29
#define kLevelMeterTop		30
#define kLevelMeterWidth	155
#define kLevelMeterHeight	28
#define kLevelOverload		0.9
#define kLevelHot			0.7
#define kLevelMinimum		0.01

void interruptionListenerCallback (
								   void	*inUserData,
								   UInt32	interruptionState
) {
	// This callback, being outside the implementation block, needs a reference 
	//	to the CellAudio object
	CellAudio *cell = (CellAudio *) inUserData;
	
	if (interruptionState == kAudioSessionBeginInterruption) {
		
		NSLog (@"Interrupted. Stopping playback or recording.");
		
		if (cell.audioRecorder) {
			// if currently recording, stop
			[cell recordOrStop: (id) cell];
		} else if (cell.audioPlayer) {
			// if currently playing, pause
			[cell pausePlayback];
			cell.interruptedOnPlayback = YES;
		}
		
	} else if ((interruptionState == kAudioSessionEndInterruption) && cell.interruptedOnPlayback) {
		// if the interruption was removed, and the app had been playing, resume playback
		[cell resumePlayback];
		cell.interruptedOnPlayback = NO;
	}
}

// cell identifier for this custom cell
NSString *kCellAudio_ID = @"CellAudio_ID";

@implementation CellAudio

@synthesize audioPlayer;			// the playback audio queue object
@synthesize audioRecorder;			// the recording audio queue object
@synthesize soundFileURL;			// the sound file to record to and to play back
@synthesize recordingDirectory;		// the location to record into; it's the application's Documents directory
@synthesize playButton;				// the play button, which toggles to display "stop"
@synthesize recordButton;			// the record button, which toggles to display "stop"
@synthesize levelMeter;				// a mono audio level meter to show average level, implemented using Core Animation
@synthesize peakLevelMeter;			// a mono audio level meter to show peak level, implemented using Core Animation
@synthesize peakGray;				// colors to use with the peak audio level display
@synthesize peakOrange;
@synthesize peakRed;
@synthesize peakClear;
@synthesize bargraphTimer;			// a timer for updating the level meter
@synthesize audioLevels;			// an array of two floating point values that represents the current recording or playback audio level
@synthesize peakLevels;				// an array of two floating point values that represents the current recording or playback audio level
@synthesize statusSign;				// a UILabel object that says "Recording" or "Playback," or empty when stopped
@synthesize interruptedOnPlayback;	// this allows playback to resume when an interruption ends. this app does not resume a recording for the user.
@synthesize didRecording;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		// this app uses a fixed file name at a fixed location, so it makes sense to set the name and 
		// URL here.
		NSArray *filePaths =	NSSearchPathForDirectoriesInDomains (
																	 
																	 NSDocumentDirectory, 
																	 NSUserDomainMask,
																	 YES
																	 ); 
		
		self.recordingDirectory = [filePaths objectAtIndex: 0];
		
		CFStringRef fileString = (CFStringRef) [NSString stringWithFormat: @"%@/Recording.caf", self.recordingDirectory];
		
		//Delete previous audio report
		[[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat: @"%@/Recording.caf", self.recordingDirectory] error:NULL];

		// create the file URL that identifies the file that the recording audio queue object records into
		CFURLRef fileURL =	CFURLCreateWithFileSystemPath (
														   NULL,
														   fileString,
														   kCFURLPOSIXPathStyle,
														   false
														   );
		NSLog (@"Recorded file path: %@", fileURL); // shows the location of the recorded file
		
		// save the sound file URL as an object attribute (as an NSURL object)
		if (fileURL) {
			self.soundFileURL	= (NSURL *) fileURL;
			CFRelease (fileURL);
		}
		
		// allocate memory to hold audio level values
		audioLevels = calloc (2, sizeof (AudioQueueLevelMeterState));
		peakLevels = calloc (2, sizeof (AudioQueueLevelMeterState));
		
		// initialize the audio session object for this application,
		//		registering the callback that Audio Session Services will invoke 
		//		when there's an interruption
		AudioSessionInitialize (
								NULL,
								NULL,
								interruptionListenerCallback,
								self
								);
		

		playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[playButton setTitle:@"Play" forState:UIControlStateNormal];
		playButton.frame = CGRectMake(210, 10, 70, 30);
		[playButton addTarget:self action:@selector(playOrStop:) forControlEvents:UIControlEventTouchUpInside];
		[self.playButton setEnabled:NO];
		[self.contentView addSubview:playButton];

		recordButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[recordButton setTitle:@"Record" forState:UIControlStateNormal];
		recordButton.frame = CGRectMake(210, 50, 70, 30);
		[recordButton addTarget:self action:@selector(recordOrStop:) forControlEvents:UIControlEventTouchUpInside];
		[self.contentView addSubview:recordButton];
		
		[self addBargraphToView:self.contentView];

    }
    return self;
}

- (void) addBargraphToView: (UIView *) parentView {
	
	// static image for showing average level
	UIImage *soundbarImage		= [[UIImage imageNamed: @"soundbar_mono.png"] retain];
	UIImageView *soundbarBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed: @"soundbar_plate_mono.png"]];
	soundbarBackground.frame = CGRectMake(10, 10, 185, 72);
	[parentView addSubview:soundbarBackground];
	
	// background colors for generated image for showing peak level
	self.peakClear				= [UIColor clearColor];
	self.peakGray				= [UIColor lightGrayColor];
	self.peakOrange				= [UIColor orangeColor];
	self.peakRed				= [UIColor redColor]; 
	
	levelMeter					= [CALayer layer];
	levelMeter.anchorPoint		= CGPointMake (0.0, 0.5);						// anchor to halfway up the left edge
	levelMeter.frame			= CGRectMake (kLevelMeterLeft, kLevelMeterTop, 0, kLevelMeterHeight);	// set width to 0 to start to completely hide the bar graph segements
	levelMeter.contents			= (UIImage *) soundbarImage.CGImage;
	
	peakLevelMeter				= [CALayer layer];
	peakLevelMeter.frame		= CGRectMake (kLevelMeterLeft, kLevelMeterTop, 0, kLevelMeterHeight);
	peakLevelMeter.anchorPoint	= CGPointMake (0.0, 0.5);
	peakLevelMeter.backgroundColor = peakGray.CGColor;
	
	peakLevelMeter.bounds		= CGRectMake (0, 0, 0, kLevelMeterHeight);
	peakLevelMeter.contentsRect	= CGRectMake (0, 0, 1.0, 1.0);
	
	[parentView.layer addSublayer: levelMeter];
	[parentView.layer addSublayer: peakLevelMeter];
}

- (void) viewDidLoad {
	
	NSFileManager * fileManager = [NSFileManager defaultManager];
	
	// on the very first launch of the application, there's no file to play,
	//	so gray out the Play button
	if ([fileManager fileExistsAtPath: [NSString stringWithFormat: @"%@/Recording.caf", self.recordingDirectory]] != TRUE) {
		[self.playButton setEnabled: NO];
	}
	
	
	[statusSign setFont: [UIFont fontWithName: @"Helvetica" size: 24.0]];
}


// this method gets called (by property listener callback functions) when a recording or playback 
// audio queue object starts or stops. 
- (void) updateUserInterfaceOnAudioQueueStateChange: (AudioQueueObject *) inQueue {
	
	NSAutoreleasePool *uiUpdatePool = [[NSAutoreleasePool alloc] init];
	
	NSLog (@"updateUserInterfaceOnAudioQueueStateChange just called.");
	
	// the audio queue (playback or record) just started
	if ([inQueue isRunning]) {
		
		// create a timer for updating the audio level meter
		self.bargraphTimer = [NSTimer scheduledTimerWithTimeInterval:	0.05		// seconds
															  target:		self
															selector:	@selector (updateBargraph:)
															userInfo:	inQueue		// makes the currently-active audio queue (record or playback) available to the updateBargraph method
															 repeats:	YES];
		// playback just started
		if (inQueue == self.audioPlayer) {
			
			NSLog (@"playback just started.");
			[self.recordButton setEnabled: NO];
			[self.playButton setTitle: @"Stop"  forState:UIControlStateNormal];
			[self.statusSign setText: @"Playback"];
			[self.statusSign setTextColor: [UIColor colorWithRed: 0.0 green: 0.0 blue: 0.0 alpha: 1.0]];
			
			// recording just started
		} else if (inQueue == self.audioRecorder) {
			didRecording = YES;
			NSLog (@"recording just started.");
			[self.playButton setEnabled: NO];
			NSLog (@"setting Record button title to Stop.");
			[self.recordButton setTitle: @"Stop" forState:UIControlStateNormal];
			[self.statusSign setText: @"Recording"];
			[self.statusSign setTextColor: [UIColor colorWithRed: 0.67 green: 0.0 blue: 0.0 alpha: 1.0]];
		}
		// the audio queue (playback or record) just stopped
	} else {
		
		// playback just stopped
		if (inQueue == self.audioPlayer) {
			
			NSLog (@"playback just stopped.");
			[self.recordButton setEnabled: YES];
			[self.playButton setTitle: @"Play"  forState:UIControlStateNormal];
			
			[audioPlayer release];
			audioPlayer = nil;
			
			// recording just stopped
		} else if (inQueue == self.audioRecorder) {
			NSLog (@"recording just stopped.");
			[self.playButton setEnabled: YES];
			NSLog (@"setting Record button title to Record.");
			[self.recordButton setTitle: @"Record"  forState:UIControlStateNormal];
			
			[audioRecorder release];
			audioRecorder = nil;
		}
		
		if (self.bargraphTimer) {
			
			[self.bargraphTimer invalidate];
			[self.bargraphTimer release];
			bargraphTimer = nil;
		}
		
		[self.statusSign setText: @""];
		[self resetBargraph];
	}
	
	[uiUpdatePool drain];
}


// respond to a tap on the Record button. If stopped, start recording. If recording, stop.
// an audio queue object is created for each recording, and destroyed when the recording finishes.
- (void) recordOrStop: (id) sender {
	
	NSLog (@"recordOrStop:");
	
	// if not recording, start recording
	if (self.audioRecorder == nil) {
		
		// before instantiating the recording audio queue object, 
		//	set the audio session category
		UInt32 sessionCategory = kAudioSessionCategory_RecordAudio;
		AudioSessionSetProperty (
								 kAudioSessionProperty_AudioCategory,
								 sizeof (sessionCategory),
								 &sessionCategory
								 );
		
		// the first step in recording is to instantiate a recording audio queue object
		AudioRecorder *theRecorder = [[AudioRecorder alloc] initWithURL: self.soundFileURL];
		
		// if the audio queue was successfully created, initiate recording.
		if (theRecorder) {
			
			self.audioRecorder = theRecorder;
			[theRecorder release];								// decrements the retain count for the theRecorder object
			
			[self.audioRecorder setNotificationDelegate: self];	// sets up the recorder object to receive property change notifications 
			//	from the recording audio queue object
			
			// activate the audio session immediately before recording starts
			AudioSessionSetActive (true);
			NSLog (@"sending record message to recorder object.");
			[self.audioRecorder record];						// starts the recording audio queue object
		}
		
		// else if recording, stop recording
	} else if (self.audioRecorder) {
		
		[self.audioRecorder setStopping: YES];				// this flag lets the property listener callback
		//	know that the user has tapped Stop
		NSLog (@"sending stop message to recorder object.");
		[self.audioRecorder stop];							// stops the recording audio queue object. the object 
		//	remains in existence until it actually stops, at
		//	which point the property listener callback calls
		//	this class's updateUserInterfaceOnAudioQueueStateChange:
		//	method, which releases the recording object.
		// now that recording has stopped, deactivate the audio session
		AudioSessionSetActive (false);
		
	}
}

// respond to a tap on the Play button. If stopped, start playing. If playing, stop.
- (void) playOrStop: (id) sender {
	
	NSLog (@"playOrStop:");
	
	// if not playing, start playing
	if (self.audioPlayer == nil) {
		
		// before instantiating the playback audio queue object, 
		//	set the audio session category
		UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
		AudioSessionSetProperty (
								 kAudioSessionProperty_AudioCategory,
								 sizeof (sessionCategory),
								 &sessionCategory
								 );
		
		AudioPlayer *thePlayer = [[AudioPlayer alloc] initWithURL: self.soundFileURL];
		
		if (thePlayer) {
			
			self.audioPlayer = thePlayer;
			[thePlayer release];								// decrements the retain count for the thePlayer object
			
			[self.audioPlayer setNotificationDelegate: self];	// sets up the playback object to receive property change notifications from the playback audio queue object
			
			// activate the audio session immmediately before playback starts
			AudioSessionSetActive (true);
			NSLog (@"sending play message to play object.");
			[self.audioPlayer play];
		}
		
		// else if playing, stop playing
	} else if (self.audioPlayer) {
		
		NSLog (@"User tapped Stop to stop playing.");
		[self.audioPlayer setAudioPlayerShouldStopImmediately: YES];
		NSLog (@"Calling AudioQueueStop from cell object.");
		[self.audioPlayer stop];
		
		// now that playback has stopped, deactivate the audio session
		AudioSessionSetActive (false);
	}  
}

// pausing is only ever invoked by the interruption listener callback function, which
//	is why this isn't an IBAction method(that is, 
//	there's no explicit UI for invoking this method)
- (void) pausePlayback {
	
	if (self.audioPlayer) {
		
		NSLog (@"Pausing playback on interruption.");
		[self.audioPlayer pause];
	}
}

// resuming playback is only every invoked if the user rejects an incoming call
//	or other interruption, which is why this isn't an IBAction method (that is, 
//	there's no explicit UI for invoking this method)
- (void) resumePlayback {
	
	NSLog (@"Resuming playback on end of interruption.");
	
	// before resuming playback, set the audio session
	// category and activate it
	UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
	AudioSessionSetProperty (
							 kAudioSessionProperty_AudioCategory,
							 sizeof (sessionCategory),
							 &sessionCategory
							 );
	AudioSessionSetActive (true);
	
	[self.audioPlayer resume];
}

// Core Animation-based audio level meter updating method
- (void) updateBargraph: (NSTimer *) timer {
	
	AudioQueueObject *activeQueue = (AudioQueueObject *) [timer userInfo];
	
	if (activeQueue) {
		
		[activeQueue getAudioLevels: self.audioLevels peakLevels: self.peakLevels];
		//		NSLog (@"Average: %f, Peak: %f", audioLevels[0], peakLevels[0]);
		
		[CATransaction begin];
		
		[CATransaction setValue: [NSNumber numberWithBool:YES] forKey: kCATransactionDisableActions];
		
		levelMeter.bounds =			CGRectMake (
												0,
												0,
												(audioLevels[0] > 1.0 ? 1.0 : audioLevels[0]) * kLevelMeterWidth,
												kLevelMeterHeight
												);
		
		levelMeter.contentsRect	=	CGRectMake (
												0,
												0,
												audioLevels[0],
												1.0
												);
		
		peakLevelMeter.frame =		CGRectMake (
												kLevelMeterLeft + (peakLevels[0] > 1.0 ? 1.0 : peakLevels[0] )* kLevelMeterWidth,
												kLevelMeterTop,
												3,
												kLevelMeterHeight
												);
		peakLevelMeter.bounds =		CGRectMake (
												0,
												0,
												3,
												kLevelMeterHeight
												);
		
		if (peakLevels[0] > kLevelOverload) {
			peakLevelMeter.backgroundColor = self.peakRed.CGColor;
		} else if (peakLevels[0] > kLevelHot) {
			peakLevelMeter.backgroundColor = self.peakOrange.CGColor;
		} else if (peakLevels[0] > kLevelMinimum) {
			peakLevelMeter.backgroundColor = self.peakGray.CGColor;
		} else {
			peakLevelMeter.backgroundColor = self.peakClear.CGColor;
		}
		
		[CATransaction commit];
	}
}


- (void) resetBargraph {
	
	levelMeter.bounds		= CGRectMake (0, 0, 0, kLevelMeterHeight);
	peakLevelMeter.frame	= CGRectMake (kLevelMeterLeft, kLevelMeterTop, 3, kLevelMeterHeight);
	peakLevelMeter.bounds	= CGRectMake (0, 0, 0, kLevelMeterHeight);
}

//////////
// Standard table cell view stuff from here down
//////////

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)dealloc {
	[recordButton		release];
	[playButton			release];
    [super dealloc];
}


@end
