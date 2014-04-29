//
//  JSMessagesViewController.m
//
//  Created by Jesse Squires on 2/12/13.
//  Copyright (c) 2013 Hexed Bits. All rights reserved.
//
//  http://www.hexedbits.com
//
//
//  Largely based on work by Sam Soffes
//  https://github.com/soffes
//
//  SSMessagesViewController
//  https://github.com/soffes/ssmessagesviewcontroller
//
//
//  The MIT License
//  Copyright (c) 2013 Jesse Squires
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the
//  following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
//  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
//  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
//  OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "JSMessagesViewController.h"
#import "NSString+JSMessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "UIColor+JSMessagesView.h"
#import "JSDismissiveTextView.h"
#import "EmojiView.h"
#import "OtherView.h"
#import "WLConstants.h"
#import "Emoji.h"

#define INPUT_HEIGHT     46.0f

#define ANIMATION_TIME   0.25
#define KEYBOARD_HEIGHT 216

typedef enum {
    INPUT_VIEW_STATUS_NORMAL = 0,
    INPUT_VIEW_STATUS_EMOJI,
    INPUT_VIEW_STATUS_OTHER
}INPUT_VIEW_STATUS;

@interface JSMessagesViewController () <JSDismissiveTextViewDelegate>
{
    UIButton *recoderBtn;
    INPUT_VIEW_STATUS status;
    UIButton* mediaButton;    //录音
    UIButton *emoji;          //表情
    UIButton *others;
    
    BOOL isNull;           //是否为空
}

@property (nonatomic, strong) EmojiView *emojiView;
@property (nonatomic, strong) OtherView *otherView;

- (void)setup;

@end



@implementation JSMessagesViewController

