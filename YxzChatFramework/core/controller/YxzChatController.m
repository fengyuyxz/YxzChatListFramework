//
//  YxzChatController.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/23.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzChatController.h"
#import "YxzChatCompleteComponent.h"
#import "YxzVideoLooksBasicInfoView.h"
#import "SuspensionWindow.h"
#import "YXZConstant.h"
#import <Masonry/Masonry.h>



@interface YxzChatController ()



@property(nonatomic,strong)YxzChatCompleteComponent *chatComponentView;
@property(nonatomic,strong)UIView *videoContainerView;
@property(nonatomic,strong)YxzVideoLooksBasicInfoView *basInfoView;
@end

@implementation YxzChatController
- (instancetype)init {
    if (YxzSuperPlayerWindowShared.backController) {
        [YxzSuperPlayerWindowShared hidden];
        YxzChatController *playerViewCtrl = (YxzChatController *)YxzSuperPlayerWindowShared.backController;

        return playerViewCtrl;
    } else {
        if (self = [super init]) {
            
        }
        return self;
    }
}

-(void)dealloc{
   NSLog(@"%@释放了",self.class);
    
}
- (void)willMoveToParentViewController:(nullable UIViewController *)parent
{
    
}
- (void)didMoveToParentViewController:(nullable UIViewController *)parent
{
    if (parent == nil) {
        if (!SuperPlayerWindowShared.isShowing) {
//            [self.playerView resetPlayer];
        }
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    
    
    [self.view addSubview:self.basInfoView];
    [self.view addSubview:self.videoContainerView];
    _chatComponentView=[[YxzChatCompleteComponent alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_chatComponentView];
//    self.playerView.fatherView = self.videoContainerView;
     [self layoutSubViewConstraint];
    [self startPlayAndJoinChatRoom];
    
}

-(void)startPlayAndJoinChatRoom{
    if (self.roomBaseInfo) {
//        SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
//        playerModel.videoURL         = self.roomBaseInfo.payLiveUrl;
//        [self.playerView playWithModel:playerModel];
        
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}
-(void)layoutSubViewConstraint{
    [self.basInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(70));
        make.top.equalTo(self.videoContainerView.mas_bottom);
    }];
    [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.view.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(320));
    }];
    [self.chatComponentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.videoContainerView.mas_bottom);
               make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}
- (BOOL)shouldAutorotate
{
return YES;
}

-(UIView *)videoContainerView{
    if (!_videoContainerView) {
        _videoContainerView=[[UIView alloc]init];
    }
    return _videoContainerView;
}
-(YxzVideoLooksBasicInfoView *)basInfoView{
    if (!_basInfoView) {
        _basInfoView=[[YxzVideoLooksBasicInfoView alloc]init];
    }
    return _basInfoView;
}

@end
