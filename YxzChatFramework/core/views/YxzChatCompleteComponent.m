//
//  YxzChatCompleteComponent.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/23.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzChatCompleteComponent.h"
#import "YxzChatListTableView.h"
#import "YxzInputBoxView.h"
#import "YXZConstant.h"
@interface YxzChatCompleteComponent()
@property(nonatomic,strong)YxzChatListTableView *listTableView;
@property(nonatomic,strong)YxzInputBoxView *inputboxView;
@end
@implementation YxzChatCompleteComponent
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
    }
    return self;
}
-(void)setupSubViews{
    
    _listTableView=[[YxzChatListTableView alloc]initWithFrame:CGRectMake(0, 0, MsgTableViewWidth, CGRectGetHeight(self.bounds)-inputBoxDefaultHight)];
    _listTableView.reloadType=YxzReloadLiveMsgRoom_Time;
    [self addSubview:_listTableView];
    _inputboxView=[[YxzInputBoxView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-inputBoxDefaultHight, MsgTableViewWidth, inputBoxDefaultHight)];
    [self addSubview:_inputboxView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.listTableView.frame=CGRectMake(0, 0, MsgTableViewWidth, CGRectGetHeight(self.bounds)-inputBoxDefaultHight);
    self.inputboxView.frame=CGRectMake(0, CGRectGetHeight(self.bounds)-inputBoxDefaultHight, MsgTableViewWidth, inputBoxDefaultHight);
}
@end
