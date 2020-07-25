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
@interface YxzChatCompleteComponent()<YxzInputViewDelegate>
@property(nonatomic,strong)YxzChatListTableView *listTableView;
@property(nonatomic,strong)YxzInputBoxView *inputboxView;
@property(nonatomic,assign)CGFloat inputBoxHight;
@property(nonatomic,assign)CGFloat defaultINputBoxHight;
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
    self.inputBoxHight=inputBoxDefaultHight;
    _listTableView=[[YxzChatListTableView alloc]initWithFrame:CGRectMake(0, 0, MsgTableViewWidth, CGRectGetHeight(self.bounds)-inputBoxDefaultHight)];
    _listTableView.reloadType=YxzReloadLiveMsgRoom_Time;
    [self addSubview:_listTableView];
    _inputboxView=[[YxzInputBoxView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-inputBoxDefaultHight, MsgTableViewWidth, inputBoxDefaultHight)];
    _inputboxView.delegate=self;
    [self addSubview:_inputboxView];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    
//    [self layoutSubViewFrame];
    
}
-(void)layoutSubViewFrame{
    CGRect frame =CGRectMake(0, CGRectGetHeight(self.bounds)-self.inputBoxHight, MsgTableViewWidth, self.inputBoxHight);
    self.inputboxView.frame=frame;
    CGRect listTabeFrame=self.listTableView.frame;
    listTabeFrame.size.height-=CGRectGetHeight(frame);
    self.listTableView.frame=listTabeFrame;
}
#pragma mark - YxzInputViewDelegate ======================
-(void)inputBoxStatusChange:(YxzInputBoxView *)boxView changeFromStatus:(YxzInputStatus)fromStatus toStatus:(YxzInputStatus)toStatus changeHight:(CGFloat)hight{
    self.inputBoxHight=hight;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self layoutSubViewFrame];
        
    });
}
//发送消息
-(void)sendText:(NSString *)msgText faceImage:(NSString *)faceImageUrlStr{
    YXZMessageModel *model=[YXZMessageModel new];
    model.msgType=YxzMsgType_barrage;
    model.content=msgText;
    model.faceImageUrl=faceImageUrlStr;
    YxzUserModel *user=[YxzUserModel new];
    user.nickName=@"fengyuyxz";
    user.level=7;
    model.user=user;
    model.msgID = [NSString stringWithFormat:@"msgID_%u", arc4random() % 10000];
    // 生成富文本模型
    [model initMsgAttribute];
    [self.listTableView addNewMsg:model];
}
-(void)inputBoxHightChange:(YxzInputBoxView *)boxView inputViewHight:(CGFloat)inputHight{
    CGRect frame =self.inputboxView.frame;
    frame.size.height=inputHight;
    frame.origin.y=CGRectGetHeight(self.bounds)-inputHight;
    self.inputboxView.frame=frame;
    CGRect listTabeFrame=self.listTableView.frame;
    listTabeFrame.size.height=CGRectGetHeight(self.bounds)-CGRectGetHeight(frame);
    self.listTableView.frame=listTabeFrame;
}
@end
