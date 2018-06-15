//
//  ViewController.m
//  WebServices
//
//  Created by Ramesh on 7/28/16.
//  Copyright © 2016 Sample. All rights reserved.
//

#import "ViewController.h"
#import "CollectionCell.h"
#import "SubCatagoryModel.h"
#import "AddController.h"
#import "MyBookingsController.h"
#import "MyBookingsCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tableData;
    NSIndexPath *checkmarkIndex;
    UIToolbar* toolbar;
    UIDatePicker* picker12;
    
   // var imgArr = [String]
    

    //IBOutlet UIImageView *dropDownImg;
    
    IBOutlet UIButton *changeDateBtn;
    NSDictionary *dictionaryRes;
    

}
// new Array
@property (nonatomic,strong) NSMutableArray *imageArr;
    @property (nonatomic,strong) NSArray *subArray;

@property (nonatomic, strong) NSMutableArray *resMutableArr;
@property (nonatomic,strong) NSMutableArray *rIDMutableArr;
@property (nonatomic,strong) NSString *r_id;
@property (nonatomic,strong) NSString *r_name;
@property (nonatomic,weak) IBOutlet UILabel *subSelectedRoom;
@property (nonatomic,weak) IBOutlet UILabel *selectedRoom;
@property (nonatomic,strong) NSMutableArray * indexpathArray;
-(IBAction)changeDate:(id)sender;

@property (nonatomic,weak)IBOutlet UICollectionView *collectionImg;
@property (nonatomic,strong) NSArray *itemsArray;
@property (nonatomic,strong) NSArray *tickMarkImg;

@property (nonatomic,strong) NSArray *arrayResMRMS;
@property (nonatomic,strong) NSString *strUserId;

@property (nonatomic,strong) NSIndexPath *tempIndex;

@property (nonatomic) BOOL firstIndex;

@property (nonatomic,strong) NSIndexPath *indexReload;



// var strUserId : String = ""

//

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
   NSDictionary *resDict = [userDefaults objectForKey:@"userdata"];
    _strUserId= [resDict objectForKey:@"user_id"];
    NSLog(@"%@",_strUserId);
       _imageArr = [[NSMutableArray alloc]init];
    _firstIndex = true;
    
    _tempIndex = [[NSIndexPath alloc] initWithIndex: 0];
    


    NSDateFormatter *currentDate = [[NSDateFormatter alloc]init];
    [currentDate setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDateStr = [currentDate stringFromDate:[NSDate date]];
    _selectLabel.text = currentDateStr;
    
    _indexpathArray = [[NSMutableArray alloc]init];
    

    self.resMutableArr = [NSMutableArray array];
    self.rIDMutableArr = [[NSMutableArray alloc]init];
   
    tableData.hidden=NO;
    
    

        NSString *post =[NSString stringWithFormat:@"user_id=%@",_strUserId];
    NSLog(@"%@",_strUserId);
    
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kanishkagroups.com/sop/android/getDetailsMrms.php"]]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        NSURLSession *session = [NSURLSession sharedSession];
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            
            NSError *error1;
            _mainDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error1];
            _subArray =[_mainDict objectForKey:@"rooms"];
            
            for (NSDictionary *roomDict in _subArray) {
                NSString *roomName = [roomDict objectForKey:@"r_name"];
                [self appendImg:roomName];
            }
           
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[NSThread currentThread] isMainThread]){
                    [_collectionImg reloadData];
                NSLog(@"In main thread--completion handler");
            }
            else{
                NSLog(@"Not in main thread--completion handler");
            }
        });
    }];
    [dataTask resume];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (_indexReload !=nil) {
        [self callFunc:_indexReload];
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *strIdentifier=@"Cell";
    CollectionCell *viewCell = [collectionView dequeueReusableCellWithReuseIdentifier:strIdentifier forIndexPath:indexPath];
    long row = [indexPath row];
    UIImage *image1 = [UIImage imageNamed:self.imageArr[row]];//[UIImage imageNamed:self.itemsArray[row]];
    viewCell.namesLabel.text = [[_subArray   objectAtIndex:indexPath.row]objectForKey:@"r_name"];
    viewCell.imgView.image = image1;
    NSString *strTV = [[_subArray objectAtIndex:indexPath.row]objectForKey:@"r_tv_flag"];
    if ([strTV isEqualToString:@"1"]) {
        viewCell.tVLabel.text = @"T.V";
    }else{
        viewCell.tVLabel.text = @"";
    }
    
    if (_firstIndex  && indexPath.row == 0) {
        [viewCell.selectedImgView setHidden:NO];
        [self callFunc:indexPath];

    } else {
        if ([_indexpathArray containsObject:indexPath]) {
            [viewCell.selectedImgView setHidden:NO];
        }else
        {
            [viewCell.selectedImgView setHidden:YES];
        }
    }
//
//    if ([_indexpathArray containsObject:indexPath]) {
//        [viewCell.selectedImgView setHidden:NO];
//    }else
//    {
//        [viewCell.selectedImgView setHidden:YES];
//    }
    

    
    return viewCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    _firstIndex = false;
    _indexReload = indexPath;
    
    if ([_indexpathArray containsObject:indexPath]) {
        [_indexpathArray removeObject:indexPath];
        self.selectedRoom.text= @"";

    } else {
        if (_indexpathArray.count) {
            [_indexpathArray removeAllObjects];
        }
        [_indexpathArray addObject:indexPath];
        
        [self callFunc:indexPath];
    
    }
    [_collectionImg reloadData];

}

