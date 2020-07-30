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

#import "YxzLivePlayer.h"

@interface YxzChatController ()<YxzLiveRoomControlDelegate,YxzPlayerDelegate>


@property(nonatomic,strong)UIView *containerView;//容器 用于做旋转
@property(nonatomic,strong)YxzChatCompleteComponent *chatComponentView;
@property(nonatomic,strong)UIView *videoContainerView;
@property(nonatomic,strong)YxzVideoLooksBasicInfoView *basInfoView;
@property(nonatomic,strong)YxzLivePlayer *livePlayer;
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
    [self setupSubView];
    
   
//    self.playerView.fatherView = self.videoContainerView;
     [self layoutSubViewConstraint];
    [self startPlayAndJoinChatRoom];
    
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
#pragma mark - 旋转相关 方法
// 设备支持方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationPortrait|UIInterfaceOrientationLandscapeLeft;
}
// 默认方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait; // 或者其他值 balabala~
}
- (BOOL)shouldAutorotate {
    return YES;
}
- (void)setInterfaceOrientation:(UIDeviceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:orientation] forKey:@"orientation"];
    }
}
-(void)setupSubView{
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.basInfoView];
    [self.containerView addSubview:self.videoContainerView];
    _chatComponentView=[[YxzChatCompleteComponent alloc]initWithFrame:self.view.bounds];
    [self.containerView addSubview:_chatComponentView];
    self.livePlayer.fatherView=self.videoContainerView;
}
-(void)startPlayAndJoinChatRoom{
    if (self.roomBaseInfo) {
//        SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
//        playerModel.videoURL         = self.roomBaseInfo.payLiveUrl;
//        [self.playerView playWithModel:playerModel];
        YxzPlayerModel *payModel=[[YxzPlayerModel alloc]init];
        payModel.videoURL=self.roomBaseInfo.payLiveUrl;
        [self.livePlayer playWithModel:payModel];
        
    }
}
-(void)layoutSubViewConstraint{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
    [self.basInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView);
        make.right.equalTo(self.containerView);
        make.height.equalTo(@(70));
        make.top.equalTo(self.videoContainerView.mas_bottom);
    }];
    [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.top.equalTo(self.containerView.mas_top);
        make.right.equalTo(self.containerView.mas_right);
        make.height.equalTo(@(320));
    }];
    [self.chatComponentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.top.equalTo(self.videoContainerView.mas_bottom);
               make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
}

#pragma mark - 更多信息  小窗播放 delegate =============
-(void)suspensionClick{
    YxzSuperPlayerWindowShared.superPlayer=self.livePlayer;
    YxzSuperPlayerWindowShared.backController=self;
    [YxzSuperPlayerWindowShared show];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)moreInfoClick{
    
}
/** 播放器全屏 */
- (void)controlViewChangeScreen:(UIView *)controlView withFullScreen:(BOOL)isFullScreen{
    
    [self.chatComponentView hiddenTheKeyboardAndFace:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isFullScreen) {
                [self setInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
            }else{
                [self setInterfaceOrientation:UIDeviceOrientationPortrait];
            }
        });
    }];
    
    
}
#pragma mark -getter  ===============
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
-(UIView *)containerView{
    if (!_containerView) {
        _containerView=[[UIView alloc]init];
    }
    return _containerView;
}
-(YxzLivePlayer *)livePlayer{
    if (!_livePlayer) {
        _livePlayer=[[YxzLivePlayer alloc]init];
        _livePlayer.roomControlDelegate=self;
        _livePlayer.delegate=self;
    }
    return _livePlayer;
}
@end
