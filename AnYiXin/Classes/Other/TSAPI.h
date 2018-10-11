//
//  TSAPI.h
//  Shangdai
//
//  Created by tuanshang on 17/2/16.
//  Copyright © 2017年 tuanshang. All rights reserved.
//

#ifndef TSAPI_h
#define TSAPI_h


#define TSAPI_BASE_HTTP_PREFIX                @"https://www.51jqd.com/Service/"
// 测试站
//#define TSAPI_Image_PREFIX                    @"http://test.51jqd.com/Service/"

//#define TSAPI_Image_PREFIX                    @"http://demo.51jqd.com/Service/"

#define TSAPI_Image_PREFIX                    @"https://www.51jqd.com/Service/"
//=================================================================
//                       登录注册接口分割线
//=================================================================
#define TSAPI_LOGIN                              @"login"    //登录
#define TSAPI_REG                                @"reg"    //注册
#define TSAPI_CHECK_NAME                         @"check_name"    //检测用户名
#define TSAPI_SEND_CODE                          @"send_code"   //发送验证码

//=================================================================
//                       首页接口分割线
//=================================================================
#define TSAPI_INDEXBANNER                   @"indexbanner"     //首页banner图
#define TSAPI_RECOMMEND_LIST                @"recommend_list"     //推荐项目

//=================================================================
//                        理财接口分割线
//=================================================================
#define TSAPI_TRANSFER_LIST                       @"transfer_list"  //优计划列表
#define TSAPI_TRANSFER_DETAIL                     @"transfer_detail"   // 优计划详情
#define TSAPI_TRANSFER_INVEST_LIST                @"transfer_invest_list"   //投资列表

#define TSAPI_BORROW_LIST                         @"borrow_list"      //散标列表
#define TSAPI_BORROW_DETAIL                       @"borrow_detail"     //散标详情
#define TSAPI_BORROW_INVEST_LIST                  @"borrow_invest_list"   //散标投资列表

#define TSAPI_DEBT_LIST                           @"debt_list"       // 债权列表
#define TSAPI_DEBT_DETAIL                         @"debt_detail"       // 债权详情

//=================================================================
//                        个人中心接口分割线
//=================================================================
#define TSAPI_MEMBER                    @"member"                    //账户中心首页
#define TSAPI_SET_PIN_PASS              @"set_pin_pass"              //修改设置支付密码
#define TSAPI_CHECK_ID_STATUS           @"check_id_status"           //判断是否实名认证
#define TSAPI_CHECK_BANK_CARD           @"check_bank_card"           //判断是否绑定银行卡
#define TSAPI_CHECK_PIN_PASS            @"check_pin_pass"            //判断是否设置支付密码
#define TSAPI_VERIFY_ID_CARD            @"verify_id_card"            //实名认证
#define TSAPI_INNER_MSG_LIST            @"inner_msg_list"            //站内信列表
#define TSAPI_INNER_MSG_STATUS          @"inner_msg_status"          //站内信状态更新
#define TSAPI_CHANGE_PWD_BY_PHONE       @"change_pwd_by_phone"       //通过手机验证码修改/找回登录密码
#define TSAPI_CHANGE_PWD_BY_OLD         @"change_pwd_by_old"         //通过旧密码修改登录密码
#define TSAPI_EVENT_INFO                @"event_info"                //活动详情
#define TSAPI_EVENTS                    @"events"                    //活动列表
#define TSAPI_GONGGAOS                  @"gonggaos"                  //公告
#define TSAPI_GONGGAOBYID               @"gonggaobyid"               //公告详情
#define TSAPI_MAIN_TENANACE               @"main_tenance"               //系统维护

//=================================================================
//                           拓展更多接口分割线
//=================================================================

#define TSAPI_MORE      @"more"     //更多 （二维码，客服，微博等）


#endif /* TSAPI_h */
