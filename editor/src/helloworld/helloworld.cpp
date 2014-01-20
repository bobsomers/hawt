#include <QApplication>
#include <QPushButton>
#include <QThread>

#include <enet/enet.h>

#include <cstdlib>
#include <iostream>
#include <string>

class EnetThread : public QThread {
    Q_OBJECT

    void run() Q_DECL_OVERRIDE {
        if (enet_initialize() != 0) {
            std::cerr << "Failed to initialize enet." << std::endl;
        }
        std::atexit(enet_deinitialize);

        ENetHost* client = enet_host_create(nullptr, 1, 1, 0, 0);
        if (!client) {
            std::cerr << "Failed to create enet client." << std::endl;
        }

        ENetAddress address;
        enet_address_set_host(&address, "localhost");
        address.port = 21981;

        if (enet_host_connect(client, &address, 1, 0) == nullptr) {
            std::cerr << "Failed to allocate peer." << std::endl;
        }

        ENetEvent event;
        while (true) {
            if (enet_host_service(client, &event, 1000) <= 0) continue;

            switch (event.type) {
            case ENET_EVENT_TYPE_CONNECT:
                emit connected();
                break;

            case ENET_EVENT_TYPE_RECEIVE:
                {
                    std::string packet(reinterpret_cast<char*>(event.packet->data), event.packet->dataLength);
                    emit received(packet);
                    enet_packet_destroy(event.packet);
                }
                break;

            default:
                break;
            }
        }

        // TODO: service events
        enet_host_destroy(client);
    }

signals:
    void connected();
    void received(const std::string& message);
};

#include "helloworld.moc"

int main(int argc, char* argv[]) {
    QApplication app(argc, argv);
    QPushButton button("Hello, world!");

    EnetThread* enetThread = new EnetThread;
    QObject::connect(enetThread, &EnetThread::connected, []() {
        std::cout << "Connected to game server." << std::endl;
    });
    QObject::connect(enetThread, &EnetThread::received, [](const std::string& message) {
        std::cout << "Received message: " << message << std::endl;
    });

    button.show();

    return app.exec();
}
