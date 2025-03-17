#include <iostream>
#include <cstring>
#include <cstdlib>
#include <unistd.h>
#include <pthread.h>
#include <arpa/inet.h>
#include <ctime>
#include <vector>
#include <limits>
#include <string>
#include <sstream>

#define PORT 2908
#define BUFFER_SIZE 1024
#define MESSAGE_QUEUE_SIZE 100
#define CORRECT_IP "127.0.0.1"

using namespace std;

enum MessageType {
    SPEED,
    COMMAND,
    SPEED_LIMIT,
    INCIDENT,
    LOCATION
};

struct LocationMessage{
    MessageType type;
    char strada[BUFFER_SIZE];
    char oras[BUFFER_SIZE];
};

struct Message {
    MessageType type;
    char data[BUFFER_SIZE];
};

vector<Message> message_queue;
pthread_mutex_t server_mutex = PTHREAD_MUTEX_INITIALIZER;
int sockfd;
Message speed_message;

void send_message_to_server(const Message &message) {
    cout << "Trimite mesaj catre server: " << message.data << endl;
    if (send(sockfd, &message, sizeof(Message), 0) < 0){
        perror("Eroare la trimiterea mesajului catre server");
    }
}

void send_location_to_server(const string &strada, const string &oras){
    LocationMessage location_msg;
    location_msg.type = MessageType::LOCATION;

    strncpy(location_msg.strada, strada.c_str(), BUFFER_SIZE);  
    strncpy(location_msg.oras, oras.c_str(), BUFFER_SIZE);

    if (send(sockfd, &location_msg, sizeof(LocationMessage), 0) < 0){
        perror("Eroare la trimiterea adresei catre server.");
    }
}

void *thread_for_speed(void *arg) {
    while (true) {
        pthread_mutex_lock(&server_mutex);
        if (message_queue.size() < MESSAGE_QUEUE_SIZE) {
            speed_message.type = MessageType::SPEED;
            snprintf(speed_message.data, BUFFER_SIZE, "%d", rand() % 100 + 50);
        }
        pthread_mutex_unlock(&server_mutex);
        sleep(60);
    }
    return nullptr;
}

void *server_talking_thread(void *arg) {
    while (true) {
        pthread_mutex_lock(&server_mutex);
        for (const auto &msg : message_queue) {
            send_message_to_server(msg);
            cout << "Trimis la server: " << msg.data << endl;
        }
        message_queue.clear();
        pthread_mutex_unlock(&server_mutex);
        sleep(1);
    }
    return nullptr;
}

void *receive_messages_thread(void *arg) {
    Message message;
    while (true) {
        int valread = read(sockfd, &message, sizeof(Message));
        if (valread > 0) {
            
            cout << "[server] " << message.data << endl;
            message.data[BUFFER_SIZE - 1] = '\0';

            if (message.type == MessageType::INCIDENT){
                send_message_to_server(speed_message);
            }

        } else if (valread == 0) {
            cout << "Server disconnected" << endl;
            break;
        } else {
            perror("Read error");
            break;
        }
    }
    return nullptr;
}

int main(int argc, char** argv) {
    srand(time(0));

    pthread_t speed_thread, server_thread, receive_thread;

    if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        perror("Eroare la crearea socket-ului");
        exit(EXIT_FAILURE);
    }

    sockaddr_in serv_addr{};
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);

    if (inet_pton(AF_INET, CORRECT_IP, &serv_addr.sin_addr) <= 0) {
        perror("Eroare la conversia adresei");
        exit(EXIT_FAILURE);
    }

    if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("Eroare la conectare");
        exit(EXIT_FAILURE);
    } else {
        cout << "Conectare reusita la server!" << endl;
    }

    if (pthread_create(&speed_thread, nullptr, thread_for_speed, nullptr) != 0) {
        perror("Eroare la crearea thread-ului pt viteza.");
        exit(EXIT_FAILURE);
    }

    if (pthread_create(&server_thread, nullptr, server_talking_thread, nullptr) != 0) {
        perror("Eroare la crearea thread-ului pt comunicarea cu serverul.");
        exit(EXIT_FAILURE);
    }

    if (pthread_create(&receive_thread, nullptr, receive_messages_thread, nullptr) != 0) {
        perror("Eroare la crearea thread-ului pt primire mesaje.");
        exit(EXIT_FAILURE);
    }

    cout << "MENIU" << endl;
    cout << "Tasta 1: Raporteaza un incident" << endl;
    cout << "Tasta 2: Vreau sa primesc informatii despre vreme" << endl;
    cout << "Tasta 3: Vreau sa primesc informatii despre evenimente sportive" << endl;
    cout << "Tasta 4: Vreau sa primesc informatii despre preturile la carburanti" << endl;
    cout << "Introdu locatia ta [strada, oras]: ";
    Message location;
    location.type = MessageType::LOCATION;
    string locatie;
    getline(cin, locatie);
    strcpy(location.data, locatie.c_str());
    send_message_to_server(location);

    send_message_to_server(speed_message);

    while (true) {
        string command;
        getline(cin, command);

        pthread_mutex_lock(&server_mutex);
        if (message_queue.size() < MESSAGE_QUEUE_SIZE) {
            Message command_message{};
            if (command == "2" || command == "3" || command == "4") {
                command_message.type = MessageType::COMMAND;
                strncpy(command_message.data, command.c_str(), BUFFER_SIZE);
                message_queue.push_back(command_message);
            } else if (command == "1"){
                command_message.type = MessageType::INCIDENT;
                strncpy(command_message.data, command.c_str(), BUFFER_SIZE);
                message_queue.push_back(command_message);
                // obtin informatiile despre incident de la utilizator
                cout << "[server] Introdu detalii despre incident: ";
                string incident_details;
                getline(cin, incident_details);
                strncpy(command_message.data, incident_details.c_str(), BUFFER_SIZE);
                message_queue.push_back(command_message);
            } else{
                cout << "Comanda necunoscuta: " << command << endl;
            }
        } else {
            cout << "Coada de mesaje este plina. Incearca din nou mai tarziu." << endl;
        }
        pthread_mutex_unlock(&server_mutex);
    }

    pthread_join(speed_thread, nullptr);
    pthread_join(server_thread, nullptr);
    pthread_join(receive_thread, nullptr);

    close(sockfd);
    return 0;
}
