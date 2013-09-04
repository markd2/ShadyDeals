#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, XXShadyViewStyle) {
    kAxial,
    kRadial
};

@interface XXShadyView : UIView

@property (assign, nonatomic) XXShadyViewStyle style;
@property (assign, nonatomic) BOOL fancyColors;

@end // XXShadyView

