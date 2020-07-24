//
//  YxzInputBoxView.m
//  YxzChatFramework
//
//  Created by 颜学宙 on 2020/7/23.
//  Copyright © 2020 颜学宙. All rights reserved.
//

#import "YxzInputBoxView.h"
#import "YxzGetBundleResouceTool.h"
#import "YXZConstant.h"
#define MORE_BUT_CONTAINER_WIDTH 50
#define INPUT_CONTAINER_MIN_SPCE 5
#define INPUT_CONTAINER_INNER_MIN_SPCE 4

#define MORE_BUT_WIDTH 30

@interface YxzInputBoxView()<YYTextViewDelegate>
@property(nonatomic,strong)UIButton *faceBut;
@property(nonatomic,strong)UIButton *moreBut;
@property(nonatomic,strong)UIView *inputContainerView;

@property(nonatomic,assign)CGRect keyboardFrame;
@property(nonatomic,assign)YxzInputStatus lastInputStatus;
@end
@implementation YxzInputBoxView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupSubViews];
        [self addKeyboardEventListen];
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}
-(void)addKeyboardEventListen{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 键盘的Frame值即将发生变化的时候创建的额监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

}

-(void)setupSubViews{
    self.backgroundColor=[UIColor whiteColor];
    self.inputStatus=YxzInputStatus_nothing;

    
        
    [self addSubview:self.inputContainerView];
    
    [self addSubview:self.moreBut];
    
    
    [_inputContainerView addSubview:self.textView];
    [_inputContainerView addSubview:self.faceBut];
    CGRect inputContainerFrame=CGRectMake(INPUT_CONTAINER_MIN_SPCE, INPUT_CONTAINER_MIN_SPCE, self.bounds.size.width-MORE_BUT_CONTAINER_WIDTH, CGRectGetHeight(self.bounds)-INPUT_CONTAINER_MIN_SPCE*2);
    self.inputContainerView.frame=inputContainerFrame;
    CGFloat faceWidth=CGRectGetHeight(inputContainerFrame)-INPUT_CONTAINER_INNER_MIN_SPCE*2;
    CGRect faceRect=CGRectMake(CGRectGetWidth(inputContainerFrame)-faceWidth-INPUT_CONTAINER_INNER_MIN_SPCE*2, INPUT_CONTAINER_INNER_MIN_SPCE, faceWidth, faceWidth);
    self.faceBut.frame=faceRect;
    CGRect textFrame=CGRectMake(INPUT_CONTAINER_INNER_MIN_SPCE, INPUT_CONTAINER_INNER_MIN_SPCE,faceRect.origin.x-INPUT_CONTAINER_INNER_MIN_SPCE*2, faceWidth);
    self.textView.frame=textFrame;
    YxzViewRadius(_inputContainerView,CGRectGetHeight(_inputContainerView.bounds)/2.0f);
    
    CGRect moreFrame=CGRectMake(CGRectGetWidth(self.bounds)-MORE_BUT_CONTAINER_WIDTH+(MORE_BUT_CONTAINER_WIDTH - MORE_BUT_WIDTH)/2.0f, CGRectGetHeight(self.bounds)/2.0f-MORE_BUT_WIDTH/2.0f, MORE_BUT_WIDTH, MORE_BUT_WIDTH);
    self.moreBut.frame=moreFrame;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}


