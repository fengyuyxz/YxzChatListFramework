//
//  YxzLiveVideoContainerView.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/26.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzLiveVideoContainerView.h"
#import "YxzVideoLooksBasicInfoView.h"
#import "YXZConstant.h"
#import <Masonry/Masonry.h>
#import "TXLiteAVSDK_Professional/TXLivePlayer.h"
@interface YxzLiveVideoContainerView()
@property(nonatomic,strong)YxzVideoLooksBasicInfoView *basicInfoView;

@property(nonatomic,strong)TXLivePlayer *txLivePlayer;
@end
@implementation YxzLiveVideoContainerView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    self.backgroundColor=baseBlackColor;
    [self addSubview:self.basicInfoView];
    [self addSubview:self.videoContainerView];
    _txLivePlayer = [[TXLivePlayer alloc] init];
    [_txLivePlayer setupVideoWidget:CGRectZero containView:self.videoContainerView insertIndex:0];
    
    [self layoutSubViewConstraint];
}
-(void)layoutSubViewConstraint{
    [self.basicInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
        make.height.equalTo(@(70));
    }];
    [self.videoContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.basicInfoView.mas_top);
    }];
}

-(void)playLive:(NSString *)url{
    
}

-(UIView *)videoContainerView{
    if (!_videoContainerView) {
        _videoContainerView=[[UIView alloc]init];
    }
    return _videoContainerView;
}
-(YxzVideoLooksBasicInfoView *)basicInfoView{
    if (!_basicInfoView) {
        _basicInfoView=[[YxzVideoLooksBasicInfoView alloc]init];
    }
    return _basicInfoView;
}
@end
