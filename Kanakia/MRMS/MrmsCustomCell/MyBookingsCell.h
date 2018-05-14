//
//  MyBookingsCell.h
//  WebServices
//
//  Created by VijayKumar on 2/21/18.
//  Copyright © 2018 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBookingsCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *subStartTimeTB;
@property (nonatomic,weak) IBOutlet UILabel *subEndTimeTB;
@property (nonatomic,weak) IBOutlet UILabel *subBookedTimeTB;
@property (nonatomic,weak) IBOutlet UILabel *startTimeTB;
@property (nonatomic,weak) IBOutlet UILabel *endTimeTB;
@property (nonatomic,weak) IBOutlet UILabel *bookedByTB;


@end
