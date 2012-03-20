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

#
# Copyright (c) 2012 by Delphix. All rights reserved.
#

. $STF_SUITE/include/libtest.kshlib

#################################################################################
#
# __stc_assertion_start
#
# ID: zpool_import_013_neg
#
# DESCRIPTION:
#	For pool may be in use from other system, 
#	'zpool import' will prompt the warning and fails.
#
# STRATEGY:
#	1. Prepare rawfile that are created from other system.
#	2. Verify 'zpool import' will fail.
#	3. Verify 'zpool import -f' succeed.
#
# TESTABILITY: explicit
#
# TEST_AUTOMATION_LEVEL: automated
#
# CODING_STATUS: COMPLETED (2007-07-05)
#
# __stc_assertion_end
#
################################################################################

verify_runnable "global"

POOL_NAME=unclean_export
POOL_FILE=unclean_export.dat

function uncompress_pool
{

	log_note "Creating pool from $POOL_FILES"
	$CP $STF_SUITE/tests/functional/cli_root/zpool_import/blockfiles/$POOL_FILE.Z \
		/$TESTPOOL
	$UNCOMPRESS /$TESTPOOL/$POOL_FILE.Z
	return 0
}

function cleanup
{
	poolexists $POOL_NAME && log_must $ZPOOL destroy $POOL_NAME
	[[ -e /$TESTPOOL/$POOL_FILE ]] && $RM /$TESTPOOL/$POOL_FILE
	return 0
}

log_assert "'zpool import' fails for pool that was not cleanly exported"
log_onexit cleanup

uncompress_pool
log_mustnot $ZPOOL import -d /$TESTPOOL $POOL_NAME
log_must $ZPOOL import -d /$TESTPOOL -f $POOL_NAME

log_pass "'zpool import' fails for pool that was not cleanly exported"
