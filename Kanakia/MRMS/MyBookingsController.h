//
//  MyBookingsController.h
//  WebServices
//
//  Created by VijayKumar on 1/29/18.
//  Copyright © 2018 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyBookingsController : UIViewController<UITableViewDelegate,UITableViewDataSource>


-(void)reloadMyBookings;

@property (nonatomic,weak) NSString *selectedDateStr;
@property (nonatomic,weak) NSString *myFromDateStr;
@property (nonatomic,weak) NSString *myToDateStr;
@property (nonatomic,weak) NSString *myBookedStr;
@property (nonatomic,weak) NSString *myRoomNameStr;
@property (nonatomic,weak) NSString *myRemarkStr;


@property (nonatomic,weak) IBOutlet UITableView *myBookingsTb;
@property (nonatomic,strong) NSString *m_idStr;
@property (nonatomic,strong) NSString *sm_falg;

@end