#pragma mark - Initialization
- (void)setup
{
    if([self.view isKindOfClass:[UIScrollView class]]) {
        // fix for ipad modal form presentations
        ((UIScrollView *)self.view).scrollEnabled = NO;
    }
    
    CGSize size = self.view.frame.size;
    
    int yorigin = 0;
    if (IS_OS_7_OR_LATER) {
        yorigin = 64;
    }
	
    CGRect tableFrame = CGRectMake(0.0f, yorigin, size.width, size.height - INPUT_HEIGHT - yorigin);
	self.tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
	self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	self.tableView.dataSource = self;
	self.tableView.delegate = self; 
	[self.view addSubview:self.tableView];
	
    //额外的...
	if (kAllowsMedia)
	{

        //*************     录音     **********************************************
		UIImage* image = [UIImage imageNamed:@"chat_add"];
		CGRect frame = CGRectMake(4, 0, image.size.width, image.size.height);
		CGFloat yHeight = (INPUT_HEIGHT - frame.size.height) / 2.0f;
		frame.origin.y = yHeight;
		
		// make the button
		mediaButton = [[UIButton alloc] initWithFrame:frame];
        [mediaButton setImage:[UIImage imageNamed:@"chat_add"] forState:UIControlStateNormal];
        [mediaButton setImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
		// button action
		[mediaButton addTarget:self action:@selector(recodingAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //*************     +     **********************************************
        UIImage *othersimage  = [UIImage imageNamed:@"chat_add"];
        CGRect othersframe    = CGRectMake(320 - 4 - othersimage.size.width, 0, othersimage.size.width, othersimage.size.height);
        CGFloat othersHeight = (INPUT_HEIGHT - othersframe.size.height) / 2.0f;
        othersframe.origin.y  = othersHeight;
		
		// make the button
		others = [[UIButton alloc] initWithFrame:othersframe];
        
        [others setImage:[UIImage imageNamed:@"chat_add"] forState:UIControlStateNormal];
        //        [others setImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
		
		[others addTarget:self action:@selector(othersAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        //*************     表情     **********************************************
        UIImage *emoimage  = [UIImage imageNamed:@"chat_emotion"];
        CGRect emoframe    =         CGRectMake(othersframe.origin.x - emoimage.size.width - 10, 0, emoimage.size.width, emoimage.size.height);//CGRectMake(320 - 4 - emoimage.size.width, 0, emoimage.size.width, emoimage.size.height);

        CGFloat emoyHeight = (INPUT_HEIGHT - emoframe.size.height) / 2.0f;
        emoframe.origin.y  = emoyHeight;
		
		emoji = [[UIButton alloc] initWithFrame:emoframe];


		[emoji setImage:[UIImage imageNamed:@"chat_emotion"] forState:UIControlStateNormal];
        [emoji setImage:[UIImage imageNamed:@"chat_keyboard"] forState:UIControlStateSelected];
        
		// button action
		[emoji addTarget:self action:@selector(emojiAction:) forControlEvents:UIControlEventTouchUpInside];
      
         
	}
	
    CGRect inputFrame = CGRectMake(0.0f, size.height - INPUT_HEIGHT, size.width, INPUT_HEIGHT);
    self.inputToolBarView = [[JSMessageInputView alloc] initWithFrame:inputFrame delegate:self];
    // TODO: refactor
    self.inputToolBarView.textView.dismissivePanGestureRecognizer = self.tableView.panGestureRecognizer;
    self.inputToolBarView.textView.keyboardDelegate = self;
    
    self.inputToolBarView.textView.placeHolder = @"说点什么呢？";
    
    [self.view addSubview:self.inputToolBarView];
    
    
	if (kAllowsMedia)
	{
		// adjust the size of the send button to balance out more with the camera button on the other side.
		CGRect frame = self.inputToolBarView.sendButton.frame;
		frame.size.width -= 16;
		frame.origin.x += 16;
		self.inputToolBarView.sendButton.frame = frame;
		
		// add the camera button
		[self.inputToolBarView addSubview:mediaButton];
        [self.inputToolBarView addSubview:emoji];
        [self.inputToolBarView addSubview:others];
        self.inputToolBarView.sendButton.hidden = YES;

		// move the tet view over
		frame = self.inputToolBarView.textView.frame;
        
		frame.origin.x += mediaButton.frame.size.width + mediaButton.frame.origin.x;
		frame.size.width = DEVICE_WIDTH - ( mediaButton.frame.size.width + mediaButton.frame.origin.x + emoji.frame.size.width + others.frame.size.width + 14 + 15);
		self.inputToolBarView.textView.frame = frame;
	}
	
    recoderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recoderBtn.hidden = YES;
    recoderBtn.frame = self.inputToolBarView.textView.frame;
    recoderBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    recoderBtn.backgroundColor = [UIColor clearColor];
    [recoderBtn setTitle:@"按住开始录音" forState:UIControlStateNormal];
    [recoderBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    recoderBtn.layer.borderColor = [[UIColor colorWithWhite:.8 alpha:1.0] CGColor];
    recoderBtn.layer.borderWidth = 0.65f;
    recoderBtn.layer.cornerRadius = 6.0f;
    [recoderBtn addTarget:self
                   action:@selector(pressRecoderAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.inputToolBarView addSubview:recoderBtn];
    
    self.selectedMarks = [NSMutableArray new];
    
    [self setBackgroundColor:[UIColor messagesBackgroundColor]];
    
    [self init4Views];
}

- (void)init4Views {
    [self init4EmojiView];
    
    [self init4OtherView];
}

- (void)init4EmojiView {
    self.emojiView = [[EmojiView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, KEYBOARD_HEIGHT)];
    [self.view addSubview:_emojiView];
    [self.emojiView emojiSeleted:^(NSString *emotion) {

        UITextView *textView = self.inputToolBarView.textView;
        if ([emotion isEqualToString:@"删除"]) {
            NSString *newStr;
            if (textView.text.length) {
                if ([[Emoji allEmoji] containsObject:[textView.text substringFromIndex:textView.text.length - 2]]) {
                    newStr = [textView.text substringToIndex:textView.text.length-2];
                }else{
                    newStr = [textView.text substringToIndex:textView.text.length-1];
                }
                textView.text=newStr;
            }
        }else{
            self.inputToolBarView.textView.text = [NSString stringWithFormat:@"%@%@",textView.text,emotion];
        }
    }];
    
    [self.emojiView emojiSend:^{
        if (self.inputToolBarView.textView.text.length) {
            [self sendPressed:nil];
        }
    }];
}


- (void)init4OtherView {
    self.otherView = [[OtherView alloc] initWithFrame:CGRectMake(0, DEVICE_HEIGHT, DEVICE_WIDTH, KEYBOARD_HEIGHT)];
    [self.view addSubview:_otherView];
    
    [self.otherView otherBtnClickBlock:^(UIButton *sender) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            switch (sender.tag) {
                case OtherBtnTypePhoto:
                    if(self.delegate && [self.delegate respondsToSelector:@selector(otherPhotoBtnPressed:)]){
                        [self.delegate otherPhotoBtnPressed:sender];
                    }
                    break;
                case OtherBtnTypeCamera:
                    if(self.delegate && [self.delegate respondsToSelector:@selector(otherCameraBtnPressed:)]){
                        [self.delegate otherCameraBtnPressed:sender];
                    }
                    break;
                default:
                    break;
            }
        });
    }];
}


- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scrollToBottomAnimated:NO];
    
    
    _originalTableViewContentInset = self.tableView.contentInset;
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];
    
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.inputToolBarView resignFirstResponder];
    [self setEditing:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"*** %@: didReceiveMemoryWarning ***", self.class);
}

