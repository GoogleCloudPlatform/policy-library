#!/usr/bin/env python
# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the 'License');
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an 'AS IS' BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

'''
Input: cai resource dump file + cai iam_policy dump file if it exists
Output: data.json file containing an array of json objects
Each object is one asset including object "resource" and object "iam policy" when it exist
'''

import argparse
import sys
import os
import glob
import json

replaceInfoWith = '*****'


def parse_args(argv):
    parser = argparse.ArgumentParser()
    parser.add_argument('--dump-folder-path', required=True, dest='dumpFolderPath',
                        help='path to the folder containing the cai dump files one for resources, one for iam policies')
    return parser.parse_args(argv)


def main(dumpFolderPath):
    assetsDict = {}
    assetsList = []
    for dumpFilename in glob.glob(os.path.join(dumpFolderPath, '*.dump')):
        with open(dumpFilename, 'r') as caiDumpFile:
            numberOfAssets = sum(1 for _ in caiDumpFile)
            print(f'number of asset: {numberOfAssets} in {dumpFilename}')
        with open(dumpFilename, 'r') as caiDumpFile:
            i = 0
            for line in caiDumpFile:
                i += 1
                metadata = json.loads(line)
                assetName = metadata['name']
                if assetName not in assetsDict:
                    assetsDict[assetName] = metadata
                else:
                    if 'resource' in metadata:
                        assetsDict[assetName]['resource'] = metadata['resource']
                    elif 'iam_policy' in metadata:
                        assetsDict[assetName]['iam_policy'] = metadata['iam_policy']
                if (i % 500 == 0) or (i == numberOfAssets):
                    print(
                        f"{i}/{numberOfAssets} caiDump: {dumpFilename}")

    assetsDict = get_ancestry_path(assets=assetsDict)
    assetsDict = remove_data(assets=assetsDict)

    for _, asset in assetsDict.items():
        assetsList.append(asset)
        if asset['ancestry_path'] == "":
            print(f"Warning: missing ancestry path {asset['name']}")

    localJSONFile = open(dumpFolderPath + '/data.json', 'w')
    localJSONFile.write(json.dumps(assetsList, indent=2))
    localJSONFile.close()


def get_ancestry_path(assets):
    # First flush, get the root asset
    for _, asset in assets.items():
        if asset['asset_type'] == "cloudresourcemanager.googleapis.com/Organization":
            organizationPath = asset['resource']['data']['name'].replace(
                'organizations', 'organization')
            asset['ancestry_path'] = organizationPath

    if organizationPath:
        print(f"Found the organization for this dumps: {organizationPath}")
        # Second flush, fix assets without resource object
        for _, asset in assets.items():
            if not 'resource' in asset:
                asset['ancestry_path'] = organizationPath
                print(
                    f"warning: resource object is missing, ancestry_path set to org_path for {asset['name']}")

        # Thrid flush, compute the ancestry path when possible
        for _, asset in assets.items():
            if not 'ancestry_path' in asset:
                asset['ancestry_path'] = build_path(
                    name=asset['name'], assets=assets)

        knownProjects = {}
        for _, asset in assets.items():
            if 'ancestry_path' in asset and asset['asset_type'] == "cloudresourcemanager.googleapis.com/Project":
                if not asset['resource']['data']['name'] in knownProjects:
                    knownProjects[asset['resource']['data']
                                  ['name']] = asset['ancestry_path']

        # Fourth flush, fix it as possible
        for _, asset in assets.items():
            if asset['ancestry_path'] == "":
                assetNameBreakdown = asset['name'].split('/')
                if assetNameBreakdown[3] == 'projects':
                    if assetNameBreakdown[4] in knownProjects:
                        asset['ancestry_path'] = knownProjects[assetNameBreakdown[4]]
                    else:
                        asset['ancestry_path'] = organizationPath
                elif assetNameBreakdown[3] == 'billingAccounts':
                    asset['ancestry_path'] = 'organization/'
                else:
                    asset['ancestry_path'] = organizationPath
                #print(f"warning fixed ancestry path for: {asset['name']}")
    return assets


def build_path(name, assets):
    # https://github.com/forseti-security/policy-library/blob/master/docs/user_guide.md#instantiate-constraints
    path = ""
    parentPath = ""
    if 'data' in assets[name]['resource']:
        if 'name' in assets[name]['resource']['data']:
            assetName = assets[name]['resource']['data']['name']
            if assets[name]['asset_type'] == "cloudresourcemanager.googleapis.com/Project":
                path = 'project/' + assetName
            elif assets[name]['asset_type'] == "cloudresourcemanager.googleapis.com/Folder":
                path = assetName.replace('folders', 'folder')

            if 'parent' in assets[name]['resource']:
                if 'ancestry_path' in assets[assets[name]['resource']['parent']]:
                    parentPath = assets[assets[name]
                                        ['resource']['parent']]['ancestry_path']
                else:
                    parentPath = build_path(
                        name=assets[name]['resource']['parent'], assets=assets)

    if path and parentPath:
        path = parentPath + '/' + path
    elif parentPath:
        path = parentPath
    return path


def remove_data(assets):
    for _, asset in assets.items():
        if asset['asset_type'] == "sqladmin.googleapis.com/Instance":
            if 'resource' in asset:
                if 'data' in asset['resource']:
                    if 'serverCaCert' in asset['resource']['data']:
                        asset['resource']['data']['serverCaCert'] = replaceInfoWith
    return assets


if __name__ == '__main__':
    args = parse_args(sys.argv[1:])
    main(args.dumpFolderPath)
