#include <QApplication>
#include <QPushButton>

#include <enet/enet.h>

#include <cstdlib>
#include <iostream>

int main(int argc, char* argv[]) {
    QApplication app(argc, argv);
    QPushButton button("Hello, world!");

    if (enet_initialize() != 0) {
        std::cerr << "Failed to initialize enet." << std::endl;
    } else {
        std::cout << "Enet initialized successfully." << std::endl;
    }
    std::atexit(enet_deinitialize);

    button.show();

    return app.exec();
}
