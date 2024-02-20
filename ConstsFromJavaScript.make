# Variable declarations
script=$(SRCROOT)/../../Scripts/constsJSC.pl
targetFile=$(SRCROOT)/$(constsName)
inputFiles=$(SRCROOT)/ExtensionsBrowser/Firefox/sheepsystemsmenuextension/components/*.js

# Explicit rule to make the .h file (which will make the .c file too)
$(constsName).h : $(inputFiles)
	$(script) $(targetFile) $(inputFiles)

