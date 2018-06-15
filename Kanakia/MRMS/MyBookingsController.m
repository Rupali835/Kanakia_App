//
//  MyBookingsController.m
//  WebServices
//
//  Created by VijayKumar on 1/29/18.
//  Copyright © 2018 Sample. All rights reserved.
//

#import "MyBookingsController.h"
#import "NewmyBookingsCell.h"
#import "AddController.h"
@interface MyBookingsController ()
{
    NewmyBookingsCell *newbook;
    NSMutableDictionary * newBookObj;
}

@property (nonatomic,strong) NSMutableArray *myBookingsRes;
@property (nonatomic,strong) NSString *m_Occupied;
@property (nonatomic,strong) NSString *strUserId;

@end

@implementation MyBookingsController

- (void)viewDidLoad {
    [super viewDidLoad];
    _myBookingsRes = [[NSMutableArray alloc]init];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *resDict = [userDefaults objectForKey:@"userdata"];
    _strUserId= [resDict objectForKey:@"user_id"];
    NSLog(@"%@",_strUserId);
    
    //[self reloadMyBookings];
    }
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self reloadMyBookings];
}
- (void)showAlertMessage:(NSString*)alertMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:alertMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
                                   }];
        [alert addAction:noButton];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myBookingsRes.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *strId = @"NewMyBookings";
    newbook = [tableView dequeueReusableCellWithIdentifier:strId];
    if (newbook==nil) {
        newbook=[[NewmyBookingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strId];
    }
    newbook.selectionStyle = UITableViewCellSelectionStyleNone;
    self.m_idStr=[[self.myBookingsRes objectAtIndex:indexPath.row]objectForKey:@"m_id"];
    self.sm_falg=[[self.myBookingsRes objectAtIndex:indexPath.row]objectForKey:@"sm_flag"];
    newbook.startTimeLbl.text=[[self.myBookingsRes objectAtIndex:indexPath.row]objectForKey:@"sm_start_time"];
    newbook.endTimeLbl.text=[[self.myBookingsRes objectAtIndex:indexPath.row]objectForKey:@"sm_end_time"];
    newbook.bookedByLbl.text=[[self.myBookingsRes objectAtIndex:indexPath.row]objectForKey:@"sm_invited_by_user_name"];
    newbook.createdByLbl.text=[[self.myBookingsRes objectAtIndex:indexPath.row]objectForKey:@"created_by_name"];
    newbook.meetingRoomLbl.text=[[self.myBookingsRes objectAtIndex:indexPath.row]objectForKey:@"r_name"];
    newbook.selectedDateLbl.text=[[self.myBookingsRes objectAtIndex:indexPath.row]objectForKey:@"sm_date"];
    newbook.remarkLbl.text=[[self.myBookingsRes objectAtIndex:indexPath.row]objectForKey:@"sm_remark"];
    
    
    
    [newbook.editMeetBtn setTag:indexPath.row];
    
   
    
    
    
    [newbook.startMeetBtn addTarget:self action:@selector(startMeeting:) forControlEvents:UIControlEventTouchUpInside];
    [newbook.editMeetBtn addTarget:self action:@selector(editMeeting:) forControlEvents:UIControlEventTouchUpInside];
    [newbook.deleteMeetBtn addTarget:self action:@selector(deleteMeeting:) forControlEvents:UIControlEventTouchUpInside];
    [newbook.endMeetBtn addTarget:self action:@selector(endMeeting:) forControlEvents:UIControlEventTouchUpInside];
    
    newbook.startMeetBtn.tag = 500 +indexPath.row;
//    newbook.editMeetBtn.tag = indexPath.row;
    newbook.deleteMeetBtn.tag = 200 +indexPath.row;
    newbook.endMeetBtn.tag =1000 +indexPath.row;
    
    _m_Occupied = [[self.myBookingsRes objectAtIndex:indexPath.row]objectForKey:@"sm_occupied"];
    if ([_m_Occupied isEqualToString:@"2"]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [newbook.startMeetBtn setHidden:YES];
            [newbook.editMeetBtn setHidden:YES];
            [newbook.deleteMeetBtn setHidden:YES];
            [newbook.endMeetBtn setHidden:YES];
        });
    }else if ([_m_Occupied isEqualToString:@"1"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [newbook.startMeetBtn setHidden:YES];
            [newbook.editMeetBtn setHidden:YES];
            [newbook.deleteMeetBtn setHidden:YES];
            [newbook.endMeetBtn setHidden:NO];
        });
    }else if ([_m_Occupied isEqualToString:@"0"])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [newbook.startMeetBtn setHidden:NO];
            [newbook.editMeetBtn setHidden:NO];
            [newbook.deleteMeetBtn setHidden:NO];
            [newbook.endMeetBtn setHidden:YES];
        });
    }else
    {
        
    }

