//
//  CalendarViewController.m
//  MyOCCalendar
//
//  Created by Zilu.Ma on 16/7/6.
//  Copyright © 2016年 Zilu.Ma. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController ()

@end

@implementation CalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    screenWidth = [UIScreen mainScreen].bounds.size.width;
    screenHeight = [UIScreen mainScreen].bounds.size.height - 64;
    _showArray = [[NSMutableArray alloc] init];
    _allDataArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < 12; i ++) {
        NSDictionary *dic = [NSDictionary dictionaryWithObject:@"12345" forKey:[NSString stringWithFormat:@"13"]];
        [_allDataArr addObject:dic];
    }
    
    [self addWeekView];
    [self nowDate];
    [self addBackgroundScrollView];
    [self addSmallCalendarView];
}

//这个界面的背景
- (void)addBackgroundScrollView{
    
    _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64+40,screenWidth,screenHeight)];
    _bgScrollView.contentSize = CGSizeMake(screenWidth, screenHeight+(screenWidth/7*5));
    _bgScrollView.bounces = false;
    _bgScrollView.delegate = self;
    _bgScrollView.showsVerticalScrollIndicator = false;
    _bgScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bgScrollView];
    
    [self addCalendarBackgroundScrollView];
}

- (void)addWeekView{
    
    _weekArray = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    CGFloat width = screenWidth/7;
    for (int i = 0; i < 7; i ++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(width*i,64,width,40)];
        label.text = _weekArray[i];
        label.textAlignment = 1;
        label.backgroundColor = [UIColor whiteColor];
        if (i == 0 || i == 6) {
            label.textColor = [UIColor purpleColor];
        }else{
            label.textColor = [UIColor blackColor];
        }
        label.font = [UIFont boldSystemFontOfSize:24];
        [self.view addSubview:label];
    }
}

//日历的背景
- (void)addCalendarBackgroundScrollView{
    
    _calendarSV = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,screenWidth,(screenWidth)/7*6)];
    _calendarSV.contentSize = CGSizeMake(screenWidth*3, (screenWidth)/7*6);
    _calendarSV.backgroundColor = [UIColor clearColor];
    _calendarSV.delegate = self;
    _calendarSV.pagingEnabled = true;
    _calendarSV.bounces = false;
    _calendarSV.showsHorizontalScrollIndicator = false;
    _calendarSV.contentOffset = CGPointMake(screenWidth, 0);
    [_bgScrollView addSubview:_calendarSV];
    
    [self addCurrentMouthCollectionView];
    [self addLastMouthCollectionView];
    [self addNextMouthCollectionView];
}

//刷新所有的日历(可在此优化)
- (void)reloadAllDate{
    
    [_currentMonthCV reloadData];
    [_lastMonthCV reloadData];
    [_nextMonthCV reloadData];
    [_smallCalendar reloadData];
}

//初始化当前显示月的日历
- (void)addCurrentMouthCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((screenWidth)/7, (screenWidth)/7);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _currentMonthCV = [[UICollectionView alloc] initWithFrame:_calendarSV.bounds collectionViewLayout:layout];
    _currentMonthCV.dataSource = self;
    _currentMonthCV.delegate = self;
    _currentMonthCV.backgroundColor = [UIColor clearColor];
    [_currentMonthCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_calendarSV addSubview:_currentMonthCV];
}

//初始化上月的日历
- (void)addLastMouthCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((screenWidth)/7, (screenWidth)/7);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _lastMonthCV = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0,screenWidth,screenWidth) collectionViewLayout:layout];
    _lastMonthCV.dataSource = self;
    _lastMonthCV.delegate = self;
    _lastMonthCV.backgroundColor = [UIColor clearColor];
    [_lastMonthCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_calendarSV addSubview:_lastMonthCV];
}

//初始化下月的日历
- (void)addNextMouthCollectionView{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((screenWidth)/7, (screenWidth)/7);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _nextMonthCV = [[UICollectionView alloc] initWithFrame:CGRectMake(screenWidth*2,0,screenWidth,screenWidth) collectionViewLayout:layout];
    _nextMonthCV.dataSource = self;
    _nextMonthCV.delegate = self;
    _nextMonthCV.backgroundColor = [UIColor clearColor];
    [_nextMonthCV registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_calendarSV addSubview:_nextMonthCV];
}

