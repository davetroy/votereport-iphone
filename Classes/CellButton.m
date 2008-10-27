 
#import "CellButton.h"
#import "Constants.h"

// cell identifier for this custom cell
NSString *kCellButton_ID = @"CellButton_ID";

@implementation CellButton

@synthesize view;

- (id)initWithFrame:(CGRect)aRect reuseIdentifier:(NSString *)identifier
{
	self = [super initWithFrame:aRect reuseIdentifier:identifier];
	return self;
}

- (void)setView:(UIView *)inView
{
	view = inView;
	[self.view retain];
	
	//view.delegate = self;
	
	[self.contentView addSubview:inView];
	[self layoutSubviews];
}

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

- (void)dealloc
{
    [view release];
    [super dealloc];
}


@end
