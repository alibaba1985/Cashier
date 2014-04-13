//
//  UpProductTourViewController.h
//  CHSP
//
//  Created by jhyu on 13-11-28.
//
//

#import <UIKit/UIKit.h>
#import "TnPreviewPagingScrollView.h"

typedef void (^TourDismissBlock)(void);

@interface UpProductTourViewController : UIViewController <TnPreviewPagingScrollViewDelegate>

@property (nonatomic, strong) NSArray * pages;
@property (nonatomic, copy) TourDismissBlock dismissAction;

@end
