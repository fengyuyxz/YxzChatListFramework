//
//  LivePlayerController.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/27.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "LivePlayerController.h"

@implementation LivePlayerController
- (instancetype)init
{
    self = [super init];
    if (self) {
        _livePlayer=[[TXLivePlayer alloc] init];
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
    
}
@end
