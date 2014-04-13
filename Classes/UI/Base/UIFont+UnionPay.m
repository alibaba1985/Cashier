//
//  UIFont+UnionPay.m
//  CHSP
//
//  Created by jhyu on 13-10-15.
//
//

#import "UIFont+UnionPay.h"

@implementation UIFont (UnionPay)

+ (UIFont*)boldUnionpayFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
}

+ (UIFont*)unionpayFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

+ (UIFont*)fontWithKeyName:(NSString*)name
{
    NSString* path = [[NSBundle mainBundle] pathForResource:@"fonts.plist" ofType:nil];
    NSDictionary* fontsDict = [NSDictionary dictionaryWithContentsOfFile:path];
    
    NSString* fontString = nil;
#if 0
    if ([TnClientModel isIpad]) {
        NSString* ipadKeyName = [name stringByAppendingString:@"_iPad"];
        fontString = [fontsDict objectForKey:ipadKeyName];
    }
#endif
    
    if (fontString == nil) {
        fontString = [fontsDict objectForKey:name];
    }
    
    NSString* fontName = @"HelveticaNeue";
    CGFloat fontSize = 15.0f;
    
    // HelveticaNeue-Bold 20
    
    // Scan
    NSScanner* scanner = [[NSScanner alloc] initWithString:fontString];
    [scanner scanUpToCharactersFromSet:[NSCharacterSet whitespaceCharacterSet] intoString:&fontName];
    [scanner setScanLocation:[scanner scanLocation]+1];
    
    // Convert to UIFont
    return [UIFont fontWithName:fontName size:fontSize];
}


@end
