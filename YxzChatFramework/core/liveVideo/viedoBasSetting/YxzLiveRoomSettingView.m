//
//  YxzLiveRoomSettingView.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/30.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzLiveRoomSettingView.h"
#import <Masonry/Masonry.h>
#import "YXZConstant.h"
#import "NSString+Empty.h"
@interface YxzLiveRoomSettingView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIView *containerView;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation YxzLiveRoomSettingView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setPlayRate:(NSString *)playRate sharpness:(NSString *)sharpness{
    _dataSouce=[[NSMutableArray alloc]init];
    RoomSettingModel *sharpnesM=[[RoomSettingModel alloc]init];
    sharpnesM.title=@"分辨率";
    sharpnesM.logImg=@"setting";
    if (![NSString isEmpty:sharpness]) {
        sharpnesM.subTitle=sharpness;
    }
    [_dataSouce addObject:sharpnesM];
    RoomSettingModel *playM=[[RoomSettingModel alloc]init];
    playM.title=@"播放速度";
    playM.logImg=@"bofang";
    if (![NSString isEmpty:sharpness]) {
        playM.subTitle=sharpness;
    }
    [_dataSouce addObject:playM];
    RoomSettingModel *shareM=[[RoomSettingModel alloc]init];
    shareM.title=@"分享";
    shareM.logImg=@"share";
    [_dataSouce addObject:shareM];
    RoomSettingModel *jubaoM=[[RoomSettingModel alloc]init];
    jubaoM.title=@"举报";
    jubaoM.logImg=@"jubao";
    [_dataSouce addObject:jubaoM];
    [self.tableView reloadData];
}
-(void)setupView{
    self.backgroundColor=[UIColor clearColor];
    [self addSubview:self.containerView];
    [self.containerView addSubview:self.tableView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
        make.height.equalTo(self.mas_height).multipliedBy(0.45);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self.containerView);
    }];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataSouce) {
        return self.dataSouce.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveRoomSettingCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LiveRoomSettingCell"];
    RoomSettingModel *model=self.dataSouce[indexPath.row];
    cell.settingModel=model;
    return cell;
}

-(UITableView *)tableView{
    if (!_tableView) {
       _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor=baseBlackColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollEnabled=YES;
        //_tableView.estimatedRowHeight = 40;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive|UIScrollViewKeyboardDismissModeOnDrag;
        
        _tableView.tableFooterView = [UIView new];
        _tableView.sectionFooterHeight = 0;
        _tableView.sectionHeaderHeight = 0;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[LiveRoomSettingCell class] forCellReuseIdentifier:@"LiveRoomSettingCell"];
    
    }
    return _tableView;
}
-(UIView *)containerView{
    if (!_containerView) {
        _containerView=[[UIView alloc]init];
        _containerView.backgroundColor=baseBlackColor;
        _containerView.userInteractionEnabled=YES;
    }
    return _containerView;
}
@end

//=======================  setting cell =======================
@interface LiveRoomSettingCell()
@property (nonatomic,strong)UIImageView *logImageView;
@property (nonatomic,strong)UILabel *mTitleLable;
@property (nonatomic,strong)UILabel *subTitleLabel;
@end
@implementation LiveRoomSettingCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    self.backgroundColor=baseBlackColor;
    [self addSubview:self.logImageView];
    [self addSubview:self.mTitleLable];
    [self addSubview:self.subTitleLabel];
    
    [self.logImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.width.height.mas_equalTo(25);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    [self.mTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        
        make.left.equalTo(self.logImageView.mas_right).offset(15);
    }];
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        
        make.left.equalTo(self.mTitleLable.mas_right).offset(10);
    }];
}
-(void)setSettingModel:(RoomSettingModel *)settingModel{
    _settingModel=settingModel;
    self.logImageView.image=YxzSuperPlayerImage(settingModel.logImg);
    self.mTitleLable.text=settingModel.title;
    self.subTitleLabel.text=settingModel.subTitle?settingModel.subTitle:@"";
}
-(UIImageView *)logImageView{
    if (!_logImageView) {
        _logImageView=[[UIImageView alloc]init];
    }
    return _logImageView;
}
-(UILabel *)mTitleLable{
    if (!_mTitleLable) {
        _mTitleLable=[[UILabel alloc]init];
        _mTitleLable.font=[UIFont systemFontOfSize:15];
        _mTitleLable.textColor=[UIColor whiteColor];
    }
    return _mTitleLable;
}
-(UILabel *)subTitleLabel{
    if (!_subTitleLabel) {
        _subTitleLabel=[[UILabel alloc]init];
        _subTitleLabel.font=[UIFont systemFontOfSize:12];
        _subTitleLabel.textColor=RGBA_OF(0x75759);
    }
    return _subTitleLabel;
}
@end
@implementation RoomSettingModel

@end
