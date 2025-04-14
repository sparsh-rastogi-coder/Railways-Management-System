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






-- ==========================================
-- Stored Procedures and Functions
-- ==========================================

-- Procedure: Get PNR Status
DELIMITER //
CREATE PROCEDURE GetPNRStatus(IN p_pnr_number VARCHAR(15))
BEGIN
    SELECT 
        t.pnr_number,
        tr.train_id,
        tr.train_name,
        t.journey_date,
        s1.station_name AS source_station,
        s2.station_name AS destination_station,
        c.class_name,
        t.booking_status,
        tp.passenger_status,
        CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
        tp.seat_number,
        tp.waitlist_position
    FROM Tickets t
    JOIN Schedules sc ON t.schedule_id = sc.schedule_id
    JOIN Trains tr ON sc.train_id = tr.train_id
    JOIN Stations s1 ON t.source_station_id = s1.station_id
    JOIN Stations s2 ON t.destination_station_id = s2.station_id
    JOIN Classes c ON t.class_id = c.class_id
    JOIN TicketPassengers tp ON t.pnr_number = tp.pnr_number
    JOIN Passengers p ON tp.passenger_id = p.passenger_id
    WHERE t.pnr_number = p_pnr_number;
END //
DELIMITER ;

-- Procedure: Get Train Schedule
DELIMITER //
CREATE PROCEDURE GetTrainSchedule(IN p_train_id VARCHAR(10))
BEGIN
    SELECT 
        r.route_order,
        s.station_name,
        r.arrival_time,
        r.departure_time,
        r.halt_time,
        r.distance_from_source,
        r.day_number
    FROM Routes r
    JOIN Stations s ON r.station_id = s.station_id
    WHERE r.train_id = p_train_id
    ORDER BY r.route_order;
END //
DELIMITER ;
DELIMITER //

DELIMITER $$

CREATE FUNCTION GetSeatAvailabilityJSON(
    p_train_id VARCHAR(10),
    p_journey_date DATE,
    p_class_id VARCHAR(5)
)
RETURNS JSON
DETERMINISTIC
READS SQL DATA
BEGIN
    -- Declare variables to hold the seat availability data
    DECLARE available INT DEFAULT 0;
    DECLARE waitlisted INT DEFAULT 0;
    DECLARE rac INT DEFAULT 0;

    -- Fetch the seat availability info from SeatAvailability table
    SELECT 
        sa.available_seats,
        sa.waitlisted_count,
        sa.rac_count
    INTO 
        available, waitlisted, rac
    FROM 
        SeatAvailability sa
    JOIN 
        Schedules s ON sa.schedule_id = s.schedule_id
    WHERE 
        s.train_id = p_train_id
        AND sa.Date = p_journey_date
        AND sa.class_id = p_class_id
    LIMIT 1;

    -- Return the result as a JSON object
    RETURN JSON_OBJECT(
        'available_seats', available,
        'waitlisted_count', waitlisted,
        'rac_count', rac
    );
END$$

DELIMITER ;


-- Procedure: List Passengers on Train
DELIMITER //
CREATE PROCEDURE ListPassengersOnTrain(
    IN p_train_id VARCHAR(10),
    IN p_journey_date DATE
)
BEGIN
    SELECT 
        CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
        p.gender,
        tp.seat_number,
        c.class_name,
        s1.station_name AS boarding_station,
        s2.station_name AS destination_station,
        tp.passenger_status
    FROM Tickets t
    JOIN Schedules sc ON t.schedule_id = sc.schedule_id
    JOIN TicketPassengers tp ON t.pnr_number = tp.pnr_number
    JOIN Passengers p ON tp.passenger_id = p.passenger_id
    JOIN Classes c ON t.class_id = c.class_id
    JOIN Stations s1 ON t.source_station_id = s1.station_id
    JOIN Stations s2 ON t.destination_station_id = s2.station_id
    WHERE sc.train_id = p_train_id
    AND t.journey_date = p_journey_date
    AND tp.passenger_status IN ('Confirmed', 'RAC')
    ORDER BY c.class_name, tp.seat_number;
END //
DELIMITER ;


-- ==========================================
-- Triggers
-- ==========================================

