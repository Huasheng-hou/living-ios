//
//  SearchViewController.m
//  TFSearchBar
//
//  Created by TF_man on 16/5/18.
//  Copyright © 2016年 TF_man. All rights reserved.
//

//RGB
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#import "SearchViewController.h"
#import "TableViewCell.h"
#import <CoreLocation/CoreLocation.h>

@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,TFTableViewDlegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    NSArray *locArray;
    UIView  *backView;
}

@property (strong, nonatomic) UIView *statusBar;

@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *allDataSource;/**<整个数据源*/

@property (strong, nonatomic) NSMutableArray *allData;/**<一维整个数*/

@property (strong, nonatomic) NSMutableArray *resultData;/**<一维查找的结果*/

@property (strong, nonatomic) NSMutableArray *indexDataSource;/**<索引数据源*/

@property (nonatomic,strong)UITableView *tv;

@property (nonatomic,strong)UITableView *tv2;

@property (nonatomic,strong)NSString *currentCity;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_GRAY_COLOR;
    self.title = @"选择城市";
    self.navigationController.navigationBar.titleTextAttributes          = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],
                                                       NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.barTintColor = LIVING_COLOR;
    // 设置导航栏左侧按钮
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(0, 0, 40, 30);
    [leftBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    UIBarButtonItem *LeftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = LeftBarButton;
    
    self.navigationItem.rightBarButtonItem = nil;
    
    [self locate];
    //添加UITableView
    [self.view addSubview:self.tv2];

    [self.view addSubview:self.searchBar];
    //添加UITableView
    [self.view addSubview:self.tv];
    
    [self GetDataFromPlistFiles];
}

- (void)locate {
    //判断定位功能是否打开
    if ([CLLocationManager locationServicesEnabled]) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager requestAlwaysAuthorization];
        _currentCity = [[NSString alloc] init];
        _currentCity = @"定位中";
        [locationManager startUpdatingLocation];
    }
    
}

#pragma mark -------懒加载

- (UITableView *)tv{
    
    if (!_tv) {
        
        _tv = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+45, kScreenWidth, kScreenHeight-45-64)];
        _tv.delegate = self;
        _tv.dataSource = self;
        [_tv registerClass:[TableViewCell class] forCellReuseIdentifier:@"TableViewCellID"];
        
        
    }
    
    return _tv;
}

- (UITableView *)tv2{
    
    if (!_tv2) {
        _tv2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 64+45, kScreenWidth, kScreenHeight-64-45)];
        _tv2.keyboardDismissMode          = UIScrollViewKeyboardDismissModeOnDrag;
        _tv2.delegate = self;
        _tv2.dataSource = self;
        _tv2.contentInset = UIEdgeInsetsMake(-64, 0, 0, 0);
   
    }
    
    return _tv2;
}

#pragma mark CoreLocation delegate

//定位失败则执行此代理方法
//定位失败弹出提示框,点击"打开定位"按钮,会打开系统的设置,提示打开定位服务
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"允许\"定位\"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //打开定位设置
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        _currentCity = @"定位失败";
    }];
    [alertVC addAction:cancel];
    [alertVC addAction:ok];
    [self presentViewController:alertVC animated:YES completion:nil];
    
    [self.tv reloadData];
    
}
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    
    //反编码
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            _currentCity = placeMark.locality;
            if (!_currentCity) {
                _currentCity = @"定位失败";
            }
   
           [self setCityInfo];
  
           [_tv reloadData];
            
            NSLog(@"%@",_currentCity); //这就是当前的城市
            NSLog(@"%@",placeMark.name);//具体地址:  xx市xx区xx街道
        }
        else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error return");
        }
        else if (error) {
            NSLog(@"location error: %@ ",error);
        }
        
        
    }];
    
}