- (void)dealloc
{
    self.delegate = nil;
    self.dataSource = nil;
    self.tableView = nil;
    self.inputToolBarView = nil;
}

#pragma mark - View rotation
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.tableView reloadData];
    [self.tableView setNeedsLayout];
}

#pragma mark - Actions
- (void)sendPressed:(UIButton *)sender
{
    [self.delegate sendPressed:sender
                      withText:[self.inputToolBarView.textView.text trimWhitespace]];
}


- (void)recodingAction:(UIButton *)sender
{
    status = INPUT_VIEW_STATUS_NORMAL;
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.inputToolBarView.textView resignFirstResponder];
        self.inputToolBarView.textView.hidden = YES;
        recoderBtn.hidden = NO;
        [self keyboardWillBeDismissed];
    } else {
        self.inputToolBarView.textView.hidden = NO;
        recoderBtn.hidden = YES;
    }
        
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(recodingPressed:)]){
        [self.delegate recodingPressed:sender];
    }
}

- (void)emojiAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    status = INPUT_VIEW_STATUS_EMOJI;
    if (sender.selected) {
        if ([self.inputToolBarView.textView isFirstResponder]) {
            [self.inputToolBarView.textView resignFirstResponder];
        }
        
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.emojiView.frame = CGRectMake(0, DEVICE_HEIGHT - KEYBOARD_HEIGHT, DEVICE_WIDTH, KEYBOARD_HEIGHT);
            
            if (Y(_inputToolBarView) != Y(_emojiView) - HEIGHT(self.inputToolBarView)) {
                self.inputToolBarView.frame = CGRectMake(X(_inputToolBarView),
                                                         Y(_emojiView) - HEIGHT(self.inputToolBarView),
                                                         WIDTH(_inputToolBarView),
                                                         HEIGHT(_inputToolBarView));
            }
            
            if (Y(_otherView) != DEVICE_HEIGHT) {
                self.otherView.frame = CGRectMake(0, DEVICE_HEIGHT , DEVICE_WIDTH, KEYBOARD_HEIGHT);
            }
            
            [self adjustTableView:nil];
        }];

    } else {
        [self.inputToolBarView.textView becomeFirstResponder];
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.emojiView.frame = CGRectMake(0, DEVICE_HEIGHT , DEVICE_WIDTH, KEYBOARD_HEIGHT);
            if (Y(_otherView) != DEVICE_HEIGHT) {
                self.otherView.frame = CGRectMake(0, DEVICE_HEIGHT , DEVICE_WIDTH, KEYBOARD_HEIGHT);
            }

        }];
    }
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(emojiPressed:)]){
        [self.delegate emojiPressed:sender];
    }
}

