#!/bin/ksh -p
#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
# Copyright 2008 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#

. $STF_SUITE/include/libtest.kshlib
. $STF_SUITE/tests/functional/xattr/xattr_common.kshlib

#
# DESCRIPTION:
# We verify that the special . and .. dirs work as expected for xattrs.
#
# STRATEGY:
#	1. Create a file and an xattr on that file
#	2. List the . directory, verifying the output
#	3. Verify we're unable to list the ../ directory
#

function cleanup {
	typeset file

	for file in /tmp/output.$$ /tmp/expected-output.$$ \
		$TESTDIR/myfile.$$ ; do
		log_must $RM -f $file
	done
}

log_assert "special . and .. dirs work as expected for xattrs"
log_onexit cleanup

# create a file, and an xattr on it
log_must $TOUCH $TESTDIR/myfile.$$
create_xattr $TESTDIR/myfile.$$ passwd /etc/passwd

if check_version "5.10"
then
	# listing the directory . should show one file
	OUTPUT=$($RUNAT $TESTDIR/myfile.$$ $LS .)
	if [ "$OUTPUT" != "passwd" ]
	then
	log_fail "Listing the . directory doesn't show \"passwd\" as expected."
	fi
	# list the directory . long form
	log_must eval "$RUNAT $TESTDIR/myfile.$$ $LS -a . > /tmp/output.$$"
	# create a file that should be the same as the command above
	create_expected_output /tmp/expected-output.$$  .  ..   passwd 
	# compare them
	log_must $DIFF /tmp/output.$$ /tmp/expected-output.$$
else 
	# listing the directory . 
	log_must eval "$RUNAT $TESTDIR/myfile.$$ $LS  . > /tmp/output.$$"
	create_expected_output  /tmp/expected-output.$$  \
	SUNWattr_ro  SUNWattr_rw  passwd
	log_must $DIFF /tmp/output.$$ /tmp/expected-output.$$
	# list the directory . long form
	log_must eval "$RUNAT $TESTDIR/myfile.$$ $LS -a . > /tmp/output.$$"
	create_expected_output  /tmp/expected-output.$$ . ..  \
	SUNWattr_ro  SUNWattr_rw  passwd
	log_must $DIFF /tmp/output.$$ /tmp/expected-output.$$
fi
	
# list the directory .. expecting one file
OUTPUT=$($RUNAT $TESTDIR/myfile.$$ $LS ..)
if [ "$OUTPUT" != ".." ]
then
	log_fail "Listing the .. directory doesn't show \"..\" as expected."
fi

# verify we can't list ../
log_mustnot eval "$RUNAT $TESTDIR/myfile.$$ $LS ../ > /dev/null 2>&1"

log_pass "special . and .. dirs work as expected for xattrs"
