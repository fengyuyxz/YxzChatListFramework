//
//  LivePlayerController.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/27.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "LivePlayerController.h"
#import <pthread.h>
@interface LivePlayerController()<TXLivePlayListener>

@end
@implementation LivePlayerController
static LivePlayerController *sharedInstance = nil;
static pthread_mutex_t sharedInstanceLock;
+ (void)load {
    pthread_mutex_init(&sharedInstanceLock, NULL);
}
+ (instancetype)sharedInstance {
    if (sharedInstance == nil) {
        pthread_mutex_lock(&sharedInstanceLock);
        if (sharedInstance == nil) {
            
            sharedInstance = [[LivePlayerController alloc] init];
            NSLog(@"sharedInstance<%p> is created", sharedInstance);
        }
        pthread_mutex_unlock(&sharedInstanceLock);
    }
    return sharedInstance;
}

+ (void)destorySharedInstance {
    pthread_mutex_lock(&sharedInstanceLock);
    if (sharedInstance) {
        
        NSLog(@"sharedInstance<%p> is destroyed", sharedInstance);
        sharedInstance = nil;
    }
    pthread_mutex_unlock(&sharedInstanceLock);
}


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
-(void)setRotatStyle:(YxzLiveVideoScreenStyle)style{
    TX_Enum_Type_HomeOrientation orentation=HOME_ORIENTATION_DOWN;
    if (style==YxzLiveVideoScreenStyle_portarait) {
        orentation=HOME_ORIENTATION_DOWN;
    }else{
        orentation=HOME_ORIENTATION_RIGHT;
    }
    [self.livePlayer setRenderRotation:orentation];
}
-(void)play:(NSString *)playUrlStr{
    [self.livePlayer startPlay:playUrlStr type:PLAY_TYPE_VOD_MP4];
}
-(void)stop{
    if (self.livePlayer.isPlaying) {
        [self.livePlayer stopPlay];
    }
    [self.livePlayer removeVideoWidget];
//    _livePlayer=nil;
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
