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
script_path="$( cd "$(dirname "$0")" ; pwd -P )"

remote_host=$1
download_mode=$2

common_path="${script_path}/../../common"

. ${common_path}/utils/scripts/func_util.sh

function main()
{
    bash ${common_path}/prepare_presenter_server.sh "video_analysis" ${remote_host} ${download_mode}

    while [ ${presenter_server_storage_path}"X" == "X" ]
    do
        read -p "Please input a absolute path to storage video analysis data:" presenter_server_storage_path
        mkdir -p ${presenter_server_storage_path}
        if [ $? -ne 0 ];then
            echo "ERROR: invalid path: ${prepare_presenter_server}, please input a valid path."
        fi

    done
    echo "Use ${presenter_server_storage_path} to store video analysis data..."
    sed -i "s#^storage_dir=.*\$#storage_dir=${presenter_server_storage_path}#g" ${common_path}/presenter/server/video_analysis/config/config.conf
    

    echo "Finish to prepare video analysis presenter server configuration."
}

main