-(void)temFunc:(NSIndexPath *)rID {
    
}

-(void)callFunc:(NSIndexPath *)rID{
            self.r_id = [[_subArray objectAtIndex:rID.item]objectForKey:@"r_id"];
            self.r_name=[[_subArray objectAtIndex:rID.item]objectForKey:@"r_name"];
            self.selectedRoom.text= self.r_name;
            NSLog(@"%@",_r_id);
            NSLog(@"%@",_r_name);
            if ([_r_id isEqualToString:@""]) {
                [self showAlertMessage:@"Please Select Room"];
            }else if ([_selectLabel.text isEqualToString:@""])
            {
                [self showAlertMessage:@"Please Select Date"];
            }
    NSString *dateString = self.selectLabel.text;
    NSString *post =[NSString stringWithFormat:@"r_id=%@&date=%@",self.r_id,dateString];
    NSLog(@"%@&%@",_r_id,_selectLabel.text);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kanishkagroups.com/sop/android/getMeetingDetailsMrms.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSError *error1;
        self.arrayResMRMS = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error1];
        if (self.arrayResMRMS.count==0) {
            [self showAlertMessage:@"no meetings Found"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[NSThread currentThread] isMainThread]){
                [tableData reloadData];
                NSLog(@"In main thread--completion handler");
            }
            else{
                NSLog(@"Not in main thread--completion handler");
            }
        });
        NSLog(@"dictionaryRes %@",self.arrayResMRMS);
    }];
    [dataTask resume];
    
}


 //Sample Practice
