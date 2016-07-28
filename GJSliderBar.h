//
//  GJSliderBar.h
//  GJSliderBar
//
//  Created by tongguan on 16/7/26.
//  Copyright © 2016年 MinorUncle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GJSliderBar;
typedef void(^IndexCallBack)(NSInteger index);

@interface GJSliderBar : UIView
@property(strong,nonatomic)NSArray<NSString*>* titleNames;
@property(strong,nonatomic)NSArray<NSNumber*>* titleTags;

@property(strong,nonatomic)UIFont* itemFont;
@property(strong,nonatomic)UIColor* itemColor;
@property(strong,nonatomic)UIColor* itemSelectColor;

@property(copy,nonatomic)IndexCallBack slideBarItemSelectedCallback;
@property(nonatomic,readonly)NSInteger currentIndex;
-(void)selectItemWithIndex:(NSInteger)index;
@end
