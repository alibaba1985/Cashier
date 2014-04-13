//
//  UIPlaceHolderTextView.h
//  CHSP
//
//  Created by jhyu on 13-5-31.
//
//

#import <UIKit/UIKit.h>

// ref: http://stackoverflow.com/questions/1328638/placeholder-in-uitextview

@interface UIPlaceHolderTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, retain) UIFont *placeholderFont;

@end
