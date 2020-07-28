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
#import <SuperPlayer/SuperPlayer.h>
#import <Masonry/Masonry.h>



@interface YxzChatController ()<SuperPlayerDelegate>

@property (strong, nonatomic) SuperPlayerView *playerView;

@property(nonatomic,strong)YxzChatCompleteComponent *chatComponentView;
@property(nonatomic,strong)UIView *videoContainerView;
@property(nonatomic,strong)YxzVideoLooksBasicInfoView *basInfoView;
@end

@implementation YxzChatController
- (instancetype)init {
    if (SuperPlayerWindowShared.backController) {
        [SuperPlayerWindowShared hide];
        YxzChatController *playerViewCtrl = (YxzChatController *)SuperPlayerWindowShared.backController;
//        playerViewCtrl.danmakuView.clipsToBounds = NO;
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
            [self.playerView resetPlayer];
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
    self.playerView.fatherView = self.videoContainerView;
     [self layoutSubViewConstraint];
    [self startPlayAndJoinChatRoom];
    
}

-(void)startPlayAndJoinChatRoom{
    if (self.roomBaseInfo) {
        SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
        playerModel.videoURL         = self.roomBaseInfo.payLiveUrl;
        [self.playerView playWithModel:playerModel];
        
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
#pragma mark - super Player delegate =====================
/// 返回事件
- (void)superPlayerBackAction:(SuperPlayerView *)player{
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    // 是竖屏时候响应关
    if (orientation == UIInterfaceOrientationPortrait &&
        (self.playerView.state == StatePlaying)) {
//        self.danmakuView.clipsToBounds = YES;
        [SuperPlayerWindowShared setSuperPlayer:self.playerView];
        [SuperPlayerWindowShared show];
        SuperPlayerWindowShared.backController = self;
    } else {
        [self.playerView resetPlayer];  //非常重要
        SuperPlayerWindowShared.backController = nil;
    }
    [self.navigationController popViewControllerAnimated:YES];
}
/// 全屏改变通知
- (void)superPlayerFullScreenChanged:(SuperPlayerView *)player{
    
}
/// 播放开始通知
- (void)superPlayerDidStart:(SuperPlayerView *)player{
    
}
/// 播放结束通知
- (void)superPlayerDidEnd:(SuperPlayerView *)player{
    
}
/// 播放错误通知
- (void)superPlayerError:(SuperPlayerView *)player errCode:(int)code errMessage:(NSString *)why{
    
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
- (SuperPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[SuperPlayerView alloc] init];
        
        // 设置代理
        _playerView.delegate = self;
        // demo的时移域名，请根据您项目实际情况修改这里
//        _playerView.playerConfig.playShiftDomain = @"liteavapp.timeshift.qcloud.com";
        
    }
    return _playerView;
}
@end