//初始化周日历
- (void)addSmallCalendarView{
    
    [self getSmallDayArray];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((screenWidth)/7, (screenWidth)/7);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    _smallCalendar = [[UICollectionView alloc] initWithFrame:CGRectMake(0,64+40,screenWidth,0) collectionViewLayout:layout];
    _smallCalendar.dataSource = self;
    _smallCalendar.delegate = self;
    _smallCalendar.pagingEnabled = true;
    _smallCalendar.showsHorizontalScrollIndicator = NO;
    _smallCalendar.backgroundColor = [UIColor whiteColor];
    [_smallCalendar registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_smallCalendar];
}

//处理展示周日历时的坐标
- (void)showSmallCalendar{
    
    CGRect rect = _smallCalendar.frame;
    rect.size.height = (screenWidth)/7+1;
    _smallCalendar.frame = rect;
    
    CGPoint point = _smallCalendar.contentOffset;
    point.x = screenWidth;
    _smallCalendar.contentOffset = point;
    
    CGPoint TVPoint = _bgScrollView.contentOffset;
    TVPoint.y = (screenWidth)/7*5;
    _bgScrollView.contentOffset = TVPoint;
    _arrowImg.image = [UIImage imageNamed:@"slide down icon"];
}

//处理隐藏周日历时的坐标
- (void)hideSmallCalendar{
    
    CGRect rect = _smallCalendar.frame;
    rect.size.height = 0;
    _smallCalendar.frame = rect;
    
    CGPoint point = _bgScrollView.contentOffset;
    point.y = 0;
    _bgScrollView.contentOffset = point;
    _arrowImg.image = [UIImage imageNamed:@"slide up icon"];
}

//周日历固定21天,月日历统一42天(根据实际的天数显示)
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (collectionView == _smallCalendar) {
        return 21;
    }else{
        return 7*6;
    }
}

//加载日历的日期
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [cell.contentView viewWithTag:10];
    [label removeFromSuperview];
    
    if (collectionView == _currentMonthCV) {
        [self addCellLabelWithView:cell.contentView WithIndex:indexPath.item WithDayArr:_currentMonthArr WithWeek:_currentWeek];
    }else if (collectionView == _lastMonthCV) {
        [self addCellLabelWithView:cell.contentView WithIndex:indexPath.item WithDayArr:_lastMonthArr WithWeek:_lastWeek];
    }else if (collectionView == _nextMonthCV) {
        [self addCellLabelWithView:cell.contentView WithIndex:indexPath.item WithDayArr:_nextMonthArr WithWeek:_nextWeek];
    }else{
        [self LabelWithView:cell.contentView WithIndex:indexPath.item];
    }
    
    return cell;
}

//处理选中日期,
//当前为周日历,并且周日历显示两个月份的日期时(6月,7月),若由6月的日期选到7月的日期,在刷新界面的时候,同时需要将相应的月份更改掉;也许在此做处理.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *dayString = nil;
    if (collectionView == _smallCalendar) {
        dayString = _smallDayArr[indexPath.item];
        NSArray *array = [dayString componentsSeparatedByString:@"-"];
        int month = [[array firstObject] intValue];
        _selectItem = [[array lastObject] intValue];
        _selectDay = _selectItem;
        if (_currentMonth > month) {
            if (_currentMonth == 12) {
                _selectItem = _selectItem + _nextWeek-2;
                [self getDateWithYear:_currentYear WithMonth:_currentMonth+1];
            }else{
                _selectItem = _selectItem + _lastWeek-2;
                [self getDateWithYear:_currentYear WithMonth:_currentMonth-1];
            }
        }else if (_currentMonth == month){
            _selectItem = _selectItem + _currentWeek-2;
        }else{
            if (month == 12) {
                _selectItem = _selectItem + _lastWeek-2;
                [self getDateWithYear:_currentYear WithMonth:_currentMonth-1];
            }else{
                _selectItem = _selectItem + _nextWeek-2;
                [self getDateWithYear:_currentYear WithMonth:_currentMonth+1];
            }
        }
        [self getSmallDayArray];
    }else{
        if (indexPath.item >= _currentWeek-1 && indexPath.item <= _currentMonthArr.count-1+_currentWeek-1) {
            _selectItem = (int)indexPath.item;
            _selectOriginY = (indexPath.item/7)*((screenWidth)/7);
            dayString = _currentMonthArr[indexPath.item - (_currentWeek-1)];
            _selectDay = [[[dayString componentsSeparatedByString:@"-"] lastObject] intValue];
        }
        [self getSmallDayArray];
    }
    
    [_smallCalendar reloadData];
    [_currentMonthCV reloadData];
}

