//
//  TSBorDetailAllController.m
//  TuanShang
//
//  Created by tuanshang on 16/9/12.
//  Copyright © 2016年 tuanshang. All rights reserved.
//

#import "TSBorDetailAllController.h"
#import "TSBorrowDetailController.h"
#import "TSBorrowListController.h"
#import "TSSetPinController.h"
#import "TSBorrowDetailModel.h"
#import "JFDropdownMenu.h"
#import "SecondPageTopBar.h"
#import "LoadMoreView.h"
#import "NSString+Extensions.h"
#import "TSUredpackModel.h"
#import "TSRepayplanController.h"
#import "UIDevice+SLExtension.h"
#import "TSJiaxiModel.h"
#import "TSUserJiaxiController.h"
#import "TSDescribeController.h"
#import "NSString+Extensions.h"
#import "UIView+TYAlertView.h"
#import "RedPacketModel.h"
#import "UseRedpackViewController.h"


#import "CFCASIPInputField.h"
#import "ErrorCode.h"

#import "TSBorDetailWebController.h"
#define contenSize TSScreenH //两个scrollView的contentSize大小
#define dragStrength 30.0 //拖拽强度

// 上部分视图高度
static CGFloat startImageViewH = 180;

@interface TSBorDetailAllController () <SecondPageTopBarDelegate, UIScrollViewDelegate, UITextFieldDelegate, UJiaxiDelegate,UseRedPacketDelegate,CFCASIPInputFieldDelegate>
{
    NSMutableArray * _dataSource;
    UIImageView * _userImage;
    /** 投资说明 */
    UILabel * _explainlabel;
    /** 总金额 */
    UILabel * _all_moneylabel;
    /** 预计收益 */
    UILabel * _shouyilabel;
    /** 项目名称 */
    UILabel * _nameLabel;
    /** 项目期限 */
    UILabel * _balance_money;
    /** 筹资天数 */
    UILabel * _collect_interestlabel;
    /** 已投金额 */
    UILabel * _freeze_moneylabel;
    /** 还款方式 */
    UILabel * _repaymentValue;
    //加载提示语
    UILabel * loadActionLabel;
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
@property(nonatomic,strong)CFCASIPInputField * pinTF;
@property (nonatomic, strong) JFDropdownMenu * tsmenu;
@property(nonatomic,strong)TSBorrowDetailModel *borrowDetailModel;

@property (nonatomic , copy) NSString * dingPin;
@property (nonatomic , copy) NSString * num;
@property (nonatomic , copy) NSString * pin;
/** 加息劵ID */
@property (nonatomic , copy) NSString *jiaxiID;
/** 红包ID */
@property (nonatomic , copy) NSString *hongbaoID;
/** 加息 */
@property (nonatomic, strong) NSMutableArray *jiaxiArr;
/** 红包 */
@property (nonatomic, strong) NSMutableArray *hongbaoArr;

/** 选择加息按钮 */
@property (nonatomic, weak) UIButton *chooseJiaxi;

/** 选择红包按钮 */
@property (nonatomic, weak) UIButton *chooseHongbao;
/** 投资按钮 */
@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic ,strong)NSString *pswEncode;//加密后的密码

@end

@implementation TSBorDetailAllController


/**
 *  第二屏顶部的三个模块
 *
 *  @return 懒加载
 */
