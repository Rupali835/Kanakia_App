 //
//  AddController.m
//  WebServices
//
//  Created by VijayKumar on 1/24/18.
//  Copyright © 2018 Sample. All rights reserved.
//

#import "AddController.h"
#import "MyBookingsController.h"


@interface AddController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

{
    IBOutlet UIButton *allDayBtn;
    IBOutlet UIButton *donePickerBtn;
    IBOutlet UIButton *donepickerToBtn;
    IBOutlet UIImageView *calenderImageView;
    IBOutlet UIImageView *bookForImageView;
    IBOutlet UIImageView *fromTimeImageView;
    IBOutlet UIImageView *toTimeImageView;
    IBOutlet UIImageView *meetingWithImageView;
    
    IBOutlet UILabel *allDayEventLbl;
    IBOutlet UILabel *subBookForLbl;
    IBOutlet UILabel *subFromTimeLbl;
    IBOutlet UILabel *subToTimeLbl;
    IBOutlet UILabel *meetingWithLbl;
    
    
    IBOutlet UIButton *submitButton;
    
    
    IBOutlet UIButton *meetingWithBtn;
    IBOutlet UIDatePicker *picker;
    IBOutlet UIDatePicker *picker2;

    
    IBOutlet UITableView *tableMeeting;
    
    NSDateFormatter *formatter;
    NSDateFormatter *formatter2;
#pragma mark-jan30th
    NSDictionary *dictionaryRes;
    NSMutableArray *subArray;
        IBOutlet UITableView *tableValues;
    
#pragma mark-selectmeetingoutlets
    NSMutableArray *meetingArrayNames;
}
@property (nonatomic,strong) IBOutlet UITextField *bookForTextFld;
@property (nonatomic,strong) IBOutlet UITextField *selectPeopleTxtFld;


@property (nonatomic,strong) NSString *sm_invitedByIDForbookFor;
@property (nonatomic,strong) NSString *sm_withStrID;



@property (nonatomic,strong) IBOutlet UILabel *dateSelected1Lbl;
@property (nonatomic,strong) IBOutlet UILabel *fromTimeLbl;
@property (nonatomic,strong) IBOutlet UILabel *toTimeLbl;

@property (nonatomic,strong) IBOutlet UITextField *remarkTextField;


@property (nonatomic,strong) NSMutableArray *addnamesArray;
@property (nonatomic,strong) NSString *addR_id;
@property (nonatomic,strong) NSString *internalR_id;
@property (nonatomic,strong) NSString *strUserId;
-(IBAction)donePickerButton:(id)sender;
-(IBAction)donePickerToButton:(id)sender;

