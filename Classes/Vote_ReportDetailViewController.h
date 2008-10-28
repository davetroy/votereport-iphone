#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CellSlider.h"
#import "CellAudio.h"

@interface Vote_ReportDetailViewController : UIViewController <UITextViewDelegate,UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate>
{
	IBOutlet UIView       *pickerViewWithButton;
	IBOutlet UIPickerView *pickerView;
	IBOutlet UITableView *tableView;
	IBOutlet UIViewController *pickerViewController;
	IBOutlet UINavigationBar *titleBar;
	IBOutlet UINavigationItem *titleBarItem;
	NSArray *pickerViewArray;
	
	UITextField  *nameTextField;
	UITextField  *pollingPlaceTextField;
	UISlider     *ratingSlider;
	CellSlider	 *ratingSliderCell;
	CellAudio	 *messageAudioCell;
	UITextView   *commentTextView;
	
	//DataField
	NSString *waitingTime;
	BOOL machine;
	BOOL registration;
	BOOL challenges;
	BOOL hava;
	BOOL ballots;
	
}

-(IBAction)donePicker;


@end
