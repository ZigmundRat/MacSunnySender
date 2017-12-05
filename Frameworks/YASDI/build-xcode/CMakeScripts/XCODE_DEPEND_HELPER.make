# DO NOT EDIT
# This makefile makes sure all linkable targets are
# up-to-date with anything they link to
default:
	echo "Do not invoke directly"

# Rules to remove targets that are older than anything to which they
# link.  This forces Xcode to relink the targets from scratch.  It
# does not seem to check these dependencies itself.
PostBuild.yasdi.Debug:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.dylib:
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.dylib


PostBuild.yasdi_drv_ip.Debug:
PostBuild.yasdi.Debug: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_ip.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_ip.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_ip.dylib


PostBuild.yasdi_drv_serial.Debug:
PostBuild.yasdi.Debug: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_serial.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_serial.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi_drv_serial.dylib


PostBuild.yasdimaster.Debug:
PostBuild.yasdi.Debug: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdimaster.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdimaster.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdimaster.dylib


PostBuild.yasdishell.Debug:
PostBuild.yasdimaster.Debug: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/yasdishell
PostBuild.yasdi.Debug: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/yasdishell
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/yasdishell:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdimaster.1.8.1.dylib\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/yasdishell


PostBuild.yasdi.Release:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.dylib:
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.dylib


PostBuild.yasdi_drv_ip.Release:
PostBuild.yasdi.Release: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_ip.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_ip.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_ip.dylib


PostBuild.yasdi_drv_serial.Release:
PostBuild.yasdi.Release: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_serial.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_serial.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi_drv_serial.dylib


PostBuild.yasdimaster.Release:
PostBuild.yasdi.Release: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdimaster.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdimaster.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdimaster.dylib


PostBuild.yasdishell.Release:
PostBuild.yasdimaster.Release: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/yasdishell
PostBuild.yasdi.Release: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/yasdishell
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/yasdishell:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdimaster.1.8.1.dylib\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/yasdishell


PostBuild.yasdi.MinSizeRel:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.dylib:
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.dylib


PostBuild.yasdi_drv_ip.MinSizeRel:
PostBuild.yasdi.MinSizeRel: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_ip.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_ip.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_ip.dylib


PostBuild.yasdi_drv_serial.MinSizeRel:
PostBuild.yasdi.MinSizeRel: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_serial.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_serial.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi_drv_serial.dylib


PostBuild.yasdimaster.MinSizeRel:
PostBuild.yasdi.MinSizeRel: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdimaster.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdimaster.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdimaster.dylib


PostBuild.yasdishell.MinSizeRel:
PostBuild.yasdimaster.MinSizeRel: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/yasdishell
PostBuild.yasdi.MinSizeRel: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/yasdishell
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/yasdishell:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdimaster.1.8.1.dylib\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/yasdishell


PostBuild.yasdi.RelWithDebInfo:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.dylib:
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.dylib


PostBuild.yasdi_drv_ip.RelWithDebInfo:
PostBuild.yasdi.RelWithDebInfo: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_ip.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_ip.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_ip.dylib


PostBuild.yasdi_drv_serial.RelWithDebInfo:
PostBuild.yasdi.RelWithDebInfo: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_serial.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_serial.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi_drv_serial.dylib


PostBuild.yasdimaster.RelWithDebInfo:
PostBuild.yasdi.RelWithDebInfo: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdimaster.dylib
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdimaster.dylib:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdimaster.dylib


PostBuild.yasdishell.RelWithDebInfo:
PostBuild.yasdimaster.RelWithDebInfo: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/yasdishell
PostBuild.yasdi.RelWithDebInfo: /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/yasdishell
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/yasdishell:\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdimaster.1.8.1.dylib\
	/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.8.1.dylib
	/bin/rm -f /Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/yasdishell




# For each target create a dummy ruleso the target does not have to exist
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdi.1.8.1.dylib:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Debug/libyasdimaster.1.8.1.dylib:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdi.1.8.1.dylib:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/MinSizeRel/libyasdimaster.1.8.1.dylib:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdi.1.8.1.dylib:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/RelWithDebInfo/libyasdimaster.1.8.1.dylib:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdi.1.8.1.dylib:
/Users/janverrept/Documents/Development/Projects/Personal/Xcode/MacSunnySender/Frameworks/YASDI/build-xcode/Release/libyasdimaster.1.8.1.dylib:
