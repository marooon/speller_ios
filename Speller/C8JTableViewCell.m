//
//  C8JTableViewCell.m
//  Speller
//
//  Created by liulei on 2/11/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import "C8JTableViewCell.h"

@interface C8JTableViewCell ()
{
    CGFloat cellXPadding;
    CGFloat indexTitleWidth;     // for table view's index title view
    
    CGFloat textY;
    CGFloat textWidth;
    CGFloat textHeight;
    
    CGFloat arrowY;
    CGFloat arrowWidth;
    CGFloat arrowHeight;
    
    UIFont *font;
    NSString *arrowString;
}

@end

@implementation C8JTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
         self.backgroundColor = BackgroundColor;
        arrowString = @"›";
        
        cellXPadding = 10;
        indexTitleWidth = 28;
        
        font = [UIFont fontWithName:@"Baskerville-SemiBold" size:22];
        CGSize textSize = [@"Placeholder" sizeWithFont:font constrainedToSize:CGSizeMake(65535, 65535)];
        CGSize arrowSize = [arrowString sizeWithFont:font constrainedToSize:CGSizeMake(65535, 65535)];
        
        textY = round((self.height-textSize.height)/2);
        arrowY = round((self.height-arrowSize.height)/2);
        
        textWidth = self.width-2*cellXPadding-indexTitleWidth;
        textHeight = textSize.height;
        
        arrowWidth= arrowSize.width;
        arrowHeight= arrowSize.height;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [MainFontColor set];
    [labelText drawInRect:CGRectMake(cellXPadding,textY, textWidth, textHeight) withFont:font];
    [arrowString drawInRect:CGRectMake(self.width-arrowWidth-cellXPadding-indexTitleWidth,arrowY, arrowWidth, arrowHeight) withFont:font];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if(selected){
        self.backgroundColor = [UIColor colorWithRed:0.824 green:0.749 blue:0.553 alpha:0.70];
    }else{
        self.backgroundColor = BackgroundColor;
    }
}

- (void)setLabelText:(NSString *)aText
{
    if(aText != nil)
    {
        labelText = aText;
        [self setNeedsDisplay];
    }
}

@end
