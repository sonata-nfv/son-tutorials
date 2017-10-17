#!/bin/bash
#
#   Copyright 2016 RIFT.IO Inc
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# Author(s): Austin Cormier
# Creation Date: 2016/05/23
#

# Generates a NSD descriptor package from a source directory
# Usage:
# gen_nsd_pkg.sh <pkg_src_dir> <pkg_dest_dir>

set -o nounset

if [ $# -ne 2 ]; then
	echo "Error: Must provide 2 parameters" >@2
	exit 1
fi

pkg_src_dir="$1"
pkg_dest_dir="$2"

if [ ! -e ${pkg_src_dir} ]; then
    echo "Error: ${pkg_src_dir} does not exist"
    exit 1
fi

if [ ! -e ${pkg_dest_dir} ]; then
    echo "Error: ${pkg_src_dir} does not exist"
    exit 1
fi

echo "Generating package in directory: ${pkg_dest_dir}"

# Create any missing directories/files so each package has
# a complete hierachy
nsd_dirs=( ns_config vnf_config icons scripts )
nsd_files=( README )

nsd_dir="${pkg_src_dir}"
echo $(pwd)

mkdir -p "${pkg_dest_dir}"
cp -rf ${nsd_dir}/* "${pkg_dest_dir}"
for sub_dir in ${nsd_dirs[@]}; do
    dir_path=${pkg_dest_dir}/${sub_dir}
    mkdir -p ${dir_path}
done

for file in ${nsd_files[@]}; do
    file_path=${pkg_dest_dir}/${file}
    touch ${file_path}
done
