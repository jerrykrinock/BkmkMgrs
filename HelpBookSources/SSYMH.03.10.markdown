# Find/Replace Text <img src="images/Smarky.png" class="whapp" /> <img src="images/Synkmark.png" class="whapp" /> <img src="images/Markster.png" class="whapp" /> <img src="images/BookMacster.png" class="whapp" /> [reportFind]

<div class="screenshot">
<img src="images/TabReportsFind.png" alt="" />
</div>

Although the [Content Filters]() are handy for quick searches, the Reports > Find/Replace allows you to filter your bookmarks content, find those with almost any criteria imaginable, and replace text in names, shortcuts, comments or URLs with other text.  The interface is fairly self-explanatory except for the fact that you can create *compound predicates* by holding down the *option* key as you click the ⊕ button.

The *matches regular expression* operator is also known as *regex* or *grep*.  It follows the rules of [ICU Regex](http://userguide.icu-project.org/strings/regexp).  Subpatterns captured by parentheses are represented by dollar signs in Replace patterns (not backslashes as in BBEdit).  For example, $1 is the first captured subpattern, $2 is the second, etc.; $0 is the entire pattern.

Here is an illustrative example of a complicated predicate:

<div class="screenshot">
<img src="images/CrazyFindPred.png" alt="" />
</div>