@end
@implementation AddController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _addEventHomeLbl.text =@"Adding New Event";
    
    if ([_fromTimeLbl.text isEqualToString:@"9:00 AM"] && [_toTimeLbl.text isEqualToString:@"19:00 PM"]) {
        allDayBtn.tag = 101;
        UIImage *buttonImage = [UIImage imageNamed:@"checkbox"];
        [allDayBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *resDict = [userDefaults objectForKey:@"userdata"];
    _strUserId= [resDict objectForKey:@"user_id"];
    NSLog(@"%@",_strUserId);

    scrollVC.contentSize = CGSizeMake(0, 1000);    _dateSelected1Lbl.text=self.dateString;

    tableValues.hidden=YES;
    NSLog(@"%@",_roomR_idSelected);
    
    [picker setDatePickerMode:UIDatePickerModeTime];
    picker.minuteInterval=10;
    picker.hidden = YES;
    donePickerBtn.hidden= YES;
    [picker2 setDatePickerMode:UIDatePickerModeTime];
    picker2.minuteInterval=10;
    picker2.hidden = YES;
    donepickerToBtn.hidden = YES;
    formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"HH:mm:ss"];
    
    NSLog(@"%@",_dateString);
    
    meetingArrayNames=[NSMutableArray arrayWithObjects:@"INTERNAL PEOPLE",@"EXTERNAL PEOPLE", nil];
    tableMeeting.hidden=YES;
    _addnamesArray=[[NSMutableArray alloc]init];

    NSLog(@"%@", _editMeetingObj);
    
    if (_editMeetingObj!=nil) {
        [submitButton setTitle:@"Update" forState:UIControlStateNormal];
        _addEventHomeLbl.text =@"Edit Meeting Event";
        _remarkTextField.text = [_editMeetingObj objectForKey:@"sm_remark"];
        _dateSelected1Lbl.text = [_editMeetingObj objectForKey:@"sm_date"];
        [_bookForTextFld setText:[_editMeetingObj objectForKey:@"sm_invited_by_user_name"]];
        _sm_invitedByIDForbookFor = [_editMeetingObj objectForKey:@"sm_invited_by"];
        
        // while Editing Time book for textfield names id sending to this _addR_id ok.
        _addR_id = _sm_invitedByIDForbookFor;
        
        //
        _sm_withStrID = [_editMeetingObj objectForKey:@"sm_with"];
        _internalR_id = _sm_withStrID;
        if ([_sm_withStrID isEqualToString:@"1"]) {
            _selectPeopleTxtFld.text = @"INTERNAL PEOPLE";
        } else if ([_sm_withStrID isEqualToString:@"2"]){
            _selectPeopleTxtFld.text = @"EXTERNAL PEOPLE";
        }else{
            
        }
        
        [_fromTimeLbl setText:[_editMeetingObj objectForKey:@"sm_start_time"] ];
        [_toTimeLbl setText:[_editMeetingObj objectForKey:@"sm_end_time"]];
        
    }else
    {
        
    }
    

        NSString *urlStr = [NSString stringWithFormat:@"http://www.kanishkagroups.com/sop/android/getDetailsMrms.php"];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *str =[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            NSError *err;
            dictionaryRes= [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            subArray = [dictionaryRes objectForKey:@"rooms"];
            _usersArray=[dictionaryRes objectForKey:@"user"];
            NSDictionary *userNamesDict=[[_usersArray objectAtIndex:0] objectForKey:@"user_name"];
            NSLog(@"subArray=%@",subArray);
        }];
        [task resume];
    
    
    

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textChangeNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSLog(@"%@",_roomR_idSelected);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==tableValues) {
        return _addnamesArray.count;
    }
    return meetingArrayNames.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableValues) {
        NSString *str=@"Cell";
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
        }
        cell.textLabel.text=[[_addnamesArray objectAtIndex:indexPath.row]objectForKey:@"user_name"];
//        _createdByStrForNewBook = [[_addnamesArray objectAtIndex:indexPath.row]objectForKey:@"user_name"];
        return cell;
    }
    NSString *strIdentifier=@"Data";
    UITableViewCell *cell1= [tableView dequeueReusableCellWithIdentifier:strIdentifier];
    if (cell1==nil) {
        cell1=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strIdentifier];
    }
    cell1.textLabel.text=[meetingArrayNames objectAtIndex:indexPath.row];
    return cell1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==tableValues) {
        UITableViewCell *cell11=[tableValues cellForRowAtIndexPath:indexPath];
        _bookForTextFld.text=cell11.textLabel.text;
        self.addR_id = [[_addnamesArray objectAtIndex:indexPath.row]objectForKey:@"user_id"];
        NSLog(@"%@",self.addR_id);
        tableValues.hidden=YES;
    } else {
        UITableViewCell *cell22=[tableMeeting cellForRowAtIndexPath:indexPath];
        _selectPeopleTxtFld.text=cell22.textLabel.text;
        tableMeeting.hidden=YES;
        if (tableView==tableMeeting) {
            if (indexPath.row==0) {
                self.internalR_id=@"1";
            }else if (indexPath.row==1){
                self.internalR_id=@"2";
            }
        }
    }
    
}
-(void)textChangeNotification:(NSNotification *)notification {
    UITextField *searchField = (UITextField *)[notification object];
    
    if (searchField.tag==100) {
        tableValues.hidden=NO;
        [self searchRecordsAsPerText:_bookForTextFld.text];
    }
    
}
-(void)searchRecordsAsPerText:(NSString *)string {
    [_addnamesArray removeAllObjects];
    
    for (NSDictionary *obj in _usersArray){
        NSString *sTemp = [obj valueForKey:@"user_name"];
        NSRange titleResultsRange = [sTemp rangeOfString:string options:NSCaseInsensitiveSearch];
        
        if (titleResultsRange.length > 0)
        {
            [_addnamesArray addObject:obj];
        }
        [tableValues reloadData];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField.tag==103) {
        [scrollVC setContentOffset:CGPointMake(0, 200)];
    }
    [self.view setFrame:CGRectMake(0, -100, 414, 736)];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag == 103) {
        [textField resignFirstResponder];

    }
    [self.view setFrame:CGRectMake(0, 0, 414, 736)];
    return YES;
}
#pragma mark-selectmeetingActions
-(IBAction)selectfromTime:(id)sender
{
    if (_iseditingMeet) {
        [self showAlertMessage:@"You Cannot Change Meeting Timings"];
        return;
    }
    if (allDayBtn.tag == 101) {
        return;
    }else{
        
    }
    if (_editMeetingObj!=nil) {
        return;
    }
     
    donePickerBtn.hidden = NO;
    picker.hidden = NO;
   
}


