//
//  CPOrderEditCell.h
//  Cashier
//
//  Created by liwang on 14-4-20.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CPOrderActionType) {
    CPOrderActionAdd,
    CPOrderActionDelete,
    CPOrderActionCut,
};

@protocol CPOrderEditDelegate <NSObject>

- (void)orderEditActionType:(CPOrderActionType)type;

@end

@interface CPOrderEditCell : UITableViewCell

@property(nonatomic, assign)UITableView *tableView;
@property(nonatomic, assign)id<CPOrderEditDelegate> editDelegate;

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
              table:(UITableView *)table
           delegate:(id<CPOrderEditDelegate>)delegate atRow:(NSInteger)row;

@end
