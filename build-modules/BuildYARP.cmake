# YARP
include(YCMEPHelper)
include(FindOrBuildPackage)

find_or_build_package(TinyXML QUIET)
#find_or_build_package(GooCanvas QUIET)

ycm_ep_helper(YARP TYPE GIT
                   STYLE GITHUB
                   REPOSITORY robotology/yarp.git
                   TAG master
                   DEPENDS TinyXML
                           GooCanvas
                   CMAKE_CACHE_ARGS -DCREATE_IDLS:BOOL=ON
                                    -DCREATE_GUIS:BOOL=ON
                                    -DCREATE_SHARED_LIBRARY:BOOL=ON
                                    -DYARP_USE_SYSTEM_SQLITE:BOOL=ON
                                    -DCREATE_LIB_MATH:BOOL=ON
                                    -DYARP_USE_ATLAS:BOOL=OFF
                                    -DDOX_GENERATE_XML:BOOL=ON
                                    -DCREATE_OPTIONAL_CARRIERS:BOOL=ON
                                    -DENABLE_yarpcar_bayer_carrier:BOOL=ON
                                    -DUSE_LIBDC1394:BOOL=OFF
                                    -DENABLE_yarpcar_tcpros_carrier:BOOL=ON
                                    -DENABLE_yarpcar_xmlrpc_carrier:BOOL=ON
                                    -DENABLE_yarpcar_priority_carrier:BOOL=ON
                                    -DENABLE_yarpidl_thrift:BOOL=ON
                                    -DCREATE_DEVICE_LIBRARY_MODULES:BOOL=ON
                                    -DENABLE_yarpcar_human_carrier:BOOL=ON
                                    -DENABLE_yarpcar_mjpeg_carrier:BOOL=ON
                                    -DENABLE_yarpcar_rossrv_carrier:BOOL=ON
                                    -DENABLE_yarpmod_fakebot:BOOL=ON
                                    -DENABLE_yarpmod_opencv_grabber:BOOL=OFF
                                    -DUSE_PORT_AUTHENTICATION:BOOL=ON
                                    -DYARP_CLEAN_API:BOOL=ON
                                    -DYARP_COMPILE_TESTS:BOOL=OFF
                                    -DCREATE_GYARPBUILDER:BOOL=ON)
