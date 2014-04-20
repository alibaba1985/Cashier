//
//  CPOrderInfoCell.h
//  Cashier
//
//  Created by liwang on 14-4-20.
//  Copyright (c) 2014年 liwang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPOrderInfoCell : UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
            content:(NSDictionary *)content
              table:(UITableView *)table;

@end
