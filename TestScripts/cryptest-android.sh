#!/usr/bin/env bash

# ====================================================================
# Tests Android cross-compiles
#
# Crypto++ Library is copyrighted as a compilation and (as of version 5.6.2)
# licensed under the Boost Software License 1.0, while the individual files
# in the compilation are all public domain.
#
# See http://www.cryptopp.com/wiki/Android_(Command_Line) for more details
# ====================================================================
set +e

PLATFORMS=(armeabi armeabi-v7a armeabi-v7a-hard armv7a-neon aarch64 mipsel mipsel64 x86 x86_64)
RUNTIMES=(gnu-static gnu-shared llvm-static llvm-shared stlport-static stlport-shared)
for platform in ${PLATFORMS[@]}
do
	for runtime in ${RUNTIMES[@]}
	do
		make -f GNUmakefile-cross distclean > /dev/null 2>&1

		echo
		echo "===================================================================="
		echo "Testing for Android support of $platform using $runtime"

		# Test if we can set the environment for the platform
		./setenv-android.sh "$platform" "$runtime" > /dev/null 2>&1

		if [ "$?" -eq "0" ]; then
			echo
			echo "Building for $platform using $runtime..."
			echo

			# run in subshell to not keep any env vars
			(
				. ./setenv-android.sh "$platform" "$runtime"
				make -f GNUmakefile-cross static dynamic cryptest.exe
				echo
				if [ "$?" -eq "0" ]; then
					echo "==> BUILD SUCCESSFUL"
				else
					echo "==> BUILD FAILTURE"
				fi
			)
		else
			echo
			echo "$platform with $runtime not supported by Android"
		fi
	done
done