//    [newbook.endMeetBtn setHidden:YES];
        return newbook;
}
- (BOOL)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    //NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    if (hours ==0 && minutes <=10) {
        return  YES;
    }else{
        return NO;
    }
}
-(void)startMeeting:(id)sender
{
    
    UIButton *startBtn = (UIButton *)sender;
    
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:(startBtn.tag -500) inSection:0];
    NewmyBookingsCell *startNewCell = [_myBookingsTb cellForRowAtIndexPath:myIP];
    
    
    self.m_idStr = [[_myBookingsRes objectAtIndex:startBtn.tag -500] objectForKey:@"m_id"];
        NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc]init];
        [dateFormatter1 setDateFormat:@"YYYY-MM-dd"];
#pragma mark- Getting Current Date
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
#pragma mark- Getting Current Time
    NSString *currentTime = [dateFormatter1 stringFromDate:[NSDate date]];
        NSLog(@"%@",currentDate);
        NSLog(@"%@",currentTime);
    [dateFormatter1 setDateFormat:@"HH:mm:ss"];
    
        NSString * meeting = [NSString stringWithFormat:@"%@ %@",startNewCell.selectedDateLbl.text,startNewCell.startTimeLbl.text];
        NSDate * startTime = [dateFormatter dateFromString:meeting];
    
        NSDate * currTime = [dateFormatter dateFromString:currentDate];
        NSTimeInterval  timeInterval = [currTime timeIntervalSinceDate:startTime];
    
    NSLog(@"%@",newbook.selectedDateLbl.text);
    NSLog(@"%@",currentDate);
    NSLog(@"%@",newbook.startTimeLbl.text);
    NSLog(@"%@",currentTime);
    
    
        if ([self stringFromTimeInterval:timeInterval]==YES) {
            NSString *post =[NSString stringWithFormat:@"user_id=%@&status=1&m_id=%@",_strUserId,self.m_idStr];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://kanishkagroups.com/sop/android/updateMeetingStatusMrms.php"]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
                NSError *error1;
                NSDictionary *dictRes1 = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error1];
              
                NSString *str = [dictRes1 objectForKey:@"msg"];
    
                if ([str isEqualToString:@"Meeting Started Successfully"]) {
                    [self showAlertMessage:@"Meeting Started Successfully"];
                }else{
    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [startNewCell.startMeetBtn setHidden:YES];
                    [startNewCell.editMeetBtn setHidden:YES];
                    [startNewCell.deleteMeetBtn setHidden:YES];
                    [startNewCell.endMeetBtn setHidden:NO];

                });
                [self.myBookingsTb reloadData];
            }];
            [dataTask resume];
           
        }
        else{
            [self showAlertMessage:@"You cannot able to start meeting"];
        }
    }


