 
#import "CellPicker.h"
#import "Constants.h"

// cell identifier for this custom cell
NSString *kCellPicker_ID = @"CellPickter_ID";

@implementation CellPicker

@synthesize view;

- (id)initWithFrame:(CGRect)aRect reuseIdentifier:(NSString *)identifier
{
	self = [super initWithFrame:aRect reuseIdentifier:identifier];
	return self;
}

- (void)setView:(UIPickerView *)inView
{
	view = inView;
	[self.view retain];
	
	//view.delegate = self;
	
	[self.contentView addSubview:inView];
}

/*
- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect contentRect = [self.contentView bounds];
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
	CGRect frame = CGRectMake(	contentRect.origin.x + kCellLeftOffset,
								contentRect.origin.y + kCellTopOffset,
								contentRect.size.width - (kCellLeftOffset*2.0),
								kTextFieldHeight);
	self.view.frame  = frame;
}
*/
- (void)dealloc
{
    [view release];
    [super dealloc];
}


@end
