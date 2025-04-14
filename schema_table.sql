-- ==========================================
-- 🚆 INDIAN RAILWAYS EXPRESS 🚆
-- ==========================================

--            o O ________________
--        _][__|o|  |  |  |  |  |\
--         <_______|__|__|__|__|__|_)
--          /0-0-0            0-0-0\

-- ==========================================
-- 🚧 Designed & Developed By:
-- 👨‍💻 Abhay Pratap Singh
-- 👨‍💻 Sparsh Rastogi
-- 👨‍💻 Ansh Prem
-- 👨‍💻 Saksham Srivastava
-- ==========================================
-- CS2202 Mini Project – Indian Railways Reservation System | IIT Patna
-- ==========================================


-- Database Creation
CREATE DATABASE IF NOT EXISTS railway_reservation;
USE railway_reservation;

-- ==========================================
-- Table Definitions
-- ==========================================

-- Stations Table
CREATE TABLE Stations (
    station_id VARCHAR(10) PRIMARY KEY,
    station_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    address VARCHAR(200),
    no_of_platforms INT NOT NULL DEFAULT 1,
    has_waiting_room BOOLEAN DEFAULT FALSE,
    has_wifi BOOLEAN DEFAULT FALSE
);

-- Trains Table
CREATE TABLE Trains (
    train_id VARCHAR(10) PRIMARY KEY,
    train_name VARCHAR(100) NOT NULL,
    train_type ENUM('Express', 'Superfast', 'Passenger', 'Rajdhani', 'Shatabdi', 'Duronto', 'Garib Rath') NOT NULL,
    total_distance INT NOT NULL, -- in kilometers
    avg_speed INT NOT NULL,
    has_pantry BOOLEAN DEFAULT FALSE,
    source_station_id VARCHAR(10) NOT NULL,
    destination_station_id VARCHAR(10) NOT NULL,
    FOREIGN KEY (source_station_id) REFERENCES Stations(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES Stations(station_id)
);

-- Classes Table
CREATE TABLE Classes (
    class_id VARCHAR(5) PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    is_ac BOOLEAN NOT NULL,
    has_charging_point BOOLEAN DEFAULT TRUE,
    has_bedding BOOLEAN DEFAULT TRUE,
    base_fare_per_km DECIMAL(8,2) NOT NULL
);

-- Train Classes Table (Which trains offer which classes)
CREATE TABLE TrainClasses (
    train_id VARCHAR(10) NOT NULL,
    class_id VARCHAR(5) NOT NULL,
    total_seats INT NOT NULL,
    PRIMARY KEY (train_id, class_id),
    FOREIGN KEY (train_id) REFERENCES Trains(train_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

-- Routes Table
CREATE TABLE Routes (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    train_id VARCHAR(10) NOT NULL,
    route_order INT NOT NULL,
    station_id VARCHAR(10) NOT NULL,
    arrival_time TIME,
    departure_time TIME,
    halt_time INT, -- in minutes
    distance_from_source INT NOT NULL, -- in kilometers
    day_number INT NOT NULL, -- Day 1, Day 2, etc. from journey start
    UNIQUE KEY (train_id, station_id),
    UNIQUE KEY (train_id, route_order),
    FOREIGN KEY (train_id) REFERENCES Trains(train_id),
    FOREIGN KEY (station_id) REFERENCES Stations(station_id)
);

-- Schedules Table
CREATE TABLE Schedules (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    train_id VARCHAR(10) NOT NULL,
    status ENUM('On-time', 'Delayed', 'Cancelled', 'Rescheduled') DEFAULT 'On-time',
    delay_time INT DEFAULT 0, -- in minutes
    remarks VARCHAR(200),
    UNIQUE KEY (train_id),
    FOREIGN KEY (train_id) REFERENCES Trains(train_id)
);

-- Concession Categories Table
CREATE TABLE ConcessionCategories (
    category_id VARCHAR(5) PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    discount_percentage DECIMAL(5,2) NOT NULL,
    id_proof_required VARCHAR(100),
    description VARCHAR(200)
);

-- Passengers Table
CREATE TABLE Passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender ENUM('Male', 'Female', 'Other') NOT NULL,
    contact_no VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(200),
    is_registered BOOLEAN DEFAULT FALSE,
    username VARCHAR(50) UNIQUE,
    password_hash VARCHAR(255),
    date_registered DATETIME
);

-- Payment Methods Table
CREATE TABLE PaymentMethods (
    payment_method_id VARCHAR(5) PRIMARY KEY,
    method_name VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    is_online BOOLEAN NOT NULL
);

-- Tickets Table
CREATE TABLE Tickets (
    pnr_number VARCHAR(15) PRIMARY KEY,
    schedule_id INT NOT NULL,
    class_id VARCHAR(5) NOT NULL,
    booking_date DATETIME NOT NULL,
    journey_date DATE NOT NULL,
    source_station_id VARCHAR(10) NOT NULL,
    destination_station_id VARCHAR(10) NOT NULL,
    total_fare DECIMAL(10,2) NOT NULL,
    booking_status ENUM('Confirmed', 'Waitlisted', 'RAC', 'Cancelled') NOT NULL,
    ticket_type ENUM('E-Ticket', 'Counter', 'Tatkal', 'Premium Tatkal') NOT NULL,
    booked_by INT NOT NULL,
    agent_id VARCHAR(10), -- NULL if not booked through agent
    cancellation_date DATETIME,
    refund_amount DECIMAL(10,2),
    refund_status ENUM('Not Applicable', 'Pending', 'Processed', 'Rejected'),
    FOREIGN KEY (schedule_id) REFERENCES Schedules(schedule_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id),
    FOREIGN KEY (source_station_id) REFERENCES Stations(station_id),
    FOREIGN KEY (destination_station_id) REFERENCES Stations(station_id),
    FOREIGN KEY (booked_by) REFERENCES Passengers(passenger_id)
);

-- Ticket Passengers Table
CREATE TABLE TicketPassengers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pnr_number VARCHAR(15) NOT NULL,
    passenger_id INT NOT NULL,
    seat_number VARCHAR(10),
    concession_category_id VARCHAR(5),
    passenger_status ENUM('Confirmed', 'Waitlisted', 'RAC', 'Cancelled') NOT NULL,
    waitlist_position INT,
    fare DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (pnr_number) REFERENCES Tickets(pnr_number),
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (concession_category_id) REFERENCES ConcessionCategories(category_id)
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    pnr_number VARCHAR(15) NOT NULL,
    payment_method_id VARCHAR(5) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_status ENUM('Successful', 'Failed', 'Pending', 'Refunded') NOT NULL,
    transaction_id VARCHAR(50),
    remarks VARCHAR(200),
    FOREIGN KEY (pnr_number) REFERENCES Tickets(pnr_number),
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethods(payment_method_id)
);

-- Seat Availability Table
CREATE TABLE SeatAvailability (
    schedule_id INT NOT NULL,
    class_id VARCHAR(5) NOT NULL,
    available_seats INT NOT NULL,
    Date date,
    waitlisted_count INT NOT NULL DEFAULT 0,
    rac_count INT NOT NULL DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (schedule_id, class_id,Date),
    FOREIGN KEY (schedule_id) REFERENCES Schedules(schedule_id),
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);