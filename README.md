# Overview

Traffic Monitoring is a C++-based application designed to facilitate real-time monitoring and reporting of traffic data. The system allows users to send speed data, report incidents, and receive information about weather, fuel prices, and sporting events. The project utilizes multi-threading, socket communication, and message queues for efficient data processing.

## Features

Real-time vehicle speed reporting

Incident reporting and alert system

Communication with a remote server via sockets

Multi-threaded message handling

Location-based data management

## Installation

1. Clone the repository
```git clone https://github.com/EduardZaborila3/Traffic_Monitoring.git```
2. Navigate to the project directory

3. Compile the C++ files:
```g++ -o client Client.cpp -lpthread```

4. Run the application:
```./client Street, City```

## Usage

After launching the application, you will be prompted to input your location (street, city).

The menu provides the following options:

Press 1 to report an incident (you will be asked to provide details).

Press 2 to request weather information.

Press 3 to request sports event updates.

Press 4 to request fuel price updates.

The system continuously monitors and sends speed data to the server every 60 seconds.

The client listens for messages from the server and responds accordingly.
## License

This project is licensed under the MIT License. See the LICENSE file for details.