-(void)endMeeting:(id)sender
{
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:@"Are you sure you want to end meeting"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *oKButton = [UIAlertAction actionWithTitle:@"Ok"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        UIButton *stopBtn = (UIButton *)sender;
                                                               
    NSIndexPath *myIP = [NSIndexPath indexPathForRow:(stopBtn.tag -1000) inSection:0];
    NewmyBookingsCell *startNewCell = [_myBookingsTb cellForRowAtIndexPath:myIP];
 self.m_idStr = [[_myBookingsRes objectAtIndex:stopBtn.tag -1000] objectForKey:@"m_id"];

            NSString *post =[NSString stringWithFormat:@"user_id=%@&status=2&m_id=%@",_strUserId,self.m_idStr];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://kanishkagroups.com/sop/android/updateMeetingStatusMrms.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                                                                   
    NSError *error1;
    NSDictionary *dictEndRes = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error1];
    NSString *strEndRes = [dictEndRes objectForKey:@"msg"];
    [self showAlertMessage:(NSString *)strEndRes];
    dispatch_async(dispatch_get_main_queue(), ^{
    [startNewCell.startMeetBtn setHidden:YES];
    [startNewCell.endMeetBtn setHidden:YES];
    [startNewCell.deleteMeetBtn setHidden:YES];
    [startNewCell.editMeetBtn setHidden:YES];
    });
        [self reloadMyBookings];
    }];
                                                               
   [dataTask resume];
    }];
        [alert addAction:noButton];
        [alert addAction:oKButton];
        [self presentViewController:alert animated:YES completion:nil];
    });

    
    



}
-(void)editMeeting:(id)sender
{
// CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_myBookingsTb];
// NSIndexPath *indexPath = [_myBookingsTb indexPathForRowAtPoint:buttonPosition];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:@"Are sure you want to edit meeting"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *oKButton = [UIAlertAction actionWithTitle:@"Ok"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"%@",self.sm_falg);
            UIButton * editButt = (UIButton *)sender;
            
            newBookObj = [self.myBookingsRes objectAtIndex:editButt.tag];
            if ([self.sm_falg isEqualToString:@"1"]) {
                [self showAlertMessage:@"You Cannot Able To Edit The MMS Meeting"];
            }
            AddController *addBooking = (AddController *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddController"];
            addBooking.addEventHomeLbl.text = @"Edit Meeting";
            [addBooking setIseditingMeet:YES];
            [addBooking setM_idEditMeetStr:self.m_idStr];
            [addBooking setEditMeetingObj:newBookObj];
            [self.navigationController pushViewController:addBooking animated:YES];
        }];
        [alert addAction:noButton];
        [alert addAction:oKButton];
        [self presentViewController:alert animated:YES completion:nil];
    });
    
   
    }
-(void)deleteMeeting:(id)sender
{
    NSLog(@"%@",self.m_idStr);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:@"Are You Sure You Want To Delete Meeting"
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *oKButton = [UIAlertAction actionWithTitle:@"Ok"
        style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
           
            CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:_myBookingsTb];
            NSIndexPath *indexPath = [_myBookingsTb indexPathForRowAtPoint:buttonPosition];
            UIButton *deleteBtn = (UIButton *)sender;
            newBookObj = [_myBookingsRes objectAtIndex:deleteBtn.tag -200];
            self.m_idStr = [[_myBookingsRes objectAtIndex:deleteBtn.tag -200]objectForKey:@"m_id"];
            NSString *post =[NSString stringWithFormat:@"m_id=%@",self.m_idStr];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://kanishkagroups.com/sop/android/deleteMeetMrms.php"]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                
                NSError *error1;
                NSArray *arrayRes = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error1];
                NSArray *filteredData = [_myBookingsRes filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"(m_id contains[c] %@)", _m_idStr]];
                [_myBookingsRes removeObject:[filteredData objectAtIndex:0]];
                //[_myBookingsRes removeObjectAtIndex:deleteBtn.tag -200];
                
                [self reloadMyBookings];
            }];
            [dataTask resume];

                                   }];
        [alert addAction:noButton];
        [alert addAction:oKButton];
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
    
}
- (void)showStartMeetingAlert:(NSString*)alertMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:alertMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *noButton = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *oKButton = [UIAlertAction
                                   actionWithTitle:@"Ok"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                   }];
        [alert addAction:noButton];
        [alert addAction:oKButton];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
-(void)reloadMyBookings
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *resDict = [userDefaults objectForKey:@"userdata"];
    _strUserId= [resDict objectForKey:@"user_id"];
    NSLog(@"%@",_strUserId);
    NSString *post =[NSString stringWithFormat:@"user_id=%@",_strUserId];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kanishkagroups.com/sop/android/getUserMeetingMrms.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSError *error1;
        self.myBookingsRes = [[NSJSONSerialization JSONObjectWithData:data options:0 error:&error1]mutableCopy];
        if (self.myBookingsRes.count==0) {
            [self showAlertMessage:@"No Bookings Are Added Please Add New Bookings"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[NSThread currentThread] isMainThread]){
                [self.myBookingsTb reloadData];
            }
            else{
            }
        });
    }];
    [dataTask resume];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
