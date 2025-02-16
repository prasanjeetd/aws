-- Create the database if it doesn't already exist
CREATE DATABASE IF NOT EXISTS employee_db;

-- Switch to the employee_db database
USE employee_db;

-- Create the employee table with the desired columns
CREATE TABLE IF NOT EXISTS employee (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  age INT,
  department VARCHAR(100)
);


-- Make sure you're using the correct database
USE employee_db;

-- Insert dummy records into the employee table
INSERT INTO employee (name, email, age, department)
VALUES
  ('John Doe', 'john.doe@example.com', 30, 'Engineering'),
  ('Jane Smith', 'jane.smith@example.com', 28, 'Marketing'),
  ('Robert Johnson', 'robert.johnson@example.com', 45, 'Human Resources');

SELECT id,name,email,age,department FROM employee;