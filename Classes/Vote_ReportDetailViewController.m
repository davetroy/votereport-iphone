#import "Vote_ReportDetailViewController.h"
#import "DisplayCell.h"
#import "CellTextView.h"
#import "CellTextField.h"
#import "CellButton.h"
#import "SourceCell.h"
#import "Constants.h"


@implementation Vote_ReportDetailViewController

#pragma mark
#pragma mark UITextField - rounded
#pragma mark
- (UITextField *)createTextField_Rounded
{
	CGRect frame = CGRectMake(0.0, 0.0, kTextFieldWidth, kTextFieldHeight);
	UITextField *returnTextField = [[UITextField alloc] initWithFrame:frame];
    
	returnTextField.borderStyle = UITextBorderStyleRoundedRect;
    returnTextField.textColor = [UIColor blackColor];
	returnTextField.font = [UIFont systemFontOfSize:17.0];
    returnTextField.placeholder = @"<enter text>";
    returnTextField.backgroundColor = [UIColor whiteColor];
	returnTextField.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
	
	returnTextField.keyboardType = UIKeyboardTypeDefault;
	returnTextField.returnKeyType = UIReturnKeyDone;
	
	returnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	return returnTextField;
}

- (UITextView *)create_UITextView
{
	CGRect frame = CGRectMake(0.0, 0.0, 100.0, 100.0);
	
	UITextView *textView = [[[UITextView alloc] initWithFrame:frame] autorelease];
    textView.textColor = [UIColor blackColor];
    textView.font = [UIFont fontWithName:kFontName size:kTextViewFontSize];
    textView.delegate = self;
    textView.backgroundColor = [UIColor whiteColor];
	
	textView.text = @"Now is the time for all good developers to come to serve their country.\n\nNow is the time for all good developers to come to serve their country.";
	textView.returnKeyType = UIReturnKeyDefault;
	textView.keyboardType = UIKeyboardTypeDefault;	// use the default type input method (entire keyboard)
	
	// note: for UITextView, if you don't like autocompletion while typing use:
	// myTextView.autocorrectionType = UITextAutocorrectionTypeNo;
	
	return textView;
}

#pragma mark
#pragma mark UITextField - rounded
#pragma mark
- (UIButton *)createUIButton
{
	UIButton *returnButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[returnButton setTitle:@"Submit" forState:UIControlStateNormal];
	
	
	return returnButton;
}


/*
- (void)loadView 
{ 
	UITableView *tableView = [[[UITableView alloc] initWithFrame:[[UIScreen mainScreen] 
																  applicationFrame] 
														   style:UITableViewStyleGrouped] autorelease]; 
	tableView.autoresizingMask = 
	UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth; 
	tableView.delegate = self; 
	tableView.dataSource = self; 
	tableView.allowsSelectionDuringEditing = YES;	
	elementArray=nil;
	[tableView reloadData]; 
	self.tableView = tableView;
} 
*/

- (void)viewWillAppear:(BOOL)animated{
}

- (void)viewDidAppear:(BOOL)animated{
	[super viewDidAppear:animated];
}

// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
}


////////////////////////////////////////////////////////////
// UITableViewDataSource Implementation
//
//
///////////////////////////////////////////////////////////

// This table will always only have one section.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tv {
    return 7; 
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
	int num = 0;
	switch (section) {
		case 0: //NAME
			num=2;
			break;
		case 1: //Polling place
			num=2;
			break;
		case 2: //Wait Time
			num=2;
			break;
		case 3: //Overall Rating
			num=2;
			break;
		case 4: //Other Problems
			num=5;
			break;
		case 5: //Comments
			num=2;
			break;
		case 6: //Submit
			num=1;
			break;
		default:
			break;
	}
	return num;
}
- (UITableViewCell *)obtainTableTextFieldCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;
	
	if (row == 0)
		cell = [self.tableView dequeueReusableCellWithIdentifier:kCellTextField_ID];
	else if (row == 1)
		cell = [self.tableView dequeueReusableCellWithIdentifier:kSourceCell_ID];
	
	if (cell == nil)
	{
		if (row == 0)
			cell = [[[CellTextField alloc] initWithFrame:CGRectZero reuseIdentifier:kCellTextField_ID] autorelease];
		else if (row == 1)
			cell = [[[SourceCell alloc] initWithFrame:CGRectZero reuseIdentifier:kSourceCell_ID] autorelease];
	}
	
	return cell;
}

- (UITableViewCell *)obtainTableTextViewCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;
	
	if (row == 0)
		cell = [self.tableView dequeueReusableCellWithIdentifier:kCellTextView_ID];
	else if (row == 1)
		cell = [self.tableView dequeueReusableCellWithIdentifier:kSourceCell_ID];
	
	if (cell == nil)
	{
		if (row == 0)
			cell = [[[CellTextView alloc] initWithFrame:CGRectZero reuseIdentifier:kCellTextView_ID] autorelease];
		else if (row == 1)
			cell = [[[SourceCell alloc] initWithFrame:CGRectZero reuseIdentifier:kSourceCell_ID] autorelease];
	}
	
	return cell;
}

