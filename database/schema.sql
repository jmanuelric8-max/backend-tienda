CREATE TABLE IF NOT EXISTS categorias (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(100) NOT NULL,
    estado BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id),
    UNIQUE KEY uq_categorias_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS productos (
    id INT NOT NULL AUTO_INCREMENT,
    nombre VARCHAR(150) NOT NULL,
    precio DECIMAL(10, 2) NOT NULL,
    categoria_id INT NOT NULL,
    imagen VARCHAR(255) DEFAULT NULL,
    estado BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (id),
    KEY fk_producto_categoria (categoria_id),
    CONSTRAINT fk_producto_categoria
        FOREIGN KEY (categoria_id) REFERENCES categorias (id),
    CONSTRAINT chk_productos_precio CHECK (precio >= 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS carritos (
    id INT NOT NULL AUTO_INCREMENT,
    estado ENUM('activo', 'comprado', 'cancelado') DEFAULT 'activo',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS detalle_carrito (
    id INT NOT NULL AUTO_INCREMENT,
    carrito_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL DEFAULT 1,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_detalle_carrito_producto (carrito_id, producto_id),
    KEY fk_detalle_producto (producto_id),
    CONSTRAINT fk_detalle_carrito
        FOREIGN KEY (carrito_id) REFERENCES carritos (id) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (producto_id) REFERENCES productos (id),
    CONSTRAINT chk_cantidad CHECK (cantidad > 0)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS compras (
    id INT NOT NULL AUTO_INCREMENT,
    carrito_id INT NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    estado ENUM('confirmada') NOT NULL DEFAULT 'confirmada',
    fecha_creacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_compras_carrito (carrito_id),
    CONSTRAINT fk_compras_carrito
        FOREIGN KEY (carrito_id) REFERENCES carritos (id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS detalle_compra (
    id INT NOT NULL AUTO_INCREMENT,
    compra_id INT NOT NULL,
    producto_id INT NOT NULL,
    nombre_producto VARCHAR(150) NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id),
    KEY idx_detalle_compra_compra (compra_id),
    CONSTRAINT fk_detalle_compra_compra
        FOREIGN KEY (compra_id) REFERENCES compras (id) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_compra_producto
        FOREIGN KEY (producto_id) REFERENCES productos (id)
) ENGINE=InnoDB;

INSERT IGNORE INTO categorias (id, nombre) VALUES
    (1, 'Electrónica'),
    (2, 'Ropa'),
    (3, 'Accesorios'),
    (4, 'Hogar'),
    (5, 'Cuidado personal');

INSERT IGNORE INTO productos
    (id, nombre, precio, categoria_id, imagen)
VALUES
    (1, 'Audífonos Bluetooth', 89.90, 1, 'audifono01.jpg'),
    (2, 'Reloj deportivo', 119.90, 1, 'reloj01.jpg'),
    (3, 'Mochila urbana', 69.90, 3, 'mochila01.jpg'),
    (4, 'Zapatillas deportivas', 149.90, 2, 'zapatilla01.jpg'),
    (5, 'Polo básico', 35.00, 2, 'polo01.jpg'),
    (6, 'Taza de cerámica', 19.90, 4, 'taza01.jpg'),
    (7, 'Lámpara de escritorio', 49.90, 4, 'lampara01.jpg'),
    (8, 'Perfume personal', 79.90, 5, 'perfume01.jpg');

UPDATE productos
SET imagen = CASE id
    WHEN 1 THEN 'audifono01.jpg'
    WHEN 2 THEN 'reloj01.jpg'
    WHEN 3 THEN 'mochila01.jpg'
    WHEN 4 THEN 'zapatilla01.jpg'
    WHEN 5 THEN 'polo01.jpg'
    WHEN 6 THEN 'taza01.jpg'
    WHEN 7 THEN 'lampara01.jpg'
    WHEN 8 THEN 'perfume01.jpg'
END
WHERE id BETWEEN 1 AND 8
  AND (imagen IS NULL OR imagen = '');
