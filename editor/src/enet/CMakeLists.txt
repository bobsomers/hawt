include(ExternalProject)

ExternalProject_Add(enet
    PREFIX enet
    URL ${CMAKE_CURRENT_SOURCE_DIR}/../../third_party/enet-1.3.11.tar.gz
    URL_MD5 dd5273c32c4c6b29f083ef33e1917cc0
    CONFIGURE_COMMAND <SOURCE_DIR>/configure --prefix=<INSTALL_DIR>
)