//左右切换月份
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //    NSLog(@"%s",__func__);
    if (scrollView == _calendarSV) {
        int year = _currentYear;
        int mouth = _currentMonth;
        _selectDay = 1;
        if (scrollView.contentOffset.x == 0) {
            [self getDateWithYear:year WithMonth:mouth-1];
        }else if (scrollView.contentOffset.x == screenWidth*2) {
            [self getDateWithYear:year WithMonth:mouth+1];
        }
        _selectItem = _currentWeek;
        [self getSmallDayArray];
        [self reloadAllDate];
        CGPoint point = _calendarSV.contentOffset;
        point.x = screenWidth;
        _calendarSV.contentOffset = point;
        
        //若每次改变月份都要请求新的数据,就在此将旧数据删掉
//        [_allDataArr removeAllObjects];
    }
    
    NSString *dayString = nil;
    if (scrollView == _smallCalendar) {
        if (scrollView.contentOffset.x>=0 && scrollView.contentOffset.x<=10) {
            dayString = _smallDayArr[0];
            NSArray *array = [dayString componentsSeparatedByString:@"-"];
            _selectDay = [[array lastObject] intValue];
            _selectItem = _selectDay;
            _selectItem = _selectItem+(_currentWeek-1);
            int nowMouth = [[array firstObject] intValue];
            if (nowMouth != _currentMonth) {
                int year = _currentYear;
                int month = _currentMonth;
                [self getDateWithYear:year WithMonth:month-1];
                 //若每次改变月份都要请求新的数据,就在此将旧数据删掉
//                [_allDataArr removeAllObjects];
                _selectItem = _selectItem+(_currentWeek-1);
            }
        }
        
        if (scrollView.contentOffset.x>=2*(screenWidth-30) && scrollView.contentOffset.x<=2*screenWidth) {
            dayString = _smallDayArr[14];
            NSArray *array = [dayString componentsSeparatedByString:@"-"];
            _selectDay = [[array lastObject] intValue];
            _selectItem = _selectDay;
            _selectItem = _selectItem+(_currentWeek-1);
            int nowMouth = [[array firstObject] intValue];
            if (nowMouth != _currentMonth) {
                int year = _currentYear;
                int month = _currentMonth;
                [self getDateWithYear:year WithMonth:month+1];
                 //若每次改变月份都要请求新的数据,就在此将旧数据删掉
//                [_allDataArr removeAllObjects];
                _selectItem = _selectItem+(_currentWeek-1);
            }
        }
        
        [self getSmallDayArray];
        [self reloadAllDate];
        _smallCalendar.contentOffset = CGPointMake(screenWidth, 0);
    }
    
    if (scrollView == _bgScrollView) {
        if (scrollView.contentOffset.y >= (screenWidth)/5) {
            [self showSmallCalendar];
        }else{
            [self hideSmallCalendar];
        }
    }
}

//隐藏或显示周日历
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView == _bgScrollView) {
        if (scrollView.contentOffset.y >= (screenWidth)/5) {
            [self showSmallCalendar];
        }else{
            [self hideSmallCalendar];
        }
    }
}