- (void)setCityInfo
{
    NSMutableArray *mutArr = [[NSMutableArray alloc]initWithObjects:_currentCity, nil];
    
    //存入数组并同步
    
    [[NSUserDefaults standardUserDefaults] setObject:mutArr forKey:@"mutableArr"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark -------从plist文件获取数据

- (void)GetDataFromPlistFiles{
    
    self.allDataSource = [NSMutableArray array];
    self.indexDataSource = [NSMutableArray array];
    self.allData = [NSMutableArray array];
    self.resultData = [NSMutableArray array];

    
    NSArray *arrs = [[NSUserDefaults standardUserDefaults] objectForKey:@"mutableArr"];
    if (arrs != nil) {
          locArray = arrs;
        }else{
        locArray = @[_currentCity];
    }
    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchArr"];
    NSArray *newArray = [NSArray new];
    if (searchArr.count>0) {
        newArray = searchArr;
    }else{
        newArray = @[@"杭州"];
    }
    
    NSDictionary *dic2 = @{@"定位城市":locArray,@"最近访问城市":newArray,@"热门城市":@[@"杭州",@"北京",@"上海",@"重庆",@"成都",@"深圳",@"天津",@"西安",@"南京",@"广州",@"其它",@"全部"]};
    
    
    NSArray *arr2 = [dic2 allKeys];
    arr2 = [arr2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    for (NSString *str  in arr2) {
        
        [self.indexDataSource addObject:str];
        NSArray *array = dic2[str];
        [self.allDataSource addObject:array];

    }
    
    //所有的城市
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"citydict" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSArray *arr = [dic allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    for (NSString *str  in arr) {

        [self.indexDataSource addObject:str];
        NSArray *array = dic[str];
        [self.allDataSource addObject:array];
        [self.allData addObjectsFromArray:array];
     
    }
    
    [self.tv reloadData];
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 45)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.showsCancelButton = NO;
    }
    return _searchBar;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.tv2) {
        
        return 1;
        
    }
    return self.allDataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tv2) {
        
        return self.resultData.count;
        
    }else{
        
        
        if (section > 2) {
            
            NSArray *array = self.allDataSource[section];
            
            return array.count;
            
        }else{
            
            return 1;
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.tv2) {
        
        static NSString *cellID = @"cellID2";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (!cell) {
            
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
            
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text = self.resultData[indexPath.row];
        
        return cell;
        
    }else{
        
        if (indexPath.section==0) {
            TableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellID" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            
            NSArray *arrs = [[NSUserDefaults standardUserDefaults] objectForKey:@"mutableArr"];
            if (arrs.count>0) {
                if ([locArray isEqual:arrs]) {
                  cell.cellArr = locArray;
                }else{
                    cell.cellArr = arrs;
                }
            }else{
                cell.cellArr = @[_currentCity];
            }
            return cell;
        }
        
        
        if (indexPath.section > 2) {
            
            static NSString *cellID = @"cellID";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            
            if (!cell) {
                
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *array = self.allDataSource[indexPath.section];
            cell.textLabel.font = TEXT_FONT_LEVEL_2;
            cell.textLabel.text = array[indexPath.row];
            
            return cell;
            
        }else{
            
            TableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"TableViewCellID" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            cell.backgroundColor = [UIColor clearColor];
            NSArray *array = self.allDataSource[indexPath.section];
            cell.cellArr = array;
            return cell;
        }
        
        
    }

}


//右侧索引列表
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {

    if (tableView == self.tv) {
        
        NSMutableArray *mutArr = [NSMutableArray array];
        [mutArr addObjectsFromArray:(NSArray *)self.indexDataSource];
        [mutArr replaceObjectAtIndex:0 withObject:@"定位"];
        [mutArr replaceObjectAtIndex:1 withObject:@"最近"];
        [mutArr replaceObjectAtIndex:2 withObject:@"热门"];
        
        return mutArr;
    }else{
        
        return nil;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (![cell isKindOfClass:[TableViewCell class]]) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            
            [_searchBar resignFirstResponder];
            
        } completion:^(BOOL finished) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                
                if (self.succeed) {
                    self.succeed(cell.textLabel.text);
                    NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchArr"];
                    
                    NSMutableArray *newArray = [NSMutableArray new];
                    if (![searchArr containsObject:cell.textLabel.text]) {
                        [newArray addObject:cell.textLabel.text];
                    }
                    [newArray addObjectsFromArray:searchArr];
                    
                    if (newArray.count>3) {
                        [newArray removeObjectAtIndex:3];
                    }
                    //存入数组并同步
                    
                    [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"searchArr"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEvent"
                     
                                                                        object:nil];
                    
                    
                }
                
            }];
        }];
        
        
    }

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tv) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        view.backgroundColor = BG_GRAY_COLOR;
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 120, 30)];
        lb.font = TEXT_FONT_LEVEL_2;
        lb.text = self.indexDataSource[section];