-- Trigger: Update Seat Availability on Ticket Booking
DELIMITER //
CREATE TRIGGER after_ticket_insert
AFTER INSERT ON Tickets
FOR EACH ROW
BEGIN
    DECLARE passenger_count INT;
    
    -- Count number of passengers in this ticket
    SELECT COUNT(*) INTO passenger_count
    FROM TicketPassengers
    WHERE pnr_number = NEW.pnr_number;
    
    -- Update seat availability
    IF NEW.booking_status = 'Confirmed' THEN
        UPDATE SeatAvailability
        SET available_seats = available_seats - passenger_count
        WHERE schedule_id = NEW.schedule_id AND class_id = NEW.class_id;
    ELSEIF NEW.booking_status = 'Waitlisted' THEN
        UPDATE SeatAvailability
        SET waitlisted_count = waitlisted_count + passenger_count
        WHERE schedule_id = NEW.schedule_id AND class_id = NEW.class_id;
    ELSEIF NEW.booking_status = 'RAC' THEN
        UPDATE SeatAvailability
        SET rac_count = rac_count + passenger_count
        WHERE schedule_id = NEW.schedule_id AND class_id = NEW.class_id;
    END IF;
END //
DELIMITER ;

-- ==========================================
-- Sample Queries as Required in Project
-- ==========================================

-- 1. PNR status tracking for a given ticket
-- Usage: CALL GetPNRStatus('PNR1234567890');

-- 2. Train schedule lookup for a given train
-- Usage: CALL GetTrainSchedule('TRN12345');

-- 3. Available seats query for a specific train, date and class
SELECT CheckSeatAvailability('TRN12345', '2025-05-15', 'SL') AS available_seats;

-- 4. List all passengers traveling on a specific train on a given date
-- Usage: CALL ListPassengersOnTrain('TRN12345', '2025-05-15');

-- 5. Retrieve all waitlisted passengers for a particular train
DELIMITER $$

CREATE PROCEDURE GetWaitlistedPassengers (
    IN input_train_id VARCHAR(20),
    IN input_journey_date DATE
)
BEGIN
    SELECT 
        t.pnr_number,
        CONCAT(p.first_name, ' ', p.last_name) AS passenger_name,
        p.contact_no,
        p.email,
        tp.waitlist_position
    FROM Tickets t
    JOIN Schedules sc ON t.schedule_id = sc.schedule_id
    JOIN TicketPassengers tp ON t.pnr_number = tp.pnr_number
    JOIN Passengers p ON tp.passenger_id = p.passenger_id
    WHERE sc.train_id = input_train_id
      AND t.journey_date = input_journey_date
      AND tp.passenger_status = 'Waitlisted'
    ORDER BY tp.waitlist_position;
END $$

DELIMITER ;
-- 6. Find total amount that needs to be refunded for cancelling a train
DELIMITER $$

CREATE PROCEDURE CalculateTrainCancellationRefund(
    IN p_train_id VARCHAR(10),
    IN p_journey_date DATE,
    OUT p_total_refund_amount DECIMAL(12,2)
)
BEGIN
    -- Calculate total refund amount for all affected valid tickets
    SELECT COALESCE(SUM(t.total_fare), 0) INTO p_total_refund_amount
    FROM Tickets t
    JOIN Schedules s ON t.schedule_id = s.schedule_id
    WHERE s.train_id = p_train_id
    AND t.journey_date = p_journey_date
    AND t.booking_status != 'Cancelled'           -- Exclude already cancelled tickets
    AND t.cancellation_date IS NULL               -- Exclude tickets that are already cancelled
    AND (t.refund_status IS NULL                  -- Exclude tickets already refunded
         OR t.refund_status NOT IN ('Processed', 'Pending'));
    
    -- Return detailed information about affected tickets
    SELECT 
        t.pnr_number,
        t.total_fare AS refund_amount,
        p.first_name,
        p.last_name,
        p.contact_no,
        p.email,
        t.booking_status,
        t.class_id,
        t.source_station_id,
        t.destination_station_id,
        COUNT(tp.id) AS passenger_count
    FROM Tickets t
    JOIN Schedules s ON t.schedule_id = s.schedule_id
    JOIN Passengers p ON t.booked_by = p.passenger_id
    LEFT JOIN TicketPassengers tp ON t.pnr_number = tp.pnr_number
    WHERE s.train_id = p_train_id
    AND t.journey_date = p_journey_date
    AND t.booking_status != 'Cancelled'
    AND t.cancellation_date IS NULL
    AND (t.refund_status IS NULL 
         OR t.refund_status NOT IN ('Processed', 'Pending'))
    GROUP BY t.pnr_number, t.total_fare, p.first_name, p.last_name, 
             p.contact_no, p.email, t.booking_status, t.class_id,
             t.source_station_id, t.destination_station_id;