-(SecondPageTopBar*)topBar{
    if (_topBar==nil) {
        _topBar=[[SecondPageTopBar alloc]initWithArray:@[@"产品信息",@"还款计划",@"投资记录"]];
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
        _mainScrollView.frame = CGRectMake(0.0, TSScreenH, TSScreenW, TSScreenH-NaviBarH-TopTabBarH);

      //  _mainScrollView.frame = CGRectMake(0.0, navigationHeight, TSScreenW, TSScreenH - navigationHeight);
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
      //  _secScrollView.frame=CGRectMake(0, TSScreenH, TSScreenW, TSScreenH-NaviBarH-TopTabBarH);
        _secScrollView.frame=CGRectMake(0, navigationHeight+TopTabBarH, TSScreenW,  TSScreenH - navigationHeight-TopTabBarH-BottomH);

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
    
    self.navigationItem.title = @"项目详情";
    self.view.backgroundColor = [UIColor whiteColor];
    self.topBar.hidden=NO;

    self.secScrollView.hidden = NO;
    [self loadInfoData];
    [self setFirstPageView];
    [self setupAllChildVCs];
    
    [self scrollViewDidEndScrollingAnimation:self.secScrollView];
    
    
    //监听当键将要退出时
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    

}
//当键退出
- (void)keyboardWillHide:(NSNotification *)notification
{
    
    NSInteger outputValueErrorCode = SIP_INPUT_FIELD_OK;
    NSInteger clientErrorCode = SIP_INPUT_FIELD_OK;
    NSString *encryptedData = nil;
    NSMutableString *message = nil;
    NSString *clientEncryptedData = nil;
    
    encryptedData = [self.pinTF getEncryptedDataWithError:&outputValueErrorCode];
    clientEncryptedData = [self.pinTF getEncryptedClientRandomWithError:&clientErrorCode];
    _pswEncode = [NSString stringWithFormat:@"%@ %@ 0",clientEncryptedData,encryptedData];
    if (outputValueErrorCode == SIP_INPUT_FIELD_OK && clientErrorCode == SIP_INPUT_FIELD_OK) {
        message = [NSMutableString stringWithFormat:@"数据加密结果：%@\n客户端随机数加密结果：%@", encryptedData, clientEncryptedData];
    } else {
        if (outputValueErrorCode != SIP_INPUT_FIELD_OK && clientErrorCode != SIP_INPUT_FIELD_OK) {
            message = [NSMutableString stringWithFormat:@"获取加密内容失败，错误码:0x%08X\n获取客户端随机数加密失败，错误码:0x%08X", (int)outputValueErrorCode, (int)clientErrorCode];
        } else if (outputValueErrorCode != SIP_INPUT_FIELD_OK && clientErrorCode == SIP_INPUT_FIELD_OK) {
            message = [NSMutableString stringWithFormat:@"获取加密内容失败，错误码:0x%08X", (int)outputValueErrorCode];
        } else if (outputValueErrorCode == SIP_INPUT_FIELD_OK && clientErrorCode != SIP_INPUT_FIELD_OK) {
            message = [NSMutableString stringWithFormat:@"获取客户端随机数加密失败，错误码:0x%08X", (int)clientErrorCode];
        }
    }
    
    NSLog(@"message === %@",message);
}


- (void)setupAllChildVCs {
    
    TSBorrowDetailController * prodetailVC = [[TSBorrowDetailController alloc] init];
    prodetailVC.ID = self.ID;
    [self addChildViewController:prodetailVC];
    
    TSRepayplanController * repaylanVC = [[TSRepayplanController alloc] init];
    repaylanVC.ID = self.ID;
    [self addChildViewController:repaylanVC];
    
    TSBorrowListController * inverVC = [[TSBorrowListController alloc] init];
    inverVC.ID = self.ID;
    [self addChildViewController:inverVC];
    
}

#pragma mark - 详情数据请求

- (void)loadInfoData {
    TSWeakSelf;
    [[TSNetwork shareNetwork] postRequestResult:@{@"id":@(self.ID)} url:@"borrow_detail" successBlock:^(id responseBody) {
        
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            TSBorrowDetailModel * trmodel = [TSBorrowDetailModel mj_objectWithKeyValues:responseBody[@"data"]];
            weakSelf.borrowDetailModel = trmodel;
            [weakSelf viewWillLayoutSubviews];
            
#pragma mark -  孟  添加 meng_key
            NSString *meng_key =  self.borrowDetailModel.meng_key;//孟添加
            self.pinTF.strServerRandom = self.borrowDetailModel.meng_random;

        }else
        {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
        [DZStatusHud showToastWithTitle:@"服务器出现错误，请重试" complete:nil];
    }];
}
//收益
- (void)shouyiData:(NSString *)money cid:(NSString *)cid rid:(NSString *)rid {
    TSWeakSelf;
    NSDictionary * params = [NSDictionary dictionary];
    params = @{@"token":[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],@"bid":@(self.ID),@"money":money,@"cid":cid,@"rid":rid};

    
    [[TSNetwork shareNetwork] postRequestResult:params url:@"calculateEarnings" successBlock:^(id responseBody) {
        
        NSString * eventStr = [NSString stringWithFormat:@"%@",responseBody[@"event"]];
        if ([eventStr isEqualToString:@"88"]) {
            _shouyilabel.text = [NSString stringWithFormat:@"预计收益:%@",responseBody[@"msg"]];
            _shouyilabel.textColor = [UIColor redColor];
            NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:_shouyilabel.text];

            [AttributedStr addAttribute:NSFontAttributeName
             
                                  value:[UIFont systemFontOfSize:11.0]
             
                                  range:NSMakeRange(0, 5)];
            
            [AttributedStr addAttribute:NSForegroundColorAttributeName
             
                                  value:[UIColor colorWithWhite:0.702 alpha:1.000]
             
                                  range:NSMakeRange(0, 5)];
            
            _shouyilabel.attributedText = AttributedStr;
        }else
        {
            [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];
        }
    } failureBlock:^(NSString *error) {
       // [DZStatusHud showToastWithTitle:@"服务器出现错误，请重试" complete:nil];
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
    label1.text = @"募集天数";
    [label1 setFont:[UIFont systemFontOfSize:13]];
    [view1 addSubview:label1];
    UILabel * label11 = [[UILabel alloc]init];
    label11.text = @"天数";
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
    
    /** 可投金额 */
    UIView * view3 = [[UIView alloc]init];
    [bigback addSubview:view3];
    UILabel * label3 = [[UILabel alloc]init];
    label3.text = @"可投金额";
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
    
    UIView * backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, startImageViewH, TSScreenW, contenSize - startImageViewH )];
    [self.mainScrollView addSubview:backView2];
    
    UIView * grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    [backView2 addSubview:grayView];
    
    [grayView autoPinEdgeToSuperviewEdge:ALEdgeTop];
    [grayView autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    [grayView autoPinEdgeToSuperviewEdge:ALEdgeRight];
    [grayView autoSetDimension:(ALDimensionHeight) toSize:10];
    
    UILabel *repaymentLabel = [[UILabel alloc]init];
    repaymentLabel.font = FONT(11);
    repaymentLabel.text = @"还款方式:";
    repaymentLabel.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    [backView2 addSubview:repaymentLabel];
    [repaymentLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:grayView withOffset:10];
    [repaymentLabel autoSetDimension:(ALDimensionWidth) toSize:60];
    [repaymentLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    
    
    UILabel * repaymentValue = [[UILabel alloc]init];
    repaymentValue.font = FONT(11);
    repaymentValue.textAlignment = NSTextAlignmentLeft;
    repaymentValue.textColor = COLOR_MainColor;
    [backView2 addSubview:repaymentValue];
    _repaymentValue = repaymentValue;
    [repaymentValue autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:grayView withOffset:10];
    [repaymentValue autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:repaymentLabel];
    [repaymentValue autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:repaymentLabel];
    
    UILabel *userMoneyLeft = [[UILabel alloc]init];
    userMoneyLeft.font = FONT(11);
    userMoneyLeft.text = @"可用资金:";
    userMoneyLeft.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    [backView2 addSubview:userMoneyLeft];
    
    [userMoneyLeft autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:repaymentLabel withOffset:10];
    [userMoneyLeft autoSetDimension:(ALDimensionWidth) toSize:60];
    [userMoneyLeft autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    
    UILabel * label = [[UILabel alloc]init];
    label.layer.masksToBounds = YES;
    label.font = FONT(11);
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = COLOR_MainColor;
    NSString * moneyStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"balance_money"];
    label.text= [NSString stringWithFormat:@"%.2f(元)  ", moneyStr.doubleValue];
    [backView2 addSubview:label];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:repaymentLabel withOffset:10];
    [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:userMoneyLeft];
    [label autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:userMoneyLeft];
    
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
    
    UIView * line1 = [[UIView alloc] init];
    line1.backgroundColor = COLOR_Text_GrayColor;
    [backView2 addSubview:line1];
    
    [line1 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label];
    [line1 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [line1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [line1 autoSetDimension:ALDimensionHeight toSize:0.5];
    
    UILabel *paylabel = [[UILabel alloc]init];
    paylabel.font = FONT(13);
    paylabel.text = @"购买金额(元)";
    paylabel.textColor = [UIColor orangeColor];
    [backView2 addSubview:paylabel];
    
    [paylabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [paylabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:25];
    
    UITextField * numberTF = [[UITextField alloc]init];
    numberTF.placeholder = @"请输入购买金额";
    numberTF.textAlignment = NSTextAlignmentCenter;
    numberTF.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    numberTF.font = FONT(13);
    numberTF.tag = 121;
    numberTF.delegate = self;
    [backView2 addSubview:numberTF];
    self.moneyTF = numberTF;
    
    [numberTF autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [numberTF autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:paylabel withOffset:20];
    
    UIView * line2 = [[UIView alloc] init];
    line2.backgroundColor = COLOR_Text_GrayColor;
    [backView2 addSubview:line2];
    
    [line2 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:numberTF withOffset:4];
    [line2 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [line2 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100];
    [line2 autoSetDimension:ALDimensionHeight toSize:0.5];
   /*
    UILabel *pinview = [[UILabel alloc]init];
    [backView2 addSubview:pinview];
    pinview.text = @"请输入支付密码";
    pinview.textColor = [UIColor clearColor];
    pinview.font = FONT(13);
    [pinview autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [pinview autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line2 withOffset:20];
    _pinTF = [[CFCASIPInputField alloc]initWithFrame:CGRectMake((TSScreenW-100)/2,150, 100, 20)];
    self.pinTF.emSipKeyboardType = SIP_KEYBOARD_TYPE_STANDARD_DIGITAL;
    self.pinTF.sipInputFieldDelegate = self;
    self.pinTF.font = FONT(13);
    self.pinTF.userInteractionEnabled = YES;
    self.pinTF.cipherType = SIP_KEYBOARD_CIPHER_TYPE_RSA;
    _pinTF.placeholder = @"请输入支付密码";
    [backView2 addSubview:_pinTF];

    UIView * line3 = [[UIView alloc] init];
    line3.backgroundColor = COLOR_Text_GrayColor;
    [backView2 addSubview:line3];
    
    [line3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:pinview withOffset:4];
    [line3 autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [line3 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:100];
    [line3 autoSetDimension:ALDimensionHeight toSize:0.5];
    
*/
    UILabel * shouyilabel = [[UILabel alloc] init];
    shouyilabel.text = @"预计收益：￥0";
    shouyilabel.textColor = [UIColor colorWithWhite:0.702 alpha:1.000];
    shouyilabel.font = [UIFont systemFontOfSize:11];
    [backView2 addSubview:shouyilabel];
    _shouyilabel = shouyilabel;
    
    [shouyilabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [shouyilabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:line2 withOffset:20];
    
    UILabel * explainlabel = [[UILabel alloc] init];
    explainlabel.textColor = [UIColor colorWithWhite:0.702 alpha:1.000];
    explainlabel.font = [UIFont systemFontOfSize:11];
    [backView2 addSubview:explainlabel];
    _explainlabel = explainlabel;
    
    [explainlabel autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [explainlabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:shouyilabel withOffset:25];
    
    
    UIButton * chooseJiaxi = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseJiaxi setTitle:@"加息劵" forState:(UIControlStateNormal)];
    chooseJiaxi.titleLabel.font = FONT(12);
    [chooseJiaxi setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
    chooseJiaxi.layer.borderWidth = 0.5;
    chooseJiaxi.layer.cornerRadius = 8;
    chooseJiaxi.layer.borderColor = COLOR_MainColor.CGColor;
    [backView2 addSubview:chooseJiaxi];
    [chooseJiaxi addTarget:self action:@selector(didChoosejiaxi:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseJiaxi = chooseJiaxi;
    
    [chooseJiaxi autoSetDimension:ALDimensionWidth toSize:90];
//    [chooseJiaxi autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [chooseJiaxi autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:explainlabel withOffset:25];

    UIButton * chooseHongbao = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseHongbao setTitle:@"红包" forState:(UIControlStateNormal)];
    chooseHongbao.titleLabel.font = FONT(12);
    [chooseHongbao setTitleColor:COLOR_MainColor forState:UIControlStateNormal];
    chooseHongbao.layer.borderWidth = 0.5;
    chooseHongbao.layer.cornerRadius = 8;
    chooseHongbao.layer.borderColor = COLOR_MainColor.CGColor;
    [backView2 addSubview:chooseHongbao];
    [chooseHongbao addTarget:self action:@selector(didChoosehongbao:) forControlEvents:UIControlEventTouchUpInside];
    self.chooseHongbao = chooseHongbao;

    [chooseHongbao autoSetDimension:ALDimensionWidth toSize:90];
   [chooseHongbao autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:(TSScreenW-90*2-50)/2];
    [chooseHongbao autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:explainlabel withOffset:25];
    [chooseHongbao autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:chooseJiaxi];
    

    /** 申购按钮 */
    UIButton * pinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pinButton setTitle:@"立即投资" forState:UIControlStateNormal];
    [pinButton setBackgroundColor:COLOR_MainColor];
    [pinButton addTarget:self action:@selector(didGoPayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [backView2 addSubview:pinButton];
    self.payButton = pinButton;
    [pinButton autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:30];
    [pinButton autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [pinButton autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:20];
    [pinButton autoSetDimension:ALDimensionHeight toSize:40];
    pinButton.layer.cornerRadius = 20;
    pinButton.layer.masksToBounds = YES;
    
    /** 提示滑动加载语 */
    loadActionLabel = [[UILabel alloc] init];
    loadActionLabel.text = @"立即滑动，马上投资";
    loadActionLabel.font = [UIFont systemFontOfSize:11];
    loadActionLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:loadActionLabel];
   // [loadActionLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft];
   // [loadActionLabel autoPinEdgeToSuperviewEdge:ALEdgeRight];
    loadActionLabel.frame = CGRectMake(0, TSScreenH-BottomH, TSScreenW, BottomH);
   // [loadActionLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:pinButton withOffset:12];
    
    //加载更多
  //  UIView * loadMoreView=[LoadMoreView view];
   // loadMoreView.frame=CGRectMake(0, contenSize - navigationHeight, TSScreenW, BottomH);
   // [self.mainScrollView addSubview:loadMoreView];
}

#pragma mark - 输入框协议赋值

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField.tag == 121) {
        self.jiaxiID = nil;
        [self.chooseJiaxi setTitle:@"选择加息劵" forState:UIControlStateNormal];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField.tag == 121) {
        self.num = textField.text;
    }else if (textField.tag == 122) {
        self.pin = textField.text;
    }else if (textField.tag == 120) {
        self.dingPin = textField.text;
    }
    if (textField == _moneyTF) {
        [self shouyiData:_moneyTF.text cid:@"0" rid:@"0"];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField.tag == 121) {
        self.num =  [textField.text stringByReplacingCharactersInRange:range withString:string];//变化后的字符串;
    }
    return YES;
}


#pragma mark - 初始化数据

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    _nameLabel.text = [NSString stringWithFormat:@"%@", self.borrowDetailModel.borrow_name];
    /** 年化利率 */
    _all_moneylabel.text = [NSString stringWithFormat:@"%.2f%%", self.borrowDetailModel.borrow_interest_rate.doubleValue];
    /** 可投金额 */
    _freeze_moneylabel.text = [NSString stringWithFormat:@"%.2f", self.borrowDetailModel.borrow_money.doubleValue - self.borrowDetailModel.has_borrow.doubleValue];
    /** 筹资期限 */
    _balance_money.text = [NSString stringWithFormat:@"%@", self.borrowDetailModel.borrow_duration];
    /** 募筹天数 */
    _collect_interestlabel.text = [NSString stringWithFormat:@"%@", self.borrowDetailModel.collect_day];
    _repaymentValue.text = [NSString stringWithFormat:@"%@",self.borrowDetailModel.repayment_type];
    NSString *redpacket = [NSString stringWithFormat:@"%@",self.borrowDetailModel.redpacket];
    if ([redpacket isEqualToString:@"0"]) {
        self.chooseHongbao.hidden = YES;
        [_chooseJiaxi autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [_chooseJiaxi autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(TSScreenW-90)/2];//红包隐藏，加息券居中

    }else if ([redpacket isEqualToString:@"1"])
    {
        self.chooseHongbao.hidden = NO;//显示选择红包
        [_chooseJiaxi autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:(TSScreenW-90*2-50)/2];

    }
    
    //    if ([self.borrowDetailModel.can_interest isEqualToString:@"1"]) {
    //
    //        self.chooseJiaxi.hidden = NO;
    //    } else if ([self.borrowDetailModel.can_tqj isEqualToString:@"1"]) {
    //        self.chooseJiaxi.hidden = YES;
    //    } else if ([_borrowDetailModel.can_interest isEqualToString:@"1"]) {
    //        [self.chooseJiaxi autoPinEdgeToSuperviewEdge:ALEdgeLeft];
    //    } else if([self.borrowDetailModel.can_tqj isEqualToString:@"0"] && [self.borrowDetailModel.can_interest isEqualToString:@"0"]) {
    //        self.chooseJiaxi.hidden = YES;
    //    }
    
    if ([self.borrowDetailModel.borrow_max isEqualToString:@"0"]) {
        _explainlabel.text = [NSString stringWithFormat:@"最小投资金额:%.2f元,最大投资金额:无限制", self.borrowDetailModel.borrow_min.doubleValue];
    } else if([self.borrowDetailModel.borrow_min isEqualToString:@"0"]) {
        
        _explainlabel.text = [NSString stringWithFormat:@"最小投资金额:无限制,最大投资金额%.2f元", self.borrowDetailModel.borrow_max.doubleValue];
    } else {
        _explainlabel.text = [NSString stringWithFormat:@"最小投资金额:%.2f元,最大投资金额%.2f元",self.borrowDetailModel.borrow_min.doubleValue, self.borrowDetailModel.borrow_max.doubleValue];
        
    }
    
    if ([self.borrowDetailModel.borrow_status isEqualToString:@"2"]) {
        [self.payButton setTitle:@"立即加入" forState:UIControlStateNormal];
        self.payButton.alpha = 1;
        self.payButton.enabled = YES;
    } else {
        [self.payButton setTitle:self.borrowDetailModel.borrow_status_str forState:UIControlStateNormal];
        self.payButton.alpha = 0.5;
        self.payButton.enabled = NO;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark--UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSLog(@"偏移量---%f",scrollView.contentOffset.y);
    if(scrollView.tag == 200){
    
        if(scrollView.contentOffset.y<0){
            scrollView.contentOffset = CGPointMake(0, 0);//限制不能下拉
        }
        if(scrollView.contentOffset.y>=0){
            //上拖的时候改变导航栏背部的颜色
            CGFloat  fir_maxContentOffSet_Y=self.secScrollView.contentSize.height-self.secScrollView.frame.size.height;
            CGFloat  scal=scrollView.contentOffset.y/fir_maxContentOffSet_Y;
            self.NavBarView.backgroundColor= RGBA(80, 178, 229, scal);
        }
    }
    if (scrollView.tag==100) {
        //在0-60之间 懒加载子控件，并且随拖动的幅度改变子控件的标题和alpha
        CGFloat  mininumContenOffSet_Y=0;
        CGFloat  maxContentOffSet_Y=-dragStrength;
        self.secPageHeaderLabel.alpha=scrollView.contentOffset.y/maxContentOffSet_Y;
        if (scrollView.contentOffset.y>maxContentOffSet_Y&&scrollView.contentOffset.y<mininumContenOffSet_Y) {
            self.secPageHeaderLabel.text=@"下拉，回到项目详情";
            [self.view addSubview:self.secPageHeaderLabel];
        }
        if(scrollView.contentOffset.y<maxContentOffSet_Y){
            self.secPageHeaderLabel.text=@"释放，回到项目详情";
        }
    }
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.tag==200) {
        CGFloat mininumContentset_Y=self.secScrollView.contentSize.height-TSScreenH+BottomH +dragStrength;
        //上拉加载下面的视图
        if(scrollView.contentOffset.y>mininumContentset_Y){
            //此时第一屏滑到底部 可调滑动手势强度
            //            [self setSecondPageView];
            //            [self.view bringSubviewToFront:self.botomView];
            //            self.backToTopBtn.hidden=NO;
            //            [self.view addSubview:self.backToTopBtn];
            [self scrollViewDidEndScrollingAnimation:scrollView];

            //然后懒加载第二屏
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.topBar.hidden=YES;
                self.topBar.frame=CGRectMake(0-contenSize, NaviBarH, TSScreenW, TopTabBarH);
                self.secScrollView.frame=CGRectMake(0,  navigationHeight+TopTabBarH-contenSize, TSScreenW, TSScreenH-NaviBarH-TopTabBarH-BottomH);
                self.mainScrollView.frame=CGRectMake(0, NaviBarH, TSScreenW, TSScreenH -navigationHeight);
                loadActionLabel.hidden = YES;
            } completion:^(BOOL finished) {
            }];
        }
    }
    if (scrollView.tag==100) {
        //下拉
        CGFloat  maxContentOffSet_Y=-dragStrength;
        if (scrollView.contentOffset.y<maxContentOffSet_Y) {
            
            [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.secPageHeaderLabel.alpha=0;
                
                self.topBar.frame=CGRectMake(0, NaviBarH, TSScreenW, TopTabBarH);
                self.mainScrollView.frame = CGRectMake(0.0, TSScreenH, TSScreenW, TSScreenH-NaviBarH-TopTabBarH);

                self.secScrollView.frame=CGRectMake(0, TopTabBarH+navigationHeight, TSScreenW,  TSScreenH - navigationHeight);
                [_secScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
                loadActionLabel.hidden = NO;
            } completion:^(BOOL finished) {
                self.topBar.hidden=NO;
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

#pragma mark---第二页顶部按钮
-(void)tabBar:(SecondPageTopBar *)tabBar didSelectIndex:(NSInteger)index;{
    // 让scrollView滚动到对应的位置(不要去修改contentOffset的y值)
    CGPoint offset = _secScrollView.contentOffset;
    offset.x = index * _secScrollView.width;
    [_secScrollView setContentOffset:offset animated:YES];
}

#pragma mark - 点击充值
//- (void)didAddMoneyAction:(UIButton *)button {
//    TSAddMoneyController *addVC = [[TSAddMoneyController alloc] init];
//    [self.navigationController pushViewController:addVC animated:YES];
//}

#pragma mark - 投资事件

- (void)didGoPayButtonAction:(UIButton *)button {
    
    [self.view endEditing:YES];
    
    if (self.num.length == 0) {
        [DZStatusHud showToastWithTitle:@"输入购买金额" complete:^ {
            button.userInteractionEnabled = YES;
        }];
    }
//    else if (self.pinTF.text.length < 6) {
//        [DZStatusHud showToastWithTitle:@"请输入不少于6位支付密码" complete:^ {
//            button.userInteractionEnabled = YES;
//        }];
//    }
    else if ([self.borrowDetailModel.has_pass isEqualToString:@"1"]){
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            
            if (self.dingPinTF != nil) {
                params[@"borrow_pass"] = self.dingPinTF.text;
            }
            params[@"borrow_id"] = @(self.ID);
            params[@"money"] = self.num;
            //  params[@"pin"] = self.pinTF.text.MD5String;
           // params[@"pin"] = _pswEncode;
            if ([self isNull:self.jiaxiID] == YES) {
                params[@"coupon_id"] = self.jiaxiID;
            } else {
                
            }
            if ([self isNull:self.hongbaoID] == YES) {
                params[@"redpacket_id"] = self.hongbaoID;
            } else {
                
            }
#pragma mark -  孟  改成 invest_money1
            params[@"meng_sn"] = self.borrowDetailModel.meng_sn;
        TSBorDetailWebController *vc = [[TSBorDetailWebController alloc]init];
        vc.paramDic = params;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else {
        NSMutableDictionary * params = [NSMutableDictionary dictionary];
        if (self.dingPinTF != nil) {
            params[@"borrow_pass"] = self.dingPinTF.text;
        }
        params[@"borrow_id"] = @(self.ID);
        params[@"money"] = self.num;
        //   params[@"pin"] = self.pinTF.text.MD5String;
        //params[@"pin"] = _pswEncode;
        
        if ([self isNull:self.jiaxiID] == YES) {
            params[@"coupon_id"] = self.jiaxiID;
        } else {
            
        }
        if ([self isNull:self.hongbaoID] == YES) {
            params[@"redpacket_id"] = self.hongbaoID;
        } else {
            
        }
#pragma mark -  孟  改成 invest_money1
        params[@"meng_sn"] = self.borrowDetailModel.meng_sn;
        TSBorDetailWebController *vc = [[TSBorDetailWebController alloc]init];
        vc.paramDic = params;
        [self.navigationController pushViewController:vc animated:YES];

     
    }

}

#pragma mark SIPInputFieldDelegate

- (BOOL)onKeyDone:(CFCASIPInputField *)sip
{
    return YES;
}
- (void)onSIPInputFieldTextDidChanged:(CFCASIPInputField *)sipInputField withOperateType:(SIPOperateType)operateType
{
}


#pragma mark - 选择加息劵

- (void)didChoosejiaxi:(UIButton *)button {
    
     if ([self isNull:self.hongbaoID] == YES && ![self.hongbaoID isEqualToString:@""]) {
        [DZStatusHud showToastWithTitle:@"当前选择红包，加息券不可用" complete:nil];
    }else {
        if (self.num.length == 0) {
            [DZStatusHud showToastWithTitle:@"输入购买金额" complete:nil];
        }  else {
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
            params[@"id"] = @(self.ID);
            params[@"money"] = self.num;
            [[TSNetwork shareNetwork] postRequestResult:params url:@"interest_ticket" successBlock:^(id responseBody) {
                NSString * event = [NSString stringWithFormat:@"%@", responseBody[@"event"]];
                if ([event isEqualToString:@"88"]) {
                    self.jiaxiArr = [TSJiaxiModel mj_objectArrayWithKeyValuesArray:responseBody[@"msg"]];
                    JFDropdownMenu *menu = [JFDropdownMenu menu];
                    TSUserJiaxiController * uredVC = [[TSUserJiaxiController alloc] init];
                    menu.contentController = uredVC;
                    uredVC.dataArr =self.jiaxiArr;
                    [menu show];
                    self.tsmenu = menu;
                    uredVC.delegate = self;
                    if (self.jiaxiArr.count == 0) {
                        [self.chooseJiaxi setTitle:@"暂无可用加息劵" forState:(UIControlStateNormal)];
                        self.jiaxiID = nil;
                    } else {
                        
                    }
                } else {
                    [DZStatusHud showToastWithTitle:@"暂无可用加息劵" complete:nil];
                }
            } failureBlock:^(NSString *error) {
                [DZStatusHud showToastWithTitle:error complete:nil];
            }];
        }
    }
}
#pragma mark - 选择红包
- (void)didChoosehongbao:(UIButton *)button {

    if ([self isNull:self.jiaxiID] == YES && ![self.jiaxiID isEqualToString:@""]) {
        [DZStatusHud showToastWithTitle:@"当前选择加息券，红包不可用" complete:nil];
    }else {
        if (self.num.length == 0) {
            [DZStatusHud showToastWithTitle:@"输入购买金额" complete:nil];
        }  else {
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"token"] = [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
            params[@"id"] = @(self.ID);
            params[@"money"] = self.num;
            [[TSNetwork shareNetwork] postRequestResult:params url:@"redpacket_ticket" successBlock:^(id responseBody) {
                NSString * event = [NSString stringWithFormat:@"%@", responseBody[@"event"]];
                if ([event isEqualToString:@"88"]) {
                    self.hongbaoArr = [RedPacketModel mj_objectArrayWithKeyValuesArray:responseBody[@"msg"]];
                    JFDropdownMenu *menu = [JFDropdownMenu menu];
                    UseRedpackViewController * uredVC = [[UseRedpackViewController alloc] init];
                    menu.contentController = uredVC;
                    uredVC.dataArr =self.hongbaoArr;
                    [menu show];
                    self.tsmenu = menu;
                    uredVC.delegate = self;
                    if (self.hongbaoArr.count == 0) {
                        [self.chooseHongbao setTitle:@"暂无可用红包" forState:(UIControlStateNormal)];
                        self.hongbaoID = nil;
                    } else {
                        
                    }
                } else {
                    [DZStatusHud showToastWithTitle:@"暂无可用红包" complete:nil];
                }
            } failureBlock:^(NSString *error) {
                [DZStatusHud showToastWithTitle:error complete:nil];
            }];
        }
    }
}

#pragma mark - 红包协议
- (void)getHongbaoIDDelegate:(NSString *)hongbaoID withBidmoney:(NSString *)money withpaymoney:(NSString *)paymoney
{
    [self loadInfoData];
    self.hongbaoID = hongbaoID;
    [self.tsmenu dismiss];
    
    if ([self isNull:self.hongbaoID] == YES && ![self.hongbaoID isEqualToString:@""]) {
        [self.chooseHongbao setTitle:[NSString stringWithFormat:@"红包:%@", paymoney] forState:(UIControlStateNormal)];
    } else {
        [self.chooseHongbao setTitle:@"使用红包" forState:(UIControlStateNormal)];
    }
    [self shouyiData:_moneyTF.text cid:@"0" rid:hongbaoID];

}
#pragma mark - 加息劵协议
- (void)getJiaxiIDDelegate:(NSString *)jiaxiID withBidmoney:(NSString *)money withpaymoney:(NSString *)paymoney {
    [self loadInfoData];
    self.jiaxiID = jiaxiID;
    [self.tsmenu dismiss];
    
    if ([self isNull:self.jiaxiID] == YES && ![self.jiaxiID isEqualToString:@""]) {
        [self.chooseJiaxi setTitle:[NSString stringWithFormat:@"加息:%@%%", paymoney] forState:(UIControlStateNormal)];
    } else {
        [self.chooseJiaxi setTitle:@"使用加息劵" forState:(UIControlStateNormal)];
    }
    [self shouyiData:_moneyTF.text cid:jiaxiID rid:@"0"];
}

//=================================================================
//                              判空分割线
//=================================================================

- (BOOL)isNull:(id)object
{
    // 判断是否为空串
    if ([object isEqual:[NSNull null]]) {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if (object==nil){
        return NO;
    }
    
    return YES;
}

@end
