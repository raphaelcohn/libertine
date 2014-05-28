recipe_build_musl-cross()
{
	:
}







recipe_private_musl-cross_architecture()
{
	
}






build()
{
    local -r BP="$1"
    local -r BD="$2"
	local -r PREFIX="$3"
    local -r BUILT="$PWD/$BD/built$BP"
    shift 3
	
	if [ -e "$BUILT" ]; then
		return 0
	fi

    patch_source "$BD"
	
	build_push "$BD"
	
		if [ -n "$BP" ]; then
			mkdir -m 0755 -p build"$BP"
			build_push build"$BP"
			local -r CF="../configure"
		else
			local -r CF="./configure"
		fi
		
		$CF --prefix="$PREFIX" "$@"
		make
		touch "$BUILT"
	
		if [ -n "$BP" ]; then
			build_pop build"$BP"
		fi
	
	build_pop "$BD"
}


doinstall()
{
	local -r BP="$1"
	local -r BD="$2"
	local -r INSTALLED="$PWD/$BD/installed$BP"
	shift 2

	if [ -e "$INSTALLED" ]; then
		return 0
	fi

	build_push build"$BP"

		make install "$@"
		touch "$INSTALLED"
	
	build_pop
}







# FOR native architecture

# Build bootstrap
recipe_private_musl-cross_compile bootstrap "$LFS_NATIVE_ARCHITECTURE" "$LFS_NATIVE_TRIPLE"
# before cleanup
extra/build-gcc-deps.sh
NATIVE_CROSS="$PREFIX_BASE/bootstrap/bin/$TRIPLE"
# Get rid of dlfcn.h as a cheap hack to disable building plugins
rm -f "$PREFIX_BASE/bootstrap/$TRIPLE/include/dlfcn.h"

CC="'"$NATIVE_CROSS-gcc"' -static -Wl,-Bstatic -static-libgcc"
CXX="'"$NATIVE_CROSS-g++"' -static -Wl,-Bstatic -static-libgcc"
export CC CXX
GCC_BOOTSTRAP_CONFFLAGS=--disable-lto-plugin
GCC_CONFFLAGS=--disable-lto-plugin
recipe_private_musl-cross_compile "$LFS_NATIVE_TRIPLE" "$LFS_NATIVE_ARCHITECTURE" "$LFS_NATIVE_TRIPLE"


