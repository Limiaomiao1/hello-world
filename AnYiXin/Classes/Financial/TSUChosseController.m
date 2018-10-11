//
//  TSUChosseController.m
//  Shangdai
//
//  Created by tuanshang on 17/4/25.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSUChosseController.h"
#import "GSFilterView.h"

@interface TSUChosseController ()<DKFilterViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) GSFilterView *filterView;
@property (nonatomic,strong) DKFilterModel *clickModel;

@end

@implementation TSUChosseController
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.filterView.tableView reloadData];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // 备用
    [self setupSubViews];
}

//=================================================================
//                              初始化
//=================================================================
#pragma mark - 初始化
- (void)setupSubViews {
    
    self.title =@"项目筛选";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    NSArray *filterData =  @[@"3%",@"4%",@"5%",@"6%",@"7%",@"8%",@"9%",@"10%",@"11%",@"12%",@"12%以上"];
    DKFilterModel *Model1 = [[DKFilterModel alloc] initElement:filterData ofType:DK_SELECTION_SINGLE];
    Model1.title = @"标的利率";
    Model1.style = DKFilterViewDefault;
    
    filterData = @[@"天标",@"1个月",@"2个月",@"3个月",@"4个月",@"5个月",@"6个月",@"7个月",@"8个月",@"9个月",@"10个月",@"11个月",@"12个月"];
    DKFilterModel *Model2 = [[DKFilterModel alloc] initElement:filterData ofType:DK_SELECTION_SINGLE];
    Model2.title = @"标的期限";
    Model2.style = DKFilterViewDefault;
    
    filterData = @[@"100",@"200",@"300",@"400",@"500",@"600",@"700",@"800",@"900",@"1000",@"1000以上"];
    DKFilterModel *Model3 = [[DKFilterModel alloc] initElement:filterData ofType:DK_SELECTION_SINGLE];
    Model3.title = @"最小投资金额";
    Model3.style = DKFilterViewDefault;
    
    
    self.filterView = [[GSFilterView alloc] initWithFrame:self.view.frame];
    self.filterView.delegate = self;
    [self.filterView setFilterModels:@[Model1,Model2,Model3]];
    [self.view addSubview:self.filterView];
    
    
    UIButton *filterButton = [[UIButton alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT -104, SCREEN_WIDTH, 50)];
    filterButton.backgroundColor = COLOR_MainColor;
    [filterButton setTitle:@"点击查看选中的内容" forState:UIControlStateNormal];
    [filterButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [filterButton addTarget:self action:@selector(filter:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:filterButton];
}

//=================================================================
//                           事件处理
//=================================================================
#pragma mark - 事件处理

- (void)didClickAtModel:(DKFilterModel *)data{
    
    if (data == _clickModel) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"点击的内容" message:data.clickedButtonText delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)filter:(id)sender {
    //    NSString *result = @"";
    //    for (DKFilterModel *model in self.filterView.filterModels) {
    //        if(model == self.clickModel){
    //            continue;
    //        }
    //        result = [result stringByAppendingFormat:@"所属标题:%@\n",model.title];
    //        NSArray *array = [model getFilterResult];
    //        for (NSString *str in array) {
    //            result = [result stringByAppendingFormat:@"[%@]",str];
    //        }
    //        result = [result stringByAppendingString:@"\n"];
    //    }
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"选择的结果" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alert show];
    NSString *result1 = @"";
    NSString *result2 = @"";
    NSString *result3 = @"";
    
    for (int i = 0; i< self.filterView.filterModels.count; i++) {
        DKFilterModel *model = self.filterView.filterModels[i];
        NSArray *array = [model getFilterResult];
        
        if (i == 0) {
            for (NSString *str in array) {
                result1 = str;
            }
        } else if(i==1){
            for (NSString *str in array) {
                result2 = str;
            }
        } else if(i==2){
            for (NSString *str in array) {
                result3 = str;
            }
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(getChooseResultDelegateWith:with:with:)]) {
        [self.delegate getChooseResultDelegateWith:result1 with:result2 with:result3];
    }
    
    if (result1.length == 0) {
        [DZStatusHud showToastWithTitle:@"请选择标的类型" complete:nil];
    } else if (result2.length == 0){
        [DZStatusHud showToastWithTitle:@"请选择标的状态" complete:nil];
    } else if (result3.length == 0) {
        [DZStatusHud showToastWithTitle:@"请选择借款期限" complete:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
