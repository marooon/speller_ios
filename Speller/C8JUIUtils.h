//
//  C8JUIUtils.h
//  Speller
//
//  Created by liulei on 2/12/13.
//  Copyright (c) 2013 cool8jay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface C8JUIUtils : NSObject

+ (UIButton*)createButton:(NSString*)title
	  touchUpInsideAction:(SEL)pAction
				   target:(id)pTarget;

+ (UILabel*)createLabel:(UIFont*)font
				   text:(NSString*)text
			  textColor:(UIColor*)textColor;

@end
