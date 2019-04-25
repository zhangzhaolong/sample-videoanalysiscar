#!/bin/bash
#
#   =======================================================================
#
# Copyright (C) 2018, Hisilicon Technologies Co., Ltd. All Rights Reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#   1 Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#
#   2 Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#
#   3 Neither the names of the copyright holders nor the names of the
#   contributors may be used to endorse or promote products derived from this
#   software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#   =======================================================================

# ************************Variable*********************************************

script_path="$( cd "$(dirname "$0")" ; pwd -P )"

remote_host=$1
download_mode=$2

common_path="${script_path}/../../common"

. ${common_path}/utils/scripts/func_deploy.sh
. ${common_path}/utils/scripts/func_util.sh


# ************************deploy ***********************************************
# Description:  upload a file
# $1: videoanalysisapp
# $2: app path(absolute)
# $3: common path(absolute)
# $4: remote_host(host ip)
# $5: download_mode(local-do with local mode, internet-download data from internet)
# ******************************************************************************
function deploy_videoanalysis()
{
    #set remote_port
    parse_remote_port

    #build common
    echo "[Step] Build common libs..."
    bash ${common_path}/build.sh
    if [[ $? -ne 0 ]];then
        return 1
    fi

    echo "[Step] Build FFmpeg libs..."
    bash ${script_path}/build_ffmpeg.sh ${download_mode}
    if [[ $? -ne 0 ]];then
        return 1
    fi
    
    #build app
    echo "[Step] Build app libs..."
    bash ${script_path}/build.sh
    if [[ $? -ne 0 ]];then
        return 1
    fi

    #prepare_model.sh:
    echo "[Step] Prepare models..."
    if [[ ${download_mode} == "local" ]];then
        model_version="local"
    else
        model_version=`grep VERSION ${DDK_HOME}/ddk_info | awk -F '"' '{print $4}'`
        if [[ $? -ne 0 ]];then
            echo "ERROR: can not get version in ${DDK_HOME}/ddk_info, please check your env."
            return 1
        fi
    fi
    bash ${script_path}/prepare_model.sh ${model_version}
    if [[ $? -ne 0 ]];then
        return 1
    fi

    #deploy common libs
    echo "[Step] Deploy common libs..."
    bash ${common_path}/deploy.sh ${remote_host}
    if [[ $? -ne 0 ]];then
        return 1
    fi

    echo "[Step] Deploy ffmpeg libs..."
    upload_tar_file "${script_path}/ffmpeg_lib.tar" "~/HIAI_PROJECTS/ascend_lib"
    if [[ $? -ne 0 ]];then
        return 1
    fi

    #deploy dataset
    if [ -d ${script_path}/MyDataset ];then
        echo "[Step] Deploy dataset..."
        upload_path ${script_path}/MyDataset "~/HIAI_DATANDMODELSET/ascend_workspace"
        if [[ $? -ne 0 ]];then
            return 1
        fi
    fi

    #deploy models
    if [ -d ${script_path}/MyModel ];then
        echo "[Step] Deploy models..."
        upload_path ${script_path}/MyModel "~/HIAI_DATANDMODELSET/ascend_workspace" "true"
        if [[ $? -ne 0 ]];then
            return 1
        fi
    fi

    if [ -d ${script_path}/videoanalysisapp/out ];then
        echo "[Step] Deploy app libs..."
        upload_path ${script_path}/videoanalysisapp/out "~/HIAI_PROJECTS/ascend_workspace/videoanalysisapp/out"
        if [[ $? -ne 0 ]];then
            return 1
        fi
        iRet=`IDE-daemon-client --host ${remote_host}:${remote_port} --hostcmd "chmod +x ~/HIAI_PROJECTS/ascend_workspace/videoanalysisapp/out/ascend_videoanalysisapp"`
        if [[ $? -ne 0 ]];then
            echo "ERROR: change excution mode ${remote_host}:./HIAI_PROJECTS/ascend_workspace/videoanalysisapp/out/* failed, please check /var/log/syslog for details."
            return 1
        fi
    fi
    return 0
}

main()
{
    check_ip_addr ${remote_host}
    if [[ $? -ne 0 ]];then
        echo "ERROR: invalid host ip, please check your command format: ./deploy.sh host_ip [download_mode(local/internet)]."
        exit 1
    fi
    
    deploy_videoanalysis
    if [[ $? -ne 0 ]];then
        exit 1
    fi
    
    echo "[Step] Prepare presenter server information and graph.confg..."
    bash ${script_path}/prepare_graph.sh ${remote_host} ${download_mode}
    echo "Finish to deploy videoanalysisapp."
    exit 0
}

main
