# Troubleshooting

This document contains solutions to some of the problems we've seen when trying to get started with Nifty. If you encounter a problem and/or solution not discussed here please open an issue and let us know!

## System libraries not found by linker

The system libraries used by Nifty are provided by the [Nifty-libs](https://github.com/nifty-swift/Nifty-libs) package. This is used internally by Nifty so you shouldn't ever need to reference it. One complication that can arise though is if the installed system libraries are in a location not on your linker search path. In that case, you'll need to tell the linker where to find them when you build, e.g. `swift build -Xlinker -L/usr/local/opt/lapack/lib -Xlinker -L/usr/local/opt/openblas/lib`.
 
If you decide to use a different system library for one of the required system modules, you'll need to modify the Nifty-libs module map once the package manager has downloaded the Packages folder.

## Xcode build fails — module not found (e.g. 'CBlas' or 'CLapacke')

If you're building with Xcode, you need to compile with `NIFTY_XCODE_BUILD` defined. Nifty uses different modules for Xcode builds and Swift Package Manager builds. The included project has this defined already, but if you build your own project, you'll need to do this (It used to be in the project settings -> "Build Settings" -> "Other Swift flags", where you would add `-DNIFTY_XCODE_BUILD`; somewhere around Xcode 9/Swift 4, a setting called "Active Compilation Conditions" was introduced, which should be set to include `NIFTY_XCODE_BUILD`).

## Xcode build fails — undefined SYMROOT or OBJROOT

 Some users have had problems with the included Xcode project giving the errors: "Undefined OBJROOT" or "Undefined SYMROOT". One possible fix: From the project navigation side bar, click on the project icon to bring up the project settings. SYMROOT (aka  Build Products Path) and OBJROOT (aka Intermediate Build Files Path) can be set in the Build Settings tab. From the Build Settings tab, search for SYMROOT or OBJROOT. It should bring up Build Products Path or Intermediate Build Files Path (if not, make sure the search bar is set to search "All", not just "Basic"). From there, you can set the paths as you wish (a reasonable default is $SRCROOT/build). For more info, lookup Apple's "Xcode Build System Guide - Build Setting Reference."
