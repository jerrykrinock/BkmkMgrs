#import "CaseInsensitivePredicateTemplate.h"

@implementation CaseInsensitivePredicateTemplate

- (NSPredicate *)predicateWithSubpredicates:(NSArray *)subpredicates {
    // we only make NSComparisonPredicates
    NSComparisonPredicate *predicate = (NSComparisonPredicate *)[super predicateWithSubpredicates:subpredicates];
    
    // construct an identical predicate, but add the NSCaseInsensitivePredicateOption flag
    return [NSComparisonPredicate predicateWithLeftExpression:[predicate leftExpression]
											  rightExpression:[predicate rightExpression]
													 modifier:[predicate comparisonPredicateModifier]
														 type:[predicate predicateOperatorType]
													  options:[predicate options] | NSCaseInsensitivePredicateOption];
}

@end

