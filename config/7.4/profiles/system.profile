set -o errexit +o hashall;unset CDPATH;umask 022

# Happens with a different dependency order
#addToInstall binutils 2.23.2 system SVN-20130915

function downloadsList()
{
	cat <<-EOF
		tar	autoconf	2.69	"$LFS_MIRROR_GNU"/autoconf/autoconf-2.69.tar.xz	50f97f4159805e374639a73e2636f22e	xz	autoconf-2.69.tar.xz	autoconf-2.69
		tar	automake	1.14	"$LFS_MIRROR_GNU"/automake/automake-1.14.tar.xz	cb3fba6d631cddf12e230fd0cc1890df	xz	automake-1.14.tar.xz	automake-1.14
		tar	bc	1.06.95	http://alpha.gnu.org/gnu/bc/bc-1.06.95.tar.bz2	5126a721b73f97d715bb72c13c889035	bzip2	bc-1.06.95.tar.bz2	bc-1.06.95
		tar	bison	3.0	"$LFS_MIRROR_GNU"/bison/bison-3.0.tar.xz	a2624994561aa69f056c904c1ccb2880	xz	bison-3.0.tar.xz	bison-3.0
		tar	e2fsprogs	1.42.8	"$LFS_MIRROR_SOURCEFORGE"/"$ourSourcePackageName"/e2fsprogs-1.42.8.tar.gz	8ef664b6eb698aa6b733df59b17b9ed4	gzip	e2fsprogs-1.42.8.tar.gz	e2fsprogs-1.42.8
		tar	flex	2.5.37	"$LFS_MIRROR_SOURCEFORGE"/"$ourSourcePackageName"/flex-2.5.37.tar.bz2	c75940e1fc25108f2a7b3ef42abdae06	bzip2	flex-2.5.37.tar.bz2	flex-2.5.37
		tar	gdbm	1.10	"$LFS_MIRROR_GNU"/gdbm/gdbm-1.10.tar.gz	88770493c2559dc80b561293e39d3570	gzip	gdbm-1.10.tar.gz	gdbm-1.10
		tar	groff	1.22.2	"$LFS_MIRROR_GNU"/groff/groff-1.22.2.tar.gz	9f4cd592a5efc7e36481d8d8d8af6d16	gzip	groff-1.22.2.tar.gz	groff-1.22.2
		tar	grub	2.00	"$LFS_MIRROR_GNU"/grub/grub-2.00.tar.xz	a1043102fbc7bcedbf53e7ee3d17ab91	xz	grub-2.00.tar.xz	grub-2.00
		tar	iana-etc	2.30	http://anduin.linuxfromscratch.org/sources/LFS/lfs-packages/conglomeration//iana-etc/iana-etc-2.30.tar.bz2	3ba3afb1d1b261383d247f46cb135ee8	bzip2	iana-etc-2.30.tar.bz2	iana-etc-2.30
		tar	inetutils	1.9.1	"$LFS_MIRROR_GNU"/inetutils/inetutils-1.9.1.tar.gz	944f7196a2b3dba2d400e9088576000c	gzip	inetutils-1.9.1.tar.gz	inetutils-1.9.1
		tar	iproute2	3.11.0	http://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-3.11.0.tar.xz	d7ffb27bc9f0d80577b1f3fb9d1a7689	xz	iproute2-3.11.0.tar.xz	iproute2-3.11.0
		tar	kbd	2.0.0	http://ftp.altlinux.org/pub/people/legion/kbd/kbd-2.0.0.tar.gz	5ba259a0b2464196f6488a72070a3d60	gzip	kbd-2.0.0.tar.gz	kbd-2.0.0
		tar	kmod	15	http://www.kernel.org/pub/linux/utils/kernel/kmod/kmod-15.tar.xz	d03372179ed2cfa0c52b6672cf438901	xz	kmod-15.tar.xz	kmod-15
		tar	less	458	http://www.greenwoodsoftware.com/less/less-458.tar.gz	935b38aa2e73c888c210dedf8fd94f49	gzip	less-458.tar.gz	less-458
		tar	lfs-bootscripts	20130821	http://www.linuxfromscratch.org/lfs/downloads/development/lfs-bootscripts-20130821.tar.bz2	ca8331a04db5b6a48cfa46feb309529c	bzip2	lfs-bootscripts-20130821.tar.bz2	lfs-bootscripts-20130821
		tar	libpipeline	1.2.4	http://download.savannah.gnu.org/releases/libpipeline/libpipeline-1.2.4.tar.gz	a98b07f6f487fa268d1ebd99806b85ff	gzip	libpipeline-1.2.4.tar.gz	libpipeline-1.2.4
		tar	libtool	2.4.2	"$LFS_MIRROR_GNU"/libtool/libtool-2.4.2.tar.gz	d2f3b7d4627e69e13514a40e72a24d50	gzip	libtool-2.4.2.tar.gz	libtool-2.4.2
		tar	man-db	2.6.5	http://download.savannah.gnu.org/releases/man-db/man-db-2.6.5.tar.xz	36f59d9314b45a266ba350584b4d7cc1	xz	man-db-2.6.5.tar.xz	man-db-2.6.5
		tar	man-pages	3.53	http://www.kernel.org/pub/linux/docs/man-pages/man-pages-3.53.tar.xz	c3ab5df043bc95de69f73cb71a3c7bb6	xz	man-pages-3.53.tar.xz	man-pages-3.53
		tar	pkg-config	0.28	http://pkgconfig.freedesktop.org/releases/pkg-config-0.28.tar.gz	aa3c86e67551adc3ac865160e34a2a0d	gzip	pkg-config-0.28.tar.gz	pkg-config-0.28
		tar	procps-ng	3.3.8	http://sourceforge.net/projects/procps-ng/files/Production/procps-ng-3.3.8.tar.xz	aecbeeda2ab308f8d09dddcb4cb9a572	xz	procps-ng-3.3.8.tar.xz	procps-ng-3.3.8
		tar	psmisc	22.20	"$LFS_MIRROR_SOURCEFORGE"/"$ourSourcePackageName"/psmisc-22.20.tar.gz	a25fc99a6dc7fa7ae6e4549be80b401f	gzip	psmisc-22.20.tar.gz	psmisc-22.20
		tar	readline	6.2	"$LFS_MIRROR_GNU"/readline/readline-6.2.tar.gz	67948acb2ca081f23359d0256e9a271c	gzip	readline-6.2.tar.gz	readline-6.2
		tar	shadow	4.1.5.1	http://pkg-shadow.alioth.debian.org/releases/shadow-4.1.5.1.tar.bz2	a00449aa439c69287b6d472191dc2247	bzip2	shadow-4.1.5.1.tar.bz2	shadow-4.1.5.1
		tar	sysklogd	1.5	http://www.infodrom.org/projects/sysklogd/download/sysklogd-1.5.tar.gz	e053094e8103165f98ddafe828f6ae4b	gzip	sysklogd-1.5.tar.gz	sysklogd-1.5
		tar	sysvinit	2.88dsf	http://download.savannah.gnu.org/releases/sysvinit/sysvinit-2.88dsf.tar.bz2	6eda8a97b86e0a6f59dabbf25202aa6f	bzip2	sysvinit-2.88dsf.tar.bz2	sysvinit-2.88dsf
		tar	tzdata	2013d	http://www.iana.org/time-zones/repository/releases/tzdata2013d.tar.gz	65b6818162230fc02f86f293376c73df	gzip	tzdata2013d.tar.gz	tzdata2013d
		tar	systemd	207	http://www.freedesktop.org/software/systemd/systemd-207.tar.xz	7799f3cc9d289b8db1c1fa56ae7ecd88	xz	systemd-207.tar.xz	systemd-207
		tar	udev-lfs	207-1	http://anduin.linuxfromscratch.org/sources/other/udev-lfs-207-1.tar.bz2	68ac6572f3363ba067fa67d716a3ec18	bzip2	udev-lfs-207-1.tar.bz2	udev-lfs-207-1
		tar	util-linux	2.23.2	http://www.kernel.org/pub/linux/utils/util-linux/v2.23/util-linux-2.23.2.tar.xz	b39fde897334a4858bb2098edcce5b3f	xz	util-linux-2.23.2.tar.xz	util-linux-2.23.2
		tar	vim	7.4	ftp://ftp.vim.org/pub/vim/unix/vim-7.4.tar.bz2	607e135c559be642f210094ad023dc65	bzip2	vim-7.4.tar.bz2	vim-7.4
		tar	zlib	1.2.8	http://www.zlib.net/zlib-1.2.8.tar.xz	28f1205d8dd2001f26fec1e8c2cebe37	xz	zlib-1.2.8.tar.xz	zlib-1.2.8
		
		patch	automake	1.14	"$LFS_MIRROR_PATCHES"/automake-1.14-test-1.patch	1bc501443baee55bca4d6552ed18a757		automake-1.14-test-1.patch	automake-1.14-test-1.patch
		patch	bash	4.2	"$LFS_MIRROR_PATCHES"/bash-4.2-fixes-12.patch	419f95c173596aea47a23d922598977a		bash-4.2-fixes-12.patch	bash-4.2-fixes-12.patch
		patch	bzip2	1.0.6	"$LFS_MIRROR_PATCHES"/bzip2-1.0.6-installPackage_docs-1.patch	6a5ac7e89b791aae556de0f745916f7f		bzip2-1.0.6-installPackage_docs-1.patch
		patch	coreutils	8.21	"$LFS_MIRROR_PATCHES"/coreutils-8.21-i18n-1.patch	ada0ea6e1c00c4b7e0d634f49827943e		coreutils-8.21-i18n-1.patch	coreutils-8.21-i18n-1.patch
		patch	kbd	2.0.0	"$LFS_MIRROR_PATCHES"/kbd-2.0.0-backspace-1.patch	f75cca16a38da6caa7d52151f7136895		kbd-2.0.0-backspace-1.patch	kbd-2.0.0-backspace-1.patch
		patch	make	3.82	"$LFS_MIRROR_PATCHES"/make-3.82-upstream_fixes-3.patch	95027ab5b53d01699845d9b7e1dc878d		make-3.82-upstream_fixes-3.patch
		patch	tar	1.26	"$LFS_MIRROR_PATCHES"/tar-1.26-manpage-1.patch	321f85ec32733b1a9399e788714a5156		tar-1.26-manpage-1.patch	tar-1.26-manpage-1.patch
		patch	readline	6.2	"$LFS_MIRROR_PATCHES"/readline-6.2-fixes-1.patch	3c185f7b76001d3d0af614f6f2cd5dfa		readline-6.2-fixes-1.patch	readline-6.2-fixes-1.patch
	EOF
}