END$$

DELIMITER ;
-- 7. Total revenue generated from ticket bookings over a specified period
DELIMITER $$

CREATE PROCEDURE GetRevenueSummary (
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT 
        SUM(p.amount) AS total_revenue,
        COUNT(DISTINCT t.pnr_number) AS tickets_sold,
        MIN(p.payment_date) AS period_start,
        MAX(p.payment_date) AS period_end
    FROM Payments p
    JOIN Tickets t ON p.pnr_number = t.pnr_number
    WHERE p.payment_status = 'Successful'
      AND p.payment_date BETWEEN start_date AND end_date;
END $$

DELIMITER ;

-- 8. Cancellation records with refund status
DELIMITER $$

CREATE PROCEDURE GetCancellationRecords (
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    SELECT 
        t.pnr_number,
        CONCAT(p.first_name, ' ', p.last_name) AS booked_by,
        tr.train_name,
        t.journey_date,
        t.cancellation_date,
        t.total_fare,
        t.refund_amount,
        t.refund_status
    FROM Tickets t
    JOIN Schedules sc ON t.schedule_id = sc.schedule_id
    JOIN Trains tr ON sc.train_id = tr.train_id
    JOIN Passengers p ON t.booked_by = p.passenger_id
    WHERE t.booking_status = 'Cancelled'
      AND t.cancellation_date BETWEEN start_date AND end_date
    ORDER BY t.cancellation_date DESC;
END $$

DELIMITER ;

-- 9. Find the busiest route based on passenger count
DELIMITER $$

CREATE PROCEDURE GetBusiestRoutes (
    IN start_date DATE,
    IN end_date DATE,
    IN top_n INT
)
BEGIN
    SELECT 
        CONCAT(s1.station_name, ' - ', s2.station_name) AS route,
        COUNT(tp.id) AS passenger_count
    FROM Tickets t
    JOIN TicketPassengers tp ON t.pnr_number = tp.pnr_number
    JOIN Stations s1 ON t.source_station_id = s1.station_id
    JOIN Stations s2 ON t.destination_station_id = s2.station_id
    WHERE t.journey_date BETWEEN start_date AND end_date
      AND tp.passenger_status != 'Cancelled'
    GROUP BY route
    ORDER BY passenger_count DESC
    LIMIT top_n;
END $$

DELIMITER ;

-- 10. Generate an itemized bill for a ticket including all charges
DELIMITER $$

CREATE PROCEDURE GetItemizedBill (
    IN input_pnr VARCHAR(20)
)
BEGIN
    SELECT 
        t.pnr_number,
        CONCAT(p.first_name, ' ', p.last_name) AS primary_passenger,
        tr.train_name,
        c.class_name,
        t.journey_date,
        s1.station_name AS source,
        s2.station_name AS destination,
        (SELECT COUNT(*) FROM TicketPassengers WHERE pnr_number = t.pnr_number) AS total_passengers,
        (c.base_fare_per_km * 
            (SELECT r2.distance_from_source - r1.distance_from_source 
             FROM Routes r1 
             JOIN Routes r2 ON r1.train_id = r2.train_id 
             WHERE r1.station_id = t.source_station_id 
             AND r2.station_id = t.destination_station_id)) AS base_fare,
        (CASE 
            WHEN t.ticket_type = 'Tatkal' THEN (t.total_fare * 0.15)
            WHEN t.ticket_type = 'Premium Tatkal' THEN (t.total_fare * 0.25)
            ELSE 0
        END) AS premium_charges,
        t.total_fare AS total_amount,
        pm.method_name AS payment_method,
        p2.payment_status
    FROM Tickets t
    JOIN Schedules sc ON t.schedule_id = sc.schedule_id
    JOIN Trains tr ON sc.train_id = tr.train_id
    JOIN Classes c ON t.class_id = c.class_id
    JOIN Stations s1 ON t.source_station_id = s1.station_id
    JOIN Stations s2 ON t.destination_station_id = s2.station_id
    JOIN Passengers p ON t.booked_by = p.passenger_id
    JOIN Payments p2 ON t.pnr_number = p2.pnr_number
    JOIN PaymentMethods pm ON p2.payment_method_id = pm.payment_method_id
    WHERE t.pnr_number = input_pnr;
END $$

DELIMITER ;

--                  ==========================================================



-- book ticket procedure that books a ticket for a passenger and updates the seat availability, payment, etc.


DELIMITER //

CREATE PROCEDURE BookTicket(
    IN p_passenger_id INT,
    IN p_class_id VARCHAR(5),
    IN p_schedule_id INT,
    IN p_journey_date DATE,
    IN p_source_station_id VARCHAR(10),
    IN p_destination_station_id VARCHAR(10),
    IN p_payment_method_id VARCHAR(5),
    IN p_ticket_type ENUM('E-Ticket', 'Counter', 'Tatkal', 'Premium Tatkal'),
    IN p_concession_category_id VARCHAR(5),
    OUT p_pnr_number VARCHAR(15),
    OUT p_status VARCHAR(50)
)
proc_main: BEGIN
    DECLARE v_available_seats INT;
    DECLARE v_train_id VARCHAR(10);
    DECLARE v_total_fare DECIMAL(10,2);
    DECLARE v_passenger_fare DECIMAL(10,2);
    DECLARE v_passenger_status ENUM('Confirmed', 'Waitlisted', 'RAC', 'Cancelled');
    DECLARE v_waitlist_position INT DEFAULT NULL;
    DECLARE v_base_fare_per_km DECIMAL(8,2);
    DECLARE v_distance INT;
    DECLARE v_discount_percentage DECIMAL(5,2) DEFAULT 0;
    DECLARE v_transaction_id VARCHAR(50);
    DECLARE v_seat_number VARCHAR(10) DEFAULT NULL;
    
    -- For handling errors
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_status = 'Error: Transaction rolled back due to exception';
    END;
    
    START TRANSACTION;
    
    -- Generate a unique PNR number (current timestamp + random 4 digits)
    SET p_pnr_number = CONCAT('P', DATE_FORMAT(NOW(), '%y%m%d%H%i'),LPAD(FLOOR(RAND() * 1000), 3, '0'));
    
    -- Get train_id from schedule
    SELECT train_id INTO v_train_id FROM Schedules WHERE schedule_id = p_schedule_id;
    
    -- Check if train route covers source and destination stations
    IF NOT EXISTS (
        SELECT 1 FROM Routes r1 
        JOIN Routes r2 ON r1.train_id = r2.train_id
        WHERE r1.train_id = v_train_id
        AND r1.station_id = p_source_station_id
        AND r2.station_id = p_destination_station_id
        AND r1.route_order < r2.route_order
    ) THEN
        SET p_status = 'Error: Invalid source or destination for this train';
        ROLLBACK;
        LEAVE proc_main;
    END IF;
    IF NOT EXISTS (
        SELECT available_seats
        FROM SeatAvailability
        WHERE schedule_id = p_schedule_id 
        AND class_id = p_class_id 
        AND Date = p_journey_date
    ) THEN
        SET p_status = 'Error: Invalid source or destination for this train';
        ROLLBACK;
        LEAVE proc_main;
    END IF;
    -- Calculate distance between source and destination stations
    SELECT 
        ABS(r2.distance_from_source - r1.distance_from_source) INTO v_distance
    FROM 
        Routes r1
        JOIN Routes r2 ON r1.train_id = r2.train_id
    WHERE 
        r1.train_id = v_train_id
        AND r1.station_id = p_source_station_id
        AND r2.station_id = p_destination_station_id;
    
    -- Get base fare per km for the class
    SELECT base_fare_per_km INTO v_base_fare_per_km 
    FROM Classes WHERE class_id = p_class_id;
    
    -- Calculate total fare (base_fare * distance)
    SET v_passenger_fare = v_base_fare_per_km * v_distance;
    
    -- Apply concession if applicable
    IF p_concession_category_id IS NOT NULL THEN
        SELECT discount_percentage INTO v_discount_percentage 
        FROM ConcessionCategories 
        WHERE category_id = p_concession_category_id;
        SET v_passenger_fare = v_passenger_fare * (1 - (v_discount_percentage / 100));
    END IF;
    
    -- Round to 2 decimal places
    SET v_passenger_fare = ROUND(v_passenger_fare, 2);
    SET v_total_fare = v_passenger_fare;
    
    -- Check seat availability
    SELECT available_seats INTO v_available_seats 
    FROM SeatAvailability 
    WHERE schedule_id = p_schedule_id 
    AND class_id = p_class_id 
    AND Date = p_journey_date;
    
    -- Determine passenger status based on availability
    IF v_available_seats > 0 THEN
        SET v_passenger_status = 'Confirmed';
        SET v_seat_number = CONCAT(p_class_id, '-', (SELECT total_seats FROM TrainClasses WHERE train_id = v_train_id AND class_id = p_class_id) - v_available_seats + 1);
    ELSE
        -- Check RAC eligibility (implement according to your business rules)
        -- For simplicity, just setting as waitlisted here
        SET v_passenger_status = 'Waitlisted';
        
        -- Get current waitlist position
        SELECT IFNULL(MAX(waitlist_position), 0) + 1 INTO v_waitlist_position
        FROM TicketPassengers tp
        JOIN Tickets t ON tp.pnr_number = t.pnr_number
        WHERE t.schedule_id = p_schedule_id
        AND t.class_id = p_class_id
        AND t.journey_date = p_journey_date
        AND tp.passenger_status = 'Waitlisted';
    END IF;
    
    -- Create ticket record
    INSERT INTO Tickets (
        pnr_number, schedule_id, class_id, booking_date, journey_date,
        source_station_id, destination_station_id, total_fare,
        booking_status, ticket_type, booked_by
    )
    VALUES (
        p_pnr_number, p_schedule_id, p_class_id, NOW(), p_journey_date,
        p_source_station_id, p_destination_station_id, v_total_fare,
        v_passenger_status, p_ticket_type, p_passenger_id
    );
    -- Add passenger to ticket
    INSERT INTO TicketPassengers (
        pnr_number, passenger_id, seat_number, concession_category_id,
        passenger_status, waitlist_position, fare
    )
    VALUES (
        p_pnr_number, p_passenger_id, v_seat_number, p_concession_category_id,
        v_passenger_status, v_waitlist_position, v_passenger_fare
    );
    
    -- Generate a transaction ID
    SET v_transaction_id = CONCAT('TXN', DATE_FORMAT(NOW(), '%Y%m%d%H%i%s'), LPAD(FLOOR(RAND() * 10000), 4, '0'));
    
    -- Record payment
    INSERT INTO Payments (
        pnr_number, payment_method_id, amount, payment_date,
        payment_status, transaction_id
    )
    VALUES (
        p_pnr_number, p_payment_method_id, v_total_fare, NOW(),
        'Successful', v_transaction_id
    );
    
    -- Update seat availability if confirmed
    IF v_passenger_status = 'Confirmed' THEN
        UPDATE SeatAvailability
        SET available_seats = available_seats - 1
        WHERE schedule_id = p_schedule_id
        AND class_id = p_class_id
        AND Date = p_journey_date;
    ELSE
        -- Increment waitlist count
        UPDATE SeatAvailability
        SET waitlisted_count = waitlisted_count + 1
        WHERE schedule_id = p_schedule_id
        AND class_id = p_class_id
        AND Date = p_journey_date;
    END IF;
    
    COMMIT;
    
    SET p_status = CONCAT('Ticket booked successfully. Status: ', v_passenger_status);
END //

DELIMITER ;


call BookTicket(8,'SL',512,'2025-03-17','NDLS', 'HWH','CC','E-Ticket',NULL,@pn,@st);
select @pn,@st;



-- cancel ticket procedure that cancels a ticket based on PNR number and updates on seat availability payment etc


DELIMITER //

DROP PROCEDURE IF EXISTS CancelTicket //

CREATE PROCEDURE CancelTicket(
    IN p_pnr_number VARCHAR(20)
)
BEGIN
    DECLARE p_cancel_date DATE;
    DECLARE v_schedule_id INT;
    DECLARE v_class_id VARCHAR(5);
    DECLARE v_journey_date DATE;
    DECLARE v_booking_status VARCHAR(20);
    DECLARE v_waitlisted_count INT;
    DECLARE v_refund_amount DECIMAL(10,2);
    DECLARE v_total_fare DECIMAL(10,2);

    proc_block: BEGIN

        -- Get ticket details
        SELECT schedule_id, class_id, journey_date, booking_status, total_fare
        INTO v_schedule_id, v_class_id, v_journey_date, v_booking_status, v_total_fare
        FROM tickets
        WHERE pnr_number = p_pnr_number;
        SET p_cancel_date = NOW(); -- Assuming cancellation date is current date
        -- Check if ticket exists
        IF v_schedule_id IS NULL THEN
            SELECT 'Ticket not found. Please check PNR number.' AS message;
            LEAVE proc_block;
        END IF;

        -- Check if cancellation date is valid (before journey date)
        IF p_cancel_date >= v_journey_date THEN
            SELECT 'Ticket cannot be cancelled now. Cancellation date must be before journey date.' AS message;
            LEAVE proc_block;
        END IF;

        -- Calculate refund amount
        IF DATEDIFF(v_journey_date, p_cancel_date) > 3 THEN
            SET v_refund_amount = v_total_fare;
        ELSE
            SET v_refund_amount = v_total_fare * 0.5;
        END IF;
        
        -- Update seats based on ticket status
        IF v_booking_status = 'Confirmed' THEN
            SELECT waitlisted_count INTO v_waitlisted_count
            FROM seatavailability
            WHERE schedule_id = v_schedule_id
              AND class_id = v_class_id
              AND Date = v_journey_date;

            IF v_waitlisted_count > 0 THEN
                UPDATE seatavailability
                SET waitlisted_count = waitlisted_count - 1,
                    last_updated = NOW()
                WHERE schedule_id = v_schedule_id
                  AND class_id = v_class_id
                  AND Date = v_journey_date;
            ELSE
                UPDATE seatavailability
                SET available_seats = available_seats + 1,
                    last_updated = NOW()
                WHERE schedule_id = v_schedule_id
                  AND class_id = v_class_id
                  AND Date = v_journey_date;
            END IF;

        ELSEIF v_booking_status = 'Waitlisted' THEN
            UPDATE seatavailability
            SET waitlisted_count = waitlisted_count - 1,
                last_updated = NOW()
            WHERE schedule_id = v_schedule_id
              AND class_id = v_class_id
              AND Date = v_journey_date;

        ELSEIF v_booking_status = 'RAC' THEN
            UPDATE seatavailability
            SET rac_count = rac_count - 1,
                last_updated = NOW()
            WHERE schedule_id = v_schedule_id
              AND class_id = v_class_id
              AND Date = v_journey_date;
        END IF;

        -- Update ticket record
        UPDATE tickets
        SET booking_status = 'Cancelled',
            cancellation_date = p_cancel_date,
            refund_amount = v_refund_amount,
            refund_status = 'Initiated'
        WHERE pnr_number = p_pnr_number;
        
        -- Update passenger status in ticketpassengers table
        UPDATE ticketpassengers
        SET passenger_status = 'Cancelled'
        WHERE pnr_number = p_pnr_number;
        -- Update payment status in payments table
        UPDATE payments
        SET payment_status = 'Refunded'
        WHERE pnr_number = p_pnr_number;

        -- Return success message
        SELECT 'Ticket cancelled successfully. Refund of ' AS message,
               v_refund_amount AS refund_amount,
               'has been initiated.' AS status;

    END proc_block;
END //

DELIMITER ;

--               =======================================================================


-- ==========================================
-- Additional Useful Queries
-- ==========================================

-- 1. Monthly revenue analysis by train class
DELIMITER $$

CREATE PROCEDURE GetMonthlyRevenueByClass()
BEGIN
    SELECT 
        YEAR(p.payment_date) AS year,
        MONTH(p.payment_date) AS month,
        c.class_name,
        COUNT(DISTINCT t.pnr_number) AS tickets_sold,
        SUM(p.amount) AS total_revenue
    FROM Payments p
    JOIN Tickets t ON p.pnr_number = t.pnr_number
    JOIN Classes c ON t.class_id = c.class_id
    WHERE p.payment_status = 'Successful'
    GROUP BY 
        YEAR(p.payment_date), 
        MONTH(p.payment_date), 
        c.class_name
    ORDER BY 
        year DESC, 
        month DESC, 
        total_revenue DESC;
END$$

DELIMITER ;


-- 2. Trains with highest cancellation rates
SELECT 
    tr.train_id,
    tr.train_name,
    COUNT(DISTINCT t.pnr_number) AS total_bookings,
    SUM(CASE WHEN t.booking_status = 'Cancelled' THEN 1 ELSE 0 END) AS cancellations,
    ROUND(SUM(CASE WHEN t.booking_status = 'Cancelled' THEN 1 ELSE 0 END) * 100.0 / COUNT(DISTINCT t.pnr_number), 2) AS cancellation_rate
FROM Tickets t
JOIN Schedules sc ON t.schedule_id = sc.schedule_id
JOIN Trains tr ON sc.train_id = tr.train_id
WHERE t.journey_date BETWEEN '2025-01-01' AND '2026-03-31'
GROUP BY tr.train_id, tr.train_name
HAVING COUNT(DISTINCT t.pnr_number) > 10
ORDER BY cancellation_rate DESC
LIMIT 10;

-- 3. Average occupancy by day of week
SELECT 
    DAYNAME(t.journey_date) AS day_of_week,
    c.class_name,
    AVG(CASE 
        WHEN tc.total_seats > 0 THEN 
            (CAST(COUNT(tp.id) AS DECIMAL) / tc.total_seats) * 100
        ELSE 0
    END) AS avg_occupancy_percentage
FROM Tickets t
JOIN TicketPassengers tp ON t.pnr_number = tp.pnr_number
JOIN Schedules sc ON t.schedule_id = sc.schedule_id
JOIN Classes c ON t.class_id = c.class_id
JOIN TrainClasses tc ON sc.train_id = tc.train_id AND c.class_id = tc.class_id
WHERE tp.passenger_status IN ('Confirmed', 'RAC')
  AND t.journey_date BETWEEN '2025-01-01' AND '2025-03-31'
GROUP BY DAYNAME(t.journey_date), c.class_name
ORDER BY FIELD(day_of_week, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), c.class_name;

-- 4. Concession statistics
SELECT 
    cc.category_name,
    COUNT(tp.id) AS passenger_count,
    SUM(tp.fare) AS total_fare,
    AVG(cc.discount_percentage) AS avg_discount_percentage
FROM TicketPassengers tp
JOIN ConcessionCategories cc ON tp.concession_category_id = cc.category_id
WHERE tp.passenger_status != 'Cancelled'
GROUP BY cc.category_name
ORDER BY passenger_count DESC;

-- 5. Trains running at full capacity
SELECT 
    tr.train_id,
    tr.train_name,
    sc.departure_date,
    c.class_name,
    tc.total_seats,
    COUNT(tp.id) AS booked_seats,
    (tc.total_seats - COUNT(tp.id)) AS remaining_seats
FROM Trains tr
JOIN Schedules sc ON tr.train_id = sc.train_id
JOIN TrainClasses tc ON tr.train_id = tc.train_id
JOIN Classes c ON tc.class_id = c.class_id
JOIN Tickets t ON sc.schedule_id = t.schedule_id AND t.class_id = c.class_id
JOIN TicketPassengers tp ON t.pnr_number = tp.pnr_number
WHERE tp.passenger_status IN ('Confirmed', 'RAC')
  AND sc.departure_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 7 DAY)
GROUP BY tr.train_id, tr.train_name, sc.departure_date, c.class_name, tc.total_seats
HAVING (tc.total_seats - COUNT(tp.id)) <= 5
ORDER BY sc.departure_date, remaining_seats;