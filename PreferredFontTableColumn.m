#import "PreferredFontTableColumn.h"
#import "BkmxAppDel.h"


@implementation PreferredFontTableColumn

- (id)dataCellForRow:(NSInteger)iRow {
	id cell = [super dataCellForRow:iRow] ;
	NSFont* font = [(BkmxAppDel*)[NSApp delegate] fontTable] ;
	[cell setFont:font]; 
	
	return cell ;
}

@end
