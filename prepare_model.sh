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

tools_version=$1

common_path="${script_path}/../../common"

. ${common_path}/utils/scripts/func_model.sh

main()
{
    model_name="vgg_ssd"
    model_remote_path="computer_vision/object_detect"
    prepare ${model_name} ${model_remote_path}
    if [ $? -ne 0 ];then
        exit 1
    fi
    model_name="car_type"
    model_remote_path="computer_vision/classification"
    prepare ${model_name} ${model_remote_path}
    if [ $? -ne 0 ];then
        exit 1
    fi
    model_name="car_color"
    model_remote_path="computer_vision/classification"
    prepare ${model_name} ${model_remote_path}
    if [ $? -ne 0 ];then
        exit 1
    fi
    model_name="car_plate_detection"
    model_remote_path="computer_vision/object_detect"
    prepare ${model_name} ${model_remote_path}
    if [ $? -ne 0 ];then
        exit 1
    fi
    model_name="car_plate_recognition"
    model_remote_path="computer_vision/classification"
    prepare ${model_name} ${model_remote_path}
    if [ $? -ne 0 ];then
        exit 1
    fi
    exit 0
}

main
