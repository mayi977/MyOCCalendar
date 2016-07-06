//
//  CalendarViewController.h
//  MyOCCalendar
//
//  Created by Zilu.Ma on 16/7/6.
//  Copyright © 2016年 Zilu.Ma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIAlertViewDelegate>

{
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    int _selectItem;
    int _selectDay;
    NSArray *_weekArray;
    NSMutableArray *_currentMonthArr;
    NSMutableArray *_lastMonthArr;
    NSMutableArray *_nextMonthArr;
    int _nowYear;
    int _nowMonth;
    int _nowDay;
    int _currentYear;
    int _lastYear;
    int _nextYear;
    int _currentMonth;
    int _lastMonth;
    int _nextMonth;
    int _currentWeek;
    int _lastWeek;
    int _nextWeek;
    
    NSMutableArray *_allDayArr;//三个月
    
    UIScrollView *_bgScrollView;
    UIScrollView *_calendarSV;
    UICollectionView *_currentMonthCV;
    UICollectionView *_lastMonthCV;
    UICollectionView *_nextMonthCV;
    
    UICollectionView *_smallCalendar;
    NSMutableArray *_smallDayArr;
    BOOL _isShow;
    BOOL _isTop;
    
    CGFloat _selectOriginY;
    
    UIImageView *_arrowImg;
    NSMutableArray *_allDataArr;
    NSMutableArray *_showArray;
    BOOL _isHistory;
}

@end
