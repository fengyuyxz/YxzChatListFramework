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
@interface YxzLiveRoomSettingView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation YxzLiveRoomSettingView




- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    self.backgroundColor=baseBlackColor;
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(self);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LiveRoomSettingCell *cell=[tableView dequeueReusableCellWithIdentifier:@"LiveRoomSettingCell"];
    return cell;
}

-(UITableView *)tableView{
    if (!_tableView) {
       _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
        
    
    }
    return _tableView;
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
