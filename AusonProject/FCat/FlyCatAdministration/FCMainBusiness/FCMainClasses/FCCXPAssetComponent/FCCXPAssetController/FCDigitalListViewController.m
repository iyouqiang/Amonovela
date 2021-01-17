//
//  FCDigitalListViewController.m
//  Auson
//
//  Created by Yochi on 2021/1/14.
//  Copyright © 2021 Yochi. All rights reserved.
//

#import "FCDigitalListViewController.h"
#import "FCDigitalListCell.h"
#import "PCMacroDefinition.h"
#import "UIFont+Extension.h"
#import "FlyCatAdministration-Swift.h"

@interface FCDigitalListViewController ()<UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextField  *searchView;
@property (nonatomic, strong) UIView  *navigationView;
@property (nonatomic, strong) UIButton  *cancelBtn;
@property (nonatomic, strong) UIView  *navimaskView;
@property (nonatomic, strong) UITableView *listTableView;
@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@property (nonatomic, strong) NSMutableArray  *searchBtnArr;
@property (nonatomic, strong) NSMutableArray  *sectionArray;
@property (nonatomic, strong) NSMutableArray  *filterArray;

@end

@implementation FCDigitalListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = COLOR_BackgroundColor;
    self.filterArray = [NSMutableArray arrayWithArray:self.assetsArry];
    
    [self loadNavigationSearchView];
    
    [self configureTableView];
    
    [self groupingData];
}

- (NSMutableArray *)searchBtnArr
{
    if (!_searchBtnArr) {
        _searchBtnArr = [NSMutableArray array];
    }
    return  _searchBtnArr;
}

- (void)configureTableView
{
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, kSCREENWIDTH, kSCREENHEIGHT-120) style:UITableViewStylePlain];
    [self.view addSubview:_listTableView];
    _listTableView.backgroundColor = COLOR_HexColor(0x131829);
    _listTableView.sectionIndexColor = COLOR_HexColor(0xFFC400);
    _listTableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
    _listTableView.separatorColor = COLOR_HexColor(0x223249);
    _listTableView.delegate = self;
    _listTableView.dataSource = self;
    _listTableView.showsHorizontalScrollIndicator = NO;
    _listTableView.showsVerticalScrollIndicator = NO;
    //[self.listTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    //[self.listTableView setSectionIndexColor:[UIColor grayColor]];
    self.listTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)groupingData
{
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //    获取collation的索引
    NSUInteger sectionNumb = [[collation sectionTitles] count];
    NSMutableArray *sectionArray = [[NSMutableArray alloc] init];

    for (NSInteger index = 0; index<sectionNumb;index++){
        [sectionArray addObject:[[NSMutableArray alloc] init]];
    }
    
    for(FCAllAssetsConfigModel *model in self.filterArray){

        NSUInteger sectionIndex = [collation sectionForObject:model collationStringSelector:@selector(asset)];
        [sectionArray[sectionIndex] addObject:model];
    }
    
    //    对每个section中的数组按照name属性进行检索排序（快速索引）

    //    1.获取每个section下的数组

    //    2.对每个section下的数组进行字母排序

    for(NSInteger index=0; index<sectionNumb;index++){

        NSMutableArray *modelArrayForSection = sectionArray[index];

        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:modelArrayForSection collationStringSelector:@selector(asset)];

        sectionArray[index] = sortedPersonArrayForSection;
    }
    
    //  新建一个temp空的数组（目的是为了在调用enumerateObjectsUsingBlock函数的时候把空的数组添加到这个数组里，在将数据源空数组移除，或者在函数调用的时候进行判断，空的移除）

    NSMutableArray *temp = [NSMutableArray new];
    [self.searchBtnArr removeAllObjects];
     
    [sectionArray enumerateObjectsUsingBlock:^(NSArray *arr, NSUInteger idx, BOOL *stop) {

        if (arr.count == 0) {

            [temp addObject:arr];

        } else {

        
        [self.searchBtnArr addObject:[collation sectionTitles][idx]];

        }

    }];

    [sectionArray removeObjectsInArray:temp];
    self.sectionArray = sectionArray;
    
    [self.listTableView reloadData];
}

