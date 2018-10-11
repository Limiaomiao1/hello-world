//
//  TSHomeHeaderView.m
//  Shangdai
//
//  Created by tuanshang on 17/2/11.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#import "TSHomeHeaderView.h"
#import "TSSqaureButton.h"
#import "TSSqaureModel.h"
#import "TSHomeImageModel.h"
#import <MJExtension.h>
@implementation TSHomeHeaderView

- (NSMutableArray *)imageArr
{
    if(!_imageArr) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//banner
        SDCycleScrollView * cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, TSScreenW, 140) delegate:self placeholderImage:[UIImage imageNamed:@"default_header"]];
        cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
        cycleScrollView.pageDotColor = [UIColor whiteColor];
        cycleScrollView.currentPageDotColor = COLOR_MainColor;
        // 滑动动画
//        cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
        [self addSubview:cycleScrollView];
        NSMutableArray * squares = [TSSqaureModel mj_objectArrayWithFilename:@"sqaure.plist"];
        
        [self createSquares:squares];
        
        __weak SDCycleScrollView * cycView = cycleScrollView;
        //获取banner数据
        [[TSNetwork shareNetwork] postRequestResult:nil url:TSAPI_INDEXBANNER successBlock:^(id responseBody) {
            NSMutableArray * imageArr = [NSMutableArray new];
            _imageArr = [TSHomeImageModel mj_objectArrayWithKeyValuesArray:responseBody[@"data"]];
            for (int i = 0; i < _imageArr.count; i++) {
                TSHomeImageModel *model = _imageArr[i];
                [imageArr addObject:model.img];
            }
            cycView.imageURLStringsGroup = imageArr;
        } failureBlock:^(NSString *error) {
        
        }];
        
        
        //获取banner数据
        [[TSNetwork shareNetwork] postRequestResult:nil url:@"noticelist" successBlock:^(id responseBody) {
            int event = [responseBody[@"event"] intValue];
            if (event == 88) {

                NSArray *listArr = responseBody[@"data"][@"list"];
                NSMutableArray *tempArr = @[].mutableCopy;

                for (int i=0; i<listArr.count; i++) {
                    NSDictionary *dic = listArr[i];
                    UILabel *labelOne = [UILabel new];
                    labelOne.font = [UIFont systemFontOfSize:10];
                    labelOne.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"title"]];
                    labelOne.tag = [[dic objectForKey:@"id"] intValue];
                    labelOne.textColor = [UIColor orangeColor];
                    [tempArr addObject:labelOne];
                }
                
                self.marqueeView = [[LSMarqueeView alloc] initWithFrame:CGRectMake(10, 145, TSScreenW-40, 20) andLableArr:tempArr];
                [self.marqueeView  startCountdown];

                [self addSubview:self.marqueeView];
                TSWeakSelf;
                self.marqueeView.clickBlock = ^(UILabel *sender){
                    NSString *nid = [NSString stringWithFormat:@"%ld",(long)sender.tag];
                    if (weakSelf.clickBlock) {
                        weakSelf.clickBlock(nid);
                    }

                };
                
            }else
            {
                [DZStatusHud showToastWithTitle:responseBody[@"msg"] complete:nil];

            }
        } failureBlock:^(NSString *error) {
            
        }];
    }
    return self;
}

/**
 *  创建方块
 *  
 *  @param squares 方块模型数组
 */
- (void)createSquares:(NSArray *)squares
{
    NSUInteger count = squares.count;
    int totalColCount = 4;
    CGFloat buttonW = TSScreenW / totalColCount;
    CGFloat buttonH = buttonW*0.8;
    for (int i = 0; i < count; i++) {
        // 创建按钮
        TSSqaureButton *button = [TSSqaureButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        // 计算frame
        button.width = buttonW;
        button.height = buttonH;
        button.x = (i % totalColCount) * buttonW;
//        button.y = (i / totalColCount) * buttonH;
        button.y = 170;
        // 设置数据
        button.sqaure = squares[i];
        
        // 设置高度
        self.height = CGRectGetMaxY(button.frame);
    }
    
    UITableView *tableView = (UITableView *)self.superview;
    tableView.contentSize = CGSizeMake(tableView.contentSize.width, CGRectGetMaxX(self.frame));
}

/** Tag点击方法 */
- (void)buttonClick:(TSSqaureButton *)button
{
    self.buttonName = button.sqaure.name;
    if (self.didTagAction) {
        self.didTagAction();
    }
}


@end
