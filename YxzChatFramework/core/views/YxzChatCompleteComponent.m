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
#import <Masonry/Masonry.h>
@interface YxzChatCompleteComponent()<YxzInputViewDelegate,YxzListViewInputDelegate,RoomMsgListDelegate>
@property(nonatomic,strong)YxzChatListTableView *listTableView;
@property(nonatomic,strong)YxzInputBoxView *inputboxView;
@property(nonatomic,assign)CGFloat inputBoxHight;
@property(nonatomic,assign)CGFloat defaultINputBoxHight;

@property(nonatomic,copy)HiddenKeyboardAndFaceViewCompletion hiddenKyboardFaceBlock;
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
    self.userInteractionEnabled=YES;
    self.inputBoxHight=inputBoxDefaultHight;
    _listTableView=[[YxzChatListTableView alloc]initWithFrame:CGRectZero];
    _listTableView.delegate=self;
    _listTableView.listInputView.delegate=self;
    _listTableView.reloadType=YxzReloadLiveMsgRoom_Time;
    [self addSubview:_listTableView];
    _inputboxView=[[YxzInputBoxView alloc]initWithFrame:CGRectZero];
    _inputboxView.delegate=self;
    [self addSubview:_inputboxView];
    [self layoutSubViewConstraint];
    
}
-(void)layoutSubViewConstraint{
    [self.listTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        if ([self isPortrait]) {
            make.right.equalTo(self.mas_right);
        }else{
            make.width.equalTo(@(MsgTableViewWidth));
        }
        make.bottom.equalTo(self.mas_bottom);
    }];
    [self.inputboxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.mas_bottom).offset(inputBoxDefaultHight);
        make.height.equalTo(@(inputBoxDefaultHight));
    }];
}


-(BOOL)isPortrait{
    UIDeviceOrientation orientaition=[UIDevice currentDevice].orientation;
    BOOL flag=YES;
    if (orientaition==UIDeviceOrientationLandscapeLeft||orientaition==UIDeviceOrientationLandscapeLeft) {
        flag=NO;
    }
    return flag;
}

- (void)layoutSubviews{
    [super layoutSubviews];
//    [self layoutSubViewConstraint];
//    [self layoutSubViewFrame];
    
}
-(void)layoutSubViewFrame{
    /*
    CGRect frame =CGRectMake(0, CGRectGetHeight(self.bounds)-self.inputBoxHight, device_sceen_width, self.inputBoxHight);
    
    
    self.inputboxView.frame=frame;
    CGRect listTabeFrame=self.listTableView.frame;
    listTabeFrame.size.height=CGRectGetHeight(self.bounds)-CGRectGetHeight(frame);
    self.listTableView.frame=listTabeFrame;
    
    */
}
-(void)hiddenTheKeyboardAndFace:(HiddenKeyboardAndFaceViewCompletion)block{
    self.hiddenKyboardFaceBlock=block;
    if (self.inputboxView.inputStatus==YxzInputStatus_keyborad) {
         [self.inputboxView hiddenInput];
    }else if(self.inputboxView.inputStatus==YxzInputStatus_showFace){
         [self.inputboxView hiddenFace];
    }else{
        if (self.hiddenKyboardFaceBlock) {
            self.hiddenKyboardFaceBlock();
            self.hiddenKyboardFaceBlock=nil;
        }
    }
   
   
    
}
#pragma mark - YxzListViewInputDelegate =================
-(void)faceClick{
    [self.inputboxView clickFace];
}
-(void)inputClick{
    [self.inputboxView clickTextField];
}
#pragma mark - RoomMsgListDelegate =================
-(void)tapBackgroundView{
    [self.inputboxView hiddenInput];
}
#pragma mark - YxzInputViewDelegate ======================
-(void)inputBoxStatusChange:(YxzInputBoxView *)boxView changeFromStatus:(YxzInputStatus)fromStatus toStatus:(YxzInputStatus)toStatus changeHight:(CGFloat)hight{
    self.inputBoxHight=hight;
    if (toStatus==YxzInputStatus_keyborad||toStatus==YxzInputStatus_showFace) {
        [self.inputboxView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(0);
            make.height.equalTo(@(hight));
        }];
        [self.listTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-(hight-inputBoxDefaultHight));
        }];
        [UIView animateWithDuration:.5 animations:^{

            [self layoutIfNeeded];

        }];
    }else if (toStatus==YxzInputStatus_nothing){
       
        [self.inputboxView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(inputBoxDefaultHight);
            make.height.equalTo(@(inputBoxDefaultHight));
        }];
        [self.listTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                   make.bottom.equalTo(self.mas_bottom).offset(0);
               }];
        [UIView animateWithDuration:0.25 animations:^{
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            if (self.hiddenKyboardFaceBlock) {
                self.hiddenKyboardFaceBlock();
                self.hiddenKyboardFaceBlock=nil;
            }
        }];
        
    }
}
//发送消息
-(void)sendText:(NSString *)msgText faceImage:(NSString *)faceImageUrlStr{
    YXZMessageModel *model=[YXZMessageModel new];
    model.msgType=YxzMsgType_barrage;
    model.content=msgText;
   // model.faceImageUrl=faceImageUrlStr;
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
