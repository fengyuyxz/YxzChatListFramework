//
//  YxzChatController.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/23.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzChatController.h"
#import "YxzChatCompleteComponent.h"
#import "YxzLiveVideoContainerView.h"
#import "LivePlayerController.h"
#import <Masonry/Masonry.h>
@interface YxzChatController ()
@property(nonatomic,strong)YxzChatCompleteComponent *chatComponentView;
@property(nonatomic,strong)YxzLiveVideoContainerView *videoContainerView;
@property(nonatomic,strong)LivePlayerController *livePlayerController;//直播控制器
@end

@implementation YxzChatController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:self.videoContainerView];
    _chatComponentView=[[YxzChatCompleteComponent alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_chatComponentView];
    [self.livePlayerController setPlayerViewToContainerView:self.videoContainerView.videoContainerView];
     [self layoutSubViewConstraint];
    [self startPlayAndJoinChatRoom];
}

-(void)startPlayAndJoinChatRoom{
    if (self.roomBaseInfo) {
        [self.livePlayerController play:self.roomBaseInfo.payLiveUrl];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    [self.livePlayerController setPlayerViewToContainerView:self.videoContainerView.videoContainerView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.navigationController) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
}
-(void)layoutSubViewConstraint{
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
-(YxzLiveVideoContainerView *)videoContainerView{
    if (!_videoContainerView) {
        _videoContainerView=[[YxzLiveVideoContainerView alloc]init];
    }
    return _videoContainerView;
}
-(LivePlayerController *)livePlayerController{
    if (!_livePlayerController) {
        _livePlayerController=[[LivePlayerController alloc]init];
    }
    return _livePlayerController;
}
@end
