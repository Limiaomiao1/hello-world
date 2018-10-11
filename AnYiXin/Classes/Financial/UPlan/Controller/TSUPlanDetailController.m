//
//  TSUPlanDetailController.m
//  Shangdai
//
//  Created by tuanshang on 17/3/1.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSUPlanDetailController.h"
#import "TSProDetailController.h"
#import "TSInvestListController.h"
#import "TSTransferDetailModel.h"
#import "TSSetPinController.h"
#import "TSBorrowDetailModel.h"
#import "JFDropdownMenu.h"
#import "SecondPageTopBar.h"
#import "LoadMoreView.h"
#import "ZYRadioButton.h"
#import "NSString+Extensions.h"
#import "TSUredpackController.h"
#import "TSUredpackModel.h"
#import "TSRepayplanController.h"
#import "UIDevice+SLExtension.h"
#import "TSJiaxiModel.h"
#import "TSUserJiaxiController.h"
#import "TSDescribeController.h"
#import "TSAddMoneyController.h"
#import "TSAddMoneyNewController.h"
#define contenSize 667  //两个scrollView的contentSize大小
#define dragStrength 30.0 //拖拽强度

static CGFloat startImageViewH = 180;

@interface TSUPlanDetailController () <SecondPageTopBarDelegate, UIScrollViewDelegate, UITextFieldDelegate, RadioButtonDelegate>
{
    NSMutableArray * _dataSource;
    UIImageView * _userImage; //
    UILabel * _explainlabel; // 投资说明
    UILabel * _all_moneylabel;
    /** 项目名称 */
    UILabel * _nameLabel;
    /** 项目期限 */
    UILabel * _balance_money;
    /** 筹资天数 */
    UILabel * _collect_interestlabel;
    /** 已投金额 */
    UILabel * _freeze_moneylabel;
    UILabel * _fabuTimeLabel;
    UILabel * _zongFenNumLabel;
}

@property(nonatomic,strong)UIScrollView * mainScrollView;
@property(nonatomic,strong)UIScrollView * secScrollView;
@property(nonatomic,strong)SecondPageTopBar * topBar;
@property(nonatomic,strong)UIView * NavBarView;
@property(nonatomic,strong)UILabel * secPageHeaderLabel;
@property(nonatomic,strong)UILabel * dingPinLabel;
/** 红包left */
@property (nonatomic, strong) UILabel *redLabel;
@property(nonatomic,strong)UITextField * dingPinTF;
@property(nonatomic,strong)UITextField * moneyTF;
@property(nonatomic,strong)UITextField * pinTF;

@property (nonatomic, strong) JFDropdownMenu * tsmenu;

@property(nonatomic,strong)TSTransferDetailModel *transDetailModel;

@property (nonatomic , copy) NSString * dingPin;
@property (nonatomic , copy) NSString * num;
@property (nonatomic , copy) NSString * pin;
/** 红包 */
@property (nonatomic, copy) NSString *redID;
@property (nonatomic , copy) NSString *redname;
@property (nonatomic , copy) NSString *redmoney;

@property (nonatomic , copy) NSString *jiaxiID;
@property (nonatomic , copy) NSString * chooseway;

/** 特权金 */
@property (nonatomic, strong) NSMutableArray *redArr;
/** 加息 */
@property (nonatomic, strong) NSMutableArray *jiaxiArr;
/** 选择红包按钮 */
@property (nonatomic, strong) UIButton *chooseRed;
/** 选择加息按钮 */
@property (nonatomic, weak) UIButton *chooseJiaxi;
/** 投资按钮 */
@property (nonatomic, strong) UIButton *payButton;
@end

@implementation TSUPlanDetailController

- (NSMutableArray *)redArr
{
    if(!_redArr) {
        _redArr = [[NSMutableArray alloc] init];
    }
    return _redArr;
}



/**
 *  第二屏顶部的三个模块
 *
 *  @return 懒加载
 */
-(SecondPageTopBar*)topBar{
    if (_topBar==nil) {
        _topBar=[[SecondPageTopBar alloc]initWithArray:@[@"产品信息",@"投资记录"]];
        _topBar.frame=CGRectMake(0, NaviBarH, TSScreenW, TopTabBarH);
        _topBar.delegate=self;
        [self.view addSubview:_topBar];
    }
    return _topBar;
}

