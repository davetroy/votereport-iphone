//
//  CellAudio.h
//  Vote Report
//
//  Created by David Troy on 10/27/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioQueueObject.h"
#import "AudioRecorder.h"
#import "AudioPlayer.h"

extern NSString *kCellAudio_ID;

@interface CellAudio : UITableViewCell {
	AudioRecorder				*audioRecorder;
	AudioPlayer					*audioPlayer;
	NSURL						*soundFileURL;
	NSString					*recordingDirectory;
	
	NSTimer						*bargraphTimer;
	Float32						*audioLevels;
	Float32						*peakLevels;
	CALayer			*levelMeter;
	CALayer			*peakLevelMeter;
	
	UIColor						*peakClear;
	UIColor						*peakGray;
	UIColor						*peakOrange;
	UIColor						*peakRed;
	
	UITextField		*statusSign;
	
	UIButton	*recordButton;
	UIButton	*playButton;
	
	BOOL						interruptedOnPlayback;
	BOOL		didRecording;
}

@property (nonatomic, retain)	AudioRecorder				*audioRecorder;
@property (nonatomic, retain)	AudioPlayer					*audioPlayer;
@property (nonatomic, retain)	NSURL						*soundFileURL;
@property (nonatomic, retain)	NSString					*recordingDirectory;

@property (nonatomic, retain)	NSTimer						*bargraphTimer;
@property (readwrite)			Float32						*audioLevels;
@property (readwrite)			Float32						*peakLevels;
@property (nonatomic, retain)	CALayer						*levelMeter;
@property (nonatomic, retain)	CALayer						*peakLevelMeter;
@property (nonatomic, retain)	UITextField		*statusSign;

@property (nonatomic, retain)	UIColor						*peakClear;
@property (nonatomic, retain)	UIColor						*peakGray;
@property (nonatomic, retain)	UIColor						*peakOrange;
@property (nonatomic, retain)	UIColor						*peakRed;

@property (nonatomic, retain)	UIButton	*recordButton;
@property (nonatomic, retain)	UIButton	*playButton; 

@property (readwrite)			BOOL						interruptedOnPlayback;
@property (readonly)			BOOL						didRecording;

- (void) addBargraphToView: (UIView *) parentView;
- (void) updateUserInterfaceOnAudioQueueStateChange: (AudioQueueObject *) inQueue;
- (void) updateBargraph: (NSTimer *) timer;
- (void) resetBargraph;
- (IBAction) recordOrStop: (id) sender;
- (IBAction) playOrStop: (id) sender;
- (void) pausePlayback;
- (void) resumePlayback;


@end
