const express = require('express');
const cors = require('cors'); // Import cors
const swaggerJsdoc = require('swagger-jsdoc');
const swaggerUi = require('swagger-ui-express');

const app = express();

// Use cors middleware
app.use(cors({
  origin: 'http://localhost:3000' // Only allow requests from this origin
}));


app.use(express.json());

// In-memory storage for employees
let employees = [];

// Swagger definition
const swaggerDefinition = {
  openapi: '3.0.0',
  info: {
    title: 'Employee API',
    version: '1.0.0',
    description: 'API to manage employee details',
  },
  servers: [
    {
      url: 'http://localhost:4000',
      description: 'Development server',
    },
  ],
};

const options = {
  swaggerDefinition,
  apis: ['./index.js'], // files containing annotations for the Swagger docs
};

const swaggerSpec = swaggerJsdoc(options);

app.use('/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec));

// Redirect default URL to Swagger documentation
app.get('/', (req, res) => {
  res.redirect('/docs');
});

/**
 * @swagger
 * components:
 *   schemas:
 *     Employee:
 *       type: object
 *       required:
 *         - name
 *         - email
 *         - department
 *         - age
 *       properties:
 *         id:
 *           type: integer
 *           description: The auto-generated id of the employee
 *         name:
 *           type: string
 *           description: The employee's name
 *         email:
 *           type: string
 *           description: The employee's email address
 *         department:
 *           type: string
 *           description: The employee's department
 *         age:
 *           type: integer
 *           description: The employee's age
 *       example:
 *         id: 1
 *         name: Jane Doe
 *         email: jane.doe@example.com
 *         department: HR
 *         age: 28
 */

/**
 * @swagger
 * tags:
 *   name: Employees
 *   description: API for managing employees
 */

/**
 * @swagger
 * /employees:
 *   post:
 *     summary: Create a new employee
 *     tags: [Employees]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - email
 *               - department
 *               - age
 *             properties:
 *               name:
 *                 type: string
 *               email:
 *                 type: string
 *               department:
 *                 type: string
 *               age:
 *                 type: integer
 *             example:
 *               name: Jane Doe
 *               email: jane.doe@example.com
 *               department: HR
 *               age: 28
 *     responses:
 *       201:
 *         description: Employee created successfully
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Employee'
 *       500:
 *         description: Server error
 */
app.post('/employees', (req, res) => {
  const { name, email, department, age } = req.body;
  const employee = {
    id: employees.length + 1, // Simple auto-increment id
    name,
    email,
    department,
    age,
  };
  employees.push(employee);
  res.status(201).json(employee);
});

/**
 * @swagger
 * /employees:
 *   get:
 *     summary: Retrieve the list of all employees
 *     tags: [Employees]
 *     responses:
 *       200:
 *         description: A list of employees with id, name, email, department and age
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Employee'
 */
app.get('/employees', (req, res) => {
  res.json(employees);
});

const PORT = process.env.PORT || 4000;
app.listen(PORT, () => console.log(`Server is running on port ${PORT}`));
