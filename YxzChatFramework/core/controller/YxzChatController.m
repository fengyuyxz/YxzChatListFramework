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
#import "SupportedInterfaceOrientations.h"
#import <Masonry/Masonry.h>
#import "YxzLiveRoomSettingView.h"
#import "YxzLivePlayer.h"
#import "YxzPopView.h"
#import "LiveRoomSettingSeparationView.h"
#import "VoteView.h"
@interface YxzChatController ()<YxzLiveRoomControlDelegate,YxzPlayerDelegate,UIGestureRecognizerDelegate>


@property(nonatomic,strong)UIView *containerView;//容器 用于做旋转
@property(nonatomic,strong)YxzChatCompleteComponent *chatComponentView;
@property(nonatomic,strong)UIView *videoContainerView;
@property(nonatomic,strong)YxzVideoLooksBasicInfoView *basInfoView;
@property(nonatomic,strong)YxzLivePlayer *livePlayer;
@property(nonatomic,assign)BOOL isFullScreen;

@property(nonatomic,strong)UIView *topToolView;

@property(nonatomic,strong)UIButton *moreBut;
@property(nonatomic,strong)UIButton *suspensionBut;
@property(nonatomic,strong)UIButton *fullScreenBtn;
@property(nonatomic,strong)UIButton *backBut;
/** 单击 */
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
/** 双击 */
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;


@property(nonatomic,strong)YxzPlayerModel *playerModel;

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
        if (!YxzSuperPlayerWindowShared.isShowing) {
            [self.livePlayer resetPlayer];
        }
    }
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    [self setupSubView];
    
    [[SupportedInterfaceOrientations sharedInstance]beginSupport];
    [[SupportedInterfaceOrientations sharedInstance]setInterFaceOrientation:UIInterfaceOrientationPortrait];
   
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


#pragma mark 强制横屏(针对present方式)
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


