//
//  CollectionCell.h
//  WebServices
//
//  Created by VijayKumar on 2/23/18.
//  Copyright © 2018 Sample. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (nonatomic,weak)IBOutlet UIImageView *imgView;
@property (nonatomic,weak)IBOutlet UILabel *namesLabel;
@property (nonatomic,weak) IBOutlet UILabel *tVLabel;
@property (nonatomic,weak) IBOutlet UIImageView * selectedImgView;
@end