#pragma mark - 键盘通知事件 ============
-(void)keyboardWillShow:(NSNotification *)notify{
    
}
-(void)keyboardWillHide:(NSNotification *)notify{
    
}
-(void)keyboardFrameWillChange:(NSNotification *)notification{
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.inputStatus==YxzInputStatus_keyborad&&CGRectGetHeight(self.keyboardFrame)<=inputBoxDefaultHight) {
        return;
    }
    else if ((self.inputStatus == YxzInputStatus_showFace || self.inputStatus == YxzInputStatus_showMore)  &&CGRectGetHeight(self.keyboardFrame)<inputBoxDefaultHight) {
          
          return;
          
      }
    CGFloat hight = inputBoxDefaultHight;
    
    if (self.inputStatus==YxzInputStatus_keyborad) {
        hight+=CGRectGetHeight(self.keyboardFrame);
    }else if (self.inputStatus==YxzInputStatus_showFace){
        
    }
    
    if ([self.delegate respondsToSelector:@selector(inputBoxStatusChange:changeFromStatus:toStatus:changeHight:)]) {
        [self.delegate inputBoxStatusChange:self changeFromStatus:self.lastInputStatus toStatus:self.inputStatus changeHight:hight];
    }
}
#pragma mark - textView delegate ========================
- (BOOL)textViewShouldBeginEditing:(YYTextView *)textView{
    self.lastInputStatus=self.inputStatus;
    self.inputStatus=YxzInputStatus_keyborad;
    return YES;
}
-(void)textViewDidBeginEditing:(YYTextView *)textView{
    self.lastInputStatus=self.inputStatus;
    self.inputStatus=YxzInputStatus_keyborad;
}
- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
/**
 *  TextView 的输入内容一改变就调用这个方法，
 *
 *  @param textView
 */
- (void) textViewDidChange:(YYTextView *)textView{
    if ([self.delegate respondsToSelector:@selector(clientInputing:)]) {
           [self.delegate clientInputing:YES];
       }
}

#pragma mark - but event  ===============================
-(void)faceButPressed:(UIButton *)but{
    self.lastInputStatus=self.inputStatus;
    but.selected=!but.selected;
    if (but.selected) {
        self.moreBut.selected=NO;
        self.inputStatus=YxzInputStatus_showFace;
        [self.textView resignFirstResponder];
    }else{
        self.inputStatus=YxzInputStatus_keyborad;
        [self.textView becomeFirstResponder];
    }
    
  
}
-(void)moreButPressed:(UIButton *)but{
    but.selected=!but.selected;
    if (but.selected) {
        self.faceBut.selected=NO;
        self.inputStatus=YxzInputStatus_showMore;
        [self.textView resignFirstResponder];
        
    }else{
        self.inputStatus=YxzInputStatus_keyborad;
        [self.textView becomeFirstResponder];
    }
    
    if (!but.selected) {
        
    }else{
        
    }

}


#pragma mark -getter ======================
-(UIView *)inputContainerView{
    if (!_inputContainerView) {
        _inputContainerView=[[UIView alloc]init];
        _inputContainerView.backgroundColor=RGBAOF(0x000000,0.25);
    }
    return _inputContainerView;
}
-(YYTextView *)textView{
    if (!_textView) {
        _textView=[[YYTextView alloc]init];
        _textView.placeholderText=@"点击输入内容...";
        _textView.backgroundColor=[UIColor clearColor];
        _textView.delegate=self;
        [_textView setFont:[UIFont systemFontOfSize:16.0f]];
        
        [_textView setScrollsToTop:NO];
    }
    return _textView;
}
-(UIButton *)faceBut{
    if (!_faceBut) {
        _faceBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [_faceBut setBackgroundImage:[[YxzGetBundleResouceTool shareInstance]getImageWithImageName:@"faceTool"] forState:UIControlStateNormal];
        [_faceBut setBackgroundImage:[[YxzGetBundleResouceTool shareInstance]getImageWithImageName:@"icon_del"] forState:UIControlStateSelected];
        [_faceBut addTarget:self action:@selector(faceButPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _faceBut;
}
-(UIButton *)moreBut{
    if (!_moreBut) {
        _moreBut=[UIButton buttonWithType:UIButtonTypeCustom];
        [_moreBut setBackgroundImage:[[YxzGetBundleResouceTool shareInstance]getImageWithImageName:@"moreTool"] forState:UIControlStateNormal];
        [_moreBut setBackgroundImage:[[YxzGetBundleResouceTool shareInstance]getImageWithImageName:@"icon_del"] forState:UIControlStateSelected];
        [_moreBut addTarget:self action:@selector(moreButPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBut;
}
@end