-(void)setupSubView{
    [self.view addSubview:self.containerView];
    [self.containerView addSubview:self.basInfoView];
    [self.containerView addSubview:self.videoContainerView];
    _chatComponentView=[[YxzChatCompleteComponent alloc]initWithFrame:self.view.bounds];
    [self.containerView addSubview:_chatComponentView];
    self.livePlayer.fatherView=self.videoContainerView;
    [self addGesture];
    
    [self.containerView addSubview:self.topToolView];
    [self.topToolView addSubview:self.moreBut];
    [self.topToolView addSubview:self.suspensionBut];
    [self.containerView addSubview:self.fullScreenBtn];
    [self.topToolView addSubview:self.backBut];
}
-(void)setRoomBaseInfo:(RoomBaseInfo *)roomBaseInfo{
    _roomBaseInfo=roomBaseInfo;
    _playerModel=[[YxzPlayerModel alloc]init];
    _playerModel.videoURL=self.roomBaseInfo.payLiveUrl;
    NSMutableArray *paArray=[NSMutableArray array];
           for (RoomPlayUrlModel *p in self.roomBaseInfo.playList) {
               SuperPlayerUrl * sp=[SuperPlayerUrl new];
               sp.title=p.title;
               sp.url=p.playUrl;
               [paArray addObject:sp];
           }
    _playerModel.multiVideoURLs=paArray;
}
-(void)startPlayAndJoinChatRoom{
   
    [self.livePlayer playWithModel:self.playerModel];
        
    
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
        make.height.equalTo(@(280));
    }];
    [self.chatComponentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left);
        make.top.equalTo(self.videoContainerView.mas_bottom).offset(70);
               make.right.equalTo(self.containerView.mas_right);
        make.bottom.equalTo(self.containerView.mas_bottom);
    }];
    
    [self.topToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.containerView);
        if (IPHONE_X) {
            make.height.mas_equalTo(74);
        }else{
            make.height.mas_equalTo(50);
        }
    }];
    [self.suspensionBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topToolView.mas_bottom).offset(-10);
        make.right.equalTo(self.topToolView.mas_right).offset(-15);
        make.height.mas_equalTo(25);
        make.width.mas_equalTo(20);
    }];
    [self.moreBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.suspensionBut.mas_centerY);
        make.width.height.mas_equalTo(25);
        make.right.equalTo(self.suspensionBut.mas_left).offset(-15);
    }];
    [self.fullScreenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(25);
        make.right.equalTo(self.containerView.mas_right).offset(-10);
        make.bottom.equalTo(self.videoContainerView.mas_bottom).offset(-10);
    }];
    [self.backBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.suspensionBut.mas_centerY);
        make.width.height.mas_equalTo(25);
        make.left.equalTo(self.topToolView.mas_left).offset(15);
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
            make.height.equalTo(@(280));
        }];
        [self.chatComponentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.containerView.mas_left);
            make.top.equalTo(self.videoContainerView.mas_bottom).offset(70);
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
-(void)suspensionButPressed:(UIButton *)but{
    YxzSuperPlayerWindowShared.superPlayer=self.livePlayer;
    YxzSuperPlayerWindowShared.backController=self;
    [YxzSuperPlayerWindowShared show];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)backButPressed:(UIButton *)but{
    if (self.isFullScreen) {
        self.fullScreenBtn.selected=!self.fullScreenBtn.selected;
        self.isFullScreen=self.fullScreenBtn.selected;
        [self switchFull:self.isFullScreen compelation:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
            });
        }];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)moreBtuPressed:(UIButton *)but{
    
    [self.chatComponentView hiddenTheKeyboardAndFace:^{
        YxzLiveRoomSettingView *view=[[YxzLiveRoomSettingView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height*0.45)];
        RoomSettingHeadeModel *headerModel=[RoomSettingHeadeModel new];
        headerModel.headerImgUrlStr=@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1596198002372&di=9f36c7199fb31f01eed130acdae394ec&imgtype=0&src=http%3A%2F%2Fgss0.baidu.com%2F7Po3dSag_xI4khGko9WTAnF6hhy%2Fzhidao%2Fpic%2Fitem%2F267f9e2f07082838685c484ab999a9014c08f11f.jpg";
        headerModel.s_title=@"add";
        headerModel.m_title=@"天下无贼";
        [view setHeader:headerModel sharpness:@"标准"];
        
         YxzPopView *popView=[[YxzPopView alloc]initWithFrame:self.view.bounds];
        __weak typeof(self) weakSelf =self;
        view.block = ^(LiveRoomSeetingEnum setting) {
            __strong typeof(weakSelf) strongSelf =weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
                [popView dismiss];
                if (setting==liveRoomSeeting_separation) {
                    [strongSelf popSeparationView];
                }else if(setting==liveRoomSeeting_share){
                    [strongSelf popVote];
                }
            });
            
        };
         [popView show:view superView:self.view];
    }];
    
    
}
-(void)popVote{
    
    VoteItemModel *item1=[VoteItemModel new];
    item1.title=@"唱歌";
    item1.imgeUrlStr=@"https://t7.baidu.com/it/u=3616242789,1098670747&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1596951525&t=3ce06a68d37777a94af82d99bb56c185";
    VoteItemModel *item2=[VoteItemModel new];
    item2.title=@"唱歌";
    item2.imgeUrlStr=@"https://t7.baidu.com/it/u=3616242789,1098670747&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1596951525&t=3ce06a68d37777a94af82d99bb56c185";
    VoteItemModel *item3=[VoteItemModel new];
    item3.title=@"唱歌";
    item3.imgeUrlStr=@"https://t7.baidu.com/it/u=3616242789,1098670747&fm=79&app=86&size=h300&n=0&g=4n&f=jpeg?sec=1596951525&t=3ce06a68d37777a94af82d99bb56c185";
    
    VoteView *vote=[[VoteView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
    vote.dataSouce=[@[item1,item2,item3]mutableCopy];
    PopVoteView *pop=[[PopVoteView alloc]initWithFrame:self.view.bounds];
    vote.block = ^{
        [pop dismiss];
    };
    [pop show:vote superView:self.view];
}
-(void)popSeparationView{
    if (self.playerModel.multiVideoURLs&&self.playerModel.multiVideoURLs.count>1) {
        LiveRoomSettingSeparationView *separationView=[[LiveRoomSettingSeparationView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 180)];
        separationView.playerModel=self.playerModel;
        YxzPopView *popView=[[YxzPopView alloc]initWithFrame:self.view.bounds];
        __weak typeof(self) weakSelf =self;
        separationView.block = ^(NSString *title, NSString *url) {
            __strong typeof(weakSelf) strongSelf =weakSelf;
            dispatch_async(dispatch_get_main_queue(), ^{
//                strongSelf.playerModel.playingDefinition=title;
                [strongSelf.livePlayer switchSeparation:title];
                [popView dismiss];
            });
        };
        
        [popView show:separationView superView:self.view];
    }
}

-(void)fullScreenBtnClick:(UIButton *)but{
    but.selected=!but.selected;
    self.livePlayer.isFullScreen=but.selected;
    self.isFullScreen=but.selected;
    
    [self switchFull:self.isFullScreen compelation:nil];
       /*
         [self modifyLeftSapcen:self.isFullScreen];
       [self.chatComponentView hiddenTheKeyboardAndFace:^{
           dispatch_async(dispatch_get_main_queue(), ^{
               
               
               if (self.isFullScreen) {

                   
                   [[SupportedInterfaceOrientations sharedInstance]setInterFaceOrientation:UIInterfaceOrientationLandscapeLeft];
                    
                  
               }else{
                  
                   [[SupportedInterfaceOrientations sharedInstance]setInterFaceOrientation:UIInterfaceOrientationPortrait];
                    
                   
               }
           });
       }];*/
}

-(void)switchFull:(BOOL)isFull compelation:(void(^)(void))block{
    [self modifyLeftSapcen:isFull];
    
    [self.chatComponentView hiddenTheKeyboardAndFace:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if (isFull) {

                
                [[SupportedInterfaceOrientations sharedInstance]setInterFaceOrientation:UIInterfaceOrientationLandscapeLeft];
                 
               
            }else{
               
                [[SupportedInterfaceOrientations sharedInstance]setInterFaceOrientation:UIInterfaceOrientationPortrait];
                 
                
            }
            if (block) {
                block();
            }
        });
    }];
}
/** 播放器全屏 */
- (void)controlViewChangeScreen:(UIView *)controlView withFullScreen:(BOOL)isFullScreen{
    
   
    
    
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
//        _livePlayer.playerConfig.playShiftDomain = @"liteavapp.timeshift.qcloud.com";
    }
    return _livePlayer;
}