//        [lb sizeToFit];
        [view addSubview:lb];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView ==_tv2) {
        return 40;
    }else{
    
    if (indexPath.section == 1) {
        NSArray *array = self.allDataSource[indexPath.section];
        if (array.count==3) {
            return array.count/3*45+15;
        }else{
           return array.count/3*45 +60;
        }
        
    }
    
    if (indexPath.section > 2) {
        
        return 40;
        
    }
    if (indexPath.section == 2) {
        NSArray *array = self.allDataSource[indexPath.section];
        return array.count/3*45+15;
    }
    
    else{
        
        NSArray *array = self.allDataSource[indexPath.section];
        return array.count/3*45 +60;
        
    }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView == self.tv2) {
        
        return 0.001;
    }
    return 30;
}


#pragma mark - UISearchDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
//    self.allData
    [self.resultData removeAllObjects];
    //一维查找
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", searchText];
    
    NSArray *filterdArray = [(NSArray *)self.allData filteredArrayUsingPredicate:predicate];
    
    [self.resultData addObjectsFromArray:filterdArray];
    if (self.resultData.count>0) {
        [backView removeFromSuperview];
    }
    
    [self.view bringSubviewToFront:self.tv2];
    [self.tv2 reloadData];
    
    
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self.resultData removeAllObjects];
    //一维查找
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [cd] %@", searchBar.text];
    
    NSArray *filterdArray = [(NSArray *)self.allData filteredArrayUsingPredicate:predicate];
    
    [self.resultData addObjectsFromArray:filterdArray];
    
    if (self.resultData.count>0) {
        [backView removeFromSuperview];
    }
    
    [self.view bringSubviewToFront:self.tv2];
    [self.tv2 reloadData];
}


- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    _searchBar.showsCancelButton = YES;
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64+45, kScreenWidth, kScreenHeight-64-45)];
    backView.backgroundColor = [UIColor blackColor];
    backView.alpha=0.5;
    [self.view addSubview:backView];
    
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    _searchBar.showsCancelButton = NO;
    _searchBar.text = @"";
    [_searchBar resignFirstResponder];
    [backView removeFromSuperview];
    [self.view sendSubviewToBack:self.tv2];
}

- (void)cancelBtnClick{
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

#pragma mark -------TableViewDlegate

- (void)TableViewSelectorIndix:(NSString *)str{
    
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (self.succeed) {
            self.succeed(str);
            
            NSArray *searchArr = [[NSUserDefaults standardUserDefaults] objectForKey:@"searchArr"];
            
            NSMutableArray *newArray = [NSMutableArray new];
            if (![searchArr containsObject:str]) {
               [newArray addObject:str];
            }
            
            [newArray addObjectsFromArray:searchArr];
            
            if (newArray.count>3) {
                [newArray removeObjectAtIndex:3];
            }
            //存入数组并同步
            
            [[NSUserDefaults standardUserDefaults] setObject:newArray forKey:@"searchArr"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEvent"
             
                                                                object:nil];
            
        }
        
    }];
    
}


@end
