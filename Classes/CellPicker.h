#import <UIKit/UIKit.h>

// cell identifier for this custom cell
extern NSString *kCellPicker_ID;

@interface CellPicker : UITableViewCell{
    UIPickerView *view;
}

@property (nonatomic, retain) UIPickerView *view;

@end
