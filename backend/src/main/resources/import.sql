-- Users
INSERT INTO users (id, name, email, password, phone, role) VALUES
(1, 'Alice', 'alice@example.com', '1234', '0771234567', 'PATIENT'),
(2, 'Dr Bob', 'bob@example.com', '1234', '0777654321', 'DOCTOR');

-- Patients
INSERT INTO patients (id, medical_history) VALUES
(1, 'No known allergies');

-- Doctors
INSERT INTO doctors (id, current_status, specialization) VALUES
(2, 'AVAILABLE', 'Cardiology');