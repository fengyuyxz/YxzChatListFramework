//
//  LivePlayerController.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/27.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "LivePlayerController.h"
@interface LivePlayerController()<TXLivePlayListener>

@end
@implementation LivePlayerController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _livePlayer=[[TXLivePlayer alloc] init];
        _livePlayer.delegate=self;
    }
    return self;
}
-(void)setPlayerViewToContainerView:(UIView *)containerView{
    [self.livePlayer setupVideoWidget:CGRectMake(0, 0, 0, 0) containView:containerView insertIndex:0];
}
-(void)play:(NSString *)playUrlStr{
    [self.livePlayer startPlay:playUrlStr type:PLAY_TYPE_VOD_MP4];
}
-(void)stop{
    if (self.livePlayer.isPlaying) {
        [self.livePlayer stopPlay];
    }
    [self.livePlayer removeVideoWidget];
}
/**
 * 直播事件通知
 * @param EvtID 参见 TXLiveSDKEventDef.h
 * @param param 参见 TXLiveSDKTypeDef.h
 */
- (void)onPlayEvent:(int)EvtID withParam:(NSDictionary *)param{
    
}

/**
 * 网络状态通知
 * @param param 参见 TXLiveSDKTypeDef.h
 */
- (void)onNetStatus:(NSDictionary *)param{
    
}
@end
