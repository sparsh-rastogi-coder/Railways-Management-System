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




INSERT INTO Stations (station_id, station_name, city, state, address, no_of_platforms, has_waiting_room, has_wifi) VALUES
('NDLS', 'New Delhi', 'New Delhi', 'Delhi', 'Paharganj, New Delhi-110055', 16, TRUE, TRUE),
('CSTM', 'Chhatrapati Shivaji Terminus', 'Mumbai', 'Maharashtra', 'Fort, Mumbai-400001', 18, TRUE, TRUE),
('HWH', 'Howrah Junction', 'Kolkata', 'West Bengal', 'Howrah-711101', 23, TRUE, TRUE),
('MAS', 'Chennai Central', 'Chennai', 'Tamil Nadu', 'Park Town, Chennai-600003', 12, TRUE, TRUE),
('SBC', 'KSR Bengaluru', 'Bengaluru', 'Karnataka', 'Majestic, Bengaluru-560023', 10, TRUE, TRUE),
('BCT', 'Mumbai Central', 'Mumbai', 'Maharashtra', 'Mumbai Central, Mumbai-400008', 5, TRUE, TRUE),
('PUNE', 'Pune Junction', 'Pune', 'Maharashtra', 'Pune Station Road, Pune-411001', 6, TRUE, TRUE),
('JP', 'Jaipur Junction', 'Jaipur', 'Rajasthan', 'Station Road, Jaipur-302006', 6, TRUE, TRUE),
('ADI', 'Ahmedabad Junction', 'Ahmedabad', 'Gujarat', 'Kalupur, Ahmedabad-380002', 10, TRUE, TRUE),
('LKO', 'Lucknow Junction', 'Lucknow', 'Uttar Pradesh', 'Charbagh, Lucknow-226004', 9, TRUE, TRUE),
('PNBE', 'Patna Junction', 'Patna', 'Bihar', 'Station Road, Patna-800001', 10, TRUE, TRUE),
('BBS', 'Bhubaneswar', 'Bhubaneswar', 'Odisha', 'Master Canteen Area, Bhubaneswar-751003', 6, TRUE, TRUE),
('HYB', 'Hyderabad Deccan', 'Hyderabad', 'Telangana', 'Nampally, Hyderabad-500001', 6, TRUE, FALSE),
('SC', 'Secunderabad Junction', 'Hyderabad', 'Telangana', 'Secunderabad-500003', 10, TRUE, TRUE),
('CNB', 'Kanpur Central', 'Kanpur', 'Uttar Pradesh', 'Kanpur-208001', 10, TRUE, FALSE),
('ALD', 'Prayagraj Junction', 'Prayagraj', 'Uttar Pradesh', 'Civil Lines, Prayagraj-211001', 10, TRUE, FALSE),
('JU', 'Jodhpur Junction', 'Jodhpur', 'Rajasthan', 'Station Road, Jodhpur-342001', 5, TRUE, FALSE),
('GAYA', 'Gaya Junction', 'Gaya', 'Bihar', 'Station Road, Gaya-823002', 9, TRUE, FALSE),
('NGP', 'Nagpur Junction', 'Nagpur', 'Maharashtra', 'Nagpur-440001', 8, TRUE, TRUE),
('BPL', 'Bhopal Junction', 'Bhopal', 'Madhya Pradesh', 'Bhopal-462001', 6, TRUE, TRUE);

