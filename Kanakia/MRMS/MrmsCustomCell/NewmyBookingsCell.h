//
//  NewmyBookingsCell.h
//  WebServices
//
//  Created by VijayKumar on 3/4/18.
//  Copyright © 2018 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewmyBookingsCell : UITableViewCell
@property (nonatomic,weak) IBOutlet UILabel *startTimeLbl;
@property (nonatomic,weak) IBOutlet UILabel *endTimeLbl;
@property (nonatomic,weak) IBOutlet UILabel *bookedByLbl;
@property (nonatomic,weak) IBOutlet UILabel *createdByLbl;
@property (nonatomic,weak) IBOutlet UILabel *meetingRoomLbl;
@property (nonatomic,weak) IBOutlet UILabel *selectedDateLbl;
@property (nonatomic,weak) IBOutlet UILabel *remarkLbl;


@property (nonatomic,weak) IBOutlet UILabel *subStartTimeLbl;
@property (nonatomic,weak) IBOutlet UILabel *subEndTimeLbl;
@property (nonatomic,weak) IBOutlet UILabel *subBookedByLbl;
@property (nonatomic,weak) IBOutlet UILabel *subCreatedByLbl;
@property (nonatomic,weak) IBOutlet UILabel *subMeetingRoomLbl;
@property (nonatomic,weak) IBOutlet UILabel *subSelectedDateLbl;
@property (nonatomic,weak) IBOutlet UILabel *subRemarkLbl;

@property (nonatomic,weak) IBOutlet UIButton *startMeetBtn;
@property (nonatomic,weak) IBOutlet UIButton *editMeetBtn;
@property (nonatomic,weak) IBOutlet UIButton *deleteMeetBtn;
@property (nonatomic,weak) IBOutlet UIButton *endMeetBtn;


@end
