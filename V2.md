# Restructuring of LFS

## Inputs

### Recipe
A recipe consists of all the information necessary to build a package. We currently split out an 'include'. A recipe has one or more includes. The idea of an include was to record solely the download information. 

* Version of package
* Dependencies
* Patches (may require a function to evaluate, eg bash - but this can be documented instead)
    * May be from the same upstream source (ie the package creator)
	* May be third party (eg LFS)
	* May need to be embedded in the recipe
* Some shared dependencies on autotools and gnulib, mostly to provide fixes to work with musl in packages created before musl existed

#### Include
In practice, an include covers:-

* Mirror to be used
    * Varies rarely across versions
* Relative path in that mirror
    * Varies rarely across versions when based on package name
	* Varies more frequently when based on the package version
* Implicit archive kind
    * tarball
	* flat file
	* zip
* Implicit archive compression
    * gzip
	* bzip2
	* lzma
	* xz
	* lzip
	* etc
* Implicit tarball first folder naming => register a function
    * named after archive name less extensions;
	* named oddly (eg tcl);
	* no root folder (tarbomb)
	* ? other
* Size;
* A set of cryptographic hashes (MD5, SHA1, SHA256, SHA512) or none (eg gnulib from Savannah, as they change on download);
* Whether to apply to cryptographic hashes to the compressed archive (usual) or uncompressed one (kernel.org)
* Some includes require an explicit referrer
* Some includes require an explicit POST of data (eg AMD's)
* Signatures
    * GPG key listed in a PGP server ('HKP', eg coreutils)
	* GPG key not listed in a PGP server (eg xz)
	* GPG key in a common keyring (eg bash)

#### UID / GID file
All packages are installed as an unique user. We currently capture this in an 'uidgid' file. We've experimented with generating the file numbers (not very useful). A simpler approach might be a policy of starting prefix, and a reservation of 100,000 uid-gid pairs for a package. One potential problem is needing an uid-gid per program; some packages contain many programs (eg busybox, coreutils)

For some resources, eg COETSE, the include includes multiple downloads. For others, such as selinux, one recipe references multiple downloads. Cracklin combines both.

Do we combine includes and recipes? Recipes change infrequently. We don't current support multiple recipe versions (although we might be in the future)

#### Settings file
This is recipe configuration that can be either site-local, bunch-of-machines-local or machine-local. It is required at compile time.

#### Config file
The kernel, busybox and a few other programs (eg buildroot), use the 'Kconfig' system for configuration. Users need to be able to do this themselves, as these interactive menus are cumbersome to automate otherwise.

#### Machine settings
Currently, these are defaulted with exceptions for:-

* LFS Version (a version that ties together all recipes)
* Machine CFLAGS, that are effectively representative of the machine's hardware

Defaults are:-

	
	setting_string LFS_NATIVE_ARCHITECTURE x86_64
	setting_string LFS_FOREIGN_ARCHITECTURE x86_64
	setting_string LFS_CFLAGS_NATIVE_CPU_OPTIMISATION "-march=native -mtune=generic"
	setting_string LFS_CFLAGS_FOREIGN_CPU_OPTIMISATION "-march=native -mtune=generic"
	setting_string LFS_LDFLAGS_DEBUGGING "-Wl,--strip-debug"

	setting_string LFS_AUTOTOOLS_CONFIG_VERSION "5e4de70bb0064d974a848fbe3a445d5dafaf7b48"
	setting_string LFS_AUTOTOOLS_GNULIB_VERSION "43fd1e7b5a01623bc59fcf68254ce5be8e0b8d42"

	setting_string LFS_DISTRIBUTION_ID "Linux From Scratch"
	setting_string LFS_DISTRIBUTION_CODENAME "stormmq"
	setting_string LFS_DISTRIBUTION_DESCRIPTION "Linux From Scratch"

	setting_integer LFS_INCLUSIVE_RECIPE_UID 100
	setting_integer LFS_INCLUSIVE_SYSTEM_UID 9000
	setting_integer LFS_INCLUSIVE_SYSTEM_GID 9000
	setting_integer LFS_INCLUSIVE_USER_UID 10000
	setting_integer LFS_INCLUSIVE_USER_GID 10000
	

#### Dependency Order

Mostly, one recipe can be depdendent on one or more parent recipes. Sometimes, a recipe has no parent (eg the kernel when using musl). A few recipes rely on configuration that can be added to (eg timezones, cracklib's word lists); we currently force rebuild when this configuration changes, even though it is immaterial and can be thought of as a 'database'. Some of this configuration (eg timezones) is likely to change frequently. Other examples will be iptables, static routes, etc.



## Generator a makefile

Two phases:-

* Download dependencies (each dependency download is a task)
* Verify + Build each dependency
