 
#import "CellSlider.h"
#import "Constants.h"

// cell identifier for this custom cell
NSString *kCellSlider_ID = @"CellSlider_ID";

@implementation CellSlider

@synthesize view;
@synthesize label;

- (id)initWithFrame:(CGRect)aRect reuseIdentifier:(NSString *)identifier
{
	self = [super initWithFrame:aRect reuseIdentifier:identifier];
	label = [[UILabel alloc] initWithFrame:aRect];
	label.backgroundColor = [UIColor clearColor];
	label.opaque = NO;
	label.textAlignment = UITextAlignmentCenter;
	label.textColor = [UIColor grayColor];
	label.highlightedTextColor = [UIColor blackColor];
	label.font = [UIFont systemFontOfSize:12];
	label.text = @"50";
	[self.contentView addSubview:label];
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
	
	CGRect labelFrame = CGRectMake(	contentRect.origin.x + kCellLeftOffset,
								contentRect.origin.y + 5,
								contentRect.size.width - (kCellLeftOffset*2.0),
								contentRect.size.height/2);
	
	CGRect sliderFrame = CGRectMake(	contentRect.origin.x + kCellLeftOffset,
								   contentRect.origin.y + 25,
								   contentRect.size.width - (kCellLeftOffset*2.0),
								   contentRect.size.height/2);
	label.frame = labelFrame;
	view.frame = sliderFrame;
	
}

- (void)dealloc
{
    [view release];
    [super dealloc];
}


@end