#pragma mark - datePickerActions
-(IBAction)valueChanged:(id)sender;
{
   
}
-(IBAction)donePickerButton:(id)sender
{
    _fromTimeLbl.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:picker.date]];
    donePickerBtn.hidden=YES;
    picker.hidden = YES;
    
}

-(IBAction)selectToTime:(id)sender
{
    if (_iseditingMeet) {
        [self showAlertMessage:@"You Cannot Change Meeting Timings"];
        return;
    }
    if (allDayBtn.tag ==101) {
        return;
    }else{
        
    }
    if (_editMeetingObj!=nil) {
        return;
    }
    

    picker2.hidden = NO;
    donepickerToBtn.hidden = NO;
    
    
    

        UIAlertAction *action = [UIAlertAction actionWithTitle:@"" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            NSComparisonResult result = [_toTimeLbl.text compare:_fromTimeLbl.text];
            
            if (result==NSOrderedAscending) {
                [self showAlertMessage:@"Please Chose After From Time"];
            }else if (result==NSOrderedDescending){
                //Now No Logic
            }else
            {
                [self showAlertMessage:@"Both Times Are Same"];
            }
        }];
    
}
-(IBAction)donePickerToButton:(id)sender
{
    _toTimeLbl.text = [NSString stringWithFormat:@"%@",[formatter2 stringFromDate:[picker2 date]]];
    NSLog(@"%@",_toTimeLbl.text);
    NSLog(@"%@",_fromTimeLbl.text);
    NSComparisonResult result = [_toTimeLbl.text compare:_fromTimeLbl.text];
    if (result==NSOrderedAscending) {
        [self showAlertMessage:@"Please Chose After From Time"];
    }else if (result==NSOrderedDescending){
        //Now No Logic
    }else
    {
        [self showAlertMessage:@"Both Times Are Same"];
    }
    
    picker2.hidden = YES;
    donepickerToBtn.hidden = YES;
}
-(IBAction)valueChangedForDatePicker:(id)sender
{
    formatter2 = [[NSDateFormatter alloc]init];
    [formatter2 setDateFormat:@"HH:mm:ss"];
}
- (void)showAlertMessage:(NSString*)alertMessage
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alert = [UIAlertController
                                     alertControllerWithTitle:@"Alert"
                                     message:alertMessage
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        UIAlertAction *okButton = [UIAlertAction
                                   actionWithTitle:@"OK"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action) {
                                   }];
        [alert addAction:okButton];
        [self presentViewController:alert animated:YES completion:nil];
    });
}
-(IBAction)submitToNext:(id)sender
{
    NSLog(@"%@",_dateSelected1Lbl.text);
    NSLog(@"%@",_fromTimeLbl.text);
    NSLog(@"%@",_toTimeLbl.text);
    NSLog(@"%@",_addR_id);
    NSLog(@"%@",_internalR_id);
    NSLog(@"%@",_remarkTextField.text);
    NSLog(@"%@",_roomR_idSelected);
    
    NSString *edit_m_id = [_editMeetingObj objectForKey:@"m_id"];
    
    NSString *buttonName = [sender titleForState:UIControlStateNormal];
    if ([buttonName isEqualToString:@"Update"]) {
        
         if ([_bookForTextFld.text isEqualToString:@""]){
            [self showAlertMessage:@"Please Enter Employee Name"];
        }

        
           NSString *post =[NSString stringWithFormat:@"logged_in_id=%@&m_remark=%@&m_invited_by=%@&m_with=%@&edit_m_id=%@",_strUserId, _remarkTextField.text,_addR_id,_internalR_id,edit_m_id];
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://kanishkagroups.com/sop/android/editMeetMrms.php"]]];
            [request setHTTPMethod:@"POST"];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:postData];
            NSURLSession *session = [NSURLSession sharedSession];
            NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
                NSError *error1;
                NSDictionary *dictUpdateRes = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error1];
       
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }];
            [dataTask resume];

    }else
    
    if ([_dateSelected1Lbl.text isEqualToString:@""]) {
        [self showAlertMessage:@"Please Select Date"];
    }
    else if ([_bookForTextFld.text isEqualToString:@""]){
        [self showAlertMessage:@"Please Enter Employee Name"];
    }
    else if ([_fromTimeLbl.text isEqualToString:@""] || [_fromTimeLbl.text isEqualToString:@"null"]) {
        [self showAlertMessage:@"Please Select From Time"];
    }
    else if ([_toTimeLbl.text isEqualToString:@""] || [_toTimeLbl.text isEqualToString:@"null"]) {
        [self showAlertMessage:@"Please Select End Time"];
    }else if ([_selectPeopleTxtFld.text isEqualToString:@""]){
        [self showAlertMessage:@"Please Enter Meeting With Internal or External People"];
    }
    

    else if ([buttonName isEqualToString:@"Submit"])
        
    {
    NSString *post =[NSString stringWithFormat:@"m_date=%@&m_start_time=%@&m_end_time=%@&m_invited_by=%@&r_id=%@&logged_in_user_in=%@&m_with=%@&m_remark=%@",_dateSelected1Lbl.text,_fromTimeLbl.text,_toTimeLbl.text,_addR_id,_roomR_idSelected,_strUserId, _internalR_id,_remarkTextField.text];

    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kanishkagroups.com/sop/android/verifyInsertMeetingDataMrms.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {

        NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSError *error1;
        NSDictionary *startMeetDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error1];
        NSString *meetStr = [startMeetDict objectForKey:@"s"];
        NSString *errorFields = [startMeetDict objectForKey:@"e"];
        if ([meetStr isEqualToString:@"Meeting Added Successfully"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"Alert"
                                            message:@"Meeting Added Successfully"
                                        preferredStyle:UIAlertControllerStyleAlert];
                
                
                UIAlertAction *okButton = [UIAlertAction
                                           actionWithTitle:@"OK"
                                           style:UIAlertActionStyleCancel
                                           handler:^(UIAlertAction * action) {
                        [self.navigationController popViewControllerAnimated:YES];
                                           }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
            });
            
        }else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert"
    message:errorFields preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [self.navigationController popViewControllerAnimated:YES];
                                           }];
                [alert addAction:okButton];
                [self presentViewController:alert animated:YES completion:nil];
            });
        }
            }];
    [dataTask resume];
   
};
}



