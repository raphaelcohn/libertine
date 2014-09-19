
## TODO

* Do not download package duplicates WITHIN a machine or distribution
* Do not collide when downloading in parallel (current mechanism can collide for gnulib, kernel, autotools-config)
    * Will require a lock file, probably
    * Restore storing packages by MIRROR then name then version, so overlaps unlikely
* Store downloads separately to distribution
* Annotate downloads so we know for which distributions / machines they are for (so we can work out when to remove them)
* Do not generate build scripts for already built recipes (check .built)
* ? Do not generate verify scripts for already verified recipes (check .verified)

### Add Packages
* pam_passwdqc

### Hard-coded binary locations

* /sbin/sendmail (was /usr/sbin/sendmail)
* /bin/vi (was /usr/bin/vi)
* /bin/sh

### Assumed locations

* /usr/bin/env
* /bin/sh
* /bin/bash (not as common, but fairly common)