-(IBAction)changeDate:(id)sender
{
    
    picker12 = [[UIDatePicker alloc] init];
    picker12.backgroundColor = [UIColor whiteColor];
    [picker12 setMinimumDate:[NSDate date]];
    
    [picker12 setValue:[UIColor blackColor] forKey:@"textColor"];
    
    picker12.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    picker12.datePickerMode = UIDatePickerModeDate;
    
    [picker12 addTarget:self action:@selector(dueDateChanged:) forControlEvents:UIControlEventValueChanged];
    picker12.frame = CGRectMake(0.0, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 200);
    [self.view addSubview:picker12];
    
    toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 50)];
    toolbar.barStyle = UIBarStyleDefault;
    toolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(onDoneButtonClick)]];
    [toolbar sizeToFit];
    [self.view addSubview:toolbar];
    
   
}
-(void) dueDateChanged:(UIDatePicker *)sender {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSLog(@"Picked the date %@", [dateFormatter stringFromDate:[sender date]]);
    _selectLabel.text = [dateFormatter stringFromDate:[sender date]];
}
-(void)onDoneButtonClick {
    
    
    if ([_r_id isEqualToString:@""]) {
        [self showAlertMessage:@"Please Select Room"];
    }else if ([_selectLabel.text isEqualToString:@""])
    {
        [self showAlertMessage:@"Please Select Date"];
    }
    NSString *dateString = self.selectLabel.text;
    NSString *post =[NSString stringWithFormat:@"r_id=%@&date=%@",self.r_id,dateString];
    NSLog(@"%@&%@",_r_id,_selectLabel.text);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.kanishkagroups.com/sop/android/getMeetingDetailsMrms.php"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSString *stringResponse = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        
        NSError *error1;
        self.arrayResMRMS = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error1];
        if (self.arrayResMRMS.count==0) {
            [self showAlertMessage:@"no meetings Found"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[NSThread currentThread] isMainThread]){
                [tableData reloadData];
                NSLog(@"In main thread--completion handler");
            }
            else{
                NSLog(@"Not in main thread--completion handler");
            }
        });
        NSLog(@"dictionaryRes %@",self.arrayResMRMS);
        //NSLog(@"%@",self.dataArray);
    }];
    //[tableData reloadData];
    [dataTask resume];
    
    [toolbar removeFromSuperview];
    [picker12 removeFromSuperview];
}
-(IBAction)submitButton:(id)sender
{
 
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
    return self.arrayResMRMS.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *strID =@"Data";
    MyBookingsCell *cell1=[tableView dequeueReusableCellWithIdentifier:strID];
    if (cell1==nil) {
        cell1=[[MyBookingsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    cell1.startTimeTB.text=[[self.arrayResMRMS objectAtIndex:indexPath.row] objectForKey:@"m_start_time"];
    cell1.endTimeTB.text=[[self.arrayResMRMS objectAtIndex:indexPath.row]objectForKey:@"m_end_time"];
    cell1.bookedByTB.text=[[self.arrayResMRMS objectAtIndex:indexPath.row]objectForKey:@"m_invited_by_name"];
    return cell1;
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   

        if ([segue.identifier isEqualToString:@"AddVC"])  {
        AddController *send = segue.destinationViewController;
        send.dateString= self.selectLabel.text;
        send.iseditingMeet = NO;
        send.roomR_idSelected = self.r_id;
        send.editMeetingObj = nil;
        return;
        
    }else if ([segue.identifier isEqualToString:@"MyBookings"]) 
    {
        
        UIBarButtonItem *backBarbutton = [[UIBarButtonItem alloc]initWithTitle:@"MyBookings" style:UIBarStyleDefault target:self action:@selector(backToVC)];
        self.navigationItem.backBarButtonItem = backBarbutton;
    }
    
}
-(void)backToVC
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)appendImg:(NSString *)string
{
 
    if ([string  isEqual: @"Sun"])
    {
        [_imageArr addObject: @"sun"];

    } else if ([string  isEqual: @"Moon"]) {
        [_imageArr addObject: @"moon"];

    }else if ([string  isEqual: @"Mars"]) {
        [_imageArr addObject: @"mars"];

    }else if ([string  isEqual: @"Jupiter"]) {
        [_imageArr addObject: @"jupiter"];

    }else if ([string  isEqual: @"Saturn"]) {
        [_imageArr addObject: @"saturn"];

    }else if ([string  isEqual: @"Venus"]) {
        [_imageArr addObject: @"venus"];

    }else if ([string  isEqual: @"Neptune"]) {
        [_imageArr addObject: @"neptune"];

    }else if ([string  isEqual: @"Uranus"]) {
        [_imageArr addObject: @"uranus"];

    }else if ([string  isEqual: @"Galaxy"]) {
        [_imageArr addObject: @"galaxy"];

    }
    
    NSLog(@"%lu", (unsigned long)_imageArr.count);
  
}


@end
