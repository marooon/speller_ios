//
//  C8JTextField.m
//  Speller
//
//  Created by liulei on 2/14/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import "C8JTextField.h"

@implementation C8JTextField

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
		//UIImage* image = [UIImage imageNamed:@"msgbox.png"];
        self.font = [UIFont fontWithName:@"Baskerville-SemiBold" size:26];
        
		//UIImage* disabledImage = [UIImage imageNamed:@"msgbox_disabled.png"];
        
        //		UIEdgeInsets insets = UIEdgeInsetsMake(10,10,10,10);
        
        //		if ([image respondsToSelector:@selector(resizableImageWithCapInsets)] ) {
        //			image = [image resizableImageWithCapInsets:insets];
        //   disabledImage = [disabledImage resizableImageWithCapInsets:insets];
        //		}else{
        //			image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        //  disabledImage = [disabledImage stretchableImageWithLeftCapWidth:10 topCapHeight:10];
        //		}
       // self.backgroundColor = [UIColor whiteColor];
       // self.borderStyle = UITextBorderStyleRoundedRect;
        cornerRadiusA = roundf(frame.size.height/2);
		//self.background = image;
        //  self.disabledBackground = disabledImage;
    }
    return self;
}

-(void)onCloseKeyboard:(id)sender
{
    [self resignFirstResponder];
}

- (void)drawRect:(CGRect)rect{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    //CGFloat cornerRadiusA = roundf(rect.size.height/2);
    
	CGPoint point1 = CGPointMake(cornerRadiusA,0);
    CGPoint point2 = CGPointMake(self.bounds.size.width - cornerRadiusA, 0);
    
    CGPoint point3 = CGPointMake(self.bounds.size.width - cornerRadiusA, self.bounds.size.height);
    CGPoint point4 = CGPointMake(cornerRadiusA,self.bounds.size.height);
    
    CGPathMoveToPoint(path, NULL, point1.x, point1.y);
    
    CGPathAddLineToPoint(path, NULL, point1.x, point1.y);
    CGPathAddLineToPoint(path, NULL, point2.x, point2.y);
    
    CGPathAddArc(path, NULL,  self.bounds.size.width-cornerRadiusA, cornerRadiusA,cornerRadiusA, M_PI_2, -M_PI_2, YES); // Right hump
    
    
    CGPathAddLineToPoint(path, NULL, point3.x, point3.y);
    CGPathAddLineToPoint(path, NULL, point4.x, point4.y);
    
    CGPathAddArc(path, NULL, cornerRadiusA, cornerRadiusA,cornerRadiusA, M_PI_2, -M_PI_2, NO); // Right hump
    
	CGPathCloseSubpath(path);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGFloat gradientColors[] =
    {
        0x65/255.0,0x93/255.0,0x3A/255.0,1.00,
        0x05/255.0,0x13/255.0,0x3A/255.0,1.00
    };
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradientColors, NULL, sizeof(gradientColors)/(sizeof(gradientColors[0])*4));
    
	CGContextAddPath(context, path);
	CGContextSaveGState(context);
	CGContextEOClip(context);
    
    CGPoint	gradientPoint1 = CGPointMake(0, self.bounds.size.height);
    CGPoint	gradientPoint2 = CGPointMake(self.bounds.size.width, self.bounds.size.height);
    
	//CGContextDrawLinearGradient(context, gradient, gradientPoint1, gradientPoint2, (kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation));
	CGContextRestoreGState(context);
	//[strokeColor setStroke];
    
	CGContextSetLineCap(context, kCGLineCapRound);
	CGContextAddPath(context, path);
    [[UIColor whiteColor] set];
    CGContextDrawPath(context,kCGPathFill);
    
    CGContextSetLineWidth(context, 0);
    
	CGContextStrokePath(context);
	CGPathRelease(path);
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
	return CGRectMake(5,
					  2,
					  bounds.size.width - 10,
					  bounds.size.height - 4);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
	return CGRectMake(5,
					  2,
					  bounds.size.width - 10,
					  bounds.size.height - 4);
}

@end