-(IBAction)selectMeetingWith:(id)sender
{
    tableMeeting.hidden=NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)allDayEventTouchUpInside:(id)sender {
    if (_iseditingMeet == YES) {
        [self showAlertMessage:@"You Cannot Change Meeting Timings"];
        return;
    }
    if (allDayBtn.tag == 100) {
        allDayBtn.tag = 101;
        UIImage *buttonImage = [UIImage imageNamed:@"checkbox"];
        [allDayBtn setBackgroundImage:buttonImage forState:UIControlStateNormal];
        
        _fromTimeLbl.text = [NSString stringWithFormat:@"9:00 AM"];
        _fromTimeLbl.backgroundColor = [UIColor lightGrayColor];
        _toTimeLbl.text = [NSString stringWithFormat:@"19:00 PM"];
        _toTimeLbl.backgroundColor = [UIColor lightGrayColor];
    }else {
        allDayBtn.tag = 100;
        [allDayBtn setBackgroundImage:[UIImage imageNamed:@"uncheck_chcekbox"] forState:UIControlStateNormal];
        _fromTimeLbl.text = [NSString stringWithFormat:@""];
        _fromTimeLbl.backgroundColor = [UIColor whiteColor];
        _toTimeLbl.text = [NSString stringWithFormat:@""];
        _toTimeLbl.backgroundColor = [UIColor whiteColor];
    }
}



@end
