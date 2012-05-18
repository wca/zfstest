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

#
# Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
. $STF_SUITE/include/libtest.kshlib
. $STF_SUITE/tests/functional/utils_test/utils_test.kshlib

#
# DESCRIPTION:
# Ensure that the quotaon(1M) utility fails on a ZFS file system.
#
# STRATEGY:
# 1. Enable a quota on a ZFS file system.
# 2. Run quotaon against the device.
# 3. Ensure it fails.
#

verify_runnable "global"

function cleanup
{
	$RM -rf $TESTDIR/*
}

log_onexit cleanup

log_assert "Ensure that the quotaon(1M) utility fails on a ZFS file system."

log_must $ZFS set quota=1099511627776 $TESTPOOL/$TESTFS
log_must $TOUCH $TESTDIR/quotas
log_mustnot $QUOTAON /dev/dsk/${DISK}s0

log_pass "quotaon(1M) returned an error as expected."
