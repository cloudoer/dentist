//
//  JSBubbleView.m
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

#import "JSBubbleView.h"
#import "JSMessageInputView.h"
#import "NSString+JSMessagesView.h"
#import "UIImage+JSMessagesView.h"

CGFloat const kJSAvatarSize = 50.0f;

#define kMarginTop 8.0f
#define kMarginBottom 4.0f
#define kPaddingTop 12.0f
#define kPaddingBottom 12.0f
#define kBubblePaddingRight 35.0f

#define kLeftVoiceImage [UIImage imageNamed:@"voice_pic"]
#define kRightVoiceImage [UIImage imageNamed:@"voice_pic_right"]

@interface JSBubbleView()

- (void)setup;

+ (UIImage *)bubbleImageTypeIncomingWithStyle:(JSBubbleMessageStyle)aStyle;
+ (UIImage *)bubbleImageTypeOutgoingWithStyle:(JSBubbleMessageStyle)aStyle;

@end



@implementation JSBubbleView

@synthesize type;
@synthesize style;
@synthesize mediaType;
@synthesize text;
@synthesize data;
@synthesize selectedToShowCopyMenu;

#pragma mark - Setup
- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

#pragma mark - Initialization
- (id)initWithFrame:(CGRect)rect
         bubbleType:(JSBubbleMessageType)bubleType
        bubbleStyle:(JSBubbleMessageStyle)bubbleStyle
          mediaType:(JSBubbleMediaType)bubbleMediaType
{
    self = [super initWithFrame:rect];
    if(self) {
        [self setup];
        self.type = bubleType;
        self.style = bubbleStyle;
        self.mediaType = bubbleMediaType;
    }
    return self;
}

- (void)dealloc
{
    self.text = nil;
}

#pragma mark - Setters
- (void)setType:(JSBubbleMessageType)newType
{
    type = newType;
    [self setNeedsDisplay];
}

- (void)setStyle:(JSBubbleMessageStyle)newStyle
{
    style = newStyle;
    [self setNeedsDisplay];
}

- (void)setMediaType:(JSBubbleMediaType)newMediaType{
    mediaType = newMediaType;
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)newText
{
    text = newText;
    [self setNeedsDisplay];
}

- (void)setData:(id)newData{
    data = newData;
    [self setNeedsDisplay];
}

- (void)setSelectedToShowCopyMenu:(BOOL)isSelected
{
    selectedToShowCopyMenu = isSelected;
    [self setNeedsDisplay];
}

#pragma mark - Drawing
- (CGRect)bubbleFrame
{
    if(self.mediaType == JSBubbleMediaTypeText){
        CGSize bubbleSize = [JSBubbleView bubbleSizeForText:self.text];
        return CGRectMake(floorf(self.type == JSBubbleMessageTypeOutgoing ? self.frame.size.width - bubbleSize.width : 0.0f),
                          floorf(kMarginTop),
                          floorf(bubbleSize.width),
                          floorf(bubbleSize.height));
    }else if (self.mediaType == JSBubbleMediaTypeImage){
        CGSize bubbleSize = [JSBubbleView imageSizeForImage:(UIImage *)self.data];
        return CGRectMake(floorf(self.type == JSBubbleMessageTypeOutgoing ? self.frame.size.width - bubbleSize.width : 10.0f),
                          floorf(kMarginTop),
                          floorf(bubbleSize.width),
                          floorf(bubbleSize.height));
    } else if (self.mediaType == JSBubbleMediaTypeRecoder) {
        return CGRectZero;
    } else{
        NSLog(@"act对象消息");
        return CGRectMake(0, 0, 0, 0);
    }
    
}

- (UIImage *)bubbleImage
{
    return [JSBubbleView bubbleImageForType:self.type style:self.style];
}

- (UIImage *)bubbleImageHighlighted
{
    switch (self.style) {
        case JSBubbleMessageStyleDefault:
        case JSBubbleMessageStyleDefaultGreen:
            return (self.type == JSBubbleMessageTypeIncoming) ? [UIImage bubbleDefaultIncomingSelected] : [UIImage bubbleDefaultOutgoingSelected];
            
        case JSBubbleMessageStyleSquare:
            return (self.type == JSBubbleMessageTypeIncoming) ? [UIImage bubbleSquareIncomingSelected] : [UIImage bubbleSquareOutgoingSelected];
        
      case JSBubbleMessageStyleFlat:
        return (self.type == JSBubbleMessageTypeIncoming) ? [UIImage bubbleFlatIncomingSelected] : [UIImage bubbleFlatOutgoingSelected];
        
        default:
            return nil;
    }
}

