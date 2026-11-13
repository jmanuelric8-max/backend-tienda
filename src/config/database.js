const mysql = require("mysql2/promise");
require("dotenv").config();

const host = process.env.DB_HOST || process.env.MYSQLHOST;
const user = process.env.DB_USER || process.env.MYSQLUSER;
const password = process.env.DB_PASSWORD || process.env.MYSQLPASSWORD;
const database = process.env.DB_NAME || process.env.MYSQLDATABASE;
const port = Number(process.env.DB_PORT || process.env.MYSQLPORT || 3306);

const missingSettings = Object.entries({
    DB_HOST: host,
    DB_USER: user,
    DB_PASSWORD: password,
    DB_NAME: database
})
    .filter(([, value]) => value === undefined || value === null)
    .map(([name]) => name);

if (missingSettings.length > 0) {
    throw new Error(
        `Faltan variables de conexión MySQL: ${missingSettings.join(", ")}`
    );
}

if (!Number.isInteger(port) || port <= 0 || port > 65535) {
    throw new Error("DB_PORT debe ser un puerto válido entre 1 y 65535");
}

const pool = mysql.createPool({
    host,
    user,
    password,
    database,
    port,
    waitForConnections: true,
    connectionLimit: 10
});

module.exports = pool;