-(UILabel*)secPageHeaderLabel{
    if (_secPageHeaderLabel==nil) {
        _secPageHeaderLabel=[[UILabel alloc]init];
        _secPageHeaderLabel.frame=CGRectMake(0, NaviBarH+TopTabBarH+8, TSScreenW, 21);
        _secPageHeaderLabel.textColor=[UIColor blackColor];
        _secPageHeaderLabel.font=[UIFont systemFontOfSize:12];
        _secPageHeaderLabel.alpha=0;
        _secPageHeaderLabel.textAlignment=NSTextAlignmentCenter;
    }
    return _secPageHeaderLabel;
}
-(UIScrollView*)mainScrollView{
    if (_mainScrollView == nil){
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.delegate = self;
        _mainScrollView.frame = CGRectMake(0.0, navigationHeight, TSScreenW, TSScreenH - navigationHeight);
        _mainScrollView.pagingEnabled = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.tag =100;
        [self.view addSubview:_mainScrollView];
    }
    return _mainScrollView;
}
-(UIScrollView*)secScrollView{
    if (_secScrollView==nil) {
        _secScrollView=[[UIScrollView alloc]init];
        _secScrollView.frame=CGRectMake(0, TSScreenH, TSScreenW, TSScreenH-NaviBarH-TopTabBarH);
        _secScrollView.delegate=self;
        _secScrollView.pagingEnabled=YES;
        _secScrollView.alwaysBounceVertical = NO;
        //        _secScrollView.showsVerticalScrollIndicator=NO;
        _secScrollView.tag=200;
        _secScrollView.directionalLockEnabled = YES;
        self.secScrollView.contentSize=CGSizeMake(TSScreenW*3, TSScreenH);
        [self.view addSubview:_secScrollView];
    }
    return _secScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"项目详情";
    //    self.pickerView = [[ValuePickerView alloc]init];
    TSLog(@"%f", TSScreenH);

    [self loadInfoData];
    [self setFirstPageView];
    //    [self addNavBarView];
    [self setupAllChildVCs];
    [self scrollViewDidEndScrollingAnimation:self.secScrollView];
    
}

- (void)setupAllChildVCs {
    
    TSProDetailController * prodetailVC = [[TSProDetailController alloc] init];
    prodetailVC.ID = self.ID;
    [self addChildViewController:prodetailVC];
    TSInvestListController * inverVC = [[TSInvestListController alloc] init];
    inverVC.ID = self.ID;
    [self addChildViewController:inverVC];
    
    
}

#pragma mark - 详情数据请求

- (void)loadInfoData {
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"id":@(self.ID)} url:@"transfer_detail" successBlock:^(id responseBody) {
        TSTransferDetailModel * trmodel = [TSTransferDetailModel mj_objectWithKeyValues:responseBody[@"data"]];
        
        weakSelf.transDetailModel = trmodel;
        [weakSelf viewWillLayoutSubviews];
    } failureBlock:^(NSString *error) {
        
    }];
}


#pragma mark - 设置申购初始页

