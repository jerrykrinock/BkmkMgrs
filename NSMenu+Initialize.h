@interface NSMenu (Initialize) 

/*!
 @brief    Recursively localizes a menu and does other substitutions

 @details  Send to self=[NSApp mainMenu] to recursively
 localize all submenus and menu items.

*/
- (void)doInitialization ;

@end
