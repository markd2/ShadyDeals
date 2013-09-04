#import "XXViewController.h"
#import "XXShadyView.h"


@interface XXViewController ()
@property (weak, nonatomic) IBOutlet XXShadyView *shadyView;
- (IBAction) changeStyle: (UISegmentedControl *) toggle;
- (IBAction) changeColors: (UISegmentedControl *) toggle;
@end


@implementation XXViewController

- (void) viewDidLoad {
    [super viewDidLoad];
} // viewDidLoad


- (IBAction) changeStyle: (UISegmentedControl *) toggle {
    self.shadyView.style = (XXShadyViewStyle) toggle.selectedSegmentIndex;
} // changeStyle


- (IBAction) changeColors: (UISegmentedControl *) toggle {
    self.shadyView.fancyColors = (BOOL) toggle.selectedSegmentIndex;
} // changeColors


@end
