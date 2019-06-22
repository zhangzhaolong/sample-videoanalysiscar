EN|[CN](README_cn.md)

Developers can deploy the application on the Atlas 200 DK AI acceleration cloud server to decode the local MP4 file or RTSP video streams, detect vehicles in video frames, predict their attributes, generate structured information, and send the structured information to the server for storage and display.

## Prerequisites<a name="en-us_topic_0167343881_section412314183119"></a>

Before using an open source application, ensure that:

-   Mind Studio has been installed. For details, see  [Mind Studio Installation Guide](https://www.huawei.com/minisite/ascend/en/filedetail_1.html).
-   The Atlas 200 DK developer board has been connected to Mind Studio, the cross compiler has been installed, the SD card has been prepared, and basic information has been configured. For details, see  [Atlas 200 DK User Guide](https://www.huawei.com/minisite/ascend/en/filedetail_2.html).

## Software Preparation<a name="en-us_topic_0167343881_section431629175317"></a>

Before running the application, obtain the source code package and configure the environment as follows.

1.  Obtain the source code package.

    Download all the code in the sample-videoanalysiscar repository at  [https://github.com/Ascend/sample-videoanalysiscar](https://github.com/Ascend/sample-videoanalysiscar)  to any directory on Ubuntu Server where Mind Studio is located as the Mind Studio installation user, for example,  _/home/ascend/sample-videoanalysiscar_.

2.  Log in to Ubuntu Server where Mind Studio is located as the Mind Studio installation user and set the environment variable  **DDK\_HOME**.

    **vim \~/.bashrc**

    Run the following commands to add the environment variables  **DDK\_HOME**  and  **LD\_LIBRARY\_PATH**  to the last line:

    **export DDK\_HOME=/home/XXX/tools/che/ddk/ddk**

    **export LD\_LIBRARY\_PATH=$DDK\_HOME/uihost/lib**

    >![](doc/source/img/icon-note.gif) **NOTE:**   
    >-   **XXX**  indicates the Mind Studio installation user, and  **/home/XXX/tools**  indicates the default installation path of the DDK.  
    >-   If the environment variables have been added, skip this step.  

    Enter  **:wq!**  to save and exit.

    Run the following command for the environment variable to take effect:

    **source \~/.bashrc**


## Deployment<a name="en-us_topic_0167343881_section254863302012"></a>

1.  Access the root directory where the vehicle detection application code is located as the Mind Studio installation user, for example,  _**/home/ascend/sample-videoanalysiscar**_.
2.  <a name="en-us_topic_0167343881_li08019112542"></a>Run the deployment script to prepare the project environment, including compiling and deploying the ascenddk public library, downloading the network model, and configuring Presenter Server.

    **bash deploy.sh** _host\_ip_ _model\_mode_

    -   _host\_ip_: For the Atlas 200 DK developer board, this parameter indicates the IP address of the developer board.For the AI acceleration cloud server, this parameter indicates the IP address of the host.

    -   _model\_mode_  indicates the deployment mode of the model file. The value can be  **local**  or **internet**. The default setting is  **internet**.
        -   **local**: If the Ubuntu system where Mind Studio is located is not connected to the network, use the local mode. In this case, you need to have downloaded the model file and the dependent common code library to the  **sample-videoanalysiscar/script**  directory by referring to  [Downloading Network Models and Dependency Code Library](#en-us_topic_0167343881_section083811318334).
        -   **internet**: If the Ubuntu system where Mind Studio is located is connected to the network, use the Internet mode. In this case, download the model file and  dependency code library online.


    Example command:

    **bash deploy.sh 192.168.1.2 internet**

    -   When the message  **Please choose one to show the presenter in browser\(default: 127.0.0.1\):**  is displayed, enter the IP address used for accessing the Presenter Server service in the browser. Generally, the IP address is the IP address for accessing the Mind Studio service.
    -   When the message  **Please input a absolute path to storage video analysis data:**  is displayed, enter the existing absolute path for storing video analysis data in Mind Studio. The Mind Studio user must have the read and write permissions.

    Select the IP address used by the browser to access the Presenter Server service in  **Current environment valid ip list**  and enter the path for storing video analysis data, as shown in  [Figure 1](#en-us_topic_0167343881_fig184321447181017).

    **Figure  1**  Project deployment<a name="en-us_topic_0167343881_fig184321447181017"></a>  
    ![](doc/source/img/project-deployment.png "project-deployment")

3.  <a name="en-us_topic_0167343881_li499911453439"></a>Start Presenter Server.

    Run the following command to start the Presenter Server program of the video analysis application in the background:

    **python3 presenterserver/presenter\_server.py --app video\_analysis\_car &**

    >![](doc/source/img/icon-note.gif) **NOTE:**   
    >**presenter\_server.py**  is located in the  **presenterserver**  directory. You can run the  **python3 presenter\_server.py -h**  or  **python3 presenter\_server.py --help**  command in this directory to view the usage method of  **presenter\_server.py**.  

    [Figure 2](#en-us_topic_0167343881_fig69531305324)  shows that the presenter\_server service is started successfully.

    **Figure  2**  Starting the Presenter Server process<a name="en-us_topic_0167343881_fig69531305324"></a>  
    ![](doc/source/img/starting-the-presenter-server-process.png "starting-the-presenter-server-process")

    Use the URL shown in the preceding figure to log in to Presenter Server \(only the Chrome browser is supported\). The IP address is that entered in  [2](#en-us_topic_0167343881_li08019112542)  and the default port number is  **7005**. The following figure indicates that Presenter Server is started successfully.

    **Figure  3**  Home page<a name="en-us_topic_0167343881_fig64391558352"></a>  
    ![](doc/source/img/home-page.png "home-page")

4.  The video structured application can parse local videos and RTSP video streams.
    -   To parse a local video, upload the video file to the Host.

        For example, upload the video file  **car.mp4**  to the  **/home/HwHiAiUser/sample**  directory on the host.

        >![](doc/source/img/icon-note.gif) **NOTE:**   
        >H.264 and H.265 MP4 files are supported. If an MP4 file needs to be edited, you are advised to use FFmpeg. If a video file is edited by other tools, FFmpeg may fail to parse the file.  

    -   If only RTSP video streams need to be parsed, skip this step.


## Running<a name="en-us_topic_0167343881_section2044213563203"></a>

1.  Run the video analysis application.

    Run the following command in the  **/home/ascend/sample-videoanalysiscar**  directory to start the video analysis application:

    **bash run\_videoanalysiscarapp.sh** _host\_ip_ _presenter\_view\_appname_ _channel1_ _\[channel2\]_  &

    -   _host\_ip_: For the Atlas 200 DK developer board, this parameter indicates the IP address of the developer board.For the AI acceleration cloud server, this parameter indicates the IP address of the host.
    -   _presenter\_view\_app\_name_: Indicates  **View Name**  displayed on the Presenter Server page, which is user-defined.
    -   _channel1_: absolute path of a video file on the host
    -   _channel2_: URL of an RTSP video stream

    Example command:

    **bash run\_videoanalysiscarapp.sh 192.168.1.2 video /home/HwHiAiUser/sample/car.mp4 &**

2.  Use the URL that is displayed when you start the Presenter Server service to log in to the Presenter Server website \(only the Chrome browser is supported\). For details, see  [3](#en-us_topic_0167343881_li499911453439).

    >![](doc/source/img/icon-note.gif) **NOTE:**   
    >The Presenter Server of the video analysis application supports the display of a maximum of two  _presenter\_view\_app\_name_  at the same time.  

    The navigation tree on the left displays the app name and channel name of the video. The large image of the extracted video frame and the detected target small image are displayed in the middle. After you click the small image, the detailed inference result and score are displayed on the right.

    Vehicle attribute detection supports the identification of vehicle brands, vehicle colors, and license plates.

    >![](doc/source/img/icon-note.gif) **NOTE:**   
    >In the network model of license plate recognition, the license plate images automatically generated by the program are trained as the training set, instead of using real license plate images. Therefore, this model has low accuracy in identifying real license plate numbers. If a high-accuracy model is required, collect real license plate images as the training set and train them.  


## Follow-up Operations<a name="en-us_topic_0167343881_section1092612277429"></a>

-   **Stopping the Video Structured Analysis Application**

    To stop the video analysis application, perform the following operations:

    Run the following command in the  **sample-videoanalysiscar**  directory as the Mind Studio installation user:

    **bash stop\_videoanalysiscarapp.sh** _host\_ip_

    _host\_ip_: For the Atlas 200 DK developer board, this parameter indicates the IP address of the developer board.For the AI acceleration cloud server, this parameter indicates the IP address of the host.

    Example command:

    **bash stop\_videoanalysiscarapp.sh** _192.168.1.2_

-   **Stopping the Presenter Server Service**

    The Presenter Server service is always in the running state after being started. To stop the Presenter Server service of the video structured analysis application, perform the following operations:

    Run the following command to check the process of the Presenter Server service corresponding to the video structured analysis application as the Mind Studio installation user:

    **ps -ef | grep presenter | grep video\_analysis\_car**

    ```
    ascend@ascend-HP-ProDesk-600-G4-PCI-MT:~/sample-videoanalysiscar$ ps -ef | grep presenter | grep video_analysis_car
    ascend 3655 20313 0 15:10 pts/24?? 00:00:00 python3 presenterserver/presenter_server.py --app video_analysis_car
    ```

    In the preceding information,  _3655_  indicates the process ID of the Presenter Server service corresponding to the facial recognition application.

    To stop the service, run the following command:

    **kill -9** _3655_


## Downloading Network Models and Dependency Code Library<a name="en-us_topic_0167343881_section083811318334"></a>

-   Downloading network model

    The models used in the Ascend DK open source applications are converted models that adapt to the Ascend 310 chipset. For details about how to download this kind of models and the original network models, see  [Table 1](#en-us_topic_0167343881_table0531392153). If you have a better model solution, you are welcome to share it at  [https://github.com/Ascend/models](https://github.com/Ascend/models).

    Download the network models files (.om files) to the **sample-videoanalysiscar/script** directory.

    **Table  1**  Models used in Atlas DK open source applications

    <a name="en-us_topic_0167343881_table0531392153"></a>
    <table><thead align="left"><tr id="en-us_topic_0167343881_row1154103991514"><th class="cellrowborder" valign="top" width="15.841584158415841%" id="mcps1.2.5.1.1"><p id="en-us_topic_0167343881_p195418397155"><a name="en-us_topic_0167343881_p195418397155"></a><a name="en-us_topic_0167343881_p195418397155"></a>Model Name</p>
    </th>
    <th class="cellrowborder" valign="top" width="21.782178217821784%" id="mcps1.2.5.1.2"><p id="en-us_topic_0167343881_p1054539151519"><a name="en-us_topic_0167343881_p1054539151519"></a><a name="en-us_topic_0167343881_p1054539151519"></a>Description</p>
    </th>
    <th class="cellrowborder" valign="top" width="28.71287128712871%" id="mcps1.2.5.1.3"><p id="en-us_topic_0167343881_p387083117108"><a name="en-us_topic_0167343881_p387083117108"></a><a name="en-us_topic_0167343881_p387083117108"></a>Model Download Path</p>
    </th>
    <th class="cellrowborder" valign="top" width="33.663366336633665%" id="mcps1.2.5.1.4"><p id="en-us_topic_0167343881_p35412397154"><a name="en-us_topic_0167343881_p35412397154"></a><a name="en-us_topic_0167343881_p35412397154"></a>Original Network Download Address</p>
    </th>
    </tr>
    </thead>
    <tbody><tr id="en-us_topic_0167343881_row12294113715478"><td class="cellrowborder" valign="top" width="15.841584158415841%" headers="mcps1.2.5.1.1 "><p id="en-us_topic_0167343881_p1829517371475"><a name="en-us_topic_0167343881_p1829517371475"></a><a name="en-us_topic_0167343881_p1829517371475"></a>Network model for identifying the vehicle color</p>
    <p id="en-us_topic_0167343881_p9548649134712"><a name="en-us_topic_0167343881_p9548649134712"></a><a name="en-us_topic_0167343881_p9548649134712"></a>(<strong id="en-us_topic_0167343881_b0950439193313"><a name="en-us_topic_0167343881_b0950439193313"></a><a name="en-us_topic_0167343881_b0950439193313"></a>car_color.om</strong>)</p>
    </td>
    <td class="cellrowborder" valign="top" width="21.782178217821784%" headers="mcps1.2.5.1.2 "><p id="en-us_topic_0167343881_p52721094817"><a name="en-us_topic_0167343881_p52721094817"></a><a name="en-us_topic_0167343881_p52721094817"></a>-</p>
    </td>
    <td class="cellrowborder" valign="top" width="28.71287128712871%" headers="mcps1.2.5.1.3 "><p id="en-us_topic_0167343881_p1851910895211"><a name="en-us_topic_0167343881_p1851910895211"></a><a name="en-us_topic_0167343881_p1851910895211"></a>Download the model from the <strong id="en-us_topic_0167343881_b13310145613337"><a name="en-us_topic_0167343881_b13310145613337"></a><a name="en-us_topic_0167343881_b13310145613337"></a>computer_vision/classification/car_color</strong> directory in the <a href="https://github.com/Ascend/models/" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/models/</a> repository.</p>
    <p id="en-us_topic_0167343881_p652158105210"><a name="en-us_topic_0167343881_p652158105210"></a><a name="en-us_topic_0167343881_p652158105210"></a>For the version description, see the <strong id="en-us_topic_0167343881_b0829164718402"><a name="en-us_topic_0167343881_b0829164718402"></a><a name="en-us_topic_0167343881_b0829164718402"></a>README.md</strong> file in the current directory.</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.663366336633665%" headers="mcps1.2.5.1.4 "><p id="en-us_topic_0167343881_p044110435414"><a name="en-us_topic_0167343881_p044110435414"></a><a name="en-us_topic_0167343881_p044110435414"></a>For details, see the <strong id="en-us_topic_0167343881_b615119308345"><a name="en-us_topic_0167343881_b615119308345"></a><a name="en-us_topic_0167343881_b615119308345"></a>README.md</strong> file of the <strong id="en-us_topic_0167343881_b315310304345"><a name="en-us_topic_0167343881_b315310304345"></a><a name="en-us_topic_0167343881_b315310304345"></a>computer_vision/classification/car_color</strong> directory in the <a href="https://github.com/Ascend/models/" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/models/</a> repository.</p>
   
   <p><strong id="en-us_topic_0167438951_b1026464240">Precautions during model conversion:</strong></p>
    <p id="en-us_topic_0167438951_p79199202017">The car_color_inference node processes ten pictures at a time. Therefore, the value of N in <strong>Input Shaple</strong> needs to be changed to <strong>10</strong> during conversion.
    </p>
    </td>
    </tr>
    <tr id="en-us_topic_0167343881_row12346165423420"><td class="cellrowborder" valign="top" width="15.841584158415841%" headers="mcps1.2.5.1.1 "><p id="en-us_topic_0167343881_p196801340352"><a name="en-us_topic_0167343881_p196801340352"></a><a name="en-us_topic_0167343881_p196801340352"></a>Network model for identifying the vehicle brand (<strong id="en-us_topic_0167343881_b983891319363"><a name="en-us_topic_0167343881_b983891319363"></a><a name="en-us_topic_0167343881_b983891319363"></a>car_type.om</strong>)</p>
    </td>
    <td class="cellrowborder" valign="top" width="21.782178217821784%" headers="mcps1.2.5.1.2 "><p id="en-us_topic_0167343881_p068011433519"><a name="en-us_topic_0167343881_p068011433519"></a><a name="en-us_topic_0167343881_p068011433519"></a>It is a GoogLeNet model based on Caffe.</p>
    </td>
    <td class="cellrowborder" valign="top" width="28.71287128712871%" headers="mcps1.2.5.1.3 "><p id="en-us_topic_0167343881_p7947935125417"><a name="en-us_topic_0167343881_p7947935125417"></a><a name="en-us_topic_0167343881_p7947935125417"></a>Download the model from the <strong id="en-us_topic_0167343881_b8633135413349"><a name="en-us_topic_0167343881_b8633135413349"></a><a name="en-us_topic_0167343881_b8633135413349"></a>computer_vision/classification/car_type</strong> directory in the <a href="https://github.com/Ascend/models/" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/models/</a> repository.</p>
    <p id="en-us_topic_0167343881_p4947173535413"><a name="en-us_topic_0167343881_p4947173535413"></a><a name="en-us_topic_0167343881_p4947173535413"></a>For the version description, see the <strong id="en-us_topic_0167343881_b19537121111419"><a name="en-us_topic_0167343881_b19537121111419"></a><a name="en-us_topic_0167343881_b19537121111419"></a>README.md</strong> file in the current directory.</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.663366336633665%" headers="mcps1.2.5.1.4 "><p id="en-us_topic_0167343881_p57018652210"><a name="en-us_topic_0167343881_p57018652210"></a><a name="en-us_topic_0167343881_p57018652210"></a>For details, see the <strong id="en-us_topic_0167343881_b6210101383514"><a name="en-us_topic_0167343881_b6210101383514"></a><a name="en-us_topic_0167343881_b6210101383514"></a>README.md</strong> file of the <strong id="en-us_topic_0167343881_b72116130357"><a name="en-us_topic_0167343881_b72116130357"></a><a name="en-us_topic_0167343881_b72116130357"></a>computer_vision/classification/car_type</strong> directory in the <a href="https://github.com/Ascend/models/" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/models/</a> repository.</p>
       <p><strong id="en-us_topic_0167438951_b1026464240">Precautions during model conversion:</strong></p>
    <p id="en-us_topic_0167438951_p79199202017">The car_type_inference node processes ten pictures at a time. Therefore, the value of N in <strong>Input Shaple</strong> needs to be changed to <strong>10</strong> during conversion.
    </p>
    </td>
    </tr>
    <tr id="en-us_topic_0167343881_row12462681048"><td class="cellrowborder" valign="top" width="15.841584158415841%" headers="mcps1.2.5.1.1 "><p id="en-us_topic_0167343881_p7463128346"><a name="en-us_topic_0167343881_p7463128346"></a><a name="en-us_topic_0167343881_p7463128346"></a>Network model for identifying the license plate (<strong id="en-us_topic_0167343881_b62744109120"><a name="en-us_topic_0167343881_b62744109120"></a><a name="en-us_topic_0167343881_b62744109120"></a>car_plate_detection.om</strong>)</p>
    </td>
    <td class="cellrowborder" valign="top" width="21.782178217821784%" headers="mcps1.2.5.1.2 "><p id="en-us_topic_0167343881_p445385961"><a name="en-us_topic_0167343881_p445385961"></a><a name="en-us_topic_0167343881_p445385961"></a>It is a MobileNet-SSD model based on Caffe.</p>
    </td>
    <td class="cellrowborder" valign="top" width="28.71287128712871%" headers="mcps1.2.5.1.3 "><p id="en-us_topic_0167343881_p108303405132"><a name="en-us_topic_0167343881_p108303405132"></a><a name="en-us_topic_0167343881_p108303405132"></a>Download the model from the <strong id="en-us_topic_0167343881_b11606584113"><a name="en-us_topic_0167343881_b11606584113"></a><a name="en-us_topic_0167343881_b11606584113"></a>computer_vision/object_detect/car_plate_detection</strong> directory in the <a href="https://github.com/Ascend/models/" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/models/</a> repository.</p>
    <p id="en-us_topic_0167343881_p12830144015137"><a name="en-us_topic_0167343881_p12830144015137"></a><a name="en-us_topic_0167343881_p12830144015137"></a>For the version description, see the <strong id="en-us_topic_0167343881_b73948158214"><a name="en-us_topic_0167343881_b73948158214"></a><a name="en-us_topic_0167343881_b73948158214"></a>README.md</strong> file in the current directory.</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.663366336633665%" headers="mcps1.2.5.1.4 "><p id="en-us_topic_0167343881_p1446358844"><a name="en-us_topic_0167343881_p1446358844"></a><a name="en-us_topic_0167343881_p1446358844"></a>For details, see the <strong id="en-us_topic_0167343881_b16357205212"><a name="en-us_topic_0167343881_b16357205212"></a><a name="en-us_topic_0167343881_b16357205212"></a>README.md</strong> file of the <strong id="en-us_topic_0167343881_b15359201727"><a name="en-us_topic_0167343881_b15359201727"></a><a name="en-us_topic_0167343881_b15359201727"></a>computer_vision/object_detect/car_plate_detection</strong> directory in the <a href="https://github.com/Ascend/models/" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/models/</a> repository.</p>
    <p id="en-us_topic_0167343881_p177156532915"><a name="en-us_topic_0167343881_p177156532915"></a><a name="en-us_topic_0167343881_p177156532915"></a><strong id="en-us_topic_0167343881_b1026464240"><a name="en-us_topic_0167343881_b1026464240"></a><a name="en-us_topic_0167343881_b1026464240"></a>Precautions during model conversion:</strong></p>
    <p id="en-us_topic_0167343881_p177159582910"><a name="en-us_topic_0167343881_p177159582910"></a><a name="en-us_topic_0167343881_p177159582910"></a>During the conversion, a message is displayed indicating that the conversion fails. You only need to select <strong id="en-us_topic_0167343881_b194783447"><a name="en-us_topic_0167343881_b194783447"></a><a name="en-us_topic_0167343881_b194783447"></a>SSDDetectionOutput </strong>from the drop-down list box for the last layer and click <strong id="en-us_topic_0167343881_b491117008"><a name="en-us_topic_0167343881_b491117008"></a><a name="en-us_topic_0167343881_b491117008"></a>Retry</strong>.</p>
    <p id="en-us_topic_0167343881_p107157515295"><a name="en-us_topic_0167343881_p107157515295"></a><a name="en-us_topic_0167343881_p107157515295"></a><a name="en-us_topic_0167343881_image6716185112918"></a><a name="en-us_topic_0167343881_image6716185112918"></a><span><img id="en-us_topic_0167343881_image6716185112918" src="doc/source/img/en-us_image_0167908878.png"></span></p>
    </td>
    </tr>
    <tr id="en-us_topic_0167343881_row1438610219151"><td class="cellrowborder" valign="top" width="15.841584158415841%" headers="mcps1.2.5.1.1 "><p id="en-us_topic_0167343881_p1386921161513"><a name="en-us_topic_0167343881_p1386921161513"></a><a name="en-us_topic_0167343881_p1386921161513"></a>Network model for identifying the license plate number (<strong id="en-us_topic_0167343881_b2034397935"><a name="en-us_topic_0167343881_b2034397935"></a><a name="en-us_topic_0167343881_b2034397935"></a>car_plate_recognition.om</strong>)</p>
    </td>
    <td class="cellrowborder" valign="top" width="21.782178217821784%" headers="mcps1.2.5.1.2 "><p id="en-us_topic_0167343881_p149446575155"><a name="en-us_topic_0167343881_p149446575155"></a><a name="en-us_topic_0167343881_p149446575155"></a>It is a CNN model based on Caffe.</p>
    </td>
    <td class="cellrowborder" valign="top" width="28.71287128712871%" headers="mcps1.2.5.1.3 "><p id="en-us_topic_0167343881_p143886814161"><a name="en-us_topic_0167343881_p143886814161"></a><a name="en-us_topic_0167343881_p143886814161"></a>Download the model from the <strong id="en-us_topic_0167343881_b13374152916314"><a name="en-us_topic_0167343881_b13374152916314"></a><a name="en-us_topic_0167343881_b13374152916314"></a>computer_vision/classification/car_plate_recognition</strong> directory in the <a href="https://github.com/Ascend/models/" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/models/</a> repository.</p>
    <p id="en-us_topic_0167343881_p1238898191617"><a name="en-us_topic_0167343881_p1238898191617"></a><a name="en-us_topic_0167343881_p1238898191617"></a>For the version description, see the <strong id="en-us_topic_0167343881_b63024211314"><a name="en-us_topic_0167343881_b63024211314"></a><a name="en-us_topic_0167343881_b63024211314"></a>README.md</strong> file in the current directory.</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.663366336633665%" headers="mcps1.2.5.1.4 "><p id="en-us_topic_0167343881_p15386142113152"><a name="en-us_topic_0167343881_p15386142113152"></a><a name="en-us_topic_0167343881_p15386142113152"></a>For details, see the <strong id="en-us_topic_0167343881_b85457442317"><a name="en-us_topic_0167343881_b85457442317"></a><a name="en-us_topic_0167343881_b85457442317"></a>README.md</strong> file of the <strong id="en-us_topic_0167343881_b65451944438"><a name="en-us_topic_0167343881_b65451944438"></a><a name="en-us_topic_0167343881_b65451944438"></a>computer_vision/object_detect/car_plate_recognition</strong> directory in the <a href="https://github.com/Ascend/models/" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/models/</a> repository.</p>
    </td>
    </tr>
    <tr id="en-us_topic_0167343881_row15233104034916"><td class="cellrowborder" valign="top" width="15.841584158415841%" headers="mcps1.2.5.1.1 "><p id="en-us_topic_0167343881_p671932965015"><a name="en-us_topic_0167343881_p671932965015"></a><a name="en-us_topic_0167343881_p671932965015"></a>Network model for object detection</p>
    <p id="en-us_topic_0167343881_p267913419353"><a name="en-us_topic_0167343881_p267913419353"></a><a name="en-us_topic_0167343881_p267913419353"></a>(<strong id="en-us_topic_0167343881_b11164323713"><a name="en-us_topic_0167343881_b11164323713"></a><a name="en-us_topic_0167343881_b11164323713"></a>vgg_ssd.om</strong>)</p>
    </td>
    <td class="cellrowborder" valign="top" width="21.782178217821784%" headers="mcps1.2.5.1.2 "><p id="en-us_topic_0167343881_p1668310475389"><a name="en-us_topic_0167343881_p1668310475389"></a><a name="en-us_topic_0167343881_p1668310475389"></a>It is an SSD512 model based on Caffe.</p>
    </td>
    <td class="cellrowborder" valign="top" width="28.71287128712871%" headers="mcps1.2.5.1.3 "><p id="en-us_topic_0167343881_p384510355555"><a name="en-us_topic_0167343881_p384510355555"></a><a name="en-us_topic_0167343881_p384510355555"></a>Download the model from the <strong id="en-us_topic_0167343881_b1091991553715"><a name="en-us_topic_0167343881_b1091991553715"></a><a name="en-us_topic_0167343881_b1091991553715"></a>computer_vision/object_detect/vgg_ssd</strong> directory in the <a href="https://github.com/Ascend/models/" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/models/</a> repository.</p>
    <p id="en-us_topic_0167343881_p13845123525511"><a name="en-us_topic_0167343881_p13845123525511"></a><a name="en-us_topic_0167343881_p13845123525511"></a>For the version description, see the <strong id="en-us_topic_0167343881_b2225833134116"><a name="en-us_topic_0167343881_b2225833134116"></a><a name="en-us_topic_0167343881_b2225833134116"></a>README.md</strong> file in the current directory.</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.663366336633665%" headers="mcps1.2.5.1.4 "><p id="en-us_topic_0167343881_p18846153545510"><a name="en-us_topic_0167343881_p18846153545510"></a><a name="en-us_topic_0167343881_p18846153545510"></a>For details, see the <strong id="en-us_topic_0167343881_b106568355371"><a name="en-us_topic_0167343881_b106568355371"></a><a name="en-us_topic_0167343881_b106568355371"></a>README.md</strong> file of the <strong id="en-us_topic_0167343881_b14657143515378"><a name="en-us_topic_0167343881_b14657143515378"></a><a name="en-us_topic_0167343881_b14657143515378"></a>computer_vision/object_detect/vgg_ssd</strong> directory in the <a href="https://github.com/Ascend/models/" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/models/</a> repository.</p>
    </td>
    </tr>
    </tbody>
    </table>

-   Download the dependent software libraries
    
    Download the dependent software libraries to the **sample-videoanalysiscar/script** directory.

    **Table  2**  Download the dependent software library

    <a name="en-us_topic_0167343881_table141761431143110"></a>
    <table><thead align="left"><tr id="en-us_topic_0167343881_row18177103183119"><th class="cellrowborder" valign="top" width="33.33333333333333%" id="mcps1.2.4.1.1"><p id="en-us_topic_0167343881_p8177331103112"><a name="en-us_topic_0167343881_p8177331103112"></a><a name="en-us_topic_0167343881_p8177331103112"></a>Module Name</p>
    </th>
    <th class="cellrowborder" valign="top" width="33.33333333333333%" id="mcps1.2.4.1.2"><p id="en-us_topic_0167343881_p1317753119313"><a name="en-us_topic_0167343881_p1317753119313"></a><a name="en-us_topic_0167343881_p1317753119313"></a>Module Description</p>
    </th>
    <th class="cellrowborder" valign="top" width="33.33333333333333%" id="mcps1.2.4.1.3"><p id="en-us_topic_0167343881_p1417713111311"><a name="en-us_topic_0167343881_p1417713111311"></a><a name="en-us_topic_0167343881_p1417713111311"></a>Download Address</p>
    </th>
    </tr>
    </thead>
    <tbody><tr id="en-us_topic_0167343881_row19177133163116"><td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.1 "><p id="en-us_topic_0167343881_p2017743119318"><a name="en-us_topic_0167343881_p2017743119318"></a><a name="en-us_topic_0167343881_p2017743119318"></a>EZDVPP</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.2 "><p id="en-us_topic_0167343881_p52110611584"><a name="en-us_topic_0167343881_p52110611584"></a><a name="en-us_topic_0167343881_p52110611584"></a>Encapsulates the dvpp interface and provides image and video processing capabilities, such as color gamut conversion and image / video conversion</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.3 "><p id="en-us_topic_0167343881_p31774315318"><a name="en-us_topic_0167343881_p31774315318"></a><a name="en-us_topic_0167343881_p31774315318"></a><a href="https://github.com/Ascend/sdk-ezdvpp" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/sdk-ezdvpp</a></p>
    <p id="en-us_topic_0167343881_p1634523015710"><a name="en-us_topic_0167343881_p1634523015710"></a><a name="en-us_topic_0167343881_p1634523015710"></a>After the download, keep the folder name <span class="filepath" id="en-us_topic_0167343881_filepath1324864613582"><a name="en-us_topic_0167343881_filepath1324864613582"></a><a name="en-us_topic_0167343881_filepath1324864613582"></a><b>ezdvpp</b></span>。</p>
    </td>
    </tr>
    <tr id="en-us_topic_0167343881_row101773315313"><td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.1 "><p id="en-us_topic_0167343881_p217773153110"><a name="en-us_topic_0167343881_p217773153110"></a><a name="en-us_topic_0167343881_p217773153110"></a>Presenter Agent</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.2 "><p id="en-us_topic_0167343881_p19431399359"><a name="en-us_topic_0167343881_p19431399359"></a><a name="en-us_topic_0167343881_p19431399359"></a><span>API for interacting with the Presenter Server</span>.</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.3 "><p id="en-us_topic_0167343881_p16684144715560"><a name="en-us_topic_0167343881_p16684144715560"></a><a name="en-us_topic_0167343881_p16684144715560"></a><a href="https://github.com/Ascend/sdk-presenter/tree/master/presenteragent" target="_blank" rel="noopener noreferrer">https://github.com/Ascend/sdk-presenter/tree/master/presenteragent</a></p>
    <p id="en-us_topic_0167343881_p82315442578"><a name="en-us_topic_0167343881_p82315442578"></a><a name="en-us_topic_0167343881_p82315442578"></a>After the download, keep the folder name <span class="filepath" id="en-us_topic_0167343881_filepath19800155745817"><a name="en-us_topic_0167343881_filepath19800155745817"></a><a name="en-us_topic_0167343881_filepath19800155745817"></a><b>presenteragent</b></span>.</p>
    </td>
    </tr>
    <tr id="en-us_topic_0167343881_row119002017360"><td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.1 "><p id="en-us_topic_0167343881_p1390111083619"><a name="en-us_topic_0167343881_p1390111083619"></a><a name="en-us_topic_0167343881_p1390111083619"></a>FFmpeg code</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.2 "><p id="en-us_topic_0167343881_p29013043617"><a name="en-us_topic_0167343881_p29013043617"></a><a name="en-us_topic_0167343881_p29013043617"></a>The current application uses FFmpeg to decapsulate video files.</p>
    </td>
    <td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.3 "><p id="en-us_topic_0167343881_p72741933193610"><a name="en-us_topic_0167343881_p72741933193610"></a><a name="en-us_topic_0167343881_p72741933193610"></a>The URL for downloading the FFmpeg 4.0 code is <a href="https://github.com/FFmpeg/FFmpeg/tree/release/4.0" target="_blank" rel="noopener noreferrer">https://github.com/FFmpeg/FFmpeg/tree/release/4.0</a>.</p>
    <p id="en-us_topic_0167343881_p389163893617"><a name="en-us_topic_0167343881_p389163893617"></a><a name="en-us_topic_0167343881_p389163893617"></a>After the download, keep the folder name <span class="filepath" id="en-us_topic_0167343881_filepath13981556103612"><a name="en-us_topic_0167343881_filepath13981556103612"></a><a name="en-us_topic_0167343881_filepath13981556103612"></a><b>ffmpeg.</b></span></p>
    </td>
    </tr>
    <tr id="en-us_topic_0167333650_row101773315313"><td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.1 "><p>tornado (5.1.0)</p><p>protobuf (3.5.1)</p><p>numpy (1.14.2)</P>
</td>
<td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.2 "><p id="en-us_topic_0167333650_p19431399359"><a name="en-us_topic_0167333650_p19431399359"></a><a name="en-us_topic_0167333650_p19431399359"></a><span>Python libraries that Presenter Server depends on.</span>.</p>
</td>
<td class="cellrowborder" valign="top" width="33.33333333333333%" headers="mcps1.2.4.1.3 "><p id="en-us_topic_0167333650_p16684144715560">Search for related sources and install them.</p>
</td>
</tr>
    </tbody>
    </table>


