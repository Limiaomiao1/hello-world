//
//  TSBorrowDetailController.m
//  TuanShang
//
//  Created by tuanshang on 16/9/12.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSBorrowDetailController.h"
#import "TSBorrowDetailModel.h"
#import "TSBorrowDetailCell.h"
#import "SDCycleScrollView.h"
#import "TSDescribeController.h"

@interface TSBorrowDetailController ()<SDCycleScrollViewDelegate>

@property (nonatomic, strong)TSBorrowDetailModel * borrowDetailModel;
@property (strong, nonatomic) SDCycleScrollView * myScrollview; // 轮播
/** Banner */
@property (nonatomic, strong) NSMutableArray *imageArr;
@end

@implementation TSBorrowDetailController

- (NSMutableArray *)imageArr
{
    if(!_imageArr) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setSubViews];
    [self loadInfoData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 界面部署
- (void)setSubViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TSScreenW, TSScreenH - 64) style:UITableViewStylePlain];
    [self.tableView registerNib:[UINib nibWithNibName:@"TSBorrowDetailCell" bundle:nil] forCellReuseIdentifier:@"TSBorrowDetailCell"];
    self.tableView.rowHeight = 45*9;
//    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}


#pragma mark - 数据加载
- (void)loadInfoData {
    
    [[TSNetwork shareNetwork] postRequestResult:@{@"id":@(self.ID)} url:@"borrow_detail" successBlock:^(id responseBody) {
        TSLog(@"%@", responseBody);
        
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
 
        if ([eventStr isEqualToString:@"88"]) {

            TSBorrowDetailModel * model = [TSBorrowDetailModel mj_objectWithKeyValues:responseBody[@"data"]];
            self.borrowDetailModel = model;
            [self.tableView reloadData];
        }else
        {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TSBorrowDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TSBorrowDetailCell" forIndexPath:indexPath];
    cell.borrowModel = self.borrowDetailModel;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TSWeakSelf;
    cell.didDescribtn = ^ {
        TSDescribeController * desVC = [[TSDescribeController alloc] init];
//        desVC.httpStr = weakSelf.borrowDetailModel.borrow_info;
        desVC.borrow_info_two = weakSelf.borrowDetailModel.borrow_info_two;

        [self.navigationController pushViewController:desVC animated:YES];
    };
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SDCycleScrollView * myScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, TSScreenW, 200) delegate:self placeholderImage:[UIImage imageNamed:@"borrowPicNull"]];
    self.myScrollview = myScroll;
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"id":@(self.ID)} url:@"borrow_detail" successBlock:^(id responseBody) {
        
        
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {

            _imageArr = responseBody[@"data"][@"updata"];
            TSLog(@"%@", _imageArr);
            NSMutableArray * imageurl = [[NSMutableArray alloc] init];
            if (![_imageArr isEqual:[NSNull null]] && ![responseBody[@"data"][@"updata"] isEqual:@0]) {
                for (int i = 0; i<_imageArr.count; i++) {
                    NSString * url = [NSString stringWithFormat:@"%@",[_imageArr[i] objectForKey:@"img"]];
                    [imageurl addObject:url];
                }
                weakSelf.myScrollview.imageURLStringsGroup = imageurl;
            } else {
                
            }
            weakSelf.myScrollview.imageURLStringsGroup = imageurl;
            
        }else
        {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:@"网络连接异常" complete:nil];
    }];
    self.myScrollview.pageDotColor = COLOR_MainColor;
    return self.myScrollview;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}


@end
