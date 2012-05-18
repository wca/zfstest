#!/usr/bin/ksh -p
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

#
# DESCRIPTION:
#
# Writing random data into /dev/zfs should do no harm.
#
# STRATEGY:
# 1. Write some random data into /dev/zfs
# 2. Verify that this should fail.
#
#

log_assert "Writing random data into /dev/zfs should do no harm."

log_mustnot $DD if=/dev/urandom of=/dev/zfs count=1024

log_pass "Writing random data into /dev/zfs should do no harm."
