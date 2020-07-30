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

@interface YxzChatController ()<YxzLiveRoomControlDelegate,YxzPlayerDelegate,UIGestureRecognizerDelegate>


@property(nonatomic,strong)UIView *containerView;//容器 用于做旋转
@property(nonatomic,strong)YxzChatCompleteComponent *chatComponentView;
@property(nonatomic,strong)UIView *videoContainerView;
@property(nonatomic,strong)YxzVideoLooksBasicInfoView *basInfoView;
@property(nonatomic,strong)YxzLivePlayer *livePlayer;


/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/** 双击 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;


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
-(void)addGesture{
    // 单击
       self.singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
       self.singleTap.delegate                = self;
       self.singleTap.numberOfTouchesRequired = 1; //手指数
       self.singleTap.numberOfTapsRequired    = 1;
       [self.chatComponentView addGestureRecognizer:self.singleTap];
       
       // 双击(播放/暂停)
       self.doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
       self.doubleTap.delegate                = self;
       self.doubleTap.numberOfTouchesRequired = 1; //手指数
       self.doubleTap.numberOfTapsRequired    = 2;
     [self.chatComponentView addGestureRecognizer:self.doubleTap];

       // 解决点击当前view时候响应其他控件事件
       [self.singleTap setDelaysTouchesBegan:YES];
       [self.doubleTap setDelaysTouchesBegan:YES];
       // 双击失败响应单击事件
       [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
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


#pragma mark 强制横屏(针对present方式)


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
    [self addGesture];
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
-(void)modifyLeftSapcen:(BOOL)isFull{
    if (isFull) {
        [self.videoContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.top.equalTo(self.containerView);
        }];
        [self.chatComponentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left);
            make.bottom.equalTo(self.containerView.mas_bottom).offset(-60);
            make.right.equalTo(self.containerView.mas_right);
            make.top.equalTo(self.containerView.mas_top).offset(90);
        }];
    }else{
        [self.videoContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left);
            make.top.equalTo(self.containerView.mas_top);
            make.right.equalTo(self.containerView.mas_right);
            make.height.equalTo(@(320));
        }];
        [self.chatComponentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left);
            make.top.equalTo(self.videoContainerView.mas_bottom);
                   make.right.equalTo(self.containerView.mas_right);
            make.bottom.equalTo(self.containerView.mas_bottom);
        }];
    }
}
/**
 *   轻拍方法
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)singleTapAction:(UIGestureRecognizer *)gesture {
    if (self.livePlayer.isFullScreen) {
        if (gesture.state == UIGestureRecognizerStateRecognized) {
           
            
            
          
            if (YxzSuperPlayerWindowShared.isShowing)
                return;
            
            if (self.livePlayer.controlView.hidden) {
                [[self.livePlayer.controlView fadeShow] fadeOut:5];
            } else {
                [self.livePlayer.controlView fadeOut:0.2];
            }
        }
    }
    
}

/**
 *  双击播放/暂停
 *
 *  @param gesture UITapGestureRecognizer
 */
- (void)doubleTapAction:(UIGestureRecognizer *)gesture {
    if (self.livePlayer.isFullScreen) {
        if (self.livePlayer.playDidEnd) { return;  }
           // 显示控制层
        [self.livePlayer.controlView fadeShow];
        if (self.livePlayer.isPauseByUser) {
            [self.livePlayer resume];
           } else {
               [self.livePlayer pause];
           }
    }
   
}
#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    

    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.livePlayer.playDidEnd){
            return NO;
        }
    }

    if ([touch.view isKindOfClass:[UISlider class]] || [touch.view.superview isKindOfClass:[UISlider class]]) {
        return NO;
    }
  
    if (YxzSuperPlayerWindowShared.isShowing)
        return NO;
    
    return YES;
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
    [self modifyLeftSapcen:isFullScreen];
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