- (void)loadNavigationSearchView
{
    /// 左侧视图
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 45, 45)];
    leftView.backgroundColor = [UIColor clearColor];
    
    UIImageView *leftImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    leftImgView.image = [UIImage imageNamed:@"market_search"];
    leftImgView.center = leftView.center;
    [leftView addSubview:leftImgView];
    
    /// 搜索框
    _searchView = [[UITextField alloc] initWithFrame:CGRectMake(15, 120 - 53, kSCREENWIDTH - 85, 38)];
    _searchView.delegate = self;
    _searchView.layer.cornerRadius = 5;
    _searchView.leftView = leftView;
    _searchView.font = [UIFont font_DINProBoldTypeSize:14];
    _searchView.textColor = COLOR_HexColor(0x848D9B);
    _searchView.backgroundColor = COLOR_HexColor(0x131829);
    _searchView.borderStyle = UITextBorderStyleNone;
    //_searchView.returnKeyType = UIReturnKeyDone;
    _searchView.leftViewMode = UITextFieldViewModeAlways;
    _searchView.textAlignment = NSTextAlignmentLeft;
    _searchView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"请输入法币" attributes:@{NSForegroundColorAttributeName: COLOR_HexColor(0x6E7E97)}];
    [_searchView addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    
    // 头部界面
    _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 120)];
    _navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_navigationView];
    _navimaskView = [[UIView alloc] initWithFrame:_navigationView.bounds];
    _navimaskView.backgroundColor = COLOR_HexColor(0x212733);
    [_navigationView addSubview:_navimaskView];
    [_navigationView addSubview: _searchView];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(kSCREENWIDTH - 70, 120 - 53, 55, 38);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:COLOR_HexColor(0x848D9B) forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(cancelSearchAction) forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _cancelBtn.titleLabel.font = [UIFont font_PingFangSCTypeSize:14];
    [_navigationView addSubview:_cancelBtn];
}

#pragma market - searchData

- (void)searchDigital
{
    [self.filterArray removeAllObjects];
    
    if (_searchView.text.length == 0) {
        
        [self.filterArray addObjectsFromArray:self.assetsArry];
        [self groupingData];
        return;
    }
    
    for(FCAllAssetsConfigModel *model in self.assetsArry){
        
        NSString *assetStr = [model.asset uppercaseString];
        NSString *searchText = [self.searchView.text uppercaseString];
        if ([assetStr containsString:searchText]) {
            [self.filterArray addObject:model];
        }
    }
    
    [self groupingData];
}

- (void)cancelSearchAction
{
    [self dismissViewControllerAnimated:YES completion:^{
            
    }];
}

- (void)textFieldChange
{
    [self searchDigital];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchDigital];
    return YES;
}

#pragma market - tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *tempArray = self.sectionArray[section];
    return tempArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"cell";
    
    FCDigitalListCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (cell == nil) {
        cell = [[FCDigitalListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:string];
    }
    NSArray *items = self.sectionArray[indexPath.section];
    FCAllAssetsConfigModel *model = items[indexPath.row];
    [cell.imgHead sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    cell.labName.text = model.asset;
    NSLog(@"model.asset  :%@", model.asset);
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return self.searchBtnArr;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    NSInteger count = 0;
    for(NSString *header in self.searchBtnArr){
        if([header isEqualToString:title]){
            return count;
        }
        count ++;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, 40)];
    header.backgroundColor = COLOR_HexColor(0x131829);
    UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kSCREENWIDTH - 30, 40)];
    nameL.font = [UIFont font_DINProBoldTypeSize:16];
    nameL.textColor = [UIColor whiteColor];
    [header addSubview:nameL];
    nameL.text = self.searchBtnArr[section];
    return  header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"----%ld,\n%ld",indexPath.section,indexPath.row);
    
    if(_callBackItemBlock) {
        
        NSArray *items = _sectionArray[indexPath.section];
        _callBackItemBlock(items[indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
