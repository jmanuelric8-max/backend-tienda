
const cloudinary = require("../config/cloudinary");

function subirImagen(buffer) {
  return new Promise((resolve, reject) => {
    const stream = cloudinary.uploader.upload_stream(
      {
        folder: "carrito-compras/productos",
        resource_type: "image",
      },
      (error, resultado) => {
        if (error) {
          return reject(error);
        }

        resolve({
          imagen_url: resultado.secure_url,
          imagen_public_id: resultado.public_id,
        });
      }
    );

    stream.end(buffer);
  });
}

module.exports = subirImagen;
