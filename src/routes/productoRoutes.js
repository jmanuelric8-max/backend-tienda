
const express = require("express");
const router = express.Router();

const productoController = require("../controllers/productoController");

// Listar productos con sus imágenes de Cloudinary
router.get("/", productoController.listarProductos);

module.exports = router;