- (UIButton *)fullScreenBtn {
    if (!_fullScreenBtn) {
        _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenBtn setImage:YxzSuperPlayerImage(@"fullscreen") forState:UIControlStateNormal];
        [_fullScreenBtn setImage:YxzSuperPlayerImage(@"wb_fullscreen_back") forState:UIControlStateSelected];
        [_fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fullScreenBtn;
}
-(UIButton *)moreBut{
    if (!_moreBut) {
        _moreBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBut setImage:YxzSuperPlayerImage(@"gengduo") forState:UIControlStateNormal];
        [_moreBut addTarget:self action:@selector(moreBtuPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBut;
}
-(UIButton *)suspensionBut{
    if (!_suspensionBut) {
        
        _suspensionBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [_suspensionBut setImage:YxzSuperPlayerImage(@"xiangxia") forState:UIControlStateNormal];
        [_suspensionBut addTarget:self action:@selector(suspensionButPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _suspensionBut;
}
-(UIButton *)backBut{
    if (!_backBut) {
        _backBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [_backBut setImage:YxzSuperPlayerImage(@"back_full") forState:UIControlStateNormal];
        [_backBut addTarget:self action:@selector(backButPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBut;
}
-(UIView *)topToolView{
    if (!_topToolView) {
        _topToolView=[[UIView alloc]init];
        _topToolView.backgroundColor=[UIColor clearColor];
    }
    return _topToolView;
}
@end
