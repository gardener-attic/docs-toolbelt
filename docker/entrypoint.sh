#!/bin/sh
#
# SPDX-FileCopyrightText: 2020 SAP SE or an SAP affiliate company and Gardener contributors
#
# SPDX-License-Identifier: Apache-2.0
set -e

CMD_LIST="help-toolbelt hunspell write-good proselint markdownlint-cli2 liche"

if echo $CMD_LIST | grep -w $1 > /dev/null; then
    exec "$@"
else
    help-toolbelt
fi