- (void)drawRect:(CGRect)frame
{
    [super drawRect:frame];
    
	UIImage *image = (self.selectedToShowCopyMenu) ? [self bubbleImageHighlighted] : [self bubbleImage];
    
    CGRect bubbleFrame = [self bubbleFrame];
	[image drawInRect:bubbleFrame];
    
	

	if (self.mediaType == JSBubbleMediaTypeText)
	{
        CGSize textSize = [JSBubbleView textSizeForText:self.text];
        
        CGFloat textX = image.leftCapWidth - 3.0f + (self.type == JSBubbleMessageTypeOutgoing ? bubbleFrame.origin.x : 0.0f);
        
        CGRect textFrame = CGRectMake(textX,
                                      kPaddingTop + kMarginTop,
                                      textSize.width,
                                      textSize.height);
        
		// for flat outgoing messages change the text color to grey or white.  Otherwise leave them black.
		if (self.style == JSBubbleMessageStyleFlat && self.type == JSBubbleMessageTypeOutgoing)
		{
			UIColor* textColor = [UIColor whiteColor];
			if (self.selectedToShowCopyMenu)
				textColor = [UIColor lightTextColor];
			
			if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
			{
				NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
				[paragraphStyle setAlignment:NSTextAlignmentLeft];
				[paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
				
				NSDictionary* attributes = @{NSFontAttributeName: [JSBubbleView font],
											 NSParagraphStyleAttributeName: paragraphStyle};
				
				// change the color attribute if we are flat
				if ([JSMessageInputView inputBarStyle] == JSInputBarStyleFlat)
				{
					NSMutableDictionary* dict = [attributes mutableCopy];
					[dict setObject:textColor forKey:NSForegroundColorAttributeName];
					attributes = [NSDictionary dictionaryWithDictionary:dict];
				}
				
				[self.text drawInRect:textFrame
					   withAttributes:attributes];
			}
			else
			{
				CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), textColor.CGColor);
				[self.text drawInRect:textFrame
							 withFont:[JSBubbleView font]
						lineBreakMode:NSLineBreakByWordWrapping
							alignment:NSTextAlignmentLeft];
				CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blackColor].CGColor);
			}
		}
		else
		{
			if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
			{
                UIColor* textColor = [UIColor blackColor];
                if (self.selectedToShowCopyMenu)
                    textColor = [UIColor lightTextColor];
                
                
				NSMutableParagraphStyle* paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
				[paragraphStyle setAlignment:NSTextAlignmentLeft];
				[paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
				
				NSDictionary* attributes = @{NSFontAttributeName: [JSBubbleView font],
											 NSParagraphStyleAttributeName: paragraphStyle};
				
                // change the color attribute if we are flat
				if ([JSMessageInputView inputBarStyle] == JSInputBarStyleFlat)
				{
					NSMutableDictionary* dict = [attributes mutableCopy];
					[dict setObject:textColor forKey:NSForegroundColorAttributeName];
					attributes = [NSDictionary dictionaryWithDictionary:dict];
				}
                
				[self.text drawInRect:textFrame
					   withAttributes:attributes];
			}
			else
			{
				[self.text drawInRect:textFrame
							 withFont:[JSBubbleView font]
						lineBreakMode:NSLineBreakByWordWrapping
							alignment:NSTextAlignmentLeft];
			}
		}
	}
	else if(self.mediaType == JSBubbleMediaTypeImage)	// media
	{
        UIImage *recivedImg = (UIImage *)self.data;
        
		if (recivedImg)
		{
            
            
            
            CGSize imageSize = [JSBubbleView imageSizeForImage:recivedImg];
            
            CGFloat imgX = image.leftCapWidth - 3.0f + (self.type == JSBubbleMessageTypeOutgoing ? bubbleFrame.origin.x : 10.0f);
            
            CGRect imageFrame = CGRectMake(imgX - 3.f,
                                          kPaddingTop,
                                          imageSize.width - kPaddingTop - kMarginTop,
                                          imageSize.height - kPaddingBottom + 2.f);
            
            if (recivedImg == kRightVoiceImage) {
                
                imageFrame = CGRectMake(imgX + 33.f + 5.,
                                               kPaddingTop + 5,
                                               recivedImg.size.width ,
                                               recivedImg.size.height + 2.f);

            }
            
            if (recivedImg == kLeftVoiceImage) {
                imageFrame = CGRectMake(imgX,
                                        kPaddingTop + 5,
                                        recivedImg.size.width ,
                                        recivedImg.size.height + 2.f);
            }
            
            if (self.style == JSBubbleMessageStyleFlat && self.type == JSBubbleMessageTypeOutgoing)
            {
                UIColor* textColor = [UIColor whiteColor];
                if (self.selectedToShowCopyMenu)
                    textColor = [UIColor lightTextColor];
            }
            [recivedImg drawInRect:imageFrame];
            
		}
	}
}