-- ==========================================
-- Populate Classes
-- ==========================================
INSERT INTO Classes (class_id, class_name, description, is_ac, has_charging_point, has_bedding, base_fare_per_km) VALUES
('1A', 'First Class AC', 'Premium air-conditioned coach with lockable doors', TRUE, TRUE, TRUE, 3.50),
('2A', 'AC 2-Tier', 'Air-conditioned coach with 2-berth compartments', TRUE, TRUE, TRUE, 2.10),
('3A', 'AC 3-Tier', 'Air-conditioned coach with 3-berth compartments', TRUE, TRUE, TRUE, 1.40),
('SL', 'Sleeper Class', 'Non-AC coach with 3-berth compartments', FALSE, TRUE, FALSE, 0.60),
('CC', 'Chair Car', 'Air-conditioned seating coach', TRUE, TRUE, FALSE, 1.35),
('2S', 'Second Sitting', 'Non-AC seating coach', FALSE, FALSE, FALSE, 0.40),
('FC', 'First Class', 'Premium non-AC coach with lockable doors', FALSE, TRUE, TRUE, 2.20),
('EC', 'Executive Chair Car', 'Premium air-conditioned seating coach', TRUE, TRUE, FALSE, 2.80);

-- ==========================================
-- Populate Trains
-- ==========================================
INSERT INTO Trains (train_id, train_name, train_type, total_distance, avg_speed, has_pantry, source_station_id, destination_station_id) VALUES
('12301', 'Rajdhani Express', 'Rajdhani', 1415, 90, TRUE, 'NDLS', 'HWH'),
('12302', 'Rajdhani Express', 'Rajdhani', 1415, 90, TRUE, 'HWH', 'NDLS'),
('12951', 'Mumbai Rajdhani', 'Rajdhani', 1384, 85, TRUE, 'NDLS', 'BCT'),
('12952', 'Mumbai Rajdhani', 'Rajdhani', 1384, 85, TRUE, 'BCT', 'NDLS'),
('12269', 'Chennai Duronto', 'Duronto', 2176, 80, TRUE, 'NDLS', 'MAS'),
('12270', 'Chennai Duronto', 'Duronto', 2176, 80, TRUE, 'MAS', 'NDLS'),
('12001', 'Shatabdi Express', 'Shatabdi', 284, 70, TRUE, 'NDLS', 'LKO'),
('12002', 'Shatabdi Express', 'Shatabdi', 284, 70, TRUE, 'LKO', 'NDLS'),
('12611', 'Garib Rath Express', 'Garib Rath', 2122, 75, FALSE, 'NDLS', 'MAS'),
('12612', 'Garib Rath Express', 'Garib Rath', 2122, 75, FALSE, 'MAS', 'NDLS'),
('12309', 'Patna Rajdhani', 'Rajdhani', 997, 85, TRUE, 'NDLS', 'PNBE'),
('12310', 'Patna Rajdhani', 'Rajdhani', 997, 85, TRUE, 'PNBE', 'NDLS'),
('22691', 'Bengaluru Rajdhani', 'Rajdhani', 2420, 80, TRUE, 'NDLS', 'SBC'),
('22692', 'Bengaluru Rajdhani', 'Rajdhani', 2420, 80, TRUE, 'SBC', 'NDLS'),
('18635', 'Hatia Express', 'Express', 1250, 60, FALSE, 'HWH', 'HYB'),
('18636', 'Hatia Express', 'Express', 1250, 60, FALSE, 'HYB', 'HWH'),
('16723', 'Ananthapuri Express', 'Express', 984, 55, FALSE, 'MAS', 'CSTM'),
('16724', 'Ananthapuri Express', 'Express', 984, 55, FALSE, 'CSTM', 'MAS'),
('20901', 'Mumbai-Bhubaneswar Express', 'Express', 1800, 60, TRUE, 'BCT', 'BBS'),
('20902', 'Bhubaneswar-Mumbai Express', 'Express', 1800, 60, TRUE, 'BBS', 'BCT');