- (UITableViewCell *)obtainTableSwitchCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;
	
	cell = [self.tableView dequeueReusableCellWithIdentifier:kCellSwitch_ID];
	
	if (cell == nil)
	{
		cell = [[[CellTextField alloc] initWithFrame:CGRectZero reuseIdentifier:kCellSwitch_ID] autorelease];
	}
	
	return cell;
}

- (UITableViewCell *)obtainTableDisplayCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;
	
	if (row == 0)
		cell = [self.tableView dequeueReusableCellWithIdentifier:kDisplayCell_ID];
	else if (row == 1)
		cell = [self.tableView dequeueReusableCellWithIdentifier:kSourceCell_ID];
	
	if (cell == nil)
	{
		if (row == 0)
			cell = [[[DisplayCell alloc] initWithFrame:CGRectZero reuseIdentifier:kDisplayCell_ID] autorelease];
		else if (row == 1)
			cell = [[[SourceCell alloc] initWithFrame:CGRectZero reuseIdentifier:kSourceCell_ID] autorelease];
	}
	return cell;
}

- (UITableViewCell *)obtainTableButtonCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;

	cell = [self.tableView dequeueReusableCellWithIdentifier:kCellButton_ID];
	
	if (cell == nil)
	{
		cell = [[[CellButton alloc] initWithFrame:CGRectZero reuseIdentifier:kCellButton_ID] autorelease];
	}
	
	
	
	return cell;
}


- (UITableViewCell *)obtainTableCellForRow:(NSInteger)row inSection:(NSInteger)section
{
	UITableViewCell *cell = nil;
	switch (section) {
			case 0: //NAME
				cell = [self obtainTableTextFieldCellForRow:row];
				break;
			case 1: //Polling place
				cell = [self obtainTableTextFieldCellForRow:row];
				break;
			case 2: //Wait Time
				cell = [self obtainTableDisplayCellForRow:row];
				break;
			case 3: //Overall Rating
				cell = [self obtainTableTextFieldCellForRow:row];
				break;
			case 4: //Other Problems
				cell = [self obtainTableSwitchCellForRow:row];
				break;
			case 5: //Comments
				cell = [self obtainTableTextViewCellForRow:row];
				break;
			case 6: //Submit
				cell = [self obtainTableButtonCellForRow:row];
				break;
			default:
				break;
			}
			
			
			return cell;
			
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	NSInteger section = indexPath.section;
	NSInteger row = indexPath.row;
	UITableViewCell *sourceCell = [self obtainTableCellForRow:row inSection:section];
	
	switch (section) {
		case 0: //NAME
			if (row == 0)
			{
				// this cell hosts the UISwitch control
				((CellTextField *)sourceCell).view = [self createTextField_Rounded];
			}
			else
			{
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Please enter your name.";
			}
			break;
		case 1: //Polling place
			if (row == 0)
			{
				// this cell hosts the UISwitch control
				((CellTextField *)sourceCell).view = [self createTextField_Rounded];
			}
			else
			{
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Please enter your polling place.";
			}
			break;
		case 2: //Wait Time
			if (row == 0)
			{
				// this cell hosts the UISwitch control
				((DisplayCell *)sourceCell).nameLabel.text = @"Wait time";
			}
			else
			{
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Please enter your total wait time.";
			}
			break;
		case 3: //Overall Rating
			if (row == 0)
			{
				// this cell hosts the UISwitch control
				((CellTextField *)sourceCell).view = [self createTextField_Rounded];
			}
			else
			{
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Please enter your overall rating.";
			}
			break;
		case 4: //Other Problems
				((CellTextField *)sourceCell).view = [self createTextField_Rounded];
			break;
		case 5: //Comments
			if (row == 0)
			{
				// this cell hosts the UISwitch control
				((CellTextView *)sourceCell).view = [self create_UITextView];
			}
			else
			{
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Please enter any other comments.";
			}
			break;
		case 6: //Submit
			((CellButton *)sourceCell).view = [self createUIButton];
			break;
		default:
			break;
	}
	
	
    return sourceCell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *title;
	
	switch (section) {
		case 0: //NAME
			title = @"Your Name";
			break;
		case 1: //Polling place
			title = @"Polling Place";
			break;
		case 2: //Wait Time
			title = @"Waiting Time";
			break;
		case 3: //Overall Rating
			title=@"Overall Rating";
			break;
		case 4: //Other Problems
			title=@"Other Problems";
			break;
		case 5: //Comments
			title=@"Comments";
			break;
		case 6: //Submit
			title=nil;
			break;
		default:
			break;
	}
    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 4.0;
}

/*
 - (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
 UIView *myEmptyView = [[[UIView alloc] initWithFrame:CGRectMake(0,0,10,10)] autorelease];
 return myEmptyView;
 }
 */

- (UITableViewCellAccessoryType)tableView:(UITableView *)tv accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellAccessoryNone;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
	return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath{
	return NO;	
}

/*
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
 return YES;	
 }
 */

/*
 - (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 return nil;	
 }
 */


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)newIndexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
	NSInteger section = newIndexPath.section;
	
	if (section==2){
		[self presentModalViewController:pickerViewController animated:YES];
	}
}


- (void)dealloc {
    [super dealloc];
}

@end
