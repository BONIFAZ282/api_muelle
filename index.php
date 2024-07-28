<?php
// Configuracion
require './config/cors.php';

// JWT
require './vendor/firebase/php-jwt/src/JWT.php';
require './config/JWTConfig.php';

// Bliblioteca Flight
require 'flight/Flight.php';

//MODAL
require './Model/Token.php';
require './Model/Usuario.php';

// Llamado a los ficheros correpondientes de cada controlador

require './Controller/UsuarioController.php';
require './Controller/PrivilegioController.php';
require './Controller/CategoriaController.php';
require './Controller/TrabajadorController.php';
require './Controller/RolController.php';
require './Controller/MesaController.php';
require './Controller/PlatoController.php';
require './Controller/PedidoController.php';
require './Controller/ReporteController.php';

// |||||||||||||| DATABASE ||||||||||||||||||||||||
require './config/dbConfig.php';

// Registro a Flight con las configuraciones de DB
Flight::register('db', 'PDO', $GLOBALS["db"]);

// Ruta principal devuelvo mensaje por GET para probar el correcto funcionanmiento de API
Flight::route('GET /', function () {
    $data = array('info' => 'API SISCAP CSJICA');
    Flight::json($data);
});

// ||||||||||||||||||| RUTAS |||||||||||||||||||||||||||




// USUARIOS
$usuarioController = new UsuarioController();
Flight::route('POST /auth', array($usuarioController, "LOGIN_USUARIO"));
Flight::route('GET /usuario/list', array($usuarioController, "LISTAR_USUARIOS"));
Flight::route('POST /usuario/create', array($usuarioController, "CREAR_USUARIO"));
Flight::route('POST /usuario/update', array($usuarioController, "ACTUALIZAR_USUARIO"));
Flight::route('POST /usuario/delete', array($usuarioController, "ELIMINAR_USUARIO_DEFINITIVO"));


// TRABAJADORES
$trabajadorController = new TrabajadorController();
Flight::route('GET /trabajador/list', array($trabajadorController, "LISTAR_TRABAJADORES"));
Flight::route('POST /trabajador/create', array($trabajadorController, "CREAR_TRABAJADOR"));
Flight::route('POST /trabajador/update', array($trabajadorController, "ACTUALIZAR_TRABAJADOR"));
Flight::route('POST /trabajador/delete', array($trabajadorController, "ELIMINAR_TRABAJADOR_DEFINITIVO"));
Flight::route('GET /trabajador/total', array($trabajadorController, "TOTAL_TRABAJADORES"));
Flight::route('GET /trabajador/por_rol', array($trabajadorController, "TRABAJADORES_POR_ROL"));
Flight::route('GET /mesero/list', array($trabajadorController, "LISTAR_MESEROS"));


// PRIVILEGIOS
$privilegioController = new PrivilegioController();
Flight::route('GET /privilegio/list', array($privilegioController, "LISTAR_PRIVILEGIOS"));
Flight::route('POST /privilegio/crear', array($privilegioController, "CREAR_PRIVILEGIO"));
Flight::route('POST /privilegio/actualizar', array($privilegioController, "ACTUALIZAR_PRIVILEGIO"));
Flight::route('POST /privilegio/eliminar', array($privilegioController, "ELIMINAR_PRIVILEGIO"));



// CATEGORIAS
$categoriaController = new CategoriaController();
Flight::route('GET /categoria/list', array($categoriaController, "LISTAR_CATEGORIAS"));
Flight::route('POST /categoria/create', array($categoriaController, "CREAR_CATEGORIA"));
Flight::route('POST /categoria/update', array($categoriaController, "ACTUALIZAR_CATEGORIA"));
Flight::route('POST /categoria/delete', array($categoriaController, "ELIMINAR_CATEGORIA"));


// ROLES
$rolController = new RolController();
Flight::route('GET /rol/list', array($rolController, "LISTAR_ROLES"));
Flight::route('POST /rol/create', array($rolController, "CREAR_ROL"));
Flight::route('POST /rol/update', array($rolController, "ACTUALIZAR_ROL"));
Flight::route('POST /rol/delete', array($rolController, "ELIMINAR_ROL"));


// MESAS
$mesaController = new MesaController();
Flight::route('GET /mesa/list', array($mesaController, "LISTAR_MESAS"));
Flight::route('POST /mesa/crear', array($mesaController, "CREAR_MESA"));
Flight::route('POST /mesa/actualizar', array($mesaController, "ACTUALIZAR_MESA"));
Flight::route('POST /mesa/eliminar', array($mesaController, "ELIMINAR_MESA"));

// PLATOS
$platoController = new PlatoController();
Flight::route('GET /plato/list', array($platoController, "LISTAR_PLATOS"));
Flight::route('POST /plato/crear', array($platoController, "CREAR_PLATO"));
Flight::route('POST /plato/actualizar', array($platoController, "ACTUALIZAR_PLATO"));
Flight::route('POST /plato/eliminar', array($platoController, "ELIMINAR_PLATO"));

// PEDIDOS
$pedidoController = new PedidoController();
Flight::route('POST /pedido/crear', array($pedidoController, "CREAR_PEDIDO"));
Flight::route('GET /pedido/list', array($pedidoController, "LISTAR_PEDIDOS"));
Flight::route('POST /pedido/detalle', array($pedidoController, "VER_DETALLE_PEDIDO"));
Flight::route('POST /pedido/cambiar_estado', array($pedidoController, "CAMBIAR_ESTADO_PEDIDO"));


$reporteController = new ReporteController();
Flight::route('GET /reporte/ganancias', array($reporteController, "LISTAR_GANANCIAS_REPORTE"));

// Iniciar Flight
Flight::start();