-- ==========================================
-- Populate TrainClasses
-- ==========================================
INSERT INTO TrainClasses (train_id, class_id, total_seats) VALUES
('12301', '1A', 24),
('12301', '2A', 60),
('12301', '3A', 96),
('12302', '1A', 24),
('12302', '2A', 60),
('12302', '3A', 96),
('12951', '1A', 24),
('12951', '2A', 60),
('12951', '3A', 96),
('12952', '1A', 24),
('12952', '2A', 60),
('12952', '3A', 96),
('12269', '2A', 60),
('12269', '3A', 96),
('12270', '2A', 60),
('12270', '3A', 96),
('12001', 'CC', 144),
('12001', 'EC', 60),
('12002', 'CC', 144),
('12002', 'EC', 60),
('12611', '3A', 144),
('12612', '3A', 144),
('12309', '1A', 24),
('12309', '2A', 60),
('12309', '3A', 96),
('12310', '1A', 24),
('12310', '2A', 60),
('12310', '3A', 96),
('22691', '1A', 24),
('22691', '2A', 60),
('22691', '3A', 96),
('22692', '1A', 24),
('22692', '2A', 60),
('22692', '3A', 96),
('18635', 'SL', 216),
('18635', '3A', 96),
('18635', '2A', 48),
('18636', 'SL', 216),
('18636', '3A', 96),
('18636', '2A', 48),
('16723', 'SL', 216),
('16723', '3A', 96),
('16723', '2A', 48),
('16723', '2S', 108),
('16724', 'SL', 216),
('16724', '3A', 96),
('16724', '2A', 48),
('16724', '2S', 108),
('20901', 'SL', 216),
('20901', '3A', 96),
('20901', '2A', 60),
('20902', 'SL', 216),
('20902', '3A', 96),
('20902', '2A', 60);

-- ==========================================
-- Populate Routes
-- ==========================================
-- For Rajdhani Express (NDLS to HWH)
INSERT INTO Routes (train_id, route_order, station_id, arrival_time, departure_time, halt_time, distance_from_source, day_number) VALUES
('12301', 1, 'NDLS', NULL, '16:55:00', NULL, 0, 1),
('12301', 2, 'CNB', '22:05:00', '22:15:00', 10, 435, 1),
('12301', 3, 'ALD', '00:15:00', '00:25:00', 10, 632, 2),
('12301', 4, 'PNBE', '07:15:00', '07:25:00', 10, 997, 2),
('12301', 5, 'GAYA', '09:05:00', '09:10:00', 5, 1122, 2),
('12301', 6, 'HWH', '10:55:00', NULL, NULL, 1415, 2);

-- For Mumbai Rajdhani (NDLS to BCT)
INSERT INTO Routes (train_id, route_order, station_id, arrival_time, departure_time, halt_time, distance_from_source, day_number) VALUES
('12951', 1, 'NDLS', NULL, '16:25:00', NULL, 0, 1),
('12951', 2, 'JP', '21:25:00', '21:30:00', 5, 314, 1),
('12951', 3, 'ADI', '04:50:00', '05:00:00', 10, 943, 2),
('12951', 4, 'BCT', '08:15:00', NULL, NULL, 1384, 2);

-- For Chennai Duronto (NDLS to MAS)
INSERT INTO Routes (train_id, route_order, station_id, arrival_time, departure_time, halt_time, distance_from_source, day_number) VALUES
('12269', 1, 'NDLS', NULL, '15:55:00', NULL, 0, 1),
('12269', 2, 'BPL', '00:25:00', '00:35:00', 10, 699, 2),
('12269', 3, 'NGP', '06:15:00', '06:25:00', 10, 1094, 2),
('12269', 4, 'SC', '13:30:00', '13:40:00', 10, 1659, 2),
('12269', 5, 'MAS', '20:25:00', NULL, NULL, 2176, 2);

-- For Bengaluru Rajdhani (NDLS to SBC)
INSERT INTO Routes (train_id, route_order, station_id, arrival_time, departure_time, halt_time, distance_from_source, day_number) VALUES
('22691', 1, 'NDLS', NULL, '20:50:00', NULL, 0, 1),
('22691', 2, 'BPL', '05:45:00', '05:55:00', 10, 704, 2),
('22691', 3, 'NGP', '10:45:00', '10:55:00', 10, 1092, 2),
('22691', 4, 'SC', '18:30:00', '18:40:00', 10, 1659, 2),
('22691', 5, 'SBC', '05:30:00', NULL, NULL, 2420, 3);

