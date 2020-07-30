//
//  LiveRoomViewController.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/30.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "LiveRoomViewController.h"
#import "YxzLivePlayer.h"
#import "YxzChatCompleteComponent.h"
#import "YxzVideoLooksBasicInfoView.h"
#import "SuspensionWindow.h"
#import "YXZConstant.h"
#import "SupportedInterfaceOrientations.h"
#import <Masonry/Masonry.h>
@interface LiveRoomViewController ()<YxzLiveRoomControlDelegate,YxzPlayerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView *containerView;//容器 用于做旋转

@property(nonatomic,strong)UIView *videoContainerView;

@property(nonatomic,strong)YxzLivePlayer *livePlayer;
@end

@implementation LiveRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self layoutSubViewConstraint];
    [self playVideo];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)setupViews{
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.videoContainerView];
    self.livePlayer.fatherView=self.videoContainerView;
}
-(void)layoutSubViewConstraint{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.view);
    }];
    [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.containerView);
        make.height.mas_equalTo(320);
    }];
}
-(void)playVideo{
     if (self.roomBaseInfo) {
    
            YxzPlayerModel *payModel=[[YxzPlayerModel alloc]init];
            payModel.videoURL=self.roomBaseInfo.payLiveUrl;
            [self.livePlayer playWithModel:payModel];
            
        }
}
//支持的方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [SupportedInterfaceOrientations sharedInstance].orientationMask;
}

//是否可以旋转
-(BOOL)shouldAutorotate
{
    return YES;
}

/** 播放器全屏 */
- (void)controlViewChangeScreen:(UIView *)controlView withFullScreen:(BOOL)isFullScreen{
        dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    if (isFullScreen) {
        //                [self setInterfaceOrientation2:UIInterfaceOrientationLandscapeLeft];
                        /*
                        [[SupportedInterfaceOrientations sharedInstance]setInterFaceOrientation:UIInterfaceOrientationLandscapeLeft];
                         */
                        [SupportedInterfaceOrientations sharedInstance].orientationMask = UIInterfaceOrientationMaskLandscape;
                        
                        NSNumber *orientationValue = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
                        [[UIDevice currentDevice] setValue:orientationValue forKey:@"orientation"];
                        [UIViewController attemptRotationToDeviceOrientation];
                    }else{
                        
                        [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIInterfaceOrientationPortrait] forKey:@"orientation"];
                        [SupportedInterfaceOrientations sharedInstance].orientationMask = UIInterfaceOrientationMaskPortrait;
                        
                        NSNumber *orientationValue = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
                        [[UIDevice currentDevice] setValue:orientationValue forKey:@"orientation"];
                        [UIViewController attemptRotationToDeviceOrientation];
        //                [self setInterfaceOrientation:UIDeviceOrientationPortrait];
        //                [self setInterfaceOrientation2:UIInterfaceOrientationPortrait];
                        /*
                        [[SupportedInterfaceOrientations sharedInstance]setInterFaceOrientation:UIInterfaceOrientationPortrait];
                         */
                        
                    }
                });
    
}
#pragma mark - getter ======
-(UIView *)containerView{
    if (!_containerView) {
        _containerView=[[UIView alloc]init];
    }
    return _containerView;
}
-(UIView *)videoContainerView{
    if (!_videoContainerView) {
        _videoContainerView=[[UIView alloc]init];
    }
    return _videoContainerView;
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
