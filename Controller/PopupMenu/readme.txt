1、控件说明：
   (1)支持在任意位置弹出带尖角的悬浮菜单
  （2）支持横竖屏、上下屏切换
*****************************************************************************************
2、使用说明
 (1) #import "HCPopupMenu.h"
     #import "HCPopupMenuItem.h"
 (2) 创建菜单项
 调用如下两个方法之一即可，比如： CHCPopupMenuItem *aItem = [CHCPopupMenuItem menuItem:tabItemChild.iTitle
                                       image:aImage
                                      target:self
                                      action:@selector(pushMenuItem:)
                                         tag:tabItemChild.iTag
                                    supertag:sender.tag];
要改变菜单项文字的颜色给 CHCPopupMenuItem 的iFforeColor属性赋值即可，默认为白色
/*!
 @method
 @abstract	构造一个菜单项
 @discussion	target,image和action可以为空
 @param  title 菜单项标题
 @param  image 菜单项图片
 @param 	target 响应点击事件的类
 @param  action 菜单项点击的动作
 @result	一个菜单项
 */
+ (instancetype) createMenuItemWithTitle:(NSString *) title
                                   image:(UIImage *) image
                                  target:(id)target
                                  action:(SEL) action;

/*!
 @method
 @abstract	创建菜单项
 @discussion
 @param  title 菜单项标题
 @param  image 菜单项图片
 @param 	target 响应点击事件的类
 @param 	tag 菜单项item的tag
 @param 	supertag 响应弹出菜单事件的tag
 @result	一个菜单项
 */
+ (instancetype) menuItem:(NSString *) title
                    image:(UIImage *) image
                   target:(id)target
                   action:(SEL) action
                      tag:(int)tag
                 supertag:(int)supertag;
(3)展示菜单
调用如下两个方法之一即可，比如
   CHCPopupMenu *aMenu = [CHCPopupMenu sharedMenu];
    aMenu.iMargin= CGRectMake(3, 3, 3, 3);
    aMenu.iToTop = 4;
    aMenu.iToLeft=2;
    aMenu.iToRight = 6;
    aMenu.iCenter = 4;
    aMenu.iToDown = 4;
    aMenu.isEqualMargin = YES;
    aMenu.iBreakLineColor = [UIColor blueColor];
    aMenu.iBreakLineHeight = 1;
    UIEdgeInsets insets = UIEdgeInsetsMake(10.0f,10.0f,20.0f,10.0f);
    UIImage *targetImage = [[UIImage imageNamed:@"tab_popupmenu_bg_right1"]resizableImageWithCapInsets:insets];
    aMenu.iBgImage = targetImage;
    [CHCPopupMenu showMenuInView:self.iWebVC.view
                fromRect:[self barItemFrame:sender tabarNum:iTabarItemNum+1]
               menuItems:menuArray
   ];


  
  弹出菜单尖角的高度默认10.0f,更改请给iArrowSize属性赋值。
/*!
 @method
 @abstract	点击按钮的时候弹出菜单
 @discussion 
           调用者知道展示的菜单的frame，需要调用[CHCPopupMenu sharedMenu]方法获得实例，给iMenuFrame赋值
           默认frame (210, 35, 114, 81)
           默认在导航栏的右barIten 弹出菜单 默认白色背景图片蓝色边框 
           更改背景图片 请给 iMenuBgImageName 赋值
           
 @param 	view 	显示菜单的view
 @param 	menuItems 	菜单项数组
 */
+ (void) showMenuInView:(UIView *)view
              menuItems:(NSArray *)menuItems;

/*!
 @method
 @abstract	点击按钮的时候弹出菜单
 @discussion 
              调用者不需计算菜单的frame,需要想响应点击事件弹出菜单控件的frame
              如果要设置菜单的背景，给iBgImage赋值，默认无背景图片
 @param 	view 	显示菜单的View
 @param 	rect 	响应点击事件的按钮的frame
 @param 	menuItems 	菜单项数组
 */
+ (void) showMenuInView:(UIView *)view
               fromRect:(CGRect)rect
              menuItems:(NSArray *)menuItems;
