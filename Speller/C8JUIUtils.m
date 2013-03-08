//
//  C8JUIUtils.m
//  Speller
//
//  Created by liulei on 2/12/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import "C8JUIUtils.h"

@implementation C8JUIUtils

+ (UIButton*)createButton:(NSString*)title
	  touchUpInsideAction:(SEL)pAction
				   target:(id)pTarget
{
	UIButton *button = [[[UIButton alloc] init] autorelease];
	UIImage *buttonImage = nil;
	UIImage *buttonHighlightImage = nil;
	UIImage *buttonDisableImage = nil;
	
    //	if(GameUIButtonStyleSmallBlue == style ){
    //		buttonImage = [GameUIUtils imageNamed:@"button_blue_small.png"];
    //		buttonHighlightImage = [GameUIUtils imageNamed:@"button_blue_small_p.png"];
    //		buttonDisableImage = [GameUIUtils imageNamed:@"button_grey_small.png"];
    //		[button.titleLabel setFont:smallButtonFont];
    //
    //		[button setTitleColor:FONT_BODY_COLOR_FOR_BLUE_BUTTON forState:UIControlStateNormal];
    //		[button setTitleShadowColor:FONT_SHADOW_COLOR_FOR_BLUE_BUTTON forState:UIControlStateNormal];
    //	}
    //	else if(GameUIButtonStyleSmallBrown == style){
    //		buttonImage = [GameUIUtils imageNamed:@"button_brown_small.png"];
    //		buttonHighlightImage = [GameUIUtils imageNamed:@"button_brown_small_p.png"];
    //		buttonDisableImage = [GameUIUtils imageNamed:@"button_grey_small.png"];
    //		[button.titleLabel setFont:smallButtonFont];
    //
    //		[button setTitleColor:FONT_BODY_COLOR_FOR_BROWN_BUTTON forState:UIControlStateNormal];
    //		[button setTitleShadowColor:FONT_SHADOW_COLOR_FOR_BROWN_BUTTON forState:UIControlStateNormal];
    //	}
    //	else if(GameUIButtonStyleSmallGreen == style){
    //		buttonImage = [GameUIUtils imageNamed:@"button_green_small.png"];
    //		buttonHighlightImage = [GameUIUtils imageNamed:@"button_green_small_p.png"];
    //		buttonDisableImage = [GameUIUtils imageNamed:@"button_grey_small.png"];
    //		[button.titleLabel setFont:smallButtonFont];
    //
    //		[button setTitleColor:FONT_BODY_COLOR_FOR_GREEN_BUTTON forState:UIControlStateNormal];
    //		[button setTitleShadowColor:FONT_SHADOW_COLOR_FOR_GREEN_BUTTON forState:UIControlStateNormal];
    //	}
    //	else if(GameUIButtonStyleSmallRed == style){
    //		buttonImage = [GameUIUtils imageNamed:@"button_red_small.png"];
    //		buttonHighlightImage = [GameUIUtils imageNamed:@"button_red_small_p.png"];
    //		buttonDisableImage = [GameUIUtils imageNamed:@"button_grey_small.png"];
    //		[button.titleLabel setFont:smallButtonFont];
    //
    //		[button setTitleColor:FONT_BODY_COLOR_FOR_RED_BUTTON forState:UIControlStateNormal];
    //		[button setTitleShadowColor:FONT_SHADOW_COLOR_FOR_RED_BUTTON forState:UIControlStateNormal];
    //	}
    //	else if(GameUIButtonStyleMiddleBrown == style){
    //		buttonImage = [GameUIUtils imageNamed:@"button_brown_medium.png"];
    //		buttonHighlightImage = [GameUIUtils imageNamed:@"button_brown_medium_p.png"];
    //		buttonDisableImage = [GameUIUtils imageNamed:@"button_grey_medium.png"];
    //		[button.titleLabel setFont:middleButtonFont];
    //
    //		[button setTitleColor:FONT_BODY_COLOR_FOR_BROWN_BUTTON forState:UIControlStateNormal];
    //		[button setTitleShadowColor:FONT_SHADOW_COLOR_FOR_BROWN_BUTTON forState:UIControlStateNormal];
    //	}
    //	else if(GameUIButtonStyleMiddleGreen == style){
    //		buttonImage = [GameUIUtils imageNamed:@"button_green_medium.png"];
    //		buttonHighlightImage = [GameUIUtils imageNamed:@"button_green_medium_p.png"];
    //        buttonDisableImage = [GameUIUtils imageNamed:@"button_grey_medium.png"];
    //		[button.titleLabel setFont:middleButtonFont];
    //
    //		[button setTitleColor:FONT_BODY_COLOR_FOR_GREEN_BUTTON forState:UIControlStateNormal];
    //		[button setTitleShadowColor:FONT_SHADOW_COLOR_FOR_GREEN_BUTTON forState:UIControlStateNormal];
    //	}
    //	else if(GameUIButtonStyleMiddleRed == style){
    //		buttonImage = [GameUIUtils imageNamed:@"button_red_medium.png"];
    //		buttonHighlightImage = [GameUIUtils imageNamed:@"button_red_medium_p.png"];
    //		buttonDisableImage = [GameUIUtils imageNamed:@"button_grey_medium.png"];
    //		[button.titleLabel setFont:middleButtonFont];
    //
    //		[button setTitleColor:FONT_BODY_COLOR_FOR_RED_BUTTON forState:UIControlStateNormal];
    //		[button setTitleShadowColor:FONT_SHADOW_COLOR_FOR_RED_BUTTON forState:UIControlStateNormal];
    //	}
    //	else if(GameUIButtonStyleBigBrown == style){
    //		buttonImage = [GameUIUtils imageNamed:@"button_brown_big.png"];
    //		buttonHighlightImage = [GameUIUtils imageNamed:@"button_brown_big_p.png"];
    //		buttonDisableImage = [GameUIUtils imageNamed:@"button_grey_big.png"];
    //
    //		[button.titleLabel setFont:bigButtonFont];
    //
    //		[button setTitleColor:FONT_BODY_COLOR_FOR_BROWN_BUTTON forState:UIControlStateNormal];
    //		[button setTitleShadowColor:FONT_SHADOW_COLOR_FOR_BROWN_BUTTON forState:UIControlStateNormal];
    //	}
    //	else if(GameUIButtonStyleBigGreen == style){
    //		buttonImage = [GameUIUtils imageNamed:@"button_green_big.png"];
    //		buttonHighlightImage = [GameUIUtils imageNamed:@"button_green_big_p.png"];
    //        buttonDisableImage = [GameUIUtils imageNamed:@"button_grey_big.png"];
    //		[button.titleLabel setFont:bigButtonFont];
    //
    //		[button setTitleColor:FONT_BODY_COLOR_FOR_GREEN_BUTTON forState:UIControlStateNormal];
    //		[button setTitleShadowColor:FONT_SHADOW_COLOR_FOR_GREEN_BUTTON forState:UIControlStateNormal];
    //	}
    //	else if(GameUIButtonStyleBigRed == style){
    //		buttonImage = [GameUIUtils imageNamed:@"button_red_big.png"];
    //		buttonHighlightImage = [GameUIUtils imageNamed:@"button_red_big_p.png"];
    //        buttonDisableImage = [GameUIUtils imageNamed:@"button_grey_big.png"];
    //		[button.titleLabel setFont:bigButtonFont];
    //
    //		[button setTitleColor:FONT_BODY_COLOR_FOR_RED_BUTTON forState:UIControlStateNormal];
    //		[button setTitleShadowColor:FONT_SHADOW_COLOR_FOR_RED_BUTTON forState:UIControlStateNormal];
    //	}
	button.exclusiveTouch = YES;
	
	[button setTitle:title forState:UIControlStateNormal];
    
    //    [button setTitleEdgeInsets:UIEdgeInsetsMake(0,
    //                                                DEVICE_SCALE(8),
    //                                                0,
    //                                                DEVICE_SCALE(8))];
	
    //	button.titleLabel.shadowOffset = CGSizeMake(0, -DEVICE_SCALE(1));
	
	[button setBackgroundImage:buttonImage forState:UIControlStateNormal];
	[button setBackgroundImage:buttonHighlightImage forState:UIControlStateHighlighted];
	[button setBackgroundImage:buttonDisableImage forState:UIControlStateDisabled];
	
	[button setTitleColor:[UIColor colorWithRed:0xdd/255.0 green:0xdd/255.0 blue:0xdd/255.0 alpha:1] forState:UIControlStateDisabled];
	[button setTitleShadowColor:[UIColor colorWithRed:0x22/255.0 green:0x22/255.0 blue:0x22/255.0 alpha:1] forState:UIControlStateDisabled];
	
	[button addTarget:pTarget action:pAction forControlEvents:UIControlEventTouchUpInside];
	
    button.frame = CGRectMake(0, 0, buttonImage.size.width, buttonImage.size.height);

	return button;
}

+ (UILabel*)createLabel:(UIFont*)font
				   text:(NSString*)text
			  textColor:(UIColor*)textColor{
	UILabel *label = [[[UILabel alloc] init] autorelease];
	label.text = text;
	label.font = font;
	
	label.textColor = textColor;
	label.backgroundColor = [UIColor clearColor];
	
	label.numberOfLines = 1;
	label.adjustsFontSizeToFitWidth = YES;
	label.minimumFontSize = 8;
	
	CGFloat width = [text sizeWithFont:font].width;
	
	/*
	 When the label is created, it is possible the text is not set. No matter
	 what the text content is the height of text is determinate according to
	 the font.
	 */
    CGFloat height = [@"anyword" sizeWithFont:font].height;
	label.bounds = CGRectMake(0, 0, width, height);
	return label;
}


@end