- (void)setFirstPageView{
    
    self.mainScrollView.contentSize=CGSizeMake(21, contenSize);
    
    UIView * bigback = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TSScreenW, startImageViewH)];
    [self.mainScrollView addSubview:bigback];
    
    UIImageView * imagview = [[UIImageView alloc]initWithFrame:bigback.frame];
    imagview.image = [UIImage imageNamed:@"beijign"];
    [bigback addSubview:imagview];
    
    UILabel *nameLabel = [[UILabel alloc]init];
    nameLabel.text = @"项目名称";
    nameLabel.font = FONT(10);
    [bigback addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:10];
    [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:24];
    
    /** 筹资天数 */
    UIView * view1 = [[UIView alloc]init];
    [bigback addSubview:view1];
    UILabel * label1 = [[UILabel alloc]init];
    label1.text = @"起投金额";
    [label1 setFont:[UIFont systemFontOfSize:13]];
    [view1 addSubview:label1];
    UILabel * label11 = [[UILabel alloc]init];
    label11.text = @"";
    [label11 setFont:[UIFont systemFontOfSize:13]];
    _collect_interestlabel = label11;
    [view1 addSubview:_collect_interestlabel];
    
    UIView * lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor =  [UIColor colorWithWhite:0.800 alpha:1.000];
    [bigback addSubview:lineView1];
    
    /** 项目期限 */
    UIView * view2 = [[UIView alloc]init];
    [bigback addSubview:view2];
    UILabel * label2 = [[UILabel alloc]init];
    label2.text = @"项目期限";
    [label2 setFont:[UIFont systemFontOfSize:13]];
    [view2 addSubview:label2];
    UILabel * label22 = [[UILabel alloc]init];
    label22.text = @"期限";
    [label22 setFont:[UIFont systemFontOfSize:13]];
    _balance_money = label22;
    [view2 addSubview:_balance_money];
    
    UIView * lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [UIColor colorWithWhite:0.800 alpha:1.000];
    [bigback addSubview:lineView2];
    
    /** 已投金额 */
    UIView * view3 = [[UIView alloc]init];
    [bigback addSubview:view3];
    UILabel * label3 = [[UILabel alloc]init];
    label3.text = @"可投份数";
    [label3 setFont:[UIFont systemFontOfSize:13]];
    [view3 addSubview:label3];
    UILabel * label33 = [[UILabel alloc]init];
    label33.text = @"无";
    [label33 setFont:[UIFont systemFontOfSize:13]];
    _freeze_moneylabel = label33;
    [view3 addSubview:_freeze_moneylabel];
    
    /** 年化利率 */
    UILabel * alllabel = [[UILabel alloc]init];
    alllabel.text= @"年化利率	";
    [bigback addSubview:alllabel];
    
    UILabel * alllabel1 = [[UILabel alloc]init];
    alllabel1.text = @"8.00%";
    alllabel1.textColor = [UIColor redColor];
    [alllabel1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    _all_moneylabel = alllabel1;
    [bigback addSubview:_all_moneylabel];
    
    
    [alllabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:view2 withOffset:-65];
    [alllabel autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    
    [alllabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:alllabel withOffset:10];
    [alllabel1 autoAlignAxis:ALAxisVertical toSameAxisOfView:alllabel];
    
    [view1 autoSetDimensionsToSize:CGSizeMake(TSScreenW/3-2, 60)];
    [view1 autoPinEdgeToSuperviewEdge:ALEdgeLeading];
    [view1 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [label1 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [label2 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label2 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    [label3 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label3 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:5];
    
    [label11 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label11 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [label22 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label22 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [label33 autoAlignAxisToSuperviewMarginAxis:ALAxisVertical];
    [label33 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    
    [lineView1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:view1];
    [lineView1 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [lineView1 autoSetDimensionsToSize:CGSizeMake(1, 40)];
    
    [view2 autoSetDimensionsToSize:CGSizeMake(TSScreenW/3, 60)];
    [view2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:lineView1];
    [view2 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    [lineView2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:view2];
    [lineView2 autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:10];
    [lineView2 autoSetDimensionsToSize:CGSizeMake(1, 40)];
    
    [view3 autoSetDimensionsToSize:CGSizeMake(TSScreenW/3, 60)];
    [view3 autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
    [view3 autoPinEdgeToSuperviewEdge:ALEdgeBottom];
    
    UIView * backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, startImageViewH, TSScreenW, contenSize- startImageViewH)];
    [self.mainScrollView addSubview:backView2];
    
    
    UIView * grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [backView2 addSubview:grayView];
    
    [grayView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [grayView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [grayView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [grayView autoSetDimension:(ALDimensionHeight) toSize:10];
    
    UILabel *userMoneyLeft = [[UILabel alloc]init];
    userMoneyLeft.font = FONT(12);
    userMoneyLeft.text = @"可用资金:";
    userMoneyLeft.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    [backView2 addSubview:userMoneyLeft];
    [userMoneyLeft autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:grayView withOffset:18];
    [userMoneyLeft autoSetDimension:(ALDimensionWidth) toSize:60];
    [userMoneyLeft autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    
    UILabel * label = [[UILabel alloc]init];
    label.layer.masksToBounds = YES;
    label.font = FONT(12);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = COLOR_MainColor;
    NSString * moneyStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"balance_money"];
    label.text= [NSString stringWithFormat:@"%.2f(元)  ", moneyStr.doubleValue];
    [backView2 addSubview:label];
    
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:grayView withOffset:18];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:userMoneyLeft];
    [label autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:userMoneyLeft];
    
    UILabel *fabuTimeLeft = [[UILabel alloc]init];
    fabuTimeLeft.font = FONT(12);
    fabuTimeLeft.text = @"发布时间:";
    fabuTimeLeft.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    [backView2 addSubview:fabuTimeLeft];
    [fabuTimeLeft autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:userMoneyLeft withOffset:18];
    [fabuTimeLeft autoSetDimension:(ALDimensionWidth) toSize:60];
    [fabuTimeLeft autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    
    UILabel * fabuTimelabel = [[UILabel alloc]init];
    fabuTimelabel.layer.masksToBounds = YES;
    fabuTimelabel.font = FONT(12);
    fabuTimelabel.textAlignment = NSTextAlignmentLeft;
    fabuTimelabel.textColor = [UIColor blackColor];
    [backView2 addSubview:fabuTimelabel];
    _fabuTimeLabel = fabuTimelabel;
    [fabuTimelabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:userMoneyLeft withOffset:18];
    [fabuTimelabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:fabuTimeLeft];
    [fabuTimelabel autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:fabuTimeLeft];
    
    UILabel *zongFenNumLeft = [[UILabel alloc]init];
    zongFenNumLeft.font = FONT(12);
    zongFenNumLeft.text = @"总份数:";
    zongFenNumLeft.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    [backView2 addSubview:zongFenNumLeft];
    [zongFenNumLeft autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:fabuTimeLeft withOffset:18];
    [zongFenNumLeft autoSetDimension:(ALDimensionWidth) toSize:60];
    [zongFenNumLeft autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    
    UILabel * zongFenNumRight = [[UILabel alloc]init];
    zongFenNumRight.layer.masksToBounds = YES;
    zongFenNumRight.font = FONT(12);
    zongFenNumRight.textAlignment = NSTextAlignmentLeft;
    zongFenNumRight.textColor = [UIColor blackColor];
    [backView2 addSubview:zongFenNumRight];
    _zongFenNumLabel = zongFenNumRight;
    [zongFenNumRight autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:fabuTimeLeft withOffset:18];
    [zongFenNumRight autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:zongFenNumLeft];
    [zongFenNumRight autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:zongFenNumLeft];
    
//    UIButton *addMoneyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [addMoneyButton setTitle:@"充值" forState:(UIControlStateNormal)];
//    addMoneyButton.titleLabel.font = FONT(11);
//    [addMoneyButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [backView2 addSubview:addMoneyButton];
//    [addMoneyButton addTarget:self action:@selector(didAddMoneyAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [addMoneyButton autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:label];
//    [addMoneyButton autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:label];
//    [addMoneyButton autoSetDimension:(ALDimensionWidth) toSize:80];
//    [addMoneyButton autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:userMoneyLeft];
    
    
    
    UIView * grayView1 = [[UIView alloc] init];
    grayView1.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [backView2 addSubview:grayView1];
    
    [grayView1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:zongFenNumLeft withOffset:10];
    [grayView1 autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [grayView1 autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [grayView1 autoSetDimension:(ALDimensionHeight) toSize:10];

    
    UILabel *paylabel = [[UILabel alloc]init];
    paylabel.font = [UIFont systemFontOfSize:14];
    paylabel.text = @"投资份数:";
    [backView2 addSubview:paylabel];
    
    UILabel *pinlabel = [[UILabel alloc]init];
    pinlabel.font = [UIFont systemFontOfSize:14];
    pinlabel.text = @"支付密码:";
    [backView2 addSubview:pinlabel];

    
    UITextField * numberTF = [[UITextField alloc]init];
    numberTF.placeholder = @"请输入投资份数";
    numberTF.keyboardType = UIKeyboardTypeNumberPad;
    numberTF.font = [UIFont systemFontOfSize:13];
    numberTF.tag = 121;
    numberTF.delegate = self;
    [backView2 addSubview:numberTF];
    self.moneyTF = numberTF;
    
    
    UITextField * pinTF = [[UITextField alloc]init];
    pinTF.placeholder = @"请输入支付密码";
    pinTF.font = [UIFont systemFontOfSize:13];
    pinTF.secureTextEntry = YES;
    pinTF.delegate = self;
    pinTF.tag = 122;
    [backView2 addSubview:pinTF];
    self.pinTF = pinTF;
    


    [paylabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [paylabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:grayView1 withOffset:30];
    
    [pinlabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [pinlabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:paylabel withOffset:20];
    
    [numberTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:paylabel withOffset:5];
    [numberTF autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:grayView1 withOffset:30];
    
    [pinTF autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:pinlabel withOffset:5];
    [pinTF autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:numberTF withOffset:20];
    
    [@[numberTF, pinTF] autoSetViewsDimension:ALDimensionWidth toSize:TSScreenW/2];
    
    UILabel *radioLabel = [[UILabel alloc]init];
    radioLabel.font = [UIFont systemFontOfSize:14];
    radioLabel.text = @"还款方式:";
    [backView2 addSubview:radioLabel];
    [radioLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [radioLabel autoPinEdge:ALEdgeTop  toEdge:ALEdgeBottom ofView:pinlabel withOffset:20];
     //初始化单选按钮控件
     ZYRadioButton *rb1 = [[ZYRadioButton alloc] initWithGroupId:@"first group" index:0];
     ZYRadioButton *rb2 = [[ZYRadioButton alloc] initWithGroupId:@"first group" index:1];
     
     
     //添加到视图容器
     [backView2 addSubview:rb1];
     [backView2 addSubview:rb2];
     
     
     //初始化第一个单选按钮的UILabel
     UILabel *radiolabel1 =[[UILabel alloc] init];
     radiolabel1.backgroundColor = [UIColor clearColor];
     radiolabel1.font = [UIFont systemFontOfSize:14];
     
     radiolabel1.text = @"按月还息";
     [backView2 addSubview:radiolabel1];
     
     UILabel *radiolabel2 =[[UILabel alloc] init];
     radiolabel2.backgroundColor = [UIColor clearColor];
     radiolabel2.font = [UIFont systemFontOfSize:14];
     
     radiolabel2.text = @"利息复投";
     [backView2 addSubview:radiolabel2];
     
     //设置Frame
     
     [rb1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:radioLabel withOffset:20];
     [rb1 autoSetDimensionsToSize:CGSizeMake(13, 13)];
     [rb1 autoPinEdge:ALEdgeTop  toEdge:ALEdgeBottom ofView:pinlabel withOffset:20];
     
     [radiolabel1 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:rb1];
     [radiolabel1 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:rb1];
     [radiolabel1 autoSetDimensionsToSize:CGSizeMake(100, 13)];
     
     [rb2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:radiolabel1];
     [rb2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:rb1];
     [rb2 autoSetDimensionsToSize:CGSizeMake(13, 13)];
     
     [radiolabel2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:rb2];
     [radiolabel2 autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:rb1];
     [radiolabel2 autoSetDimensionsToSize:CGSizeMake(100, 13)];
     //按照GroupId添加观察者
     [ZYRadioButton addObserverForGroupId:@"first group" observer:self];
    
    
    UILabel * explainlabel = [[UILabel alloc] init];
    explainlabel.textColor = [UIColor colorWithWhite:0.702 alpha:1.000];
    explainlabel.font = FONT(12);
    explainlabel.textAlignment = NSTextAlignmentCenter;
    [backView2 addSubview:explainlabel];
    _explainlabel = explainlabel;

    [explainlabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [explainlabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [explainlabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:radioLabel withOffset:30];
    
    /** 申购按钮 */
    UIButton * pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pinButton setTitle:@"立即加入" forState:UIControlStateNormal];
    [pinButton setBackgroundColor:COLOR_MainColor];
    [pinButton addTarget:self action:@selector(didGoPayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView2 addSubview:pinButton];
    self.payButton = pinButton;
    [pinButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:100];
    [pinButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [pinButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [pinButton autoSetDimension:ALDimensionHeight toSize:40];
    pinButton.layer.cornerRadius = 20;
    pinButton.layer.masksToBounds = YES;
    
    /** 提示滑动加载语 */
    UILabel * loadActionLabel = [[UILabel alloc] init];
    loadActionLabel.text = @"继续滑动，加载详情哦";
    loadActionLabel.font = [UIFont systemFontOfSize:11];
    loadActionLabel.textAlignment = NSTextAlignmentCenter;
    [backView2 addSubview:loadActionLabel];
    [loadActionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [loadActionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [loadActionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:pinButton withOffset:12];
    
    
    //加载更多
    UIView * loadMoreView=[LoadMoreView view];
    loadMoreView.frame=CGRectMake(0, contenSize - navigationHeight, TSScreenW, BottomH);
    [self.mainScrollView addSubview:loadMoreView];
}

#pragma mark - 输入框赋值



- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField.tag == 121) {
        self.num = textField.text;
    }else if (textField.tag == 122) {
        self.pin = textField.text;
    }else if (textField.tag == 120) {
        self.dingPin = textField.text;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField.tag == 121) {
        self.num =  [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串;
        self.redID = nil;
        [self.chooseRed setTitle:@"选择特权金" forState:(UIControlStateNormal)];
        
        
    }
    return YES;
}

/**
 添加导航栏背后的View
 */
-(void)addNavBarView{
    UIView* view = [[UIView alloc] init];
    self.NavBarView = view;
    view.backgroundColor = COLOR_MainColor;
    view.frame = CGRectMake(0, 0, TSScreenW, NaviBarH);
    [self.view addSubview:view];
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, NaviBarH-0.5, TSScreenW, 0.5)];
    lineView.backgroundColor= COLOR_MainColor;
    [self.NavBarView addSubview:lineView];
    
    UIButton * backBtn=[[UIButton alloc]initWithFrame:CGRectMake(10, 32, 25, 25)];
    [backBtn setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(navBarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    backBtn.layer.cornerRadius=25/2;
    backBtn.backgroundColor=[UIColor whiteColor];
    [self.NavBarView addSubview:backBtn];
    backBtn.tag=1;
    
}

#pragma mark - 初始化数据

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _nameLabel.text = [NSString stringWithFormat:@"%@", self.transDetailModel.borrow_name];
    /** 年化利率 */
    _all_moneylabel.text = [NSString stringWithFormat:@"%.2f%%", self.transDetailModel.borrow_interest_rate.doubleValue];
    /** 已筹金额 */
    _freeze_moneylabel.text = [NSString stringWithFormat:@"%d", self.transDetailModel.transfer_total.intValue - self.transDetailModel.transfer_out.intValue];
    /** 筹资期限 */
    _balance_money.text = [NSString stringWithFormat:@"%@", self.transDetailModel.borrow_duration];
    /** 募筹天数 */
    _collect_interestlabel.text = [NSString stringWithFormat:@"%@元/份", self.transDetailModel.per_transfer];

    
    if ([self.transDetailModel.borrow_max isEqual:@0]) {
        _explainlabel.text = [NSString stringWithFormat:@"单人最小投资份数:%d份,单人最大投资份数:无限制", self.transDetailModel.borrow_min.intValue];
    } else if([self.transDetailModel.borrow_min isEqual:@0]) {
        
        _explainlabel.text = [NSString stringWithFormat:@"单人最小投资份数:无限制,单人最大投资份数%d份", self.transDetailModel.borrow_max.intValue];
    } else {
        _explainlabel.text = [NSString stringWithFormat:@"单人最小投资份数:%d份,单人最大投资份数%d份",self.transDetailModel.borrow_min.intValue, self.transDetailModel.borrow_max.intValue];
        
    }
    
    _fabuTimeLabel.text = self.transDetailModel.add_time;
    _zongFenNumLabel.text = [NSString stringWithFormat:@"%@ 份", self.transDetailModel.transfer_total];

        
    if (self.transDetailModel.immediately == 1) {
        [self.payButton setTitle:@"即将上线" forState:UIControlStateNormal];
        self.payButton.alpha = 0.5;
        self.payButton.enabled = NO;
    } else {
        
        if ([self.transDetailModel.borrow_status isEqual:@2]) {
            if ([self.transDetailModel.progress isEqual:@100]) {
                [self.payButton setTitle:@"还款中" forState:UIControlStateNormal];
                self.payButton.alpha = 0.5;
                self.payButton.enabled = NO;
            } else {
                [self.payButton setTitle:@"立即加入" forState:UIControlStateNormal];
                self.payButton.alpha = 1;
                self.payButton.enabled = YES;       \
            }

        } else {
            [self.payButton setTitle:@"已完成" forState:UIControlStateNormal];
            self.payButton.alpha = 0.5;
            self.payButton.enabled = NO;
        }
    }

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (void)navBarBtnAction:(UIButton *)button {
    
    if (button.tag==1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark--UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.tag == 100){
        if(scrollView.contentOffset.y<0){
            scrollView.contentOffset = CGPointMake(0, 0);//限制不能下拉
        }
        if(scrollView.contentOffset.y>=0){
            //上拖的时候改变导航栏背部的颜色
            CGFloat  fir_maxContentOffSet_Y=self.mainScrollView.contentSize.height-self.mainScrollView.frame.size.height;
            CGFloat  scal=scrollView.contentOffset.y/fir_maxContentOffSet_Y;
            self.NavBarView.backgroundColor= RGBA(80, 178, 229, scal);
        }
    }
    if (scrollView.tag==200) {
        //在0-60之间 懒加载子控件，并且随拖动的幅度改变子控件的标题和alpha
        CGFloat  mininumContenOffSet_Y=0;
        CGFloat  maxContentOffSet_Y=-dragStrength;
        self.secPageHeaderLabel.alpha=scrollView.contentOffset.y/maxContentOffSet_Y;
        if (scrollView.contentOffset.y>maxContentOffSet_Y&&scrollView.contentOffset.y<mininumContenOffSet_Y) {
            self.secPageHeaderLabel.text=@"下拉，回到产品详情";
            [self.view addSubview:self.secPageHeaderLabel];
        }
        if(scrollView.contentOffset.y<maxContentOffSet_Y){
            self.secPageHeaderLabel.text=@"释放，回到产品详情";
        }
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag==100) {
        CGFloat mininumContentset_Y=self.mainScrollView.contentSize.height-TSScreenH+BottomH +dragStrength;
        if(scrollView.contentOffset.y>mininumContentset_Y){
            //此时第一屏滑到底部 可调滑动手势强度
            //            [self setSecondPageView];
            self.topBar.hidden=NO;
            //            [self.view bringSubviewToFront:self.botomView];
            //            self.backToTopBtn.hidden=NO;
            //            [self.view addSubview:self.backToTopBtn];
            //然后懒加载第二屏
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.topBar.frame=CGRectMake(0, NaviBarH, TSScreenW, TopTabBarH);
                self.secScrollView.frame=CGRectMake(0, NaviBarH+TopTabBarH, TSScreenW, TSScreenH-NaviBarH-TopTabBarH);
                self.mainScrollView.frame=CGRectMake(0, NaviBarH-contenSize, TSScreenW, TSScreenH -navigationHeight);
            } completion:^(BOOL finished) {
            }];
        }
    }
    if (scrollView.tag==200) {
        CGFloat  maxContentOffSet_Y=-dragStrength;
        if (scrollView.contentOffset.y<maxContentOffSet_Y) {
            
            //            self.backToTopBtn.hidden=YES;
            //            [self.view bringSubviewToFront:self.botomView];
            [self scrollViewDidEndScrollingAnimation:scrollView];
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.secPageHeaderLabel.alpha=0;
                self.topBar.frame=CGRectMake(0, TSScreenH, TSScreenW, TopTabBarH);
                self.secScrollView.frame=CGRectMake(0, TSScreenH+TopTabBarH, TSScreenW, TSScreenH-NaviBarH-TopTabBarH);
                self.mainScrollView.frame=CGRectMake(0, NaviBarH, TSScreenW, TSScreenH);
            } completion:^(BOOL finished) {
                self.topBar.hidden=YES;
            }];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (scrollView.tag == 200) {
        int index = scrollView.contentOffset.x / scrollView.width;
        UIViewController *willShowChildVc = self.childViewControllers[index];
        
        // 如果这个子控制器的view已经添加过了，就直接返回
        if (willShowChildVc.isViewLoaded) return;
        
        // 添加子控制器的view
        willShowChildVc.view.frame = scrollView.bounds;
        [scrollView addSubview:willShowChildVc.view];
    }
}

/**
 *  滚动完毕就会调用（如果是人为拖拽scrollView导致滚动完毕，才会调用这个方法）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView.tag == 200) {
        // 添加子控制器的view
        [self scrollViewDidEndScrollingAnimation:scrollView];
        int index = scrollView.contentOffset.x / scrollView.width;
        
        [self.topBar TabBarSelectedSegment:index];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//  单选按钮代理方法
-(void)radioButtonSelectedAtIndex:(NSUInteger)index inGroup:(NSString *)groupId{
    
    if (index == 0) {
        self.chooseway = @"4";
    }else if (index == 1) {
        self.chooseway = @"6";
    }
    
}

#pragma mark---第二页顶部按钮
-(void)tabBar:(SecondPageTopBar *)tabBar didSelectIndex:(NSInteger)index;{
    
    // 让scrollView滚动到对应的位置(不要去修改contentOffset的y值)
    CGPoint offset = _secScrollView.contentOffset;
    offset.x = index * _secScrollView.width;
    [_secScrollView setContentOffset:offset animated:YES];
}

#pragma mark - 点击充值
- (void)didAddMoneyAction:(UIButton *)button {
    TSAddMoneyNewController *addVC = [[TSAddMoneyNewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

#pragma mark - 投资事件
- (void)didGoPayButtonAction:(UIButton *)button {
    
    
    button.userInteractionEnabled = NO;
    
    [self.view endEditing:YES];
    if (self.num.length == 0) {
        [DZStatusHud showToastWithTitle:@"输入购买金额" complete:nil];
        button.userInteractionEnabled = YES;
    } else if (self.pin.length < 6) {
        button.userInteractionEnabled = YES;
        [DZStatusHud showToastWithTitle:@"请输入不少于6位交易密码" complete:nil];
    } else if (self.chooseway.length == 0){
        button.userInteractionEnabled = YES;
        [DZStatusHud showToastWithTitle:@"请选择投资方式" complete:nil];
    } else {
        NSMutableDictionary * params = [[NSMutableDictionary alloc]init];
        params[@"borrow_id"] = @(self.ID);
        params[@"chooseWay"] = self.chooseway;
        params[@"num"] = self.num;
        params[@"pin"] = self.pin.MD5String;
        params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
        [[TSNetwork shareNetwork] postRequestResult:params url:@"transfer_invest_money" successBlock:^(id responseBody) {
            
            NSString * event = [NSString stringWithFormat:@"%@", responseBody[@"event"]];
            if ([event isEqualToString:@"88"]) {
                [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:^{
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                
            } else {
                if ([responseBody[@"msg"] isEqualToString:@"投标密码不正确"]) {
                    [DZStatusHud showToastWithTitle:@"定向标密码不正确" complete:^{
                        
                    }];
                }else {
                    [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
                }
                self.moneyTF.text = @"";
                self.pinTF.text = @"";
                self.dingPinTF.text = @"";
                self.num = @"";
                self.pin = @"";
                self.redID = @"";
                self.dingPin = @"";
                
            }
            button.userInteractionEnabled = YES;
        } failureBlock:^(NSString *error) {
            [DZStatusHud showToastWithTitle:error complete:nil];
            button.userInteractionEnabled = YES;
        }];
    }
   
}




@end