- (void)othersAction:(UIButton *)sender {
    status = INPUT_VIEW_STATUS_OTHER;
    sender.selected = !sender.selected;
    if (sender.selected) {
        if ([self.inputToolBarView.textView isFirstResponder]) {
            [self.inputToolBarView.textView resignFirstResponder];
        }

        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.otherView.frame = CGRectMake(0, DEVICE_HEIGHT - KEYBOARD_HEIGHT, DEVICE_WIDTH, KEYBOARD_HEIGHT);
            if (Y(_inputToolBarView) != Y(_otherView) - HEIGHT(self.inputToolBarView)) {
                self.inputToolBarView.frame = CGRectMake(X(_inputToolBarView),
                                                         Y(_otherView) - HEIGHT(self.inputToolBarView),
                                                         WIDTH(_inputToolBarView),
                                                         HEIGHT(_inputToolBarView));
            }
            if (Y(_emojiView) != DEVICE_HEIGHT) {
                self.emojiView.frame = CGRectMake(0, DEVICE_HEIGHT , DEVICE_WIDTH, KEYBOARD_HEIGHT);
            }
            
            [self adjustTableView:nil];
        }];
    } else {
        [self.inputToolBarView.textView becomeFirstResponder];
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.otherView.frame = CGRectMake(0, DEVICE_HEIGHT , DEVICE_WIDTH, KEYBOARD_HEIGHT);
            if (Y(_emojiView) != DEVICE_HEIGHT) {
                self.emojiView.frame = CGRectMake(0, DEVICE_HEIGHT , DEVICE_WIDTH, KEYBOARD_HEIGHT);
            }

        }];
    }

    if(self.delegate && [self.delegate respondsToSelector:@selector(otherBtnPressed:)]){
        [self.delegate otherBtnPressed:sender];
    }
}

