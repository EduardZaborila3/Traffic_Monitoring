#include <iostream>
#include <vector>
#include <cstring>
#include <cstdlib>
#include <unistd.h>
#include <pthread.h>
#include <arpa/inet.h>
#include <string>
#include <sstream>

#include <mysql_driver.h>
#include <mysql_connection.h>
#include <cppconn/prepared_statement.h>
#include <cppconn/resultset.h>
#include <cppconn/statement.h>

#define PORT 2908
#define BUFFER_SIZE 1024
#define MAX_CLIENTS 100

using namespace std;

struct Client {
    int socket;
    int id_client;
    bool vreme = false;
    bool sport = false;
    bool carburant = false;
    char judet[100];
    char strada[100];
};

enum MessageType {
    SPEED,
    COMMAND,
    SPEED_LIMIT,
    INCIDENT,
    LOCATION,
    UNDEFINED,
    FUEL_UPDATE,
    SPORT_EVENTS,
    WEATHER
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

//unordered_map<int, Client> client_socket_map;3

vector<Client> clients;
pthread_mutex_t clients_mutex = PTHREAD_MUTEX_INITIALIZER;

sql::Connection* conn;

bool connect_to_db() {
    try {
        // obtin driver-ul mysql
        sql::mysql::MySQL_Driver *driver;
        driver = sql::mysql::get_mysql_driver_instance();

        // creez conexiunea la bd
        conn = driver->connect("tcp://127.0.0.1", "root", "Edu@rd03!");
        
        // selectez bd
        conn->setSchema("MonitorizareTraffic");

        return true;
    } catch (sql::SQLException &e) {
        cerr << "Eroare la conectarea la baza de date: " << e.what() << endl;
        return false;
    }
}

void save_driver_to_db(const string& strada, const string& oras, Client& client) {
    if (conn == nullptr) {
        cerr << "Conexiune la baza de date nu este deschisa!" << endl;
        return;
    }

    try {
        sql::PreparedStatement* stmt = conn->prepareStatement(
            "INSERT INTO soferi (strada, oras, data_inregistrare) VALUES (?, ?, CURRENT_TIMESTAMP)"
        );
        stmt->setString(1, strada);
        stmt->setString(2, oras);
        stmt->executeUpdate();

        sql::PreparedStatement* select_stmt = conn->prepareStatement("SELECT LAST_INSERT_ID() AS id");
        sql::ResultSet* res = select_stmt->executeQuery();
        if (res->next()){
            client.id_client = res->getInt("id");
            cout << "id " << client.id_client << endl; 
        }
        
        delete stmt;
        delete select_stmt;
        delete res;

        cout << "clientul a fost salvat in baza de date" << endl;
    } catch (sql::SQLException& e) {
        cerr << "Eroare la salvarea soferului: " << e.what() << endl;
    }
}

void update_driver_speed(int id, int viteza){
    if (conn == nullptr){
        cerr << "Conexiune la baza de date nu este deschisa!" << endl;
        return;
    }

    try {
        sql::PreparedStatement* stmt = conn->prepareStatement(
            "UPDATE soferi SET viteza = ? WHERE id = ?"
        );
        stmt->setInt(1, viteza);
        stmt->setInt(2, id);
        stmt->executeUpdate();
        delete stmt;
    } catch (sql::SQLException& e) {
        cerr << "Eroare la actualizarea vitezei soferului: " << e.what() << endl;
    }
}

void update_driver_subscriptions(int id, bool vreme, bool sport, bool carburant) {
    if (conn == nullptr) {
        cerr << "Conexiune la baza de date nu este deschisa!" << endl;
        return;
    }

    try {
        sql::PreparedStatement* stmt = conn->prepareStatement(
            "UPDATE soferi SET vreme = ?, sport = ?, carburant = ? WHERE id = ?"
        );
        stmt->setBoolean(1, vreme);
        stmt->setBoolean(2, sport);
        stmt->setBoolean(3, carburant);
        stmt->setInt(4, id);
        stmt->executeUpdate();
        delete stmt;
    } catch (sql::SQLException& e) {
        cerr << "Eroare la actualizarea abonamentului soferului: " << e.what() << endl;
    }
}

void save_incident_to_db(const string& incident_description, Client& client) {
    if (conn == nullptr) {
        cerr << "Conexiunea la baza de date nu este deschisa!" << endl;
        return;
    }

    try {
        sql::PreparedStatement* stmt = conn->prepareStatement(
            "INSERT INTO incidente (id_sofer, detalii, data_inregistrare_incident) VALUES (?, ?, NOW())"
        );
        cout << client.id_client << " " << incident_description << endl;
        stmt->setInt(1, client.id_client);               
        stmt->setString(2, incident_description);
        stmt->executeUpdate();

        delete stmt;
        cout << "Incident salvat cu succes pentru soferul cu id-ul " << client.id_client << endl;
    } catch (sql::SQLException& e) {
        cerr << "Eroare la salvarea incidentului: " << e.what() << endl;
    }
}


int get_speed_limit_for_street(const Client& client) {
    int speed_limit = -1;
    if (conn == nullptr) {
        cerr << "Conexiune la baza de date nu este deschisa!" << endl;
        return speed_limit;
    }

    try {
        sql::PreparedStatement* stmt = conn->prepareStatement(
            "SELECT limita_viteza FROM strada WHERE nume = ? "
        );
        stmt->setString(1, client.strada);
        cout << "viteza str. " << client.strada << endl;

        sql::ResultSet* res = stmt->executeQuery();
        if (res->next()) {
            speed_limit = res->getInt("limita_viteza");
        }

        delete stmt;
        delete res;

    } catch (sql::SQLException& e) {
        cerr << "Eroare la obtinerea limitei de viteza: " << e.what() << endl;
    }

    return speed_limit;
}

void send_fuel_prices(const Client& client) {
    if (conn == nullptr) {
        cerr << "Conexiune la baza de date nu este deschisa!" << endl;
        return;
    }

    try {
        // Selecteaza o benzinarie aleatorie
        sql::PreparedStatement* stmt = conn->prepareStatement(
            "SELECT DISTINCT nume_statie FROM preturi_combustibil"
        );
        sql::ResultSet* res = stmt->executeQuery();
        vector<string> statii;
        
        while (res->next()) {
            statii.push_back(res->getString("nume_statie"));
        }

        if (statii.empty()) {
            cerr << "Nu s-au gasit benzinarii!" << endl;
            delete stmt;
            delete res;
            return;
        }

        string benzinaria_aleasa = statii[rand() % statii.size()];

        stmt = conn->prepareStatement(
            "SELECT tip_combustibil, pret FROM preturi_combustibil WHERE nume_statie = ?"
        );
        stmt->setString(1, benzinaria_aleasa);
        res = stmt->executeQuery();

        stringstream fuel_prices;
        fuel_prices << benzinaria_aleasa << endl; 
        while (res->next()) {
            string tip_combustibil = res->getString("tip_combustibil");
            float pret = res->getDouble("pret");
            fuel_prices << tip_combustibil << ": " << pret << " RON\n";
        }

        Message preturi_carburant;
        preturi_carburant.type = MessageType::FUEL_UPDATE;
        strncpy(preturi_carburant.data, fuel_prices.str().c_str(), BUFFER_SIZE - 1);
        preturi_carburant.data[BUFFER_SIZE - 1] = '\0';

        if (send(client.socket, &preturi_carburant, sizeof(Message), 0) < 0) {
            perror("Eroare la trimiterea preturilor combustibilului către client");
        } else {
            cout << "Trimit către clientul " << client.socket << " preturile pentru combustibil:\n" << endl;
        }

        delete stmt;
        delete res;
    } catch (sql::SQLException& e) {
        cerr << "Eroare la obtinerea preturilor combustibilului: " << e.what() << endl;
    }
}

void send_sport_events(const Client& client){
    if (conn == nullptr) {
        cerr << "Conexiune la baza de date nu este deschisa!" << endl;
        return;
    }

    try{
        sql::PreparedStatement* stmt = conn->prepareStatement(
            "SELECT DISTINCT id FROM evenimente_sportive"
        );
        sql::ResultSet* res = stmt->executeQuery();

        vector<int> ids;
        while (res->next()){
            ids.push_back(res->getInt("id"));
        }

        delete res;
        delete stmt;

        srand(time(nullptr));
        int randomPos = rand() % ids.size();
        int randomId = ids[randomPos];

        stmt = conn->prepareStatement(
            "SELECT descriere, data FROM evenimente_sportive WHERE id = ?"
        );
        stmt->setInt(1, randomId);
        res = stmt->executeQuery();

        string eveniment, data;
        if (res->next()){
            eveniment = res->getString("descriere");
            data = res->getString("data");
        } else {
            cerr << "Nu s a gasit evenimentul cu ID ul " << randomId << "." << endl;
            delete res;
            delete stmt;
            return;
        }

        delete res;
        delete stmt;

        string mesaj_complet = eveniment + " (Evenimentul se va desfasura la data de: " + data + ")";

        Message evenimente_sportive;
        evenimente_sportive.type = SPORT_EVENTS;
        strncpy(evenimente_sportive.data, mesaj_complet.c_str(), BUFFER_SIZE - 1);
        evenimente_sportive.data[BUFFER_SIZE - 1] = '\0';

        if (send(client.socket, &evenimente_sportive, sizeof(Message), 0) < 0){
            perror("Eroare la trimiterea stirilor despre evenimente sportive catre client");
        } else {
            cout << "Trimit catre clientul " << client.socket << " stiri despre evenimente sportive" << endl;
        }
    } catch (sql::SQLException& e){
        cerr << "Eroare la accesarea bazei de date: " << e.what() << endl;
    }
}

void send_weather_updates(const Client& client) {
    if (conn == nullptr) {
        cerr << "Conexiune la baza de date nu este deschisa!" << endl;
        return;
    }

    try {
        sql::PreparedStatement* stmt = conn->prepareStatement(
            "SELECT temperatura, conditii_meteo FROM judet WHERE nume = ?"
        );
        stmt->setString(1, client.judet);
        sql::ResultSet* res = stmt->executeQuery();

        if (!res->next()) {
            cerr << "Orasul " << client.judet << " nu a fost gasit in baza de date!" << endl;
            delete stmt;
            delete res;
            return;
        }

        int temperatura = res->getInt("temperatura");
        string conditii_meteo = res->getString("conditii_meteo");

        stringstream weather_update;
        weather_update << "Vremea in " << client.judet << ": " 
                       << temperatura << "°C, " << conditii_meteo << endl;

        Message weather_message;
        weather_message.type = MessageType::WEATHER;
        strncpy(weather_message.data, weather_update.str().c_str(), BUFFER_SIZE - 1);
        weather_message.data[BUFFER_SIZE - 1] = '\0';

        if (send(client.socket, &weather_message, sizeof(Message), 0) < 0) {
            perror("Eroare la trimiterea vremii catre client");
        } else {
            cout << "Trimis catre clientul " << client.socket << " starea meteo:\n" << weather_update.str() << endl;
        }

        delete stmt;
        delete res;
    } catch (sql::SQLException& e) {
        cerr << "Eroare la obtinerea starii meteo: " << e.what() << endl;
    }
}


void subscribe(Client& client, const string& command) {
    pthread_mutex_lock(&clients_mutex);

    Message mesaj_confirmare;
    mesaj_confirmare.type = UNDEFINED;
    for (auto& c : clients) {
        if (c.socket == client.socket) {
            if (command == "2") {
                c.vreme = true;
                cout << "Clientul " << c.id_client << " a ales informatii despre vreme.\n";
                strcpy(mesaj_confirmare.data, "Te-ai abonat la informatii despre vreme.");
                //update_driver_subscriptions(client.id_client, c.vreme, c.sport, c.carburant);
            } else if (command == "3") {
                c.sport = true;
                cout << "Clientul " << c.id_client << " a ales informatii despre evenimente sportive.\n";
                strcpy(mesaj_confirmare.data, "Te-ai abonat la informatii despre evenimente sportive.");
                //update_driver_subscriptions(client.id_client, c.vreme, c.sport, c.carburant);
            } else if (command == "4") {
                c.carburant = true;
                cout << "Clientul " << c.id_client << " a ales informatii despre preturi la carburant.\n";
                strcpy(mesaj_confirmare.data, "Te-ai abonat la informatii despre preturile la carburant.");
                //update_driver_subscriptions(client.id_client, c.vreme, c.sport, c.carburant);
            }
            cout << c.socket << " " << c.vreme << " " << c.sport << " " << c.carburant << endl;
            update_driver_subscriptions(c.id_client, c.vreme, c.sport, c.carburant);
            
            if (send(client.socket, &mesaj_confirmare, sizeof(Message), 0) < 0) {
                perror("Eroare la trimiterea confirmarii catre client");
            }
            break;
        }
    }

    pthread_mutex_unlock(&clients_mutex);
}

void send_message_to_all_clients(const Message& message, int sender_socket) {
    pthread_mutex_lock(&clients_mutex);

    for (const auto& client : clients) {
        if (client.socket != sender_socket) {
            if (send(client.socket, &message, sizeof(Message), 0) < 0) {
                perror("Eroare la trimiterea mesajului catre client");
            }
        }
    }

    pthread_mutex_unlock(&clients_mutex);
}

void receive_incident_info(Client& client){
    // asteapta informatiile despre incident
    Message response_info;
    int valread = read(client.socket, &response_info, sizeof(Message));
    if (valread > 0){
        response_info.data[BUFFER_SIZE - 1] = '\0';
        if (response_info.type == MessageType::INCIDENT){
            cout << "Informatii despre incident de la clientul " << client.socket << ": " << response_info.data << endl;
            save_incident_to_db(response_info.data, client);

            // trimite incidentul catre toti ceilalti clienti
            send_message_to_all_clients(response_info, client.socket);
        } else {
            cout << "Mesaj primit dar nu este de tip INCIDENT";
        }
    }
    else if (valread == 0){
        cout << "Clientul " << client.socket << " s-a deconectat in timpul raportarii incidentului\n";
    } else {
        perror("Eroare la citirea informatiilor despre incident");
    }

}


void process_location_message(string locatie, Client& client){
    string strada, oras;

    stringstream ss(locatie);

    getline(ss, strada, ',');
    getline(ss, oras);

    strada.erase(strada.find_last_not_of(" ") + 1);
    oras.erase(0, oras.find_first_not_of(" "));

    pthread_mutex_lock(&clients_mutex);

    for (auto& c : clients) {
        if (c.socket == client.socket) {
            strcpy(c.judet, oras.c_str());
            strcpy(c.strada, strada.c_str());
            save_driver_to_db(strada, oras, c);
            client.id_client = c.id_client;
            cout << c.strada << " " << c.judet << " " << c.socket << " " << c.id_client << endl;
            break;
        }
    }

    pthread_mutex_unlock(&clients_mutex);
}

void process_message(const Message& message, Client& client) {
    int viteza;
    
    switch (message.type) {
        case MessageType::SPEED:
            pthread_mutex_lock(&clients_mutex);
            viteza = atoi(message.data);
            pthread_mutex_unlock(&clients_mutex);
            update_driver_speed(client.id_client, viteza);
            cout << "update speed: " << client.id_client << " viteza " << viteza << endl;
            break;

        case MessageType::COMMAND:
            subscribe(client, message.data);
            cout  << "subscribe " << client.socket << " " << client.id_client << endl;
            break;

        case MessageType::INCIDENT:
            receive_incident_info(client);
            break;

        case MessageType::LOCATION:
            process_location_message(message.data, client);
            break;

        default:
            cout << "Comanda necunoscuta\n";
    }
}

void send_updates_to_clients(int update_type) {
    pthread_mutex_lock(&clients_mutex);

    for (const auto& client : clients) {
        if (update_type == 1 && client.vreme) send_weather_updates(client);
        if (update_type == 2 && client.sport) send_sport_events(client);
        if (update_type == 3 && client.carburant) send_fuel_prices(client);
        if (update_type == 4){
            int a = client.id_client;
            if (a != -1){
                cout << "ID-ul soferului este: " << a << endl;
            } else{
                cout << "Soferul nu a fost gasit" << endl; 
            }
            int speed_limit = get_speed_limit_for_street(client);
            Message speed_limit_message;
            speed_limit_message.type = SPEED_LIMIT;
            snprintf(speed_limit_message.data, sizeof(speed_limit_message.data), "Atentie! Limita de viteza pe portiunea ta de drum este: %d km/h", speed_limit);
            send(client.socket, &speed_limit_message, sizeof(speed_limit_message), 0);
        }
    }

    pthread_mutex_unlock(&clients_mutex);
}

void* send_periodic_updates(void*) {
    while (true) {
        send_updates_to_clients(1);
        send_updates_to_clients(2);
        send_updates_to_clients(3);
        send_updates_to_clients(4);
        sleep(45);
    }
    return nullptr;
}



void* handle_client(void* arg) {
    int client_socket = *static_cast<int*>(arg);
    delete static_cast<int*>(arg);

    Client client_ptr;
    bool client_found = false;

    pthread_mutex_lock(&clients_mutex);
    for (auto& c : clients) {
        if (c.socket == client_socket) {
            client_ptr = c; 
            client_found = true;
            break;
        }
    }
    pthread_mutex_unlock(&clients_mutex);

    if (!client_found) {
        cout << "Clientul nu exista.\n";
        close(client_socket);
        return nullptr;
    }

    Message message;

    while (true) {
        int valread = read(client_socket, &message, sizeof(Message));
        if (valread > 0) {
            process_message(message, client_ptr);
        } else if (valread == 0) {
            cout << "Clientul " << client_socket << " s-a deconectat\n";
            break;
        } else {
            perror("Eroare la citire");
            break;
        }
    }

    pthread_mutex_lock(&clients_mutex);
    auto it = clients.begin();
    while (it != clients.end()) {
        if (it->socket == client_socket) {
            it = clients.erase(it);
        } else {
            ++it;
        }
    }

    pthread_mutex_unlock(&clients_mutex);

    close(client_socket);
    return nullptr;
}

int main() {
    srand(time(nullptr));

    if (!connect_to_db()) {
        cerr << "Nu s-a putut conecta la baza de date. Oprirea serverului." << endl;
        exit(EXIT_FAILURE);
    }

    int server_fd;
    sockaddr_in address;
    int addrlen = sizeof(address);

    pthread_t update_thread;

    // creare socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("Eroare la crearea socket-ului");
        exit(EXIT_FAILURE);
    }

    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);

    // atasez socket la port
    if (bind(server_fd, reinterpret_cast<sockaddr*>(&address), sizeof(address)) < 0) {
        perror("Eroare la bind");
        exit(EXIT_FAILURE);
    }

    // ascult conexiuni
    if (listen(server_fd, 10) < 0) {
        perror("Eroare la listen");
        exit(EXIT_FAILURE);
    }

    // thread pt update-uri periodice
    pthread_create(&update_thread, nullptr, send_periodic_updates, nullptr);

    while (true) {
        int* new_socket = new int;
        if ((*new_socket = accept(server_fd, reinterpret_cast<sockaddr*>(&address), reinterpret_cast<socklen_t*>(&addrlen))) < 0) {
            perror("Eroare la accept");
            delete new_socket;
            continue;
        }

        cout << "S-a realizat o noua conexiune\n";

        cout << "Socket acceptat: " << *new_socket << endl;

        pthread_mutex_lock(&clients_mutex);
        if (clients.size() < MAX_CLIENTS) {
            clients.push_back({*new_socket});
        } else {
            cout << "Numarul maxim de utilizatori a fost atins. Conexiune refuzata!\n";
            close(*new_socket);
            delete new_socket;
            pthread_mutex_unlock(&clients_mutex);
            continue;
        }
        pthread_mutex_unlock(&clients_mutex);

        pthread_t client_thread;
        if (pthread_create(&client_thread, nullptr, handle_client, new_socket) != 0) {
            perror("Nu s-a putut crea thread-ul client");
            delete new_socket;
            continue;
        }

        pthread_detach(client_thread);
    }

    close(server_fd);
    return 0;
}