//显示周日历的日期
- (void)LabelWithView:(UIView *)view WithIndex:(NSInteger)index{
    
    UILabel *lab = [[UILabel alloc] initWithFrame:view.bounds];
    NSString *string = _smallDayArr[index];
    NSArray *array = [string componentsSeparatedByString:@"-"];
    lab.text = [array lastObject];
    lab.textAlignment = 1;
    lab.tag = 10;
    lab.font = [UIFont boldSystemFontOfSize:24];
    
    int month = [[array firstObject] intValue];
    int day = [[array lastObject] intValue];
    
    UIColor *lastColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.8];
    UIColor *nextColor = [UIColor blackColor];
    //选择哪一天
    if (day == _selectDay) {
        lab.layer.cornerRadius = 20;
        lab.layer.backgroundColor = [UIColor orangeColor].CGColor;
        lab.textColor = [UIColor whiteColor];
    }else{
        //判断昨天今天明天
        if (_nowYear < _currentYear) {
            lab.textColor = nextColor;
        }else if (_nowYear == _currentYear){
            if (_nowMonth < month) {
                lab.textColor = nextColor;
            }else if (_nowMonth == month){
                if (day > _nowDay) {
                    lab.textColor = nextColor;
                }else if (day == _nowDay){
                    lab.textColor = [UIColor redColor];
                }else{
                    lab.textColor = lastColor;
                }
            }else{
                lab.textColor = lastColor;
            }
        }else{
            lab.textColor = lastColor;
        }
    }
    
    for (NSDictionary *dic in _allDataArr) {
        NSString *key = [[dic allKeys] firstObject];
        if ([key isEqualToString:string]) {
            [self addCellPointWithView:lab];
        }
    }
    [view addSubview:lab];
}

//显示月日历的日期,包括添加标记
- (void)addCellLabelWithView:(UIView *)view WithIndex:(NSInteger)index WithDayArr:(NSMutableArray *)dayArr WithWeek:(int)week{
    
    if (index >= week-1 && index <= dayArr.count-1+week-1){
        UILabel *lab = [[UILabel alloc] initWithFrame:view.bounds];
        NSString *string = dayArr[index - (week-1)];
        NSString *dayStr = [[string componentsSeparatedByString:@"-"] lastObject];
        int day = [dayStr intValue];
        lab.text = dayStr;
        lab.textAlignment = 1;
        lab.tag = 10;
        lab.font = [UIFont boldSystemFontOfSize:24];
        
        //选择的日期
        if (day == _selectDay && dayArr == _currentMonthArr) {
            lab.layer.cornerRadius = (lab.bounds.size.width)/2;
            lab.layer.backgroundColor = [UIColor orangeColor].CGColor;
            lab.textColor = [UIColor whiteColor];
        }else{
            UIColor *lastColor = [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.8];
            UIColor *nextColor = [UIColor blackColor];
            //在此判断昨天今天明天
            if (_nowYear < _currentYear) {
                lab.textColor = nextColor;
            }else if (_nowYear == _currentYear){
                if (_nowMonth < _currentMonth) {
                    lab.textColor = nextColor;
                }else if (_nowMonth == _currentMonth){
                    if (index > _nowDay + week - 2) {
                        lab.textColor = nextColor;
                    }else if (index == _nowDay + week - 2){
                        lab.textColor = [UIColor redColor];
                    }else{
                        lab.textColor = lastColor;
                    }
                }else{
                    lab.textColor = lastColor;
                }
            }else{
                lab.textColor = lastColor;
            }

        }
        
        //在此遍历数据,有的话就进行标记
        for (NSDictionary *dic in _allDataArr) {
            NSString *key = [[dic allKeys] firstObject];
            if ([key isEqualToString:[string componentsSeparatedByString:@"-"].lastObject]) {
                [self addCellPointWithView:lab];
            }
        }
        [view addSubview:lab];
    }
}


//在日期下面添加点作为标记
- (void)addCellPointWithView:(UIView *)view{
    
    CALayer *layer=[CALayer layer];
    layer.bounds = CGRectMake(0, 0, 5, 5);
    layer.cornerRadius = 5/2;
    layer.position = CGPointMake(((screenWidth)/7)/2, (screenWidth)/7-5);
    layer.backgroundColor = [UIColor redColor].CGColor;
    [view.layer addSublayer:layer];
}

//计算相应的年份
- (int)getYearWithYear:(int)year WithMonth:(int)month{
    
    if (month <= 0) {
        year = year - 1;
    }else if (month >= 13) {
        year = year + 1;
    }
    
    return year;
}

//计算相应的月份
- (int)getMonthWithMonth:(int)month{
    
    if (month <= 0) {
        month = 12;
    }else if(month >= 13){
        month = 1;
    }
    
    return month;
}

//根据日期得到相应的星期
- (int)getWeekWithYear:(int)year WihtMonth:(int)month WithDay:(int)day{
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.day = day;
    comps.month = month;
    comps.year = year;
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [calendar dateFromComponents:comps];
    NSDateComponents *components =
    [calendar components:NSCalendarUnitWeekday fromDate:date];
    int week = (int)[components weekday];
    
    return week;
}