-- For Mumbai-Bhubaneswar Express (BCT to BBS)
INSERT INTO Routes (train_id, route_order, station_id, arrival_time, departure_time, halt_time, distance_from_source, day_number) VALUES
('20901', 1, 'BCT', NULL, '11:35:00', NULL, 0, 1),
('20901', 2, 'PUNE', '15:45:00', '15:55:00', 10, 192, 1),
('20901', 3, 'NGP', '03:25:00', '03:35:00', 10, 889, 2),
('20901', 4, 'HWH', '18:45:00', '19:05:00', 20, 1501, 2),
('20901', 5, 'BBS', '03:15:00', NULL, NULL, 1800, 3);

-- ==========================================
-- Populate Concession Categories
-- ==========================================
INSERT INTO ConcessionCategories (category_id, category_name, discount_percentage, id_proof_required, description) VALUES
('SR', 'Senior Citizen (Male)', 40.00, 'Age Proof (Voter ID, Aadhar, etc.)', 'Men aged 60 years or above'),
('SRF', 'Senior Citizen (Female)', 50.00, 'Age Proof (Voter ID, Aadhar, etc.)', 'Women aged 58 years or above'),
('STU', 'Student', 75.00, 'Valid Student ID Card', 'Students with valid university/college ID'),
('HP', 'Physically Challenged', 75.00, 'Disability Certificate', 'Persons with physical disabilities'),
('WR', 'War Widow', 75.00, 'War Widow Certificate', 'Widows of defense personnel who died in action'),
('MD', 'Medical Professional', 10.00, 'Medical Council Registration', 'Doctors traveling for professional work'),
('SC', 'Sports Person', 75.00, 'Sports Certificate', 'Persons participating in national/international sports events'),
('PJ', 'Journalist', 30.00, 'Press Card', 'Accredited journalists');

-- ==========================================
-- Populate Payment Methods
-- ==========================================
INSERT INTO PaymentMethods (payment_method_id, method_name, description, is_online) VALUES
('CC', 'Credit Card', 'Payment via credit card', TRUE),
('DC', 'Debit Card', 'Payment via debit card', TRUE),
('NB', 'Net Banking', 'Payment via Internet banking', TRUE),
('UPI', 'UPI', 'Payment via UPI apps like Google Pay, PhonePe, etc.', TRUE),
('WL', 'Mobile Wallet', 'Payment via mobile wallets like Paytm, Amazon Pay, etc.', TRUE),
('CH', 'Cash', 'Payment via cash at counter', FALSE),
('DD', 'Demand Draft', 'Payment via bank draft at counter', FALSE);

-- ==========================================
-- Populate Schedules
INSERT INTO Schedules (train_id, status, delay_time, remarks)
VALUES 
('12301', 'On-time', 0, 'Running as per schedule'),
('12951', 'Delayed', 45, 'Signal failure at previous station'),
('12269', 'Cancelled', 0, 'Operational issues'),
('22691', 'Rescheduled', 120, 'Departure shifted due to maintenance'),
('20901', 'On-time', 0, 'No delays reported');

-- ==========================================
-- Populate Seat Availability (based on schedules)
-- ==========================================
INSERT INTO SeatAvailability (schedule_id, class_id, available_seats, waitlisted_count, rac_count,Date)
SELECT s.schedule_id, tc.class_id,tc.total_seats,0,0,'2025-04-25'
FROM Schedules s
JOIN TrainClasses tc ON s.train_id = tc.train_id where s.schedule_id BETWEEN 517 AND 526;
-- Alternative approach using a JOIN to populate SeatAvailability
INSERT INTO SeatAvailability (schedule_id, class_id, available_seats, waitlisted_count, rac_count, Date)
SELECT s.schedule_id, c.class_id, tc.total_seats, 0, 0, '2025-04-25'
FROM Schedules s
CROSS JOIN Classes c
WHERE s.schedule_id BETWEEN 517 AND 526;


