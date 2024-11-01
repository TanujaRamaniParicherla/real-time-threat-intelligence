CREATE TABLE CrisisEvent (
    event_id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    status VARCHAR(50) CHECK (status IN ('Active', 'Resolved', 'Pending')),
    severity VARCHAR(50) CHECK (severity IN ('Low', 'Medium', 'High')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolution_details TEXT,
    reported_by INTEGER REFERENCES UserTable(user_id) ON DELETE SET NULL
);


CREATE TABLE CrisisLog (
    log_id SERIAL PRIMARY KEY,
    event_id INTEGER NOT NULL REFERENCES CrisisEvent(event_id) ON DELETE CASCADE,
    action VARCHAR(255) NOT NULL,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    user_id INTEGER REFERENCES UserTable(user_id) ON DELETE SET NULL,
    details TEXT
);


CREATE TABLE UserTable (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    role VARCHAR(50) CHECK (role IN ('Admin', 'Analyst')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO UserTable (username, email, role) VALUES 
('jdoe', 'jdoe@example.com', 'Admin'),
('asmith', 'asmith@example.com', 'Analyst');


INSERT INTO CrisisEvent (title, description, status, severity, reported_by)
VALUES ('Data Breach', 'Unauthorized access to sensitive data', 'Active', 'High', 1)
RETURNING event_id;


INSERT INTO CrisisLog (event_id, action, user_id, details)
VALUES (1, 'Status updated to Active', 1, 'Event marked as high-priority and requires immediate action');



SELECT event_id, title, description, severity, created_at
FROM CrisisEvent
WHERE status = 'Active'
ORDER BY created_at DESC;







































