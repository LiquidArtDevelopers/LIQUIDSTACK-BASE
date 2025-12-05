-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 05-12-2025 a las 09:23:41
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `liquid_stack_bbdd`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ls_admins`
--

CREATE TABLE `ls_admins` (
  `id_admin` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `email` varchar(200) NOT NULL,
  `telefono` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ls_admins`
--

INSERT INTO `ls_admins` (`id_admin`, `nombre`, `email`, `telefono`) VALUES
(1, 'Darren', 'michaelmdvr@gmail.com', ''),
(2, 'Igor', 'aranaz@gmail.com', '');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ls_credenciales`
--

CREATE TABLE `ls_credenciales` (
  `id_credencial` int(11) NOT NULL,
  `id_usuario` int(11) NOT NULL,
  `email_login` varchar(200) NOT NULL,
  `password` varchar(200) NOT NULL,
  `token` varchar(200) NOT NULL,
  `token_data_limit` date NOT NULL,
  `last_conection` datetime NOT NULL,
  `id_rol` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ls_roles`
--

CREATE TABLE `ls_roles` (
  `id_rol` int(11) NOT NULL,
  `rol` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `ls_roles`
--

INSERT INTO `ls_roles` (`id_rol`, `rol`) VALUES
(1, 'admin'),
(2, 'user');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `ls_usuarios`
--

CREATE TABLE `ls_usuarios` (
  `id_usuario` int(11) NOT NULL,
  `num_socio` varchar(50) DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `apellidos` varchar(100) NOT NULL,
  `email` varchar(200) NOT NULL,
  `telefono` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `ls_admins`
--
ALTER TABLE `ls_admins`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indices de la tabla `ls_credenciales`
--
ALTER TABLE `ls_credenciales`
  ADD PRIMARY KEY (`id_credencial`),
  ADD UNIQUE KEY `email_login` (`email_login`),
  ADD UNIQUE KEY `id_usuario` (`id_usuario`),
  ADD KEY `id_rol` (`id_rol`),
  ADD KEY `email_login_2` (`email_login`);

--
-- Indices de la tabla `ls_roles`
--
ALTER TABLE `ls_roles`
  ADD PRIMARY KEY (`id_rol`);

--
-- Indices de la tabla `ls_usuarios`
--
ALTER TABLE `ls_usuarios`
  ADD PRIMARY KEY (`id_usuario`),
  ADD UNIQUE KEY `num_socio` (`num_socio`),
  ADD KEY `email` (`email`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `ls_admins`
--
ALTER TABLE `ls_admins`
  MODIFY `id_admin` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `ls_credenciales`
--
ALTER TABLE `ls_credenciales`
  MODIFY `id_credencial` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=475;

--
-- AUTO_INCREMENT de la tabla `ls_roles`
--
ALTER TABLE `ls_roles`
  MODIFY `id_rol` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `ls_credenciales`
--
ALTER TABLE `ls_credenciales`
  ADD CONSTRAINT `ls_credenciales_ibfk_2` FOREIGN KEY (`id_rol`) REFERENCES `ls_roles` (`id_rol`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
