#import "AudioQueueObject.h"
#import "AudioRecorder.h"
#import "AudioPlayer.h"
#import "HTTPManager.h"

@interface AudioViewController : UIViewController {

	AudioRecorder				*audioRecorder;
	AudioPlayer					*audioPlayer;
	NSURL						*soundFileURL;
	NSString					*recordingDirectory;
	
	NSTimer						*bargraphTimer;
	Float32						*audioLevels;
	Float32						*peakLevels;
	IBOutlet CALayer			*levelMeter;
	IBOutlet CALayer			*peakLevelMeter;

	UIColor						*peakClear;
	UIColor						*peakGray;
	UIColor						*peakOrange;
	UIColor						*peakRed;

	IBOutlet UITextField		*statusSign;

	IBOutlet UIBarButtonItem	*recordButton;
	IBOutlet UIBarButtonItem	*playButton;
	
	BOOL						interruptedOnPlayback;
	HTTPManager					*httprequest;
}

@property (nonatomic, retain)	HTTPManager					*httpRequest;
@property (nonatomic, retain)	AudioRecorder				*audioRecorder;
@property (nonatomic, retain)	AudioPlayer					*audioPlayer;
@property (nonatomic, retain)	NSURL						*soundFileURL;
@property (nonatomic, retain)	NSString					*recordingDirectory;

@property (nonatomic, retain)	NSTimer						*bargraphTimer;
@property (readwrite)			Float32						*audioLevels;
@property (readwrite)			Float32						*peakLevels;
@property (nonatomic, retain)	CALayer						*levelMeter;
@property (nonatomic, retain)	CALayer						*peakLevelMeter;
@property (nonatomic, retain)	IBOutlet UITextField		*statusSign;

@property (nonatomic, retain)	UIColor						*peakClear;
@property (nonatomic, retain)	UIColor						*peakGray;
@property (nonatomic, retain)	UIColor						*peakOrange;
@property (nonatomic, retain)	UIColor						*peakRed;

@property (nonatomic, retain)	IBOutlet UIBarButtonItem	*recordButton;
@property (nonatomic, retain)	IBOutlet UIBarButtonItem	*playButton; 

@property (readwrite)			BOOL						interruptedOnPlayback;

- (void) addBargraphToView: (UIView *) parentView;
- (void) updateUserInterfaceOnAudioQueueStateChange: (AudioQueueObject *) inQueue;
- (void) updateBargraph: (NSTimer *) timer;
- (void) resetBargraph;
- (IBAction) recordOrStop: (id) sender;
- (IBAction) playOrStop: (id) sender;
- (void) pausePlayback;
- (void) resumePlayback;

@end
