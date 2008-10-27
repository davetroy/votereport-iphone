#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CellSlider.h"

@interface Vote_ReportDetailViewController : UIViewController <UITextViewDelegate,UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate>
{
	IBOutlet UIPickerView *pickerView;
	IBOutlet UITableView *tableView;
	IBOutlet UIViewController *pickerViewController;
	NSArray *pickerViewArray;
	
	UITextField  *nameTextField;
	UITextField  *pollingPlaceTextField;
	UISlider     *ratingSlider;
	CellSlider	 *ratingSliderCell;
	
	//DataField
	NSString *waitingTime;
	
}


@end
