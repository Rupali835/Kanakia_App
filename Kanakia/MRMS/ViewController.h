//
//  ViewController.h
//  WebServices
//
//  Created by Ramesh on 7/28/16.
//  Copyright © 2016 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) IBOutlet UILabel *selectLabel;
    @property (nonatomic,strong) NSDictionary *mainDict;
    @property (nonatomic,strong) NSArray *RoomsArray;
    @property (nonatomic,strong) NSArray *usersArray;
@end