#pragma mark - Bubble view
+ (UIImage *)bubbleImageForType:(JSBubbleMessageType)aType style:(JSBubbleMessageStyle)aStyle
{
    switch (aType) {
        case JSBubbleMessageTypeIncoming:
            return [self bubbleImageTypeIncomingWithStyle:aStyle];
            
        case JSBubbleMessageTypeOutgoing:
            return [self bubbleImageTypeOutgoingWithStyle:aStyle];
            
        default:
            return nil;
    }
}

+ (UIImage *)bubbleImageTypeIncomingWithStyle:(JSBubbleMessageStyle)aStyle
{
    switch (aStyle) {
        case JSBubbleMessageStyleDefault:
            return [UIImage bubbleDefaultIncoming];
            
        case JSBubbleMessageStyleSquare:
            return [UIImage bubbleSquareIncoming];
            
        case JSBubbleMessageStyleDefaultGreen:
            return [UIImage bubbleDefaultIncomingGreen];
        
      case JSBubbleMessageStyleFlat:
        return [UIImage bubbleFlatIncoming];
        
        default:
            return nil;
    }
}

+ (UIImage *)bubbleImageTypeOutgoingWithStyle:(JSBubbleMessageStyle)aStyle
{
    switch (aStyle) {
        case JSBubbleMessageStyleDefault:
            return [UIImage bubbleDefaultOutgoing];
            
        case JSBubbleMessageStyleSquare:
            return [UIImage bubbleSquareOutgoing];
            
        case JSBubbleMessageStyleDefaultGreen:
            return [UIImage bubbleDefaultOutgoingGreen];
        
      case JSBubbleMessageStyleFlat:
        return [UIImage bubbleFlatOutgoing];
        
        default:
            return nil;
    }
}

+ (UIFont *)font
{
    return [UIFont systemFontOfSize:16.0f];
}

+ (CGSize)textSizeForText:(NSString *)txt
{
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width * 0.75f;
    CGFloat height = MAX([JSBubbleView numberOfLinesForMessage:txt],
                         [txt numberOfLines]) * [JSMessageInputView textViewLineHeight];
    
    return [txt sizeWithFont:[JSBubbleView font]
           constrainedToSize:CGSizeMake(width - kJSAvatarSize, height + kJSAvatarSize)
               lineBreakMode:NSLineBreakByWordWrapping];
}

+ (CGSize)bubbleSizeForText:(NSString *)txt
{
	CGSize textSize = [JSBubbleView textSizeForText:txt];
	return CGSizeMake(textSize.width + kBubblePaddingRight,
                      textSize.height + kPaddingTop + kPaddingBottom);
}

+ (CGSize)bubbleSizeForImage:(UIImage *)image{
    
//    if (image == kLeftVoiceImage || image == kRightVoiceImage) {
//        return CGSizeMake(image.size.width, image.size.height);
//    }
    
    CGSize imageSize = [JSBubbleView imageSizeForImage:image];
	return CGSizeMake(imageSize.width,
                      imageSize.height);
}

+ (CGSize)imageSizeForImage:(UIImage *)image{
    CGFloat width = [UIScreen mainScreen].applicationFrame.size.width * 0.75f;
    CGFloat height =  image.size.height;
    if (height > 130.) {
        height = 130;
    }
    
    if (image == kLeftVoiceImage || image == kRightVoiceImage) {
      return  CGSizeMake(image.size.width + 2 * kBubblePaddingRight,
                   image.size.height + kPaddingTop + kPaddingBottom);
    }
   
    
    return CGSizeMake(width - kJSAvatarSize, height + kJSAvatarSize);

}

+ (CGFloat)cellHeightForText:(NSString *)txt
{
    return [JSBubbleView bubbleSizeForText:txt].height + kMarginTop + kMarginBottom;
}

+ (CGFloat)cellHeightForImage:(UIImage *)image{

    NSLog(@"cellHeightForImage == %f", [JSBubbleView bubbleSizeForImage:image].height + kMarginTop + kMarginBottom);
    return [JSBubbleView bubbleSizeForImage:image].height + kMarginTop + kMarginBottom;
}

+ (int)maxCharactersPerLine
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 34 : 109;
}

+ (int)numberOfLinesForMessage:(NSString *)txt
{
    return (int)(txt.length / [JSBubbleView maxCharactersPerLine]) + 1;
}

@end