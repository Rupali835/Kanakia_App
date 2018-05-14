//
//  AddController.h
//  WebServices
//
//  Created by VijayKumar on 1/24/18.
//  Copyright © 2018 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UIScrollView *scrollVC;
}

@property (nonatomic,strong) IBOutlet UILabel *addEventHomeLbl;

@property (nonatomic,strong) NSMutableArray *usersArray;
@property (nonatomic,strong) NSString *createdByStrForNewBook;

@property (nonatomic,assign) BOOL iseditingMeet;
//@property(nonatomic,retain)UIPopoverPresentationController *dateTimePopover8;
@property (nonatomic,weak) IBOutlet UIButton *fromTimeButton;
@property (nonatomic,weak) IBOutlet UIButton *toTimeButton;
@property (nonatomic,strong) NSString *dateString;
@property (nonatomic,strong) NSString *roomR_idSelected;
@property (nonatomic,strong) NSMutableDictionary * editMeetingObj;
@property (nonatomic,strong) NSString *m_idEditMeetStr;
@end
