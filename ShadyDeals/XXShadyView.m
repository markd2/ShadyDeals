#import "XXShadyView.h"

@implementation XXShadyView



- (void) evalShadingAtLocation: (float) location
              returningResults: (float *) results {
    if (self.fancyColors) {
        results[0] = location;
        results[1] = sin(M_PI * 2 * location);
        results[2] = cos(M_PI * 2 * location);
        results[3] = 1.0;
    } else {
        results[0] = location;
        results[1] = location;
        results[2] = location;
        results[3] = 1.0;
    }

} // evalShadingAtLocation


#if JUST_C_FUNC

static void shadingCallback (void *info, const float *in, float *out) {
    float thing = in[0];
 
    out[0] = thing;
    out[1] = thing;
    out[2] = thing;
    out[3] = 1.0;
} // shadingCallback

#else

static void shadingCallback (void *info, const float *in, float *out) {
    XXShadyView *view = (__bridge XXShadyView *)info;

    [view evalShadingAtLocation: *in
          returningResults: out];

} // shadingCallback

#endif


- (void) shadeInRect: (CGRect) rect {
    float domain[2] = { 0.0, 1.0 };  // 1-in function
    float range[8] = { 0.0, 1.0,     // N-out, RGBA
                       0.0, 1.0,
                       0.0, 1.0,
                       0.0, 1.0 };
    CGFunctionCallbacks callback = { 0, shadingCallback, NULL };

    CGFunctionRef shaderFunction = CGFunctionCreate ((__bridge void *)self,  // info
                                                     1,     // number of inputs for domain
                                                     domain,
                                                     4,     // number of inputs for range
                                                     range,
                                                     &callback);

    CGColorSpaceRef deviceRGB = CGColorSpaceCreateDeviceRGB ();

    CGShadingRef shader;

    if (self.style == kAxial) {
        CGPoint axisStart = CGPointMake (CGRectGetMinX(rect), CGRectGetMidY(rect));
        CGPoint axisEnd = CGPointMake (CGRectGetMaxX(rect), CGRectGetMidY(rect));

        shader = CGShadingCreateAxial (deviceRGB,      // colorspace
                                       axisStart,      // start of axis
                                       axisEnd,        // end of axis
                                       shaderFunction, // shader, 1-n, n-out
                                       false,          // extend start
                                       false);         // extend end
    } else {
        CGPoint center = CGPointMake (CGRectGetMidX(rect), CGRectGetMidY(rect));

        shader = CGShadingCreateRadial (deviceRGB,       // colorspace
                                        center,		 // circle 1 center
                                        rect.size.width * 0.1,  // circle 1 radius
                                        center,		 // circle 2 center
                                        rect.size.width, // circle 2 radius
                                        shaderFunction,  // shader, 1-n, n-out
                                        true,            // extend start - fill innner circle
                                        false);          // extend end
    }

    CGContextRef context = UIGraphicsGetCurrentContext ();

    CGContextSaveGState (context); {
        CGContextClipToRect (context, rect);
        CGContextDrawShading (context, shader);
    } CGContextRestoreGState (context);

    CGFunctionRelease (shaderFunction);
    CGColorSpaceRelease (deviceRGB);
    CGShadingRelease (shader);

} // shadeInRect


- (void) drawRect: (CGRect) rect {
    CGRect bounds = self.bounds;

    [[UIColor whiteColor] set];
    UIRectFill (bounds);

    [self shadeInRect: bounds];

    [[UIColor blackColor] set];
    UIRectFrame (bounds);

} // drawRect


- (void) setStyle: (XXShadyViewStyle) style {
    _style = style;
    [self setNeedsDisplay];
} // setStyle


- (void) setFancyColors: (BOOL) fancyColors {
    _fancyColors = fancyColors;
    [self setNeedsDisplay];
} // setFancyColors

@end // XXShadyView