- (void)pressRecoderAction:(UIButton *)sender {
    status = INPUT_VIEW_STATUS_NORMAL;
    if(self.delegate && [self.delegate respondsToSelector:@selector(longPressBtnPressed:)]){
        [self.delegate longPressBtnPressed:sender];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    JSBubbleMediaType mediaType = [self.delegate messageMediaTypeForRowAtIndexPath:indexPath];
    JSAvatarStyle avatarStyle = [self.delegate avatarStyle];
    
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d_%d", type, bubbleStyle, hasTimestamp, hasAvatar, mediaType];
    JSBubbleMessageCell *cell = (JSBubbleMessageCell *)[tableView dequeueReusableCellWithIdentifier:CellID];
    
    if(!cell)
        cell = [[JSBubbleMessageCell alloc] initWithBubbleType:type
                                                   bubbleStyle:bubbleStyle
                                                   avatarStyle:(hasAvatar) ? avatarStyle : JSAvatarStyleNone
                                                     mediaType:mediaType
                                                  hasTimestamp:hasTimestamp
                                               reuseIdentifier:CellID];
    
    if(hasTimestamp)
        [cell setTimestamp:[self.dataSource timestampForRowAtIndexPath:indexPath]];
    
    if(hasAvatar) {
        switch (type) {
            case JSBubbleMessageTypeIncoming:
                [cell setAvatarImage:[self.dataSource avatarImageForIncomingMessage]];
                break;
                
            case JSBubbleMessageTypeOutgoing:
                [cell setAvatarImage:[self.dataSource avatarImageForOutgoingMessage]];
                break;
        }
    }
    
	if (kAllowsMedia)
		[cell setMedia:[self.dataSource dataForRowAtIndexPath:indexPath]];
    
    [cell setMessage:[self.dataSource textForRowAtIndexPath:indexPath]];
    [cell setBackgroundColor:tableView.backgroundColor];
    
    
    cell.isSelected = [self.selectedMarks containsObject:CellID] ? YES : NO;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JSBubbleMessageType type = [self.delegate messageTypeForRowAtIndexPath:indexPath];
    JSBubbleMessageStyle bubbleStyle = [self.delegate messageStyleForRowAtIndexPath:indexPath];
    
    BOOL hasTimestamp = [self shouldHaveTimestampForRowAtIndexPath:indexPath];
    BOOL hasAvatar = [self shouldHaveAvatarForRowAtIndexPath:indexPath];
    
    NSString *CellID = [NSString stringWithFormat:@"MessageCell_%d_%d_%d_%d", type, bubbleStyle, hasTimestamp, hasAvatar];
    
    if ([self.selectedMarks containsObject:CellID])// Is selected?
        [self.selectedMarks removeObject:CellID];
    else
        [self.selectedMarks addObject:CellID];
    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![self.delegate messageMediaTypeForRowAtIndexPath:indexPath]){
        return [JSBubbleMessageCell neededHeightForText:[self.dataSource textForRowAtIndexPath:indexPath]
                                              timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                 avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }else{
        return [JSBubbleMessageCell neededHeightForImage:[self.dataSource dataForRowAtIndexPath:indexPath]
                                               timestamp:[self shouldHaveTimestampForRowAtIndexPath:indexPath]
                                                  avatar:[self shouldHaveAvatarForRowAtIndexPath:indexPath]];
    }
}

#pragma mark - Messages view controller
- (BOOL)shouldHaveTimestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate timestampPolicy]) {
        case JSMessagesViewTimestampPolicyAll:
            return YES;
            
        case JSMessagesViewTimestampPolicyAlternating:
            return indexPath.row % 2 == 0;
            
        case JSMessagesViewTimestampPolicyEveryThree:
            return indexPath.row % 3 == 0;
            
        case JSMessagesViewTimestampPolicyEveryFive:
            return indexPath.row % 5 == 0;
            
        case JSMessagesViewTimestampPolicyCustom:
            if([self.delegate respondsToSelector:@selector(hasTimestampForRowAtIndexPath:)])
                return [self.delegate hasTimestampForRowAtIndexPath:indexPath];
            
        default:
            return NO;
    }
}

- (BOOL)shouldHaveAvatarForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([self.delegate avatarPolicy]) {
        case JSMessagesViewAvatarPolicyIncomingOnly:
            return [self.delegate messageTypeForRowAtIndexPath:indexPath] == JSBubbleMessageTypeIncoming;
            
        case JSMessagesViewAvatarPolicyBoth:
            return YES;
            
        case JSMessagesViewAvatarPolicyNone:
        default:
            return NO;
    }
}

- (void)finishSend
{
    [self.inputToolBarView.textView setText:nil];
    [self textViewDidChange:self.inputToolBarView.textView];
    [self.tableView reloadData];
    [self scrollToBottomAnimated:YES];
}

- (void)setBackgroundColor:(UIColor *)color
{
    self.view.backgroundColor = color;
    self.tableView.backgroundColor = color;
    self.tableView.separatorColor = color;
}

- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}


- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath
			  atScrollPosition:(UITableViewScrollPosition)position
					  animated:(BOOL)animated
{
	[self.tableView scrollToRowAtIndexPath:indexPath
						  atScrollPosition:position
								  animated:animated];
}