recipe_private_musl-cross_compile()
{
	local -r BINUTILS_CONFFLAGS=
	local -r GCC_BOOTSTRAP_CONFFLAGS=
	local -r MUSL_CONFFLAGS=
	local -r GCC_CONFFLAGS=
	local -r ARCH="$2"
	
	case "$ARCH" in
	    arm*)
	        GCC_BOOTSTRAP_CONFFLAGS="$GCC_BOOTSTRAP_CONFFLAGS --with-arch=armv4t"
	        GCC_CONFFLAGS="$GCC_CONFFLAGS --with-arch=armv4t"
	        ;;

	    powerpc* | ppc*)
	        GCC_BOOTSTRAP_CONFFLAGS="$GCC_BOOTSTRAP_CONFFLAGS --with-long-double-64 --enable-secureplt"
	        GCC_CONFFLAGS="$GCC_CONFFLAGS --with-long-double-64 --enable-secureplt"
	        ;;
	esac
	
	# ARM float conventions
	case "$ARCH" in
	    *hf | \
	    *-hf*)
	        GCC_BOOTSTRAP_CONFFLAGS="$GCC_BOOTSTRAP_CONFFLAGS --with-float=hard"
	        GCC_CONFFLAGS="$GCC_CONFFLAGS --with-float=hard"
	        ;;

	    *sf | \
	    *-sf*)
	        GCC_BOOTSTRAP_CONFFLAGS="$GCC_BOOTSTRAP_CONFFLAGS --with-float=soft"
	        GCC_CONFFLAGS="$GCC_CONFFLAGS --with-float=soft"
	        ;;
	esac
	
	local LINUX_ARCH=`echo "$ARCH" | sed 's/-.*//'`
	local LINUX_DEFCONFIG=defconfig
	case "$LINUX_ARCH" in
	    i*86) LINUX_ARCH=i386 ;;
	    arm*) LINUX_ARCH=arm ;;
	    mips*) LINUX_ARCH=mips ;;

	    powerpc* | ppc*)
	        LINUX_ARCH=powerpc
	        LINUX_DEFCONFIG=g5_defconfig
	        ;;
	esac
	
	
	
	local -r prefixVariant="$1"
	
	local -r PREFIX="$LFS_BUILD_ROOT_PATH_RECIPE_BUILD_TMP"/"$prefixVariant"
	local -r CC_PREFIX="$PREFIX"
	local -r TRIPLE="$3"
	
	local -r BINUTILS_VERSION="${LFS_DOWNLOADS_PACKAGE_VERSIONS[binutils]}"
	local -r GCC_VERSION="${LFS_DOWNLOADS_PACKAGE_VERSIONS[gcc]}"
	local -r MUSL_VERSION="${LFS_DOWNLOADS_PACKAGE_VERSIONS[musl]}"
	local -r LINUX_HEADERS_VERSION="${LFS_DOWNLOADS_PACKAGE_VERSIONS[linux]}"
	
	mkdir -m 0755 -p "$PREFIX"/"$TRIPLE"
	ln -s . "$PREFIX"/"$TRIPLE"/usr
	sed -i 's,MAKEINFO="$MISSING makeinfo",MAKEINFO=true,g' "${LFS_DOWNLOADS_PACKAGE_EXTRACT_PATHS[binutils]}"/configure
	
	
	#buildinstall 1 binutils-$BINUTILS_VERSION --target=$TRIPLE --disable-werror --with-sysroot="$PREFIX"/"$TRIPLE" "$BINUTILS_CONFFLAGS"
    build 1 binutils-$BINUTILS_VERSION "$PREFIX" --target=$TRIPLE --disable-werror --with-sysroot="$PREFIX"/"$TRIPLE" "$BINUTILS_CONFFLAGS"
    doinstall 1 binutils-$BINUTILS_VERSION
	
	# GCC 1
	
	#gccprereqs
	local gccDependency
	for gccDependency in gmp mpfr mpc
	do
		mkdir -m 0755 -p "${LFS_DOWNLOADS_PACKAGE_EXTRACT_PATHS[gcc]}"/"$gccDependency"
		cp -a "${LFS_DOWNLOADS_PACKAGE_EXTRACT_PATHS["$gccDependency"]}"/"${LFS_DOWNLOADS_PACKAGE_ARCHIVE_FOLDERS["$gccDependency"]}" "${LFS_DOWNLOADS_PACKAGE_EXTRACT_PATHS[gcc]}"/"$gccDependency"/
	done
	
	
	
	#buildinstall 1 gcc-$GCC_VERSION --target=$TRIPLE --with-sysroot="$PREFIX"/"$TRIPLE" --enable-languages=c --with-newlib --disable-multilib --disable-libssp --disable-libquadmath --disable-threads --disable-decimal-float --disable-shared --disable-libmudflap --disable-libgomp --disable-libatomic "$GCC_BOOTSTRAP_CONFFLAGS"
	build 1 gcc-$GCC_VERSION "$PREFIX" --target=$TRIPLE --with-sysroot="$PREFIX"/"$TRIPLE" --enable-languages=c --with-newlib --disable-multilib --disable-libssp --disable-libquadmath --disable-threads --disable-decimal-float --disable-shared --disable-libmudflap --disable-libgomp --disable-libatomic "$GCC_BOOTSTRAP_CONFFLAGS"
	doinstall 1 gcc-$GCC_VERSION
	
	# This code ensures linux headers get installed just once
	if [ ! -e linux-$LINUX_HEADERS_VERSION/configured ]
	then
		build_pushPackage linux
			make $LINUX_DEFCONFIG ARCH=$LINUX_ARCH
			touch configured
		build_popPackage linux
	fi
	
	if [ ! -e linux-$LINUX_HEADERS_VERSION/installedheaders ]
	then
		build_pushPackage linux
			make headers_install ARCH=$LINUX_ARCH INSTALL_HDR_PATH="$CC_PREFIX/$TRIPLE"
			touch installedheaders
		build_popPackage linux
	fi
	
	# NOTE THAT WE fiddle with path - used for C compiler and to pick-up native binutils
	#export PATH="$CC_PREFIX/bin:$PATH"
	
    #buildinstall '' musl-$MUSL_VERSION --enable-debug CC="$TRIPLE-gcc" "$MUSL_CONFFLAGS"
	build '' musl-$MUSL_VERSION "$CC_PREFIX/$TRIPLE" --enable-debug CC="$TRIPLE-gcc" "$MUSL_CONFFLAGS"
	doinstall '' musl-$MUSL_VERSION

    # if it didn't build libc.so, disable dynamic linking
    if [ ! -e "$CC_PREFIX/$TRIPLE/lib/libc.so" ]
    then
        GCC_CONFFLAGS="--disable-shared $GCC_CONFFLAGS"
    fi

    # gcc 2
    #buildinstall 2 gcc-$GCC_VERSION --target=$TRIPLE --with-sysroot="$PREFIX"/"$TRIPLE" --enable-languages=c,c++,objc,objc-c++,fortran --disable-multilib --disable-libmudflap --disable-libsanitizer "$GCC_CONFFLAGS"
    build 2 gcc-$GCC_VERSION "$PREFIX" --target=$TRIPLE --with-sysroot="$PREFIX"/"$TRIPLE" --enable-languages=c,c++,objc,objc-c++,fortran --disable-multilib --disable-libmudflap --disable-libsanitizer "$GCC_CONFFLAGS"
    doinstall 2 gcc-$GCC_VERSION --target=$TRIPLE
	
	# un"fix" headers
	rm -rf "$CC_PREFIX/lib/gcc/$TRIPLE"/*/include-fixed/ "$CC_PREFIX/lib/gcc/$TRIPLE"/*/include/stddef.h
	
	# but no export of CC, CXX for non-bootstrap
	# builds gmp, mpfr, mpc
	"$MUSL_CC_BASE"/extra/build-gcc-deps.sh
	
	# Clean up
	local pkg
	local bf
    for pkg in binutils gcc linux musl gmp mpfr mpc
    do
        for bf in configured build built installed
        do
            rm -rf $pkg-*/$bf*
        done
    done

    for pkg in musl-*/ gmp-*/ mpfr-*/ mpc-*/
    do
        (
			cd $pkg && make distclean || true
        )
    done
}
	

# Build native

# Build cross (if required)
