.onAttach<-function(libname, pkgname){

    #v <- packageDescription("Rdistance", fields="Version")  # this requires utils package, and I don't want to make mra dependent on utils, just for this.
    v <- "1.0"

    packageStartupMessage( paste("Rdistance - Distance and Line Transect Analysis (vers ", v ,")", sep=""))  # You have to change this every version
	packageStartupMessage("\nTrent McDonald, WEST Inc.\n(tmcdonald@west-inc.com, www.west-inc.com)") 


}