-- ==========================================
-- Populate Passengers
-- ==========================================
INSERT INTO Passengers (first_name, last_name, date_of_birth, gender, contact_no, email, address, is_registered, username, password_hash, date_registered) VALUES
('Rajesh', 'Kumar', '1985-05-12', 'Male', '9876543210', 'rajesh.kumar@email.com', '123 Main St, New Delhi', TRUE, 'rajesh85', 'hash1', '2024-01-15 10:30:00'),
('Priya', 'Sharma', '1990-08-23', 'Female', '8765432109', 'priya.sharma@email.com', '456 Park Avenue, Mumbai', TRUE, 'priya90', 'hash2', '2024-02-01 14:45:00'),
('Amit', 'Singh', '1978-11-30', 'Male', '7654321098', 'amit.singh@email.com', '789 Railway Colony, Kolkata', TRUE, 'amit78', 'hash3', '2024-01-05 09:15:00'),
('Sneha', 'Patel', '1992-03-17', 'Female', '6543210987', 'sneha.patel@email.com', '234 Beach Road, Chennai', TRUE, 'sneha92', 'hash4', '2024-03-10 16:20:00'),
('Vikram', 'Gupta', '1982-07-04', 'Male', '5432109876', 'vikram.gupta@email.com', '567 MG Road, Bengaluru', TRUE, 'vikram82', 'hash5', '2024-02-20 11:10:00'),
('Neha', 'Verma', '1995-01-21', 'Female', '4321098765', 'neha.verma@email.com', '890 Civil Lines, Allahabad', TRUE, 'neha95', 'hash6', '2024-03-05 13:30:00'),
('Sanjay', 'Joshi', '1975-09-08', 'Male', '3210987654', 'sanjay.joshi@email.com', '123 Lajpat Nagar, New Delhi', FALSE, NULL, NULL, NULL),
('Deepika', 'Das', '1988-12-15', 'Female', '2109876543', 'deepika.das@email.com', '456 Salt Lake, Kolkata', TRUE, 'deepika88', 'hash7', '2024-01-25 17:40:00'),
('Ravi', 'Tiwari', '1980-04-29', 'Male', '1098765432', 'ravi.tiwari@email.com', '789 Andheri West, Mumbai', TRUE, 'ravi80', 'hash8', '2024-02-10 12:15:00'),
('Anita', 'Reddy', '1993-06-11', 'Female', '9087654321', 'anita.reddy@email.com', '234 Jayanagar, Bengaluru', FALSE, NULL, NULL, NULL),
('Manoj', 'Desai', '1972-10-03', 'Male', '8976543210', 'manoj.desai@email.com', '567 Shivaji Nagar, Pune', TRUE, 'manoj72', 'hash9', '2024-03-15 10:05:00'),
('Kavita', 'Mehta', '1987-02-27', 'Female', '7865432109', 'kavita.mehta@email.com', '890 Vasant Kunj, New Delhi', TRUE, 'kavita87', 'hash10', '2024-01-10 15:25:00'),
('Alok', 'Nair', '1991-12-09', 'Male', '6754321098', 'alok.nair@email.com', '123 Adyar, Chennai', FALSE, NULL, NULL, NULL),
('Sunita', 'Agarwal', '1983-08-16', 'Female', '5643210987', 'sunita.agarwal@email.com', '456 Model Town, Jaipur', TRUE, 'sunita83', 'hash11', '2024-02-05 09:50:00'),
('Dinesh', 'Rao', '1979-05-22', 'Male', '4532109876', 'dinesh.rao@email.com', '789 Malleswaram, Bengaluru', TRUE, 'dinesh79', 'hash12', '2024-03-20 14:35:00'),
('Pooja', 'Saxena', '1994-11-08', 'Female', '3421098765', 'pooja.saxena@email.com', '234 Gomti Nagar, Lucknow', FALSE, NULL, NULL, NULL),
('Rahul', 'Malhotra', '1981-03-25', 'Male', '2310987654', 'rahul.malhotra@email.com', '567 Hazratganj, Lucknow', TRUE, 'rahul81', 'hash13', '2024-01-20 11:55:00'),
('Meena', 'Kapoor', '1986-07-13', 'Female', '1209876543', 'meena.kapoor@email.com', '890 Secretariat, Hyderabad', TRUE, 'meena86', 'hash14', '2024-02-15 16:40:00'),
('Suresh', 'Bansal', '1977-09-04', 'Male', '9198765432', 'suresh.bansal@email.com', '123 Connaught Place, New Delhi', FALSE, NULL, NULL, NULL),
('Leela', 'Iyer', '1989-01-30', 'Female', '8187654321', 'leela.iyer@email.com', '456 T. Nagar, Chennai', TRUE, 'leela89', 'hash15', '2024-03-25 12:10:00'),
('Prakash', 'Bajaj', '1974-04-18', 'Male', '7176543210', 'prakash.bajaj@email.com', '789 Alipore, Kolkata', TRUE, 'prakash74', 'hash16', '2024-01-30 10:20:00'),
('Geeta', 'Walia', '1996-08-22', 'Female', '6165432109', 'geeta.walia@email.com', '234 Palam Vihar, Gurgaon', FALSE, NULL, NULL, NULL),
('Arun', 'Sengupta', '1984-12-14', 'Male', '5154321098', 'arun.sengupta@email.com', '567 Lake Gardens, Kolkata', TRUE, 'arun84', 'hash17', '2024-02-25 15:30:00'),
('Nisha', 'Pillai', '1990-02-28', 'Female', '4143210987', 'nisha.pillai@email.com', '890 Matunga, Mumbai', TRUE, 'nisha90', 'hash18', '2024-03-30 09:25:00'),
('Kunal', 'Chopra', '1976-06-07', 'Male', '3132109876', 'kunal.chopra@email.com', '123 Defence Colony, New Delhi', FALSE, NULL, NULL, NULL),
('Radha', 'Venkatesh', '1993-10-19', 'Female', '2121098765', 'radha.venkatesh@email.com', '456 Marathahalli, Bengaluru', TRUE, 'radha93', 'hash19', '2024-01-05 14:15:00'),
('Mohan', 'Bhatia', '1970-05-31', 'Male', '1110987654', 'mohan.bhatia@email.com', '789 Civil Lines, Agra', TRUE, 'mohan70', 'hash20', '2024-02-08 17:35:00'),
('Shalini', 'Chawla', '1985-11-10', 'Female', '9090876543', 'shalini.chawla@email.com', '234 Boring Road, Patna', FALSE, NULL, NULL, NULL),
('Ashok', 'Mehra', '1988-03-23', 'Male', '8080765432', 'ashok.mehra@email.com', '567 Gole Market, New Delhi', TRUE, 'ashok88', 'hash21', '2024-03-12 11:40:00'),
('Jaya', 'Chandra', '1983-07-05', 'Female', '7070654321', 'jaya.chandra@email.com', '890 BTM Layout, Bengaluru', TRUE, 'jaya83', 'hash22', '2024-01-18 15:55:00');






SET @pnr_number = '';
SET @status = '';

CALL BookTicket(
    10,                  -- Sneha Patel (passenger_id)
    '2A',               -- AC 2-Tier (class_id)
    515,                -- Schedule for Bengaluru Rajdhani (train_id: 22691) - Rescheduled
    '2025-04-25',       -- Journey date
    'NDLS',             -- New Delhi (source_station_id)
    'BPL',              -- Bhopal Junction (destination_station_id)
    'DC',               -- Debit Card (payment_method_id)
    'Tatkal',           -- Tatkal Ticket
    NULL,               -- No concession
    @pnr_number,        -- Output parameter for PNR
    @status             -- Output parameter for status
);

SELECT @pnr_number AS 'PNR Number', @status AS 'Booking Status';