#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];
	
    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;
    
    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [JSMessageInputView maxHeight];
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.frame.size.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    if (status == INPUT_VIEW_STATUS_OTHER || status == INPUT_VIEW_STATUS_EMOJI) {
        self.previousTextViewContentHeight = 35.5;
    }
    // End of textView.contentSize replacement code

    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }
    else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }

    if(changeInHeight != 0.0f) {
        //        if(!isShrinking)
        //            [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.tableView.contentInset.bottom + changeInHeight,
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];

                             if(isShrinking) {
                                 // if shrinking the view, animate text view frame BEFORE input view frame
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             self.inputToolBarView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             
                             if(!isShrinking) {
                                 [self.inputToolBarView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    } else if (status == INPUT_VIEW_STATUS_OTHER && ![textView isFirstResponder]) {
        self.tableView.contentInset = self.originalTableViewContentInset;
    }
    
    isNull = ([textView.text trimWhitespace].length > 0);

}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {

    if ([text isEqualToString:@"\n"]) {
        [self sendPressed:nil];
        textView.text = @"";
        return NO;
    }

    return YES;
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    if (status == INPUT_VIEW_STATUS_EMOJI) {
        [self emojiAction:nil];
    } else if (status == INPUT_VIEW_STATUS_OTHER) {
        [self othersAction:nil];
    }
    
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    if (status == INPUT_VIEW_STATUS_NORMAL || [notification.name isEqualToString:UIKeyboardWillShowNotification]) {
        [UIView animateWithDuration:duration
                              delay:0.0f
                            options:[UIView animationOptionsForCurve:curve]
                         animations:^{
                             CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                             
                             CGRect inputViewFrame = self.inputToolBarView.frame;
                             CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                             
                             // for ipad modal form presentations
                             CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                             if(inputViewFrameY > messageViewFrameBottom)
                                 inputViewFrameY = messageViewFrameBottom;
                             
                                 self.inputToolBarView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                          inputViewFrameY,
                                                                          inputViewFrame.size.width,
                                                                          inputViewFrame.size.height);

                             

                             UIEdgeInsets insets = self.originalTableViewContentInset;
                             insets.bottom = self.view.frame.size.height - self.inputToolBarView.frame.origin.y - inputViewFrame.size.height;
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                         }
                         completion:^(BOOL finished) {
                         }];
    }
}

- (void)adjustTableView:(NSDictionary *)info {
    
    UIEdgeInsets insets = self.originalTableViewContentInset;
    insets.bottom = self.view.frame.size.height - Y(self.inputToolBarView) - HEIGHT(self.inputToolBarView);
    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    [self scrollToBottomAnimated:NO];
}

#pragma mark - Dismissive text view delegate
- (void)keyboardDidScrollToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed
{
    if ([self.inputToolBarView.textView isFirstResponder]) {
        [self.inputToolBarView.textView resignFirstResponder];
    }
    
   
    CGRect inputViewFrame = self.inputToolBarView.frame;
    inputViewFrame.origin.y = DEVICE_HEIGHT - inputViewFrame.size.height;
    
    if (Y(_emojiView) != DEVICE_HEIGHT) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            CGRect emojiViewFrame = self.emojiView.frame;
            emojiViewFrame.origin.y = DEVICE_HEIGHT;
            self.emojiView.frame = emojiViewFrame;
            self.inputToolBarView.frame = inputViewFrame;
            emoji.selected = NO;
            [self adjustTableView:nil];
        }];
        
    }
    
    if (Y(_otherView) != DEVICE_HEIGHT) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            CGRect otherFrame = self.otherView.frame;
            otherFrame.origin.y = DEVICE_HEIGHT;
            self.otherView.frame = otherFrame;
            self.inputToolBarView.frame = inputViewFrame;
            others.selected = NO;
            [self adjustTableView:nil];
        }];
        
    }
    
    if (Y(_inputToolBarView) != DEVICE_HEIGHT - INPUT_HEIGHT) {
        [UIView animateWithDuration:ANIMATION_TIME animations:^{
            self.inputToolBarView.frame = inputViewFrame;
            [self adjustTableView:nil];
        }];
    }

}

- (void)keyboardWillSnapBackToPoint:(CGPoint)pt
{
    CGRect inputViewFrame = self.inputToolBarView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:pt fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.inputToolBarView.frame = inputViewFrame;
}

@end