//计算某年某月的日期
- (NSMutableArray *)getDayArrayWithYear:(int)year WithMonth:(int)month{
    
    NSCalendar *calendar = [[NSCalendar alloc]
                            initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM";
    NSString *dayString = [NSString stringWithFormat:@"%d-%d",year,month];
    NSDate *date = [formatter dateFromString:dayString];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSMutableArray *dayArray = [[NSMutableArray alloc] init];
    for (int i = 1;i <= range.length; i++) {
        NSString *mouthStr;
        NSString *dayStr;
        if (month<10) {
            mouthStr = [NSString stringWithFormat:@"0%d",month];
        }else{
            mouthStr = [NSString stringWithFormat:@"%d",month];
        }
        if (i<10) {
            dayStr = [NSString stringWithFormat:@"0%d",i];
        }else{
            dayStr = [NSString stringWithFormat:@"%d",i];
        }
        [dayArray addObject:[NSString stringWithFormat:@"%@-%@",mouthStr,dayStr]];
    }
    
    return dayArray;
}

//计算当前的日期
- (void)nowDate{
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    NSString *year = [formatter stringFromDate:now];
    formatter.dateFormat = @"MM";
    NSString *mouth = [formatter stringFromDate:now];
    formatter.dateFormat = @"dd";
    NSString *day = [formatter stringFromDate:now];
    
    _nowYear = [year intValue];
    _nowMonth = [mouth intValue];
    _nowDay = [day intValue];
    _selectDay = _nowDay;
    
    [self getDateWithYear:_nowYear WithMonth:_nowMonth];
    _selectItem = _nowDay + _currentWeek-2;
}

//每次刷新界面时都需要计算年月日星期
- (void)getDateWithYear:(int)year WithMonth:(int)month{
    
    _currentYear = [self getYearWithYear:year WithMonth:month];
    _currentMonth = [self getMonthWithMonth:month];
    _currentWeek = [self getWeekWithYear:_currentYear WihtMonth:_currentMonth WithDay:1];
    _currentMonthArr = [self getDayArrayWithYear:_currentYear WithMonth:_currentMonth];
    self.navigationItem.title = [NSString stringWithFormat:@"%d年%d月",_currentYear,_currentMonth];
    
    _lastYear = [self getYearWithYear:_currentYear WithMonth:_currentMonth-1];
    _lastMonth = [self getMonthWithMonth:_currentMonth-1];
    _lastWeek = [self getWeekWithYear:_lastYear WihtMonth:_lastMonth WithDay:1];
    _lastMonthArr = [self getDayArrayWithYear:_lastYear WithMonth:_lastMonth];
    
    _nextYear = [self getYearWithYear:_currentYear WithMonth:_currentMonth+1];
    _nextMonth = [self getMonthWithMonth:_currentMonth+1];
    _nextWeek = [self getWeekWithYear:_nextYear WihtMonth:_nextMonth WithDay:1];
    _nextMonthArr = [self getDayArrayWithYear:_nextYear WithMonth:_nextMonth];
}

//通过当前三个月的日期,计算出周日历的日期(每次计算三周)
- (void)getSmallDayArray{
    
    if (_allDayArr == nil) {
        _allDayArr = [[NSMutableArray alloc] init];
    }else{
        [_allDayArr removeAllObjects];
    }
    
    if (_smallDayArr == nil) {
        _smallDayArr = [[NSMutableArray alloc] init];
    }else{
        [_smallDayArr removeAllObjects];
    }
    _allDayArr = [[NSMutableArray alloc] init];
    [_allDayArr addObjectsFromArray:_lastMonthArr];
    [_allDayArr addObjectsFromArray:_currentMonthArr];
    [_allDayArr addObjectsFromArray:_nextMonthArr];
    
    int week = _selectItem%7;
    //当当前月的1号是周六时,week=0;若week=0,得到的小日历的日期会增加一周
    if (week == 0) {
        week = 7;
    }
    int first = (int)_lastMonthArr.count-1+_selectItem-_currentWeek+1-week-6;
    for (int i = first; i < first+21; i ++) {
        NSString *dayStr = _allDayArr[i];
        [_smallDayArr addObject:dayStr];
    }
    [_smallCalendar reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
