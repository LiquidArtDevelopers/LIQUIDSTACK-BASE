
/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `ls_blog_analytics_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_analytics_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `session_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `visitor_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `landing_localization_id` bigint(20) unsigned NOT NULL,
  `is_returning` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `pageview_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `engagement_msec` bigint(20) unsigned NOT NULL DEFAULT 0,
  `started_at` datetime(6) NOT NULL,
  `last_activity_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_blog_as_session` (`session_hash`),
  KEY `idx_blog_as_visitor_time` (`visitor_hash`,`started_at`),
  KEY `idx_blog_as_landing_time` (`landing_localization_id`,`started_at`),
  KEY `idx_blog_as_activity` (`last_activity_at`),
  CONSTRAINT `ls_blog_f_as_landing` FOREIGN KEY (`landing_localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_as_session` CHECK (char_length(`session_hash`) = 64 and `session_hash` = lcase(`session_hash`)),
  CONSTRAINT `ls_blog_c_as_visitor` CHECK (char_length(`visitor_hash`) = 64 and `visitor_hash` = lcase(`visitor_hash`)),
  CONSTRAINT `ls_blog_c_as_returning` CHECK (`is_returning` in (0,1)),
  CONSTRAINT `ls_blog_c_as_time` CHECK (`last_activity_at` >= `started_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_analytics_sessions` WRITE;
/*!40000 ALTER TABLE `ls_blog_analytics_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_analytics_sessions` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_analytics_views`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_analytics_views` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `session_id` bigint(20) unsigned NOT NULL,
  `localization_id` bigint(20) unsigned NOT NULL,
  `engagement_msec` bigint(20) unsigned NOT NULL DEFAULT 0,
  `last_sequence` bigint(20) unsigned NOT NULL DEFAULT 0,
  `started_at` datetime(6) NOT NULL,
  `last_activity_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_blog_av_public` (`public_id`),
  KEY `idx_blog_av_local_time` (`localization_id`,`started_at`),
  KEY `idx_blog_av_session_time` (`session_id`,`started_at`),
  CONSTRAINT `ls_blog_f_av_local` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_f_av_session` FOREIGN KEY (`session_id`) REFERENCES `ls_blog_analytics_sessions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_av_public` CHECK (char_length(`public_id`) = 36 and `public_id` = lcase(`public_id`)),
  CONSTRAINT `ls_blog_c_av_time` CHECK (`last_activity_at` >= `started_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_analytics_views` WRITE;
/*!40000 ALTER TABLE `ls_blog_analytics_views` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_analytics_views` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_blog_categories_public` (`public_id`),
  KEY `idx_blog_categories_author` (`created_by_user_public_id`),
  CONSTRAINT `ls_blog_c_ca_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_blog_c_ca_author` CHECK (char_length(`created_by_user_public_id`) = 36)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_categories` WRITE;
/*!40000 ALTER TABLE `ls_blog_categories` DISABLE KEYS */;
INSERT INTO `ls_blog_categories` VALUES (1,'00000000-0000-4000-8000-000000000017','00000000-0000-4000-8000-000000000001','2026-09-10 06:12:57.414198','2026-09-10 06:12:57.414198'),(2,'ba5e0000-0000-4000-8000-000000000001','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:00.000000','2026-09-10 10:00:01.000000'),(3,'ba5e0000-0000-4000-8000-000000000006','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:02.000000','2026-09-10 10:00:03.000000'),(4,'ba5e0000-0000-4000-8000-000000000085','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 09:02:00.000000','2026-09-24 09:02:00.000000');
/*!40000 ALTER TABLE `ls_blog_categories` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_category_assignment_heads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_category_assignment_heads` (
  `post_id` bigint(20) unsigned NOT NULL,
  `assignment_version` bigint(20) unsigned NOT NULL,
  `updated_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`post_id`),
  CONSTRAINT `ls_blog_f_cah_post` FOREIGN KEY (`post_id`) REFERENCES `ls_blog_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_cah_version` CHECK (`assignment_version` > 0),
  CONSTRAINT `ls_blog_c_cah_actor` CHECK (`updated_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_category_assignment_heads` WRITE;
/*!40000 ALTER TABLE `ls_blog_category_assignment_heads` DISABLE KEYS */;
INSERT INTO `ls_blog_category_assignment_heads` VALUES (1,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.932473'),(2,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.984643'),(3,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.033255'),(4,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.074459');
/*!40000 ALTER TABLE `ls_blog_category_assignment_heads` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_category_assignment_workspace_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_category_assignment_workspace_items` (
  `post_id` bigint(20) unsigned NOT NULL,
  `category_id` bigint(20) unsigned NOT NULL,
  `assigned_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`post_id`,`category_id`),
  KEY `ls_blog_ix_cawi_category` (`category_id`),
  CONSTRAINT `ls_blog_f_cawi_category` FOREIGN KEY (`category_id`) REFERENCES `ls_blog_categories` (`id`),
  CONSTRAINT `ls_blog_f_cawi_workspace` FOREIGN KEY (`post_id`) REFERENCES `ls_blog_category_assignment_workspaces` (`post_id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_cawi_actor` CHECK (`assigned_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_category_assignment_workspace_items` WRITE;
/*!40000 ALTER TABLE `ls_blog_category_assignment_workspace_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_category_assignment_workspace_items` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_category_assignment_workspaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_category_assignment_workspaces` (
  `post_id` bigint(20) unsigned NOT NULL,
  `base_assignment_version` bigint(20) unsigned NOT NULL DEFAULT 0,
  `workspace_version` bigint(20) unsigned NOT NULL,
  `created_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `updated_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`post_id`),
  CONSTRAINT `ls_blog_f_caw_post` FOREIGN KEY (`post_id`) REFERENCES `ls_blog_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_caw_version` CHECK (`workspace_version` > 0),
  CONSTRAINT `ls_blog_c_caw_created_actor` CHECK (`created_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_caw_updated_actor` CHECK (`updated_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_caw_time` CHECK (`updated_at` >= `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_category_assignment_workspaces` WRITE;
/*!40000 ALTER TABLE `ls_blog_category_assignment_workspaces` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_category_assignment_workspaces` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_category_locales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_category_locales` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `category_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `slug` varchar(190) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `name` varchar(255) NOT NULL,
  `lock_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  `created_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `updated_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_blog_category_local_public` (`public_id`),
  UNIQUE KEY `uq_blog_category_locale` (`category_id`,`locale`),
  UNIQUE KEY `uq_blog_category_locale_slug` (`locale`,`slug`),
  KEY `idx_blog_category_name` (`locale`,`name`),
  CONSTRAINT `ls_blog_f_cl_category` FOREIGN KEY (`category_id`) REFERENCES `ls_blog_categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_cl_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_blog_c_cl_locale` CHECK (char_length(`locale`) between 2 and 16 and `locale` = lcase(`locale`) and `locale` = trim(`locale`)),
  CONSTRAINT `ls_blog_c_cl_slug` CHECK (char_length(trim(`slug`)) > 0 and `slug` = lcase(`slug`) and `slug` = trim(`slug`)),
  CONSTRAINT `ls_blog_c_cl_name` CHECK (char_length(trim(`name`)) > 0),
  CONSTRAINT `ls_blog_c_cl_lock` CHECK (`lock_version` > 0),
  CONSTRAINT `ls_blog_c_cl_created` CHECK (char_length(`created_by_user_public_id`) = 36),
  CONSTRAINT `ls_blog_c_cl_updated` CHECK (char_length(`updated_by_user_public_id`) = 36)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_category_locales` WRITE;
/*!40000 ALTER TABLE `ls_blog_category_locales` DISABLE KEYS */;
INSERT INTO `ls_blog_category_locales` VALUES (1,'00000000-0000-4000-8000-000000000117',1,'und','dummy','Dummy (interno)',1,'00000000-0000-4000-8000-000000000001','00000000-0000-4000-8000-000000000001','2026-09-10 06:12:57.415598','2026-09-10 06:12:57.415598'),(2,'ba5e0000-0000-4000-8000-000000000002',2,'es','novedades','Novedades',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:00.000000','2026-09-10 10:00:00.000000'),(3,'ba5e0000-0000-4000-8000-000000000004',2,'eu','berriak','Berriak',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:01.000000','2026-09-10 10:00:01.000000'),(4,'ba5e0000-0000-4000-8000-000000000007',3,'es','guias','Guías',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:02.000000','2026-09-10 10:00:02.000000'),(5,'ba5e0000-0000-4000-8000-000000000009',3,'eu','gidak','Gidak',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:03.000000','2026-09-10 10:00:03.000000'),(6,'ba5e0000-0000-4000-8000-000000000086',4,'es','cine','Cine',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 09:02:00.000000','2026-09-24 09:02:00.000000'),(7,'ba5e0000-0000-4000-8000-000000000087',4,'eu','zinema','Zinema',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 09:02:00.000000','2026-09-24 09:02:00.000000');
/*!40000 ALTER TABLE `ls_blog_category_locales` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_content_docs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_content_docs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `localization_id` bigint(20) unsigned NOT NULL,
  `schema_version` smallint(5) unsigned NOT NULL DEFAULT 1,
  `template_key` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `document_json` longtext NOT NULL,
  `document_bytes` int(10) unsigned NOT NULL,
  `document_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `body_text_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `snapshot_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `updated_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_blog_content_docs_public` (`public_id`),
  UNIQUE KEY `uq_blog_content_docs_local` (`localization_id`),
  KEY `idx_blog_content_docs_updated` (`updated_at`),
  CONSTRAINT `ls_blog_f_cd_localization` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_cd_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_blog_c_cd_schema` CHECK (`schema_version` = 1),
  CONSTRAINT `ls_blog_c_cd_template` CHECK (char_length(`template_key`) between 1 and 64 and `template_key` = lcase(`template_key`) and `template_key` = trim(`template_key`) and `template_key` regexp '^[a-z][a-z0-9_-]{0,63}$'),
  CONSTRAINT `ls_blog_c_cd_bytes` CHECK (`document_bytes` between 1 and 300000),
  CONSTRAINT `ls_blog_c_cd_doc_hash` CHECK (`document_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_cd_body_hash` CHECK (`body_text_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_cd_snap_hash` CHECK (`snapshot_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_cd_created` CHECK (char_length(`created_by_user_public_id`) = 36),
  CONSTRAINT `ls_blog_c_cd_updated` CHECK (char_length(`updated_by_user_public_id`) = 36)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_content_docs` WRITE;
/*!40000 ALTER TABLE `ls_blog_content_docs` DISABLE KEYS */;
INSERT INTO `ls_blog_content_docs` VALUES (1,'c33940ae-ca62-4cc0-a74d-d102262772e9',1,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"cc396780-c99b-49db-b58f-b70e7b888368\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo y la tripulación ante el universo digital de Matrix\",\"title\":\"Matrix: despertar frente a una realidad construida\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"9979969c-24dc-4864-982a-29dd9ec24bd8\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"El despertar de Neo cambia las reglas\",\"marks\":[]}]},{\"id\":\"ecb900b8-4811-4065-bce9-c83455e10f5a\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix presenta a Thomas Anderson como un programador atrapado entre una rutina reconocible y la intuición de que algo no encaja. La aparición de Trinity y Morpheus convierte esa sospecha en una elección concreta: seguir dentro de una realidad cómoda o mirar detrás de su arquitectura.\",\"marks\":[]}]},{\"id\":\"f550c5b3-d22b-41a9-bdb7-6487e5fd98f9\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La película combina ciencia ficción, acción y filosofía sin separar sus ideas de la puesta en escena. El código verde, los reflejos y los espacios repetidos hacen visible un sistema que parecía invisible. Neo no adquiere respuestas de inmediato; aprende a leer las reglas antes de intentar romperlas.\",\"marks\":[]}]},{\"id\":\"336babe6-5cb5-4802-b459-8d7338aebe7d\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La identidad como una construcción que puede cuestionarse.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La tecnología como entorno, lenguaje y mecanismo de control.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La elección personal como motor del relato y de sus consecuencias.\",\"marks\":[]}]},{\"id\":\"2d32ff92-c1d8-4016-887b-fbbd22d378d1\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"La pregunta central no es solo qué es Matrix, sino qué hacemos después de reconocer el sistema.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Cuaderno Matrix, Lectura editorial de ejemplo\",\"marks\":[\"em\"]}]},{\"id\":\"377358f7-48e9-4c90-b7ce-dd8324d0fc13\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo y la tripulación ante el universo digital de Matrix\",\"title\":\"Matrix: despertar frente a una realidad construida\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"d61593d3-07f3-4bda-beae-910ad3cd3939\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"tGgCqGm_6Hs\",\"title\":\"Tráiler oficial de Matrix: despertar frente a una realidad construida\",\"start_seconds\":0},{\"id\":\"8d6ecf0c-0246-432e-961f-077f92b07652\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"Su final funciona como una promesa de transformación: comprender la simulación permite imaginar otras posibilidades, pero también obliga a asumir el coste de actuar.\",\"marks\":[]}]}]}',3111,'cdce402acc5f1d16bd9e5d1e8c4aabe00ffe7ee175dd39427574c61ed82b5733','d24b675cd14a753d619c5f7349417c4458b5001760ff77fb0fa135226f2c60ec','7a3857bbf1f438b525ec60de919c9dc47184729d143c2efbbb47369827b493e8','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.932473','2026-09-24 03:12:14.932473'),(2,'295ecd7e-42ec-496d-942a-209212f9b05f',2,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"4d783ee7-24e0-46aa-9643-c7b6007a5107\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo eta tripulazioa Matrixeko unibertso digitalaren aurrean\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"a8de8971-27ce-4984-a52c-82d43d93d0fc\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Neoren esnatzeak arauak aldatzen ditu\",\"marks\":[]}]},{\"id\":\"2699f2ac-930e-42e6-b378-85eadfe60e6f\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrixek Thomas Anderson aurkezten du: errutina ezagun baten eta zerbait ondo ez dagoelako susmoaren artean harrapatutako programatzailea. Trinity eta Morpheus agertzean, susmo hori hautu zehatz bihurtzen da: errealitate erosoaren barruan jarraitu edo haren arkitekturaren atzean begiratu.\",\"marks\":[]}]},{\"id\":\"1f8ef740-ea0b-46ca-8d8a-5b05e29b50c8\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Filmak zientzia-fikzioa, akzioa eta filosofia uztartzen ditu, ideiak eszenaratzetik bereizi gabe. Kode berdeak, islek eta espazio errepikatuek ikusezina zirudien sistema agerian uzten dute. Neok ez ditu erantzunak berehala jasotzen; arauak irakurtzen ikasten du hausten saiatu aurretik.\",\"marks\":[]}]},{\"id\":\"9099c68e-54c3-4ad2-affb-ad1d5e9af1e2\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Nortasuna zalantzan jar daitekeen eraikuntza gisa.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Teknologia ingurune, hizkuntza eta kontrol-mekanismo gisa.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Hautu pertsonala kontakizunaren eta ondorioen motor gisa.\",\"marks\":[]}]},{\"id\":\"7b5b3892-2a8e-4f37-a539-e666142c22ae\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Galdera nagusia ez da soilik Matrix zer den, sistema ezagutu ondoren zer egiten dugun baizik.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Matrix koadernoa, Adibideko irakurketa editoriala\",\"marks\":[\"em\"]}]},{\"id\":\"bcb97557-4b6a-461e-aac2-ddf77f4831d2\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo eta tripulazioa Matrixeko unibertso digitalaren aurrean\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"872cb24b-4529-41eb-8b53-a3d6193c8afd\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"tGgCqGm_6Hs\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea filmaren trailer ofiziala\",\"start_seconds\":0},{\"id\":\"e08f2f64-e071-4570-9735-bfab1697b874\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"Amaierak eraldaketaren promesa dakar: simulazioa ulertzeak beste aukera batzuk irudikatzeko bidea ematen du, baina jardutearen kostua onartzera ere behartzen du.\",\"marks\":[]}]}]}',3068,'987991d9da06252e560995517df7ea17bb6ccd5006c60b0a0e077b0d0b0d3697','ad9be3ebdeec310dd6ba33979103ef6a77de454b3a872ab0d1818982f7b1f960','9e1e52e363972588cc2f94fab97fafc9351c6c52fd2a31e88657e1f07f82fd24','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.932473','2026-09-24 03:12:14.932473'),(3,'be99d620-bff4-43b6-a85f-948cd46c6b8c',3,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"d262854b-6b89-46da-afa0-86ac56a14432\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo y Morpheus durante el conflicto de Matrix Reloaded\",\"title\":\"Matrix Reloaded: elegir dentro de un sistema previsto\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"41b48743-0cc0-4ff2-8de3-2bf7aea0cf7f\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zion, causalidad y una elección imposible\",\"marks\":[]}]},{\"id\":\"6f201ae3-0b21-4600-bdc4-8dc875b3ff63\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Reloaded abre el relato hacia Zion y convierte la resistencia en una comunidad con responsabilidades, desacuerdos y tiempo limitado. Neo ya no busca únicamente comprender sus capacidades: debe decidir cómo utilizarlas cuando cada camino parece formar parte de un diseño anterior.\",\"marks\":[]}]},{\"id\":\"b1cf3ece-b339-4749-a116-c9886a84e1f9\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"El encuentro con el Arquitecto reformula la profecía y presenta la anomalía como un componente previsto del sistema. La persecución de la autopista y la búsqueda del Cerrajero traducen ese conflicto abstracto en movimiento, urgencia y decisiones encadenadas.\",\"marks\":[]}]},{\"id\":\"335877fd-ff67-46b0-92d4-a5baef2fff31\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La causalidad organiza tanto el diálogo como la acción.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Zion aporta una escala humana al conflicto tecnológico.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"El amor de Neo por Trinity introduce una variable difícil de reducir a cálculo.\",\"marks\":[]}]},{\"id\":\"46d73dcc-6695-4795-8fda-0a7b0bf9d5ba\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Elegir cobra sentido cuando la decisión altera un recorrido que parecía completamente calculado.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Cuaderno Matrix, Lectura editorial de ejemplo\",\"marks\":[\"em\"]}]},{\"id\":\"bc9ec40d-1ae6-49be-9475-d3832a93713a\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo y Morpheus durante el conflicto de Matrix Reloaded\",\"title\":\"Matrix Reloaded: elegir dentro de un sistema previsto\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"9d2d2f4f-7fc4-4256-8abd-befaaa7b8a55\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zmYE3tg26Qc\",\"title\":\"Tráiler oficial de Matrix Reloaded: elegir dentro de un sistema previsto\",\"start_seconds\":0},{\"id\":\"61a720f5-378a-49f0-a306-ae2beacf5aca\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"La película termina sin cerrar la ecuación. Su mayor aportación es desplazar la lucha desde una oposición simple hacia un sistema que también sabe administrar sus propias excepciones.\",\"marks\":[]}]}]}',3103,'11ac86068299ed42ae19f86b00ac77db5b692b5f081141881d25d46b15ae3af3','0136cff5ae0a34d8ab371495a646cee463c87ea7fab38b3ed36a3a77c402e417','041c6f80e0ca68e744869dda720968bab0a99b908e50b358a2bfea146912a2c7','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.984643','2026-09-24 03:12:14.984643'),(4,'378b6b28-8804-459d-9434-a291cf36c43e',4,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"d9c5877b-706f-4444-855d-832dc6223a99\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo eta Morpheus Matrix Reloaded filmeko gatazkan\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"f6ee6f9b-040a-4f8c-8191-f9731d7ecf39\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zion, kausalitatea eta ezinezko hautua\",\"marks\":[]}]},{\"id\":\"687d7122-1cc1-4cef-9709-42ab504549c3\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Reloadedek kontakizuna Zionerantz zabaltzen du, eta erresistentzia erantzukizunak, desadostasunak eta denbora mugatua dituen komunitate bihurtzen du. Neok ez du bere gaitasunak ulertu nahi soilik: nola erabili erabaki behar du, bide bakoitza aurreko diseinu baten parte dela dirudienean.\",\"marks\":[]}]},{\"id\":\"6636568f-111a-49e4-a7f0-2b35d48db682\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Arkitektoarekin izandako topaketak profezia berrinterpretatzen du, eta anomalia sistemak aurreikusitako osagai gisa aurkezten du. Autobideko jazarpenak eta Giltzariaren bilaketak gatazka abstraktu hori mugimendu, presa eta kateatutako erabaki bihurtzen dute.\",\"marks\":[]}]},{\"id\":\"fd995a8d-e235-45e0-8f87-e855b7f3a7bc\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Kausalitateak elkarrizketa eta akzioa antolatzen ditu.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Zionek giza eskala ematen dio gatazka teknologikoari.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Neok Trinityrekiko duen maitasunak kalkulura murrizten zaila den aldagaia sartzen du.\",\"marks\":[]}]},{\"id\":\"df633e3f-e4a3-4c12-a1c1-c7db6f7d13f3\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Hautuak zentzua hartzen du erabakiak erabat kalkulatuta zirudien ibilbidea aldatzen duenean.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Matrix koadernoa, Adibideko irakurketa editoriala\",\"marks\":[\"em\"]}]},{\"id\":\"92ec43cb-271a-434a-bde7-54b557869096\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo eta Morpheus Matrix Reloaded filmeko gatazkan\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"b31651d4-34d6-4f94-8ecc-337bb7ca95f4\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zmYE3tg26Qc\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea filmaren trailer ofiziala\",\"start_seconds\":0},{\"id\":\"8a298634-e401-4f05-9ff8-100803f41708\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"Filma ekuazioa itxi gabe amaitzen da. Bere ekarpen handiena borroka oposizio sinple batetik salbuespenak ere kudeatzen dakien sistema batera eramatea da.\",\"marks\":[]}]}]}',3065,'d9c6d87f35a8e5374c0dfb670d38794fe201e9cf22069ead3401d402a70a4266','e038264f73490b9e183e70b10d441178ab0ad8ed56a4138a70905a33f28d99b5','2822936978dc193585e16660b4f0465b5de9395571aa6592f0119c78392507bd','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.984643','2026-09-24 03:12:14.984643'),(5,'e9646032-ad64-498a-80f6-62c7323e4730',5,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"28e753af-1122-4443-982f-5b6ac7c7368e\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo frente al desenlace de Matrix Revolutions\",\"title\":\"Matrix Revolutions: una tregua para romper el ciclo\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"37d5f8e5-95d2-4470-8a9b-5c31de173dac\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"La defensa de Zion y el precio de la paz\",\"marks\":[]}]},{\"id\":\"6914b645-4271-4a52-a39a-b2d60d08b7c3\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Revolutions concentra la presión en dos frentes. Zion resiste el ataque de las máquinas y Neo avanza hacia una solución que exige reconocer un peligro compartido. La amenaza de Smith desborda la simulación y vuelve posible una negociación antes impensable.\",\"marks\":[]}]},{\"id\":\"c2d53130-c18d-4c61-b1a1-2a9923bea220\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La batalla de Zion muestra la escala material de la guerra, mientras el duelo final reduce el conflicto a dos figuras bajo la lluvia. Ambas líneas hablan de persistencia, sacrificio y límites: vencer ya no significa imponer una eliminación total, sino detener una repetición destructiva.\",\"marks\":[]}]},{\"id\":\"4273476c-aa93-45d0-a974-ffb4f7d0227e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La defensa colectiva de Zion sostiene el coste humano del desenlace.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Smith representa una expansión sin límite ni propósito.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La tregua abre un espacio político que antes no existía.\",\"marks\":[]}]},{\"id\":\"f46241cd-349a-47fd-9f09-8dd3ba6a41e9\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Romper el ciclo requiere una decisión que ninguna de las partes podía imponer por separado.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Cuaderno Matrix, Lectura editorial de ejemplo\",\"marks\":[\"em\"]}]},{\"id\":\"bd3c540d-1c9f-450d-8b54-ee4fdeef42a3\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo frente al desenlace de Matrix Revolutions\",\"title\":\"Matrix Revolutions: una tregua para romper el ciclo\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"6e52841e-d6e6-44a7-9de5-11c65e52164d\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zOh_pjoYTq8\",\"title\":\"Tráiler oficial de Matrix Revolutions: una tregua para romper el ciclo\",\"start_seconds\":0},{\"id\":\"336f62a7-f861-46f5-89c4-e3b6a0d8bb5f\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"El acuerdo final no resuelve todas las tensiones, pero permite imaginar convivencia, memoria y elección. La paz aparece como una construcción frágil que deberá mantenerse más allá de la victoria inmediata.\",\"marks\":[]}]}]}',3093,'c57b00da267ba3abf4ec512d6594db7e7e95296de171047de62e468d689bea64','39302b2600a27b5285acf47815fd271a00c65f008f27809c8e4590461dff77b6','5e95b263588514da7a0007cbe769f2c7f36ea504ffc4b3856e704856a3a5dc17','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.033255','2026-09-24 03:12:15.033255'),(6,'f1a45de6-987a-42a3-9073-c39380b1d304',6,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"82493402-0fc6-4dee-91ca-3fe451c9dba0\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo Matrix Revolutions filmeko amaieraren aurrean\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"bd95d17c-5bbc-422d-bfa3-d12e88955f8e\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zionen defentsa eta bakearen prezioa\",\"marks\":[]}]},{\"id\":\"fc18d799-1072-47d4-962a-d672943f8e0e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Revolutionsek presioa bi frontetan biltzen du. Zionek makinen erasoa jasaten du, eta Neo arrisku partekatu bat aitortzea eskatzen duen irtenbiderantz doa. Smithen mehatxuak simulazioa gainditzen du, eta lehen pentsaezina zen negoziazioa ahalbidetzen du.\",\"marks\":[]}]},{\"id\":\"d46cc7b6-bed5-4aa3-9fd5-783603e8e073\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Zioneko guduak gerraren eskala materiala erakusten du; azken dueluan, berriz, gatazka euripeko bi figuratara murrizten da. Bi lerroek iraunkortasuna, sakrifizioa eta mugak dituzte ardatz: irabaztea ez da erabateko ezabaketa inposatzea, errepikapen suntsitzailea geldiaraztea baizik.\",\"marks\":[]}]},{\"id\":\"b1931dbe-e2cc-4d61-8dba-2ca434d75c3e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Zionen defentsa kolektiboak amaieraren giza kostua erakusten du.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Smithek mugarik eta helbururik gabeko hedapena irudikatzen du.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Su-etenak lehen ez zegoen espazio politikoa irekitzen du.\",\"marks\":[]}]},{\"id\":\"8e4dba38-266d-4233-bdee-1f8d55e703c7\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Zikloa hausteko, aldeetako inork bere kabuz inposatu ezin zuen erabakia behar da.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Matrix koadernoa, Adibideko irakurketa editoriala\",\"marks\":[\"em\"]}]},{\"id\":\"093b7721-f0ec-4818-a4cd-1493a8700128\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo Matrix Revolutions filmeko amaieraren aurrean\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"ea0b8948-90d9-4648-8521-e3618d7b4554\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zOh_pjoYTq8\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena filmaren trailer ofiziala\",\"start_seconds\":0},{\"id\":\"ce4d9d54-19b4-4c4d-82c3-14430c845888\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"Azken akordioak ez ditu tentsio guztiak konpontzen, baina bizikidetza, memoria eta hautua irudikatzeko aukera ematen du. Bakea garaipenetik harago mantendu beharreko eraikuntza hauskor gisa agertzen da.\",\"marks\":[]}]}]}',3034,'310db2d726826cc2791ec569d12eebe4e7ae39d757b555214ed13c8babca0121','0c1dc564e25bbbe049fdd4560e4388e40d627412c3b4361a4e35176728d31337','a75af5cd44b95f7f82ef683af2f0850a3bed97c005750654e92434288eaf526d','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.033255','2026-09-24 03:12:15.033255'),(7,'f1aa9959-f5e3-45e1-a545-164ccae09ecb',7,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"b8c6248c-6fce-47a6-b6b9-b176b8ec327a\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo y Trinity vuelven a encontrarse en Matrix Resurrections\",\"title\":\"Matrix Resurrections: recordar para volver a elegir\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"d3ee70e0-fb81-4fca-876c-fe2efc7336bb\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"La memoria como mapa de salida\",\"marks\":[]}]},{\"id\":\"d5dea3fa-ddbe-433c-8f24-96f4624b6091\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Resurrections regresa a Thomas Anderson dentro de una simulación que ha convertido su historia en producto cultural. El reconocimiento llega de forma fragmentaria: imágenes, sensaciones y encuentros que contradicen la explicación oficial de su propia vida.\",\"marks\":[]}]},{\"id\":\"3b94d424-e8ea-4585-8920-f00a6b9c4f23\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La nueva Matrix no se sostiene solo mediante prohibiciones. El Analista administra deseo, miedo y proximidad para mantener a Neo y Trinity separados sin borrar por completo su vínculo. La película reflexiona así sobre nostalgia, repetición y autoría mientras reconstruye su lenguaje visual.\",\"marks\":[]}]},{\"id\":\"e2238132-a0c2-4ee4-b9d6-820aa49782a6\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Recordar permite distinguir experiencia, relato y manipulación.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La conexión entre Neo y Trinity deja de ser secundaria.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La nueva simulación explota emociones antes que reglas visibles.\",\"marks\":[]}]},{\"id\":\"849ada6d-5590-4c1b-a407-265c62817ccb\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Volver no significa repetir exactamente el pasado, sino recuperar la capacidad de decidir qué hacer con él.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Cuaderno Matrix, Lectura editorial de ejemplo\",\"marks\":[\"em\"]}]},{\"id\":\"9d46d73f-633d-4236-a472-42290322a6a9\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo y Trinity vuelven a encontrarse en Matrix Resurrections\",\"title\":\"Matrix Resurrections: recordar para volver a elegir\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"47f89423-8d30-443b-a02d-8c61bf322f8c\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"9ix7TUGVYIo\",\"title\":\"Tráiler oficial de Matrix Resurrections: recordar para volver a elegir\",\"start_seconds\":0},{\"id\":\"ce96ba35-857f-4a1e-8f28-9d6010b235b1\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"El desenlace entrega la transformación a una relación compartida. Neo y Trinity recuperan margen de acción y proponen rehacer un espacio que hasta entonces había utilizado sus recuerdos para contenerlos.\",\"marks\":[]}]}]}',3126,'ad03e277378edb0bc460935bf8f9acab886ce4546960cfcea7b4016ba5f95c07','5b7477c64fef2c983cbbb3944d42f5e2c6b19b995decfd95b8be41651cdaca3d','32da976a58090b0b4be73ebbcd5cecf5434640a3023db0e677e6ef08b4def217','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.074459','2026-09-24 03:12:15.074459'),(8,'8b2d318c-8196-4e13-9ce9-ae63699f05ed',8,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"8960b9dc-0fee-4b78-9f86-6954073be544\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo eta Trinity berriro elkartzen Matrix Resurrections filmean\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"d091f339-e777-422a-8f89-fb06f5eb4be2\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Memoria irteerako mapa gisa\",\"marks\":[]}]},{\"id\":\"dafbe1ef-beec-4db1-9866-e284f0b355e5\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Resurrections Thomas Andersonengana itzultzen da, bere historia produktu kultural bihurtu duen simulazio baten barruan. Aitorpena zatika iristen da: bere bizitzaren azalpen ofiziala gezurtatzen duten irudi, sentsazio eta topaketen bidez.\",\"marks\":[]}]},{\"id\":\"fe0729b1-54d2-4cc0-bd60-d566329523b7\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix berria ez da debekuetan soilik oinarritzen. Analistak desira, beldurra eta hurbiltasuna kudeatzen ditu Neo eta Trinity bereizita mantentzeko, haien lotura erabat ezabatu gabe. Filmak nostalgia, errepikapena eta egiletza aztertzen ditu, bere hizkuntza bisuala berreraikitzen duen bitartean.\",\"marks\":[]}]},{\"id\":\"655dbd2b-faa2-4105-afbe-9df11b17a777\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Gogoratzeak esperientzia, kontakizuna eta manipulazioa bereizten laguntzen du.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Neo eta Trinityren arteko lotura ez da bigarren mailakoa.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Simulazio berriak emozioak ustiatzen ditu ageriko arauak baino lehen.\",\"marks\":[]}]},{\"id\":\"af5eb74d-c665-462d-aa9e-fb0d1598fc28\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Itzultzea ez da iragana berdin errepikatzea, harekin zer egin erabakitzeko gaitasuna berreskuratzea baizik.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Matrix koadernoa, Adibideko irakurketa editoriala\",\"marks\":[\"em\"]}]},{\"id\":\"79ae5e9f-b7d9-4afe-bdb8-ccdb5050fa82\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo eta Trinity berriro elkartzen Matrix Resurrections filmean\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"ae95f5f1-9c71-4b60-835c-f9db5214ca25\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"9ix7TUGVYIo\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko filmaren trailer ofiziala\",\"start_seconds\":0},{\"id\":\"ed257e3b-e5ac-4d19-8aef-4cd3055a5322\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"Amaierak eraldaketa partekatutako harreman baten esku uzten du. Neok eta Trinityk ekiteko tartea berreskuratzen dute, eta ordura arte haien oroitzapenak eusteko erabili zituen espazioa berreraikitzea proposatzen dute.\",\"marks\":[]}]}]}',3126,'f204bf1a394daed96fb8edf0c4cd1b99ba6d83f7c6a7b69b84e98721a982fae7','db52fd2ffd32445e84d36c3c1684271d52fb989c2fbb0df876ba833025441c2c','9f856cd886891a741ebaba7c30e1a3abedaf903a4456c4a5606bba9d93407de9','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.074459','2026-09-24 03:12:15.074459');
/*!40000 ALTER TABLE `ls_blog_content_docs` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_content_layout_docs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_content_layout_docs` (
  `document_id` bigint(20) unsigned NOT NULL,
  `schema_version` smallint(5) unsigned NOT NULL DEFAULT 2,
  `template_key` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `document_json` longtext NOT NULL,
  `document_bytes` int(10) unsigned NOT NULL,
  `document_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `snapshot_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  PRIMARY KEY (`document_id`),
  CONSTRAINT `ls_blog_f_cld_document` FOREIGN KEY (`document_id`) REFERENCES `ls_blog_content_docs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_cld_schema` CHECK (`schema_version` = 2),
  CONSTRAINT `ls_blog_c_cld_template` CHECK (char_length(`template_key`) between 1 and 64 and `template_key` = lcase(`template_key`) and `template_key` = trim(`template_key`) and `template_key` regexp '^[a-z][a-z0-9_-]{0,63}$'),
  CONSTRAINT `ls_blog_c_cld_bytes` CHECK (`document_bytes` between 1 and 300000),
  CONSTRAINT `ls_blog_c_cld_doc_hash` CHECK (`document_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_cld_snap_hash` CHECK (`snapshot_sha256` regexp '^[0-9a-f]{64}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_content_layout_docs` WRITE;
/*!40000 ALTER TABLE `ls_blog_content_layout_docs` DISABLE KEYS */;
INSERT INTO `ls_blog_content_layout_docs` VALUES (1,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"cc396780-c99b-49db-b58f-b70e7b888368\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo y la tripulación ante el universo digital de Matrix\",\"title\":\"Matrix: despertar frente a una realidad construida\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"cd2f309c-4d11-432e-83ac-7d3077a8fe01\",\"type\":\"section\",\"children\":[{\"id\":\"9979969c-24dc-4864-982a-29dd9ec24bd8\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"El despertar de Neo cambia las reglas\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"9d9683b1-0fda-4dde-a9ef-145a6749635e\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"06a7d0b7-c305-4391-8cd0-34eff44ac77a\",\"children\":[{\"id\":\"ecb900b8-4811-4065-bce9-c83455e10f5a\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix presenta a Thomas Anderson como un programador atrapado entre una rutina reconocible y la intuición de que algo no encaja. La aparición de Trinity y Morpheus convierte esa sospecha en una elección concreta: seguir dentro de una realidad cómoda o mirar detrás de su arquitectura.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"f550c5b3-d22b-41a9-bdb7-6487e5fd98f9\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La película combina ciencia ficción, acción y filosofía sin separar sus ideas de la puesta en escena. El código verde, los reflejos y los espacios repetidos hacen visible un sistema que parecía invisible. Neo no adquiere respuestas de inmediato; aprende a leer las reglas antes de intentar romperlas.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"336babe6-5cb5-4802-b459-8d7338aebe7d\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"7a8f8827-4e2a-48eb-a24a-f0912cf8ccf8\",\"content\":[{\"type\":\"text\",\"text\":\"La identidad como una construcción que puede cuestionarse.\",\"marks\":[]}]},{\"id\":\"9099ae25-ff61-47f0-a54c-fd7340692a2f\",\"content\":[{\"type\":\"text\",\"text\":\"La tecnología como entorno, lenguaje y mecanismo de control.\",\"marks\":[]}]},{\"id\":\"b0d3d60e-c374-48b4-abaf-666ff6e7138e\",\"content\":[{\"type\":\"text\",\"text\":\"La elección personal como motor del relato y de sus consecuencias.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"2d32ff92-c1d8-4016-887b-fbbd22d378d1\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"La pregunta central no es solo qué es Matrix, sino qué hacemos después de reconocer el sistema.\",\"marks\":[]}],\"author\":\"Cuaderno Matrix\",\"source\":\"Lectura editorial de ejemplo\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"377358f7-48e9-4c90-b7ce-dd8324d0fc13\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo y la tripulación ante el universo digital de Matrix\",\"title\":\"Matrix: despertar frente a una realidad construida\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"d61593d3-07f3-4bda-beae-910ad3cd3939\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"tGgCqGm_6Hs\",\"title\":\"Tráiler oficial de Matrix: despertar frente a una realidad construida\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"8d6ecf0c-0246-432e-961f-077f92b07652\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"Su final funciona como una promesa de transformación: comprender la simulación permite imaginar otras posibilidades, pero también obliga a asumir el coste de actuar.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4424,'398acf617c25a325c90d19f2479d024fd8fe779d31ecdd5d829cab76703fdeef','e0c8f830b057e5a331851c17e5bc4760a42f79edb877f4f0586621e703f81bcd'),(2,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"4d783ee7-24e0-46aa-9643-c7b6007a5107\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo eta tripulazioa Matrixeko unibertso digitalaren aurrean\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"138ee8d3-aae8-4bbb-b672-1fe8315f0a55\",\"type\":\"section\",\"children\":[{\"id\":\"a8de8971-27ce-4984-a52c-82d43d93d0fc\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Neoren esnatzeak arauak aldatzen ditu\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"19e11227-a321-48d7-a673-cd8199d8a20a\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"1f3934ff-3d11-4e37-8764-ad2d6c05b8aa\",\"children\":[{\"id\":\"2699f2ac-930e-42e6-b378-85eadfe60e6f\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrixek Thomas Anderson aurkezten du: errutina ezagun baten eta zerbait ondo ez dagoelako susmoaren artean harrapatutako programatzailea. Trinity eta Morpheus agertzean, susmo hori hautu zehatz bihurtzen da: errealitate erosoaren barruan jarraitu edo haren arkitekturaren atzean begiratu.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"1f8ef740-ea0b-46ca-8d8a-5b05e29b50c8\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Filmak zientzia-fikzioa, akzioa eta filosofia uztartzen ditu, ideiak eszenaratzetik bereizi gabe. Kode berdeak, islek eta espazio errepikatuek ikusezina zirudien sistema agerian uzten dute. Neok ez ditu erantzunak berehala jasotzen; arauak irakurtzen ikasten du hausten saiatu aurretik.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"9099c68e-54c3-4ad2-affb-ad1d5e9af1e2\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"d0214ba1-92f1-4cdf-84ee-86ea933188b8\",\"content\":[{\"type\":\"text\",\"text\":\"Nortasuna zalantzan jar daitekeen eraikuntza gisa.\",\"marks\":[]}]},{\"id\":\"5079ce44-561b-4802-bfd8-98d0b47b1544\",\"content\":[{\"type\":\"text\",\"text\":\"Teknologia ingurune, hizkuntza eta kontrol-mekanismo gisa.\",\"marks\":[]}]},{\"id\":\"f87a55b5-9c44-4ab6-be95-c52e0fe82faa\",\"content\":[{\"type\":\"text\",\"text\":\"Hautu pertsonala kontakizunaren eta ondorioen motor gisa.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"7b5b3892-2a8e-4f37-a539-e666142c22ae\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Galdera nagusia ez da soilik Matrix zer den, sistema ezagutu ondoren zer egiten dugun baizik.\",\"marks\":[]}],\"author\":\"Matrix koadernoa\",\"source\":\"Adibideko irakurketa editoriala\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"bcb97557-4b6a-461e-aac2-ddf77f4831d2\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo eta tripulazioa Matrixeko unibertso digitalaren aurrean\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"872cb24b-4529-41eb-8b53-a3d6193c8afd\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"tGgCqGm_6Hs\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea filmaren trailer ofiziala\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"e08f2f64-e071-4570-9735-bfab1697b874\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"Amaierak eraldaketaren promesa dakar: simulazioa ulertzeak beste aukera batzuk irudikatzeko bidea ematen du, baina jardutearen kostua onartzera ere behartzen du.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4381,'bd71b27c6fe7283f290d5029ee0cf19e8c5d3617706e65991068cbb51cd9fcea','0ddfbf6da882f00d8f1ff5730406bc63d8354918dea63ab23c739ff9876596d9'),(3,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"d262854b-6b89-46da-afa0-86ac56a14432\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo y Morpheus durante el conflicto de Matrix Reloaded\",\"title\":\"Matrix Reloaded: elegir dentro de un sistema previsto\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"4c885eea-26fb-409d-8716-738b1e29264a\",\"type\":\"section\",\"children\":[{\"id\":\"41b48743-0cc0-4ff2-8de3-2bf7aea0cf7f\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zion, causalidad y una elección imposible\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"551c6d19-f5e6-49c8-b420-5652402274b6\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"cf006114-275d-4d6b-8fb0-486c432de8d7\",\"children\":[{\"id\":\"6f201ae3-0b21-4600-bdc4-8dc875b3ff63\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Reloaded abre el relato hacia Zion y convierte la resistencia en una comunidad con responsabilidades, desacuerdos y tiempo limitado. Neo ya no busca únicamente comprender sus capacidades: debe decidir cómo utilizarlas cuando cada camino parece formar parte de un diseño anterior.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b1cf3ece-b339-4749-a116-c9886a84e1f9\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"El encuentro con el Arquitecto reformula la profecía y presenta la anomalía como un componente previsto del sistema. La persecución de la autopista y la búsqueda del Cerrajero traducen ese conflicto abstracto en movimiento, urgencia y decisiones encadenadas.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"335877fd-ff67-46b0-92d4-a5baef2fff31\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"c57e2223-38d3-42cf-9cc0-100e4d32ace4\",\"content\":[{\"type\":\"text\",\"text\":\"La causalidad organiza tanto el diálogo como la acción.\",\"marks\":[]}]},{\"id\":\"84d75d86-2f07-4f76-ac7e-8953a105b5ae\",\"content\":[{\"type\":\"text\",\"text\":\"Zion aporta una escala humana al conflicto tecnológico.\",\"marks\":[]}]},{\"id\":\"a37e3e11-5181-4122-9d65-899ffeef666a\",\"content\":[{\"type\":\"text\",\"text\":\"El amor de Neo por Trinity introduce una variable difícil de reducir a cálculo.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"46d73dcc-6695-4795-8fda-0a7b0bf9d5ba\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Elegir cobra sentido cuando la decisión altera un recorrido que parecía completamente calculado.\",\"marks\":[]}],\"author\":\"Cuaderno Matrix\",\"source\":\"Lectura editorial de ejemplo\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"bc9ec40d-1ae6-49be-9475-d3832a93713a\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo y Morpheus durante el conflicto de Matrix Reloaded\",\"title\":\"Matrix Reloaded: elegir dentro de un sistema previsto\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"9d2d2f4f-7fc4-4256-8abd-befaaa7b8a55\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zmYE3tg26Qc\",\"title\":\"Tráiler oficial de Matrix Reloaded: elegir dentro de un sistema previsto\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"61a720f5-378a-49f0-a306-ae2beacf5aca\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"La película termina sin cerrar la ecuación. Su mayor aportación es desplazar la lucha desde una oposición simple hacia un sistema que también sabe administrar sus propias excepciones.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4416,'68433d63ec0b22fc9ba835276932e1b55fe83ea421bd1a73b40f60ec325f687b','751679258d6b3ac4c65838a1123bafe7b099d0689b0060f061976d5f89320ad6'),(4,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"d9c5877b-706f-4444-855d-832dc6223a99\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo eta Morpheus Matrix Reloaded filmeko gatazkan\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"e2a46c1a-2d2c-49c1-a982-3b6e1a00f0c3\",\"type\":\"section\",\"children\":[{\"id\":\"f6ee6f9b-040a-4f8c-8191-f9731d7ecf39\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zion, kausalitatea eta ezinezko hautua\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"84a17d34-35c8-40b9-9f0d-bf3da7528bfe\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"f3a793bc-e385-43bb-8b8d-0ebaf1e09685\",\"children\":[{\"id\":\"687d7122-1cc1-4cef-9709-42ab504549c3\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Reloadedek kontakizuna Zionerantz zabaltzen du, eta erresistentzia erantzukizunak, desadostasunak eta denbora mugatua dituen komunitate bihurtzen du. Neok ez du bere gaitasunak ulertu nahi soilik: nola erabili erabaki behar du, bide bakoitza aurreko diseinu baten parte dela dirudienean.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"6636568f-111a-49e4-a7f0-2b35d48db682\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Arkitektoarekin izandako topaketak profezia berrinterpretatzen du, eta anomalia sistemak aurreikusitako osagai gisa aurkezten du. Autobideko jazarpenak eta Giltzariaren bilaketak gatazka abstraktu hori mugimendu, presa eta kateatutako erabaki bihurtzen dute.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"fd995a8d-e235-45e0-8f87-e855b7f3a7bc\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"9fc32863-66b7-4469-b5aa-8216fece1776\",\"content\":[{\"type\":\"text\",\"text\":\"Kausalitateak elkarrizketa eta akzioa antolatzen ditu.\",\"marks\":[]}]},{\"id\":\"1f7274cf-6073-40f3-881f-d00261cda315\",\"content\":[{\"type\":\"text\",\"text\":\"Zionek giza eskala ematen dio gatazka teknologikoari.\",\"marks\":[]}]},{\"id\":\"a97fd2e7-c86c-48c5-a92c-abcab36fd8db\",\"content\":[{\"type\":\"text\",\"text\":\"Neok Trinityrekiko duen maitasunak kalkulura murrizten zaila den aldagaia sartzen du.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"df633e3f-e4a3-4c12-a1c1-c7db6f7d13f3\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Hautuak zentzua hartzen du erabakiak erabat kalkulatuta zirudien ibilbidea aldatzen duenean.\",\"marks\":[]}],\"author\":\"Matrix koadernoa\",\"source\":\"Adibideko irakurketa editoriala\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"92ec43cb-271a-434a-bde7-54b557869096\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo eta Morpheus Matrix Reloaded filmeko gatazkan\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b31651d4-34d6-4f94-8ecc-337bb7ca95f4\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zmYE3tg26Qc\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea filmaren trailer ofiziala\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"8a298634-e401-4f05-9ff8-100803f41708\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"Filma ekuazioa itxi gabe amaitzen da. Bere ekarpen handiena borroka oposizio sinple batetik salbuespenak ere kudeatzen dakien sistema batera eramatea da.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4378,'7214841177f7629e2b931721b6896036e9a410eb9eead754a9cb7d0575f2788d','0d1ff1e484a93f7883558468754fb0bbe00b7269bfc23c39838b1dcc201a022a'),(5,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"28e753af-1122-4443-982f-5b6ac7c7368e\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo frente al desenlace de Matrix Revolutions\",\"title\":\"Matrix Revolutions: una tregua para romper el ciclo\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"7505b315-0535-411c-906e-f74d8cff3d57\",\"type\":\"section\",\"children\":[{\"id\":\"37d5f8e5-95d2-4470-8a9b-5c31de173dac\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"La defensa de Zion y el precio de la paz\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b8811e6d-55bb-4818-9558-9659e5b56280\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"a62f6fbd-3ef0-43a8-8c74-0bd8ddfec632\",\"children\":[{\"id\":\"6914b645-4271-4a52-a39a-b2d60d08b7c3\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Revolutions concentra la presión en dos frentes. Zion resiste el ataque de las máquinas y Neo avanza hacia una solución que exige reconocer un peligro compartido. La amenaza de Smith desborda la simulación y vuelve posible una negociación antes impensable.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"c2d53130-c18d-4c61-b1a1-2a9923bea220\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La batalla de Zion muestra la escala material de la guerra, mientras el duelo final reduce el conflicto a dos figuras bajo la lluvia. Ambas líneas hablan de persistencia, sacrificio y límites: vencer ya no significa imponer una eliminación total, sino detener una repetición destructiva.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"4273476c-aa93-45d0-a974-ffb4f7d0227e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"28b1d812-0b7e-4977-a040-2e9269e37aa6\",\"content\":[{\"type\":\"text\",\"text\":\"La defensa colectiva de Zion sostiene el coste humano del desenlace.\",\"marks\":[]}]},{\"id\":\"dc732257-d2d9-4739-8e0d-8b92404d9674\",\"content\":[{\"type\":\"text\",\"text\":\"Smith representa una expansión sin límite ni propósito.\",\"marks\":[]}]},{\"id\":\"15b6a58a-3abf-4acd-8c19-c6a9e89c780b\",\"content\":[{\"type\":\"text\",\"text\":\"La tregua abre un espacio político que antes no existía.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"f46241cd-349a-47fd-9f09-8dd3ba6a41e9\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Romper el ciclo requiere una decisión que ninguna de las partes podía imponer por separado.\",\"marks\":[]}],\"author\":\"Cuaderno Matrix\",\"source\":\"Lectura editorial de ejemplo\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"bd3c540d-1c9f-450d-8b54-ee4fdeef42a3\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo frente al desenlace de Matrix Revolutions\",\"title\":\"Matrix Revolutions: una tregua para romper el ciclo\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"6e52841e-d6e6-44a7-9de5-11c65e52164d\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zOh_pjoYTq8\",\"title\":\"Tráiler oficial de Matrix Revolutions: una tregua para romper el ciclo\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"336f62a7-f861-46f5-89c4-e3b6a0d8bb5f\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"El acuerdo final no resuelve todas las tensiones, pero permite imaginar convivencia, memoria y elección. La paz aparece como una construcción frágil que deberá mantenerse más allá de la victoria inmediata.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4406,'4c58f982446ab6e120267cfe9313715b4e3ce24c4c45be79072cf52804688994','23cfc26aaa240913e82d285e22c44e833b8fa024767a7a41167b126c5d59a035'),(6,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"82493402-0fc6-4dee-91ca-3fe451c9dba0\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo Matrix Revolutions filmeko amaieraren aurrean\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b2f7cd2a-4cf7-4016-b786-4c77356d6e7e\",\"type\":\"section\",\"children\":[{\"id\":\"bd95d17c-5bbc-422d-bfa3-d12e88955f8e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zionen defentsa eta bakearen prezioa\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ffacd657-395a-41ff-aa56-698a9f5fc2cc\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"f31e54d5-48a6-4361-af57-a5fdb4bb9d7c\",\"children\":[{\"id\":\"fc18d799-1072-47d4-962a-d672943f8e0e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Revolutionsek presioa bi frontetan biltzen du. Zionek makinen erasoa jasaten du, eta Neo arrisku partekatu bat aitortzea eskatzen duen irtenbiderantz doa. Smithen mehatxuak simulazioa gainditzen du, eta lehen pentsaezina zen negoziazioa ahalbidetzen du.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"d46cc7b6-bed5-4aa3-9fd5-783603e8e073\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Zioneko guduak gerraren eskala materiala erakusten du; azken dueluan, berriz, gatazka euripeko bi figuratara murrizten da. Bi lerroek iraunkortasuna, sakrifizioa eta mugak dituzte ardatz: irabaztea ez da erabateko ezabaketa inposatzea, errepikapen suntsitzailea geldiaraztea baizik.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b1931dbe-e2cc-4d61-8dba-2ca434d75c3e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"a9d4b0ec-92c1-4d50-8bcd-284ba4ba4c83\",\"content\":[{\"type\":\"text\",\"text\":\"Zionen defentsa kolektiboak amaieraren giza kostua erakusten du.\",\"marks\":[]}]},{\"id\":\"25faf6b7-42a3-4311-bcb5-7a4600694000\",\"content\":[{\"type\":\"text\",\"text\":\"Smithek mugarik eta helbururik gabeko hedapena irudikatzen du.\",\"marks\":[]}]},{\"id\":\"d08536ef-35a7-47dd-9d6d-cea2595751e4\",\"content\":[{\"type\":\"text\",\"text\":\"Su-etenak lehen ez zegoen espazio politikoa irekitzen du.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"8e4dba38-266d-4233-bdee-1f8d55e703c7\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Zikloa hausteko, aldeetako inork bere kabuz inposatu ezin zuen erabakia behar da.\",\"marks\":[]}],\"author\":\"Matrix koadernoa\",\"source\":\"Adibideko irakurketa editoriala\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"093b7721-f0ec-4818-a4cd-1493a8700128\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo Matrix Revolutions filmeko amaieraren aurrean\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ea0b8948-90d9-4648-8521-e3618d7b4554\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zOh_pjoYTq8\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena filmaren trailer ofiziala\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ce4d9d54-19b4-4c4d-82c3-14430c845888\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"Azken akordioak ez ditu tentsio guztiak konpontzen, baina bizikidetza, memoria eta hautua irudikatzeko aukera ematen du. Bakea garaipenetik harago mantendu beharreko eraikuntza hauskor gisa agertzen da.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4347,'f597b4ef429c46d9b842d14c65f83c5b6296cd0a8cdbd0004e0cb72fa4cea40e','d8d9c125412668037c35a1ec462464e4b7e2bf95a55a57c4bbbb565a282a639b'),(7,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"b8c6248c-6fce-47a6-b6b9-b176b8ec327a\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo y Trinity vuelven a encontrarse en Matrix Resurrections\",\"title\":\"Matrix Resurrections: recordar para volver a elegir\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"7303a2e5-0b94-43e6-a796-e464d4f9fcc1\",\"type\":\"section\",\"children\":[{\"id\":\"d3ee70e0-fb81-4fca-876c-fe2efc7336bb\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"La memoria como mapa de salida\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"9b9f113c-0b02-4d7d-a908-2956b89eb5ab\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"d183b18b-aac7-44d4-a948-430a711a6376\",\"children\":[{\"id\":\"d5dea3fa-ddbe-433c-8f24-96f4624b6091\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Resurrections regresa a Thomas Anderson dentro de una simulación que ha convertido su historia en producto cultural. El reconocimiento llega de forma fragmentaria: imágenes, sensaciones y encuentros que contradicen la explicación oficial de su propia vida.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"3b94d424-e8ea-4585-8920-f00a6b9c4f23\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La nueva Matrix no se sostiene solo mediante prohibiciones. El Analista administra deseo, miedo y proximidad para mantener a Neo y Trinity separados sin borrar por completo su vínculo. La película reflexiona así sobre nostalgia, repetición y autoría mientras reconstruye su lenguaje visual.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"e2238132-a0c2-4ee4-b9d6-820aa49782a6\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"a426464a-82a9-4a8d-8847-062f45470ac3\",\"content\":[{\"type\":\"text\",\"text\":\"Recordar permite distinguir experiencia, relato y manipulación.\",\"marks\":[]}]},{\"id\":\"7babb772-5866-4723-8e95-ea4055880fd1\",\"content\":[{\"type\":\"text\",\"text\":\"La conexión entre Neo y Trinity deja de ser secundaria.\",\"marks\":[]}]},{\"id\":\"648e05cc-32c1-42cb-91ab-2e92fe4d5dbc\",\"content\":[{\"type\":\"text\",\"text\":\"La nueva simulación explota emociones antes que reglas visibles.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"849ada6d-5590-4c1b-a407-265c62817ccb\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Volver no significa repetir exactamente el pasado, sino recuperar la capacidad de decidir qué hacer con él.\",\"marks\":[]}],\"author\":\"Cuaderno Matrix\",\"source\":\"Lectura editorial de ejemplo\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"9d46d73f-633d-4236-a472-42290322a6a9\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo y Trinity vuelven a encontrarse en Matrix Resurrections\",\"title\":\"Matrix Resurrections: recordar para volver a elegir\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"47f89423-8d30-443b-a02d-8c61bf322f8c\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"9ix7TUGVYIo\",\"title\":\"Tráiler oficial de Matrix Resurrections: recordar para volver a elegir\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ce96ba35-857f-4a1e-8f28-9d6010b235b1\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"El desenlace entrega la transformación a una relación compartida. Neo y Trinity recuperan margen de acción y proponen rehacer un espacio que hasta entonces había utilizado sus recuerdos para contenerlos.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4439,'a9a73269419592576b81359d59156c5b473cf9e2e88576850ea19bf80fcc1968','7340c186c8632bc36d124daa12f33d5147341bae6f49f9651836b1936de72b01'),(8,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"8960b9dc-0fee-4b78-9f86-6954073be544\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo eta Trinity berriro elkartzen Matrix Resurrections filmean\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"e95ec0e3-a0a3-4698-a12d-915d65387d01\",\"type\":\"section\",\"children\":[{\"id\":\"d091f339-e777-422a-8f89-fb06f5eb4be2\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Memoria irteerako mapa gisa\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b6c8369b-783f-48ce-97c1-421fad16520a\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"aa65619e-8a4a-4312-a1e8-4b2d183bf655\",\"children\":[{\"id\":\"dafbe1ef-beec-4db1-9866-e284f0b355e5\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Resurrections Thomas Andersonengana itzultzen da, bere historia produktu kultural bihurtu duen simulazio baten barruan. Aitorpena zatika iristen da: bere bizitzaren azalpen ofiziala gezurtatzen duten irudi, sentsazio eta topaketen bidez.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"fe0729b1-54d2-4cc0-bd60-d566329523b7\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix berria ez da debekuetan soilik oinarritzen. Analistak desira, beldurra eta hurbiltasuna kudeatzen ditu Neo eta Trinity bereizita mantentzeko, haien lotura erabat ezabatu gabe. Filmak nostalgia, errepikapena eta egiletza aztertzen ditu, bere hizkuntza bisuala berreraikitzen duen bitartean.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"655dbd2b-faa2-4105-afbe-9df11b17a777\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"2e0cbaa6-518d-476f-b074-84c9bf9f0701\",\"content\":[{\"type\":\"text\",\"text\":\"Gogoratzeak esperientzia, kontakizuna eta manipulazioa bereizten laguntzen du.\",\"marks\":[]}]},{\"id\":\"96565030-209d-49bd-b12d-a237be2d9788\",\"content\":[{\"type\":\"text\",\"text\":\"Neo eta Trinityren arteko lotura ez da bigarren mailakoa.\",\"marks\":[]}]},{\"id\":\"7281056e-9b12-4b5a-8168-a850dbe3d8dd\",\"content\":[{\"type\":\"text\",\"text\":\"Simulazio berriak emozioak ustiatzen ditu ageriko arauak baino lehen.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"af5eb74d-c665-462d-aa9e-fb0d1598fc28\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Itzultzea ez da iragana berdin errepikatzea, harekin zer egin erabakitzeko gaitasuna berreskuratzea baizik.\",\"marks\":[]}],\"author\":\"Matrix koadernoa\",\"source\":\"Adibideko irakurketa editoriala\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"79ae5e9f-b7d9-4afe-bdb8-ccdb5050fa82\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo eta Trinity berriro elkartzen Matrix Resurrections filmean\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ae95f5f1-9c71-4b60-835c-f9db5214ca25\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"9ix7TUGVYIo\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko filmaren trailer ofiziala\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ed257e3b-e5ac-4d19-8aef-4cd3055a5322\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"Amaierak eraldaketa partekatutako harreman baten esku uzten du. Neok eta Trinityk ekiteko tartea berreskuratzen dute, eta ordura arte haien oroitzapenak eusteko erabili zituen espazioa berreraikitzea proposatzen dute.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4439,'73b36d939f53b482a4f843224d9cc3b0af8fbddead4d51f0b4d5834cda88a662','4933bc1e27fae844cc6fdd388e9c636d7518401108b79d8e5bde66d94a485c02');
/*!40000 ALTER TABLE `ls_blog_content_layout_docs` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_content_layout_revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_content_layout_revisions` (
  `revision_id` bigint(20) unsigned NOT NULL,
  `schema_version` smallint(5) unsigned NOT NULL DEFAULT 2,
  `template_key` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `document_json` longtext NOT NULL,
  `document_bytes` int(10) unsigned NOT NULL,
  `document_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `snapshot_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  PRIMARY KEY (`revision_id`),
  CONSTRAINT `ls_blog_f_clr_revision` FOREIGN KEY (`revision_id`) REFERENCES `ls_blog_content_revisions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_clr_schema` CHECK (`schema_version` = 2),
  CONSTRAINT `ls_blog_c_clr_template` CHECK (char_length(`template_key`) between 1 and 64 and `template_key` = lcase(`template_key`) and `template_key` = trim(`template_key`) and `template_key` regexp '^[a-z][a-z0-9_-]{0,63}$'),
  CONSTRAINT `ls_blog_c_clr_bytes` CHECK (`document_bytes` between 1 and 300000),
  CONSTRAINT `ls_blog_c_clr_doc_hash` CHECK (`document_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_clr_snap_hash` CHECK (`snapshot_sha256` regexp '^[0-9a-f]{64}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_content_layout_revisions` WRITE;
/*!40000 ALTER TABLE `ls_blog_content_layout_revisions` DISABLE KEYS */;
INSERT INTO `ls_blog_content_layout_revisions` VALUES (1,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"cc396780-c99b-49db-b58f-b70e7b888368\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo y la tripulación ante el universo digital de Matrix\",\"title\":\"Matrix: despertar frente a una realidad construida\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"cd2f309c-4d11-432e-83ac-7d3077a8fe01\",\"type\":\"section\",\"children\":[{\"id\":\"9979969c-24dc-4864-982a-29dd9ec24bd8\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"El despertar de Neo cambia las reglas\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"9d9683b1-0fda-4dde-a9ef-145a6749635e\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"06a7d0b7-c305-4391-8cd0-34eff44ac77a\",\"children\":[{\"id\":\"ecb900b8-4811-4065-bce9-c83455e10f5a\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix presenta a Thomas Anderson como un programador atrapado entre una rutina reconocible y la intuición de que algo no encaja. La aparición de Trinity y Morpheus convierte esa sospecha en una elección concreta: seguir dentro de una realidad cómoda o mirar detrás de su arquitectura.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"f550c5b3-d22b-41a9-bdb7-6487e5fd98f9\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La película combina ciencia ficción, acción y filosofía sin separar sus ideas de la puesta en escena. El código verde, los reflejos y los espacios repetidos hacen visible un sistema que parecía invisible. Neo no adquiere respuestas de inmediato; aprende a leer las reglas antes de intentar romperlas.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"336babe6-5cb5-4802-b459-8d7338aebe7d\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"7a8f8827-4e2a-48eb-a24a-f0912cf8ccf8\",\"content\":[{\"type\":\"text\",\"text\":\"La identidad como una construcción que puede cuestionarse.\",\"marks\":[]}]},{\"id\":\"9099ae25-ff61-47f0-a54c-fd7340692a2f\",\"content\":[{\"type\":\"text\",\"text\":\"La tecnología como entorno, lenguaje y mecanismo de control.\",\"marks\":[]}]},{\"id\":\"b0d3d60e-c374-48b4-abaf-666ff6e7138e\",\"content\":[{\"type\":\"text\",\"text\":\"La elección personal como motor del relato y de sus consecuencias.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"2d32ff92-c1d8-4016-887b-fbbd22d378d1\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"La pregunta central no es solo qué es Matrix, sino qué hacemos después de reconocer el sistema.\",\"marks\":[]}],\"author\":\"Cuaderno Matrix\",\"source\":\"Lectura editorial de ejemplo\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"377358f7-48e9-4c90-b7ce-dd8324d0fc13\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo y la tripulación ante el universo digital de Matrix\",\"title\":\"Matrix: despertar frente a una realidad construida\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"d61593d3-07f3-4bda-beae-910ad3cd3939\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"tGgCqGm_6Hs\",\"title\":\"Tráiler oficial de Matrix: despertar frente a una realidad construida\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"8d6ecf0c-0246-432e-961f-077f92b07652\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"Su final funciona como una promesa de transformación: comprender la simulación permite imaginar otras posibilidades, pero también obliga a asumir el coste de actuar.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4424,'398acf617c25a325c90d19f2479d024fd8fe779d31ecdd5d829cab76703fdeef','e0c8f830b057e5a331851c17e5bc4760a42f79edb877f4f0586621e703f81bcd'),(2,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"4d783ee7-24e0-46aa-9643-c7b6007a5107\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo eta tripulazioa Matrixeko unibertso digitalaren aurrean\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"138ee8d3-aae8-4bbb-b672-1fe8315f0a55\",\"type\":\"section\",\"children\":[{\"id\":\"a8de8971-27ce-4984-a52c-82d43d93d0fc\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Neoren esnatzeak arauak aldatzen ditu\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"19e11227-a321-48d7-a673-cd8199d8a20a\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"1f3934ff-3d11-4e37-8764-ad2d6c05b8aa\",\"children\":[{\"id\":\"2699f2ac-930e-42e6-b378-85eadfe60e6f\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrixek Thomas Anderson aurkezten du: errutina ezagun baten eta zerbait ondo ez dagoelako susmoaren artean harrapatutako programatzailea. Trinity eta Morpheus agertzean, susmo hori hautu zehatz bihurtzen da: errealitate erosoaren barruan jarraitu edo haren arkitekturaren atzean begiratu.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"1f8ef740-ea0b-46ca-8d8a-5b05e29b50c8\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Filmak zientzia-fikzioa, akzioa eta filosofia uztartzen ditu, ideiak eszenaratzetik bereizi gabe. Kode berdeak, islek eta espazio errepikatuek ikusezina zirudien sistema agerian uzten dute. Neok ez ditu erantzunak berehala jasotzen; arauak irakurtzen ikasten du hausten saiatu aurretik.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"9099c68e-54c3-4ad2-affb-ad1d5e9af1e2\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"d0214ba1-92f1-4cdf-84ee-86ea933188b8\",\"content\":[{\"type\":\"text\",\"text\":\"Nortasuna zalantzan jar daitekeen eraikuntza gisa.\",\"marks\":[]}]},{\"id\":\"5079ce44-561b-4802-bfd8-98d0b47b1544\",\"content\":[{\"type\":\"text\",\"text\":\"Teknologia ingurune, hizkuntza eta kontrol-mekanismo gisa.\",\"marks\":[]}]},{\"id\":\"f87a55b5-9c44-4ab6-be95-c52e0fe82faa\",\"content\":[{\"type\":\"text\",\"text\":\"Hautu pertsonala kontakizunaren eta ondorioen motor gisa.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"7b5b3892-2a8e-4f37-a539-e666142c22ae\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Galdera nagusia ez da soilik Matrix zer den, sistema ezagutu ondoren zer egiten dugun baizik.\",\"marks\":[]}],\"author\":\"Matrix koadernoa\",\"source\":\"Adibideko irakurketa editoriala\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"bcb97557-4b6a-461e-aac2-ddf77f4831d2\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo eta tripulazioa Matrixeko unibertso digitalaren aurrean\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"872cb24b-4529-41eb-8b53-a3d6193c8afd\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"tGgCqGm_6Hs\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea filmaren trailer ofiziala\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"e08f2f64-e071-4570-9735-bfab1697b874\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"Amaierak eraldaketaren promesa dakar: simulazioa ulertzeak beste aukera batzuk irudikatzeko bidea ematen du, baina jardutearen kostua onartzera ere behartzen du.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4381,'bd71b27c6fe7283f290d5029ee0cf19e8c5d3617706e65991068cbb51cd9fcea','0ddfbf6da882f00d8f1ff5730406bc63d8354918dea63ab23c739ff9876596d9'),(3,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"d262854b-6b89-46da-afa0-86ac56a14432\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo y Morpheus durante el conflicto de Matrix Reloaded\",\"title\":\"Matrix Reloaded: elegir dentro de un sistema previsto\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"4c885eea-26fb-409d-8716-738b1e29264a\",\"type\":\"section\",\"children\":[{\"id\":\"41b48743-0cc0-4ff2-8de3-2bf7aea0cf7f\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zion, causalidad y una elección imposible\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"551c6d19-f5e6-49c8-b420-5652402274b6\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"cf006114-275d-4d6b-8fb0-486c432de8d7\",\"children\":[{\"id\":\"6f201ae3-0b21-4600-bdc4-8dc875b3ff63\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Reloaded abre el relato hacia Zion y convierte la resistencia en una comunidad con responsabilidades, desacuerdos y tiempo limitado. Neo ya no busca únicamente comprender sus capacidades: debe decidir cómo utilizarlas cuando cada camino parece formar parte de un diseño anterior.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b1cf3ece-b339-4749-a116-c9886a84e1f9\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"El encuentro con el Arquitecto reformula la profecía y presenta la anomalía como un componente previsto del sistema. La persecución de la autopista y la búsqueda del Cerrajero traducen ese conflicto abstracto en movimiento, urgencia y decisiones encadenadas.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"335877fd-ff67-46b0-92d4-a5baef2fff31\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"c57e2223-38d3-42cf-9cc0-100e4d32ace4\",\"content\":[{\"type\":\"text\",\"text\":\"La causalidad organiza tanto el diálogo como la acción.\",\"marks\":[]}]},{\"id\":\"84d75d86-2f07-4f76-ac7e-8953a105b5ae\",\"content\":[{\"type\":\"text\",\"text\":\"Zion aporta una escala humana al conflicto tecnológico.\",\"marks\":[]}]},{\"id\":\"a37e3e11-5181-4122-9d65-899ffeef666a\",\"content\":[{\"type\":\"text\",\"text\":\"El amor de Neo por Trinity introduce una variable difícil de reducir a cálculo.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"46d73dcc-6695-4795-8fda-0a7b0bf9d5ba\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Elegir cobra sentido cuando la decisión altera un recorrido que parecía completamente calculado.\",\"marks\":[]}],\"author\":\"Cuaderno Matrix\",\"source\":\"Lectura editorial de ejemplo\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"bc9ec40d-1ae6-49be-9475-d3832a93713a\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo y Morpheus durante el conflicto de Matrix Reloaded\",\"title\":\"Matrix Reloaded: elegir dentro de un sistema previsto\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"9d2d2f4f-7fc4-4256-8abd-befaaa7b8a55\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zmYE3tg26Qc\",\"title\":\"Tráiler oficial de Matrix Reloaded: elegir dentro de un sistema previsto\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"61a720f5-378a-49f0-a306-ae2beacf5aca\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"La película termina sin cerrar la ecuación. Su mayor aportación es desplazar la lucha desde una oposición simple hacia un sistema que también sabe administrar sus propias excepciones.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4416,'68433d63ec0b22fc9ba835276932e1b55fe83ea421bd1a73b40f60ec325f687b','751679258d6b3ac4c65838a1123bafe7b099d0689b0060f061976d5f89320ad6'),(4,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"d9c5877b-706f-4444-855d-832dc6223a99\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo eta Morpheus Matrix Reloaded filmeko gatazkan\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"e2a46c1a-2d2c-49c1-a982-3b6e1a00f0c3\",\"type\":\"section\",\"children\":[{\"id\":\"f6ee6f9b-040a-4f8c-8191-f9731d7ecf39\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zion, kausalitatea eta ezinezko hautua\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"84a17d34-35c8-40b9-9f0d-bf3da7528bfe\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"f3a793bc-e385-43bb-8b8d-0ebaf1e09685\",\"children\":[{\"id\":\"687d7122-1cc1-4cef-9709-42ab504549c3\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Reloadedek kontakizuna Zionerantz zabaltzen du, eta erresistentzia erantzukizunak, desadostasunak eta denbora mugatua dituen komunitate bihurtzen du. Neok ez du bere gaitasunak ulertu nahi soilik: nola erabili erabaki behar du, bide bakoitza aurreko diseinu baten parte dela dirudienean.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"6636568f-111a-49e4-a7f0-2b35d48db682\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Arkitektoarekin izandako topaketak profezia berrinterpretatzen du, eta anomalia sistemak aurreikusitako osagai gisa aurkezten du. Autobideko jazarpenak eta Giltzariaren bilaketak gatazka abstraktu hori mugimendu, presa eta kateatutako erabaki bihurtzen dute.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"fd995a8d-e235-45e0-8f87-e855b7f3a7bc\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"9fc32863-66b7-4469-b5aa-8216fece1776\",\"content\":[{\"type\":\"text\",\"text\":\"Kausalitateak elkarrizketa eta akzioa antolatzen ditu.\",\"marks\":[]}]},{\"id\":\"1f7274cf-6073-40f3-881f-d00261cda315\",\"content\":[{\"type\":\"text\",\"text\":\"Zionek giza eskala ematen dio gatazka teknologikoari.\",\"marks\":[]}]},{\"id\":\"a97fd2e7-c86c-48c5-a92c-abcab36fd8db\",\"content\":[{\"type\":\"text\",\"text\":\"Neok Trinityrekiko duen maitasunak kalkulura murrizten zaila den aldagaia sartzen du.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"df633e3f-e4a3-4c12-a1c1-c7db6f7d13f3\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Hautuak zentzua hartzen du erabakiak erabat kalkulatuta zirudien ibilbidea aldatzen duenean.\",\"marks\":[]}],\"author\":\"Matrix koadernoa\",\"source\":\"Adibideko irakurketa editoriala\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"92ec43cb-271a-434a-bde7-54b557869096\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo eta Morpheus Matrix Reloaded filmeko gatazkan\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b31651d4-34d6-4f94-8ecc-337bb7ca95f4\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zmYE3tg26Qc\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea filmaren trailer ofiziala\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"8a298634-e401-4f05-9ff8-100803f41708\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"Filma ekuazioa itxi gabe amaitzen da. Bere ekarpen handiena borroka oposizio sinple batetik salbuespenak ere kudeatzen dakien sistema batera eramatea da.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4378,'7214841177f7629e2b931721b6896036e9a410eb9eead754a9cb7d0575f2788d','0d1ff1e484a93f7883558468754fb0bbe00b7269bfc23c39838b1dcc201a022a'),(5,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"28e753af-1122-4443-982f-5b6ac7c7368e\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo frente al desenlace de Matrix Revolutions\",\"title\":\"Matrix Revolutions: una tregua para romper el ciclo\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"7505b315-0535-411c-906e-f74d8cff3d57\",\"type\":\"section\",\"children\":[{\"id\":\"37d5f8e5-95d2-4470-8a9b-5c31de173dac\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"La defensa de Zion y el precio de la paz\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b8811e6d-55bb-4818-9558-9659e5b56280\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"a62f6fbd-3ef0-43a8-8c74-0bd8ddfec632\",\"children\":[{\"id\":\"6914b645-4271-4a52-a39a-b2d60d08b7c3\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Revolutions concentra la presión en dos frentes. Zion resiste el ataque de las máquinas y Neo avanza hacia una solución que exige reconocer un peligro compartido. La amenaza de Smith desborda la simulación y vuelve posible una negociación antes impensable.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"c2d53130-c18d-4c61-b1a1-2a9923bea220\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La batalla de Zion muestra la escala material de la guerra, mientras el duelo final reduce el conflicto a dos figuras bajo la lluvia. Ambas líneas hablan de persistencia, sacrificio y límites: vencer ya no significa imponer una eliminación total, sino detener una repetición destructiva.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"4273476c-aa93-45d0-a974-ffb4f7d0227e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"28b1d812-0b7e-4977-a040-2e9269e37aa6\",\"content\":[{\"type\":\"text\",\"text\":\"La defensa colectiva de Zion sostiene el coste humano del desenlace.\",\"marks\":[]}]},{\"id\":\"dc732257-d2d9-4739-8e0d-8b92404d9674\",\"content\":[{\"type\":\"text\",\"text\":\"Smith representa una expansión sin límite ni propósito.\",\"marks\":[]}]},{\"id\":\"15b6a58a-3abf-4acd-8c19-c6a9e89c780b\",\"content\":[{\"type\":\"text\",\"text\":\"La tregua abre un espacio político que antes no existía.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"f46241cd-349a-47fd-9f09-8dd3ba6a41e9\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Romper el ciclo requiere una decisión que ninguna de las partes podía imponer por separado.\",\"marks\":[]}],\"author\":\"Cuaderno Matrix\",\"source\":\"Lectura editorial de ejemplo\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"bd3c540d-1c9f-450d-8b54-ee4fdeef42a3\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo frente al desenlace de Matrix Revolutions\",\"title\":\"Matrix Revolutions: una tregua para romper el ciclo\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"6e52841e-d6e6-44a7-9de5-11c65e52164d\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zOh_pjoYTq8\",\"title\":\"Tráiler oficial de Matrix Revolutions: una tregua para romper el ciclo\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"336f62a7-f861-46f5-89c4-e3b6a0d8bb5f\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"El acuerdo final no resuelve todas las tensiones, pero permite imaginar convivencia, memoria y elección. La paz aparece como una construcción frágil que deberá mantenerse más allá de la victoria inmediata.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4406,'4c58f982446ab6e120267cfe9313715b4e3ce24c4c45be79072cf52804688994','23cfc26aaa240913e82d285e22c44e833b8fa024767a7a41167b126c5d59a035'),(6,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"82493402-0fc6-4dee-91ca-3fe451c9dba0\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo Matrix Revolutions filmeko amaieraren aurrean\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b2f7cd2a-4cf7-4016-b786-4c77356d6e7e\",\"type\":\"section\",\"children\":[{\"id\":\"bd95d17c-5bbc-422d-bfa3-d12e88955f8e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zionen defentsa eta bakearen prezioa\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ffacd657-395a-41ff-aa56-698a9f5fc2cc\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"f31e54d5-48a6-4361-af57-a5fdb4bb9d7c\",\"children\":[{\"id\":\"fc18d799-1072-47d4-962a-d672943f8e0e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Revolutionsek presioa bi frontetan biltzen du. Zionek makinen erasoa jasaten du, eta Neo arrisku partekatu bat aitortzea eskatzen duen irtenbiderantz doa. Smithen mehatxuak simulazioa gainditzen du, eta lehen pentsaezina zen negoziazioa ahalbidetzen du.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"d46cc7b6-bed5-4aa3-9fd5-783603e8e073\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Zioneko guduak gerraren eskala materiala erakusten du; azken dueluan, berriz, gatazka euripeko bi figuratara murrizten da. Bi lerroek iraunkortasuna, sakrifizioa eta mugak dituzte ardatz: irabaztea ez da erabateko ezabaketa inposatzea, errepikapen suntsitzailea geldiaraztea baizik.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b1931dbe-e2cc-4d61-8dba-2ca434d75c3e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"a9d4b0ec-92c1-4d50-8bcd-284ba4ba4c83\",\"content\":[{\"type\":\"text\",\"text\":\"Zionen defentsa kolektiboak amaieraren giza kostua erakusten du.\",\"marks\":[]}]},{\"id\":\"25faf6b7-42a3-4311-bcb5-7a4600694000\",\"content\":[{\"type\":\"text\",\"text\":\"Smithek mugarik eta helbururik gabeko hedapena irudikatzen du.\",\"marks\":[]}]},{\"id\":\"d08536ef-35a7-47dd-9d6d-cea2595751e4\",\"content\":[{\"type\":\"text\",\"text\":\"Su-etenak lehen ez zegoen espazio politikoa irekitzen du.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"8e4dba38-266d-4233-bdee-1f8d55e703c7\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Zikloa hausteko, aldeetako inork bere kabuz inposatu ezin zuen erabakia behar da.\",\"marks\":[]}],\"author\":\"Matrix koadernoa\",\"source\":\"Adibideko irakurketa editoriala\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"093b7721-f0ec-4818-a4cd-1493a8700128\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo Matrix Revolutions filmeko amaieraren aurrean\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ea0b8948-90d9-4648-8521-e3618d7b4554\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zOh_pjoYTq8\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena filmaren trailer ofiziala\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ce4d9d54-19b4-4c4d-82c3-14430c845888\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"Azken akordioak ez ditu tentsio guztiak konpontzen, baina bizikidetza, memoria eta hautua irudikatzeko aukera ematen du. Bakea garaipenetik harago mantendu beharreko eraikuntza hauskor gisa agertzen da.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4347,'f597b4ef429c46d9b842d14c65f83c5b6296cd0a8cdbd0004e0cb72fa4cea40e','d8d9c125412668037c35a1ec462464e4b7e2bf95a55a57c4bbbb565a282a639b'),(7,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"b8c6248c-6fce-47a6-b6b9-b176b8ec327a\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo y Trinity vuelven a encontrarse en Matrix Resurrections\",\"title\":\"Matrix Resurrections: recordar para volver a elegir\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"7303a2e5-0b94-43e6-a796-e464d4f9fcc1\",\"type\":\"section\",\"children\":[{\"id\":\"d3ee70e0-fb81-4fca-876c-fe2efc7336bb\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"La memoria como mapa de salida\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"9b9f113c-0b02-4d7d-a908-2956b89eb5ab\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"d183b18b-aac7-44d4-a948-430a711a6376\",\"children\":[{\"id\":\"d5dea3fa-ddbe-433c-8f24-96f4624b6091\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Resurrections regresa a Thomas Anderson dentro de una simulación que ha convertido su historia en producto cultural. El reconocimiento llega de forma fragmentaria: imágenes, sensaciones y encuentros que contradicen la explicación oficial de su propia vida.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"3b94d424-e8ea-4585-8920-f00a6b9c4f23\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La nueva Matrix no se sostiene solo mediante prohibiciones. El Analista administra deseo, miedo y proximidad para mantener a Neo y Trinity separados sin borrar por completo su vínculo. La película reflexiona así sobre nostalgia, repetición y autoría mientras reconstruye su lenguaje visual.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"e2238132-a0c2-4ee4-b9d6-820aa49782a6\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"a426464a-82a9-4a8d-8847-062f45470ac3\",\"content\":[{\"type\":\"text\",\"text\":\"Recordar permite distinguir experiencia, relato y manipulación.\",\"marks\":[]}]},{\"id\":\"7babb772-5866-4723-8e95-ea4055880fd1\",\"content\":[{\"type\":\"text\",\"text\":\"La conexión entre Neo y Trinity deja de ser secundaria.\",\"marks\":[]}]},{\"id\":\"648e05cc-32c1-42cb-91ab-2e92fe4d5dbc\",\"content\":[{\"type\":\"text\",\"text\":\"La nueva simulación explota emociones antes que reglas visibles.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"849ada6d-5590-4c1b-a407-265c62817ccb\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Volver no significa repetir exactamente el pasado, sino recuperar la capacidad de decidir qué hacer con él.\",\"marks\":[]}],\"author\":\"Cuaderno Matrix\",\"source\":\"Lectura editorial de ejemplo\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"9d46d73f-633d-4236-a472-42290322a6a9\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo y Trinity vuelven a encontrarse en Matrix Resurrections\",\"title\":\"Matrix Resurrections: recordar para volver a elegir\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"47f89423-8d30-443b-a02d-8c61bf322f8c\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"9ix7TUGVYIo\",\"title\":\"Tráiler oficial de Matrix Resurrections: recordar para volver a elegir\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ce96ba35-857f-4a1e-8f28-9d6010b235b1\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"El desenlace entrega la transformación a una relación compartida. Neo y Trinity recuperan margen de acción y proponen rehacer un espacio que hasta entonces había utilizado sus recuerdos para contenerlos.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4439,'a9a73269419592576b81359d59156c5b473cf9e2e88576850ea19bf80fcc1968','7340c186c8632bc36d124daa12f33d5147341bae6f49f9651836b1936de72b01'),(8,2,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"8960b9dc-0fee-4b78-9f86-6954073be544\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo eta Trinity berriro elkartzen Matrix Resurrections filmean\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"e95ec0e3-a0a3-4698-a12d-915d65387d01\",\"type\":\"section\",\"children\":[{\"id\":\"d091f339-e777-422a-8f89-fb06f5eb4be2\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Memoria irteerako mapa gisa\",\"marks\":[]}],\"preset\":\"accent-line\"}],\"presentation\":{\"width\":\"40\",\"align\":\"center\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"b6c8369b-783f-48ce-97c1-421fad16520a\",\"type\":\"article\",\"layout\":{\"preset\":\"1\",\"columns\":[{\"id\":\"aa65619e-8a4a-4312-a1e8-4b2d183bf655\",\"children\":[{\"id\":\"dafbe1ef-beec-4db1-9866-e284f0b355e5\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Resurrections Thomas Andersonengana itzultzen da, bere historia produktu kultural bihurtu duen simulazio baten barruan. Aitorpena zatika iristen da: bere bizitzaren azalpen ofiziala gezurtatzen duten irudi, sentsazio eta topaketen bidez.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"fe0729b1-54d2-4cc0-bd60-d566329523b7\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix berria ez da debekuetan soilik oinarritzen. Analistak desira, beldurra eta hurbiltasuna kudeatzen ditu Neo eta Trinity bereizita mantentzeko, haien lotura erabat ezabatu gabe. Filmak nostalgia, errepikapena eta egiletza aztertzen ditu, bere hizkuntza bisuala berreraikitzen duen bitartean.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"655dbd2b-faa2-4105-afbe-9df11b17a777\",\"type\":\"paragraph\",\"content\":[{\"type\":\"list\",\"ordered\":false,\"items\":[{\"id\":\"2e0cbaa6-518d-476f-b074-84c9bf9f0701\",\"content\":[{\"type\":\"text\",\"text\":\"Gogoratzeak esperientzia, kontakizuna eta manipulazioa bereizten laguntzen du.\",\"marks\":[]}]},{\"id\":\"96565030-209d-49bd-b12d-a237be2d9788\",\"content\":[{\"type\":\"text\",\"text\":\"Neo eta Trinityren arteko lotura ez da bigarren mailakoa.\",\"marks\":[]}]},{\"id\":\"7281056e-9b12-4b5a-8168-a850dbe3d8dd\",\"content\":[{\"type\":\"text\",\"text\":\"Simulazio berriak emozioak ustiatzen ditu ageriko arauak baino lehen.\",\"marks\":[]}]}],\"marker\":\"disc\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"af5eb74d-c665-462d-aa9e-fb0d1598fc28\",\"type\":\"paragraph\",\"content\":[{\"type\":\"quote\",\"content\":[{\"type\":\"text\",\"text\":\"Itzultzea ez da iragana berdin errepikatzea, harekin zer egin erabakitzeko gaitasuna berreskuratzea baizik.\",\"marks\":[]}],\"author\":\"Matrix koadernoa\",\"source\":\"Adibideko irakurketa editoriala\",\"preset\":\"accent\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"79ae5e9f-b7d9-4afe-bdb8-ccdb5050fa82\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo eta Trinity berriro elkartzen Matrix Resurrections filmean\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\",\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ae95f5f1-9c71-4b60-835c-f9db5214ca25\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"9ix7TUGVYIo\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko filmaren trailer ofiziala\",\"start_seconds\":0,\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}},{\"id\":\"ed257e3b-e5ac-4d19-8aef-4cd3055a5322\",\"type\":\"paragraph\",\"content\":[{\"type\":\"callout\",\"content\":[{\"type\":\"text\",\"text\":\"Amaierak eraldaketa partekatutako harreman baten esku uzten du. Neok eta Trinityk ekiteko tartea berreskuratzen dute, eta ordura arte haien oroitzapenak eusteko erabili zituen espazioa berreraikitzea proposatzen dute.\",\"marks\":[]}],\"tone\":\"info\"}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\",\"spacing_after\":\"m\"}}]}]},\"presentation\":{\"width\":\"40\",\"align\":\"center\"}}]}]}',4439,'73b36d939f53b482a4f843224d9cc3b0af8fbddead4d51f0b4d5834cda88a662','4933bc1e27fae844cc6fdd388e9c636d7518401108b79d8e5bde66d94a485c02');
/*!40000 ALTER TABLE `ls_blog_content_layout_revisions` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_content_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_content_media` (
  `document_id` bigint(20) unsigned NOT NULL,
  `block_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `media_asset_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `role` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`document_id`,`block_public_id`,`role`),
  KEY `idx_blog_content_media_asset` (`media_asset_public_id`),
  CONSTRAINT `ls_blog_f_cm_document` FOREIGN KEY (`document_id`) REFERENCES `ls_blog_content_docs` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_cm_block` CHECK (char_length(`block_public_id`) = 36),
  CONSTRAINT `ls_blog_c_cm_asset` CHECK (char_length(`media_asset_public_id`) = 36),
  CONSTRAINT `ls_blog_c_cm_role` CHECK (`role` in ('image','cover','poster'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_content_media` WRITE;
/*!40000 ALTER TABLE `ls_blog_content_media` DISABLE KEYS */;
INSERT INTO `ls_blog_content_media` VALUES (1,'377358f7-48e9-4c90-b7ce-dd8324d0fc13','ba5e0000-0000-4000-8000-000000000082','image','2026-09-24 03:12:14.932473'),(1,'cc396780-c99b-49db-b58f-b70e7b888368','ba5e0000-0000-4000-8000-000000000081','cover','2026-09-24 03:12:14.932473'),(2,'4d783ee7-24e0-46aa-9643-c7b6007a5107','ba5e0000-0000-4000-8000-000000000081','cover','2026-09-24 03:12:14.932473'),(2,'bcb97557-4b6a-461e-aac2-ddf77f4831d2','ba5e0000-0000-4000-8000-000000000082','image','2026-09-24 03:12:14.932473'),(3,'bc9ec40d-1ae6-49be-9475-d3832a93713a','ba5e0000-0000-4000-8000-000000000083','image','2026-09-24 03:12:14.984643'),(3,'d262854b-6b89-46da-afa0-86ac56a14432','ba5e0000-0000-4000-8000-000000000082','cover','2026-09-24 03:12:14.984643'),(4,'92ec43cb-271a-434a-bde7-54b557869096','ba5e0000-0000-4000-8000-000000000083','image','2026-09-24 03:12:14.984643'),(4,'d9c5877b-706f-4444-855d-832dc6223a99','ba5e0000-0000-4000-8000-000000000082','cover','2026-09-24 03:12:14.984643'),(5,'28e753af-1122-4443-982f-5b6ac7c7368e','ba5e0000-0000-4000-8000-000000000083','cover','2026-09-24 03:12:15.033255'),(5,'bd3c540d-1c9f-450d-8b54-ee4fdeef42a3','ba5e0000-0000-4000-8000-000000000084','image','2026-09-24 03:12:15.033255'),(6,'093b7721-f0ec-4818-a4cd-1493a8700128','ba5e0000-0000-4000-8000-000000000084','image','2026-09-24 03:12:15.033255'),(6,'82493402-0fc6-4dee-91ca-3fe451c9dba0','ba5e0000-0000-4000-8000-000000000083','cover','2026-09-24 03:12:15.033255'),(7,'9d46d73f-633d-4236-a472-42290322a6a9','ba5e0000-0000-4000-8000-000000000081','image','2026-09-24 03:12:15.074459'),(7,'b8c6248c-6fce-47a6-b6b9-b176b8ec327a','ba5e0000-0000-4000-8000-000000000084','cover','2026-09-24 03:12:15.074459'),(8,'79ae5e9f-b7d9-4afe-bdb8-ccdb5050fa82','ba5e0000-0000-4000-8000-000000000081','image','2026-09-24 03:12:15.074459'),(8,'8960b9dc-0fee-4b78-9f86-6954073be544','ba5e0000-0000-4000-8000-000000000084','cover','2026-09-24 03:12:15.074459');
/*!40000 ALTER TABLE `ls_blog_content_media` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_content_revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_content_revisions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `localization_id` bigint(20) unsigned NOT NULL,
  `revision_number` bigint(20) unsigned NOT NULL,
  `variant_lock_version` bigint(20) unsigned NOT NULL,
  `schema_version` smallint(5) unsigned NOT NULL DEFAULT 1,
  `template_key` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `document_json` longtext NOT NULL,
  `document_bytes` int(10) unsigned NOT NULL,
  `document_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `body_text_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `snapshot_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `h1` varchar(255) NOT NULL,
  `slug` varchar(190) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `seo_title` varchar(255) DEFAULT NULL,
  `meta_description` varchar(320) DEFAULT NULL,
  `excerpt` text DEFAULT NULL,
  `body_text` longtext NOT NULL,
  `created_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_blog_content_revisions_public` (`public_id`),
  UNIQUE KEY `uq_blog_content_revisions_number` (`localization_id`,`revision_number`),
  UNIQUE KEY `uq_blog_content_revisions_variant` (`localization_id`,`variant_lock_version`),
  KEY `idx_blog_content_revisions_time` (`created_at`),
  CONSTRAINT `ls_blog_f_cr_localization` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_cr_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_blog_c_cr_revision` CHECK (`revision_number` > 0),
  CONSTRAINT `ls_blog_c_cr_variant` CHECK (`variant_lock_version` > 0),
  CONSTRAINT `ls_blog_c_cr_schema` CHECK (`schema_version` = 1),
  CONSTRAINT `ls_blog_c_cr_template` CHECK (char_length(`template_key`) between 1 and 64 and `template_key` = lcase(`template_key`) and `template_key` = trim(`template_key`) and `template_key` regexp '^[a-z][a-z0-9_-]{0,63}$'),
  CONSTRAINT `ls_blog_c_cr_bytes` CHECK (`document_bytes` between 1 and 300000),
  CONSTRAINT `ls_blog_c_cr_doc_hash` CHECK (`document_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_cr_body_hash` CHECK (`body_text_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_cr_snap_hash` CHECK (`snapshot_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_cr_h1` CHECK (char_length(trim(`h1`)) > 0),
  CONSTRAINT `ls_blog_c_cr_slug` CHECK (`slug` is null or char_length(trim(`slug`)) > 0 and `slug` = lcase(`slug`) and `slug` = trim(`slug`)),
  CONSTRAINT `ls_blog_c_cr_created` CHECK (char_length(`created_by_user_public_id`) = 36)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_content_revisions` WRITE;
/*!40000 ALTER TABLE `ls_blog_content_revisions` DISABLE KEYS */;
INSERT INTO `ls_blog_content_revisions` VALUES (1,'53ea8f96-1c8a-415f-962a-39f6236d7eac',1,1,1,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"cc396780-c99b-49db-b58f-b70e7b888368\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo y la tripulación ante el universo digital de Matrix\",\"title\":\"Matrix: despertar frente a una realidad construida\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"9979969c-24dc-4864-982a-29dd9ec24bd8\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"El despertar de Neo cambia las reglas\",\"marks\":[]}]},{\"id\":\"ecb900b8-4811-4065-bce9-c83455e10f5a\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix presenta a Thomas Anderson como un programador atrapado entre una rutina reconocible y la intuición de que algo no encaja. La aparición de Trinity y Morpheus convierte esa sospecha en una elección concreta: seguir dentro de una realidad cómoda o mirar detrás de su arquitectura.\",\"marks\":[]}]},{\"id\":\"f550c5b3-d22b-41a9-bdb7-6487e5fd98f9\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La película combina ciencia ficción, acción y filosofía sin separar sus ideas de la puesta en escena. El código verde, los reflejos y los espacios repetidos hacen visible un sistema que parecía invisible. Neo no adquiere respuestas de inmediato; aprende a leer las reglas antes de intentar romperlas.\",\"marks\":[]}]},{\"id\":\"336babe6-5cb5-4802-b459-8d7338aebe7d\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La identidad como una construcción que puede cuestionarse.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La tecnología como entorno, lenguaje y mecanismo de control.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La elección personal como motor del relato y de sus consecuencias.\",\"marks\":[]}]},{\"id\":\"2d32ff92-c1d8-4016-887b-fbbd22d378d1\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"La pregunta central no es solo qué es Matrix, sino qué hacemos después de reconocer el sistema.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Cuaderno Matrix, Lectura editorial de ejemplo\",\"marks\":[\"em\"]}]},{\"id\":\"377358f7-48e9-4c90-b7ce-dd8324d0fc13\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo y la tripulación ante el universo digital de Matrix\",\"title\":\"Matrix: despertar frente a una realidad construida\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"d61593d3-07f3-4bda-beae-910ad3cd3939\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"tGgCqGm_6Hs\",\"title\":\"Tráiler oficial de Matrix: despertar frente a una realidad construida\",\"start_seconds\":0},{\"id\":\"8d6ecf0c-0246-432e-961f-077f92b07652\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"Su final funciona como una promesa de transformación: comprender la simulación permite imaginar otras posibilidades, pero también obliga a asumir el coste de actuar.\",\"marks\":[]}]}]}',3111,'cdce402acc5f1d16bd9e5d1e8c4aabe00ffe7ee175dd39427574c61ed82b5733','d24b675cd14a753d619c5f7349417c4458b5001760ff77fb0fa135226f2c60ec','7a3857bbf1f438b525ec60de919c9dc47184729d143c2efbbb47369827b493e8','Matrix: despertar frente a una realidad construida','matrix-despertar-realidad-construida','Matrix: el despertar de Neo y la realidad construida','Un recorrido por Matrix, el despertar de Neo, la elección de la píldora roja y las ideas visuales que convirtieron la película en un referente.','Neo descubre que su vida cotidiana es una simulación y debe decidir si acepta una verdad incómoda o permanece dentro del sistema.','Imagen de demostración para el artículo.\n\nEl despertar de Neo cambia las reglas\n\nMatrix presenta a Thomas Anderson como un programador atrapado entre una rutina reconocible y la intuición de que algo no encaja. La aparición de Trinity y Morpheus convierte esa sospecha en una elección concreta: seguir dentro de una realidad cómoda o mirar detrás de su arquitectura.\n\nLa película combina ciencia ficción, acción y filosofía sin separar sus ideas de la puesta en escena. El código verde, los reflejos y los espacios repetidos hacen visible un sistema que parecía invisible. Neo no adquiere respuestas de inmediato; aprende a leer las reglas antes de intentar romperlas.\n\n- La identidad como una construcción que puede cuestionarse.\n- La tecnología como entorno, lenguaje y mecanismo de control.\n- La elección personal como motor del relato y de sus consecuencias.\n\nLa pregunta central no es solo qué es Matrix, sino qué hacemos después de reconocer el sistema.\nCuaderno Matrix, Lectura editorial de ejemplo\n\nSegundo recurso visual del recorrido.\n\nTráiler oficial de Matrix: despertar frente a una realidad construida\n\nSu final funciona como una promesa de transformación: comprender la simulación permite imaginar otras posibilidades, pero también obliga a asumir el coste de actuar.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.932473'),(2,'21d1764f-1331-4652-9eff-78f87bb12d89',2,1,1,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"4d783ee7-24e0-46aa-9643-c7b6007a5107\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo eta tripulazioa Matrixeko unibertso digitalaren aurrean\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"a8de8971-27ce-4984-a52c-82d43d93d0fc\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Neoren esnatzeak arauak aldatzen ditu\",\"marks\":[]}]},{\"id\":\"2699f2ac-930e-42e6-b378-85eadfe60e6f\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrixek Thomas Anderson aurkezten du: errutina ezagun baten eta zerbait ondo ez dagoelako susmoaren artean harrapatutako programatzailea. Trinity eta Morpheus agertzean, susmo hori hautu zehatz bihurtzen da: errealitate erosoaren barruan jarraitu edo haren arkitekturaren atzean begiratu.\",\"marks\":[]}]},{\"id\":\"1f8ef740-ea0b-46ca-8d8a-5b05e29b50c8\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Filmak zientzia-fikzioa, akzioa eta filosofia uztartzen ditu, ideiak eszenaratzetik bereizi gabe. Kode berdeak, islek eta espazio errepikatuek ikusezina zirudien sistema agerian uzten dute. Neok ez ditu erantzunak berehala jasotzen; arauak irakurtzen ikasten du hausten saiatu aurretik.\",\"marks\":[]}]},{\"id\":\"9099c68e-54c3-4ad2-affb-ad1d5e9af1e2\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Nortasuna zalantzan jar daitekeen eraikuntza gisa.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Teknologia ingurune, hizkuntza eta kontrol-mekanismo gisa.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Hautu pertsonala kontakizunaren eta ondorioen motor gisa.\",\"marks\":[]}]},{\"id\":\"7b5b3892-2a8e-4f37-a539-e666142c22ae\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Galdera nagusia ez da soilik Matrix zer den, sistema ezagutu ondoren zer egiten dugun baizik.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Matrix koadernoa, Adibideko irakurketa editoriala\",\"marks\":[\"em\"]}]},{\"id\":\"bcb97557-4b6a-461e-aac2-ddf77f4831d2\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo eta tripulazioa Matrixeko unibertso digitalaren aurrean\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"872cb24b-4529-41eb-8b53-a3d6193c8afd\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"tGgCqGm_6Hs\",\"title\":\"Matrix: eraikitako errealitate baten aurrean esnatzea filmaren trailer ofiziala\",\"start_seconds\":0},{\"id\":\"e08f2f64-e071-4570-9735-bfab1697b874\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"Amaierak eraldaketaren promesa dakar: simulazioa ulertzeak beste aukera batzuk irudikatzeko bidea ematen du, baina jardutearen kostua onartzera ere behartzen du.\",\"marks\":[]}]}]}',3068,'987991d9da06252e560995517df7ea17bb6ccd5006c60b0a0e077b0d0b0d3697','ad9be3ebdeec310dd6ba33979103ef6a77de454b3a872ab0d1818982f7b1f960','9e1e52e363972588cc2f94fab97fafc9351c6c52fd2a31e88657e1f07f82fd24','Matrix: eraikitako errealitate baten aurrean esnatzea','matrix-eraikitako-errealitatearen-aurrean-esnatzea','Matrix: Neoren esnatzea eta eraikitako errealitatea','Matrix filmari buruzko ibilbidea: Neoren esnatzea, pilula gorriaren hautua eta filma erreferente bihurtu zuten ideia bisualak.','Neok eguneroko bizitza simulazio bat dela deskubritzen du, eta egia deserosoa onartu edo sistemaren barruan jarraitu erabaki behar du.','Artikulurako adibide-irudia.\n\nNeoren esnatzeak arauak aldatzen ditu\n\nMatrixek Thomas Anderson aurkezten du: errutina ezagun baten eta zerbait ondo ez dagoelako susmoaren artean harrapatutako programatzailea. Trinity eta Morpheus agertzean, susmo hori hautu zehatz bihurtzen da: errealitate erosoaren barruan jarraitu edo haren arkitekturaren atzean begiratu.\n\nFilmak zientzia-fikzioa, akzioa eta filosofia uztartzen ditu, ideiak eszenaratzetik bereizi gabe. Kode berdeak, islek eta espazio errepikatuek ikusezina zirudien sistema agerian uzten dute. Neok ez ditu erantzunak berehala jasotzen; arauak irakurtzen ikasten du hausten saiatu aurretik.\n\n- Nortasuna zalantzan jar daitekeen eraikuntza gisa.\n- Teknologia ingurune, hizkuntza eta kontrol-mekanismo gisa.\n- Hautu pertsonala kontakizunaren eta ondorioen motor gisa.\n\nGaldera nagusia ez da soilik Matrix zer den, sistema ezagutu ondoren zer egiten dugun baizik.\nMatrix koadernoa, Adibideko irakurketa editoriala\n\nIbilbideko bigarren baliabide bisuala.\n\nMatrix: eraikitako errealitate baten aurrean esnatzea filmaren trailer ofiziala\n\nAmaierak eraldaketaren promesa dakar: simulazioa ulertzeak beste aukera batzuk irudikatzeko bidea ematen du, baina jardutearen kostua onartzera ere behartzen du.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.932473'),(3,'73521a8a-e1ca-4a69-931d-e1023eff66af',3,1,1,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"d262854b-6b89-46da-afa0-86ac56a14432\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo y Morpheus durante el conflicto de Matrix Reloaded\",\"title\":\"Matrix Reloaded: elegir dentro de un sistema previsto\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"41b48743-0cc0-4ff2-8de3-2bf7aea0cf7f\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zion, causalidad y una elección imposible\",\"marks\":[]}]},{\"id\":\"6f201ae3-0b21-4600-bdc4-8dc875b3ff63\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Reloaded abre el relato hacia Zion y convierte la resistencia en una comunidad con responsabilidades, desacuerdos y tiempo limitado. Neo ya no busca únicamente comprender sus capacidades: debe decidir cómo utilizarlas cuando cada camino parece formar parte de un diseño anterior.\",\"marks\":[]}]},{\"id\":\"b1cf3ece-b339-4749-a116-c9886a84e1f9\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"El encuentro con el Arquitecto reformula la profecía y presenta la anomalía como un componente previsto del sistema. La persecución de la autopista y la búsqueda del Cerrajero traducen ese conflicto abstracto en movimiento, urgencia y decisiones encadenadas.\",\"marks\":[]}]},{\"id\":\"335877fd-ff67-46b0-92d4-a5baef2fff31\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La causalidad organiza tanto el diálogo como la acción.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Zion aporta una escala humana al conflicto tecnológico.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"El amor de Neo por Trinity introduce una variable difícil de reducir a cálculo.\",\"marks\":[]}]},{\"id\":\"46d73dcc-6695-4795-8fda-0a7b0bf9d5ba\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Elegir cobra sentido cuando la decisión altera un recorrido que parecía completamente calculado.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Cuaderno Matrix, Lectura editorial de ejemplo\",\"marks\":[\"em\"]}]},{\"id\":\"bc9ec40d-1ae6-49be-9475-d3832a93713a\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo y Morpheus durante el conflicto de Matrix Reloaded\",\"title\":\"Matrix Reloaded: elegir dentro de un sistema previsto\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"9d2d2f4f-7fc4-4256-8abd-befaaa7b8a55\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zmYE3tg26Qc\",\"title\":\"Tráiler oficial de Matrix Reloaded: elegir dentro de un sistema previsto\",\"start_seconds\":0},{\"id\":\"61a720f5-378a-49f0-a306-ae2beacf5aca\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"La película termina sin cerrar la ecuación. Su mayor aportación es desplazar la lucha desde una oposición simple hacia un sistema que también sabe administrar sus propias excepciones.\",\"marks\":[]}]}]}',3103,'11ac86068299ed42ae19f86b00ac77db5b692b5f081141881d25d46b15ae3af3','0136cff5ae0a34d8ab371495a646cee463c87ea7fab38b3ed36a3a77c402e417','041c6f80e0ca68e744869dda720968bab0a99b908e50b358a2bfea146912a2c7','Matrix Reloaded: elegir dentro de un sistema previsto','matrix-reloaded-elegir-sistema-previsto','Matrix Reloaded: elección, causalidad y arquitectura','Matrix Reloaded amplía Zion y plantea si una elección sigue siendo libre cuando el sistema ya ha previsto todas sus alternativas.','La segunda película amplía el conflicto y enfrenta a Neo con una arquitectura de control capaz de anticipar incluso la rebeldía.','Imagen de demostración para el artículo.\n\nZion, causalidad y una elección imposible\n\nMatrix Reloaded abre el relato hacia Zion y convierte la resistencia en una comunidad con responsabilidades, desacuerdos y tiempo limitado. Neo ya no busca únicamente comprender sus capacidades: debe decidir cómo utilizarlas cuando cada camino parece formar parte de un diseño anterior.\n\nEl encuentro con el Arquitecto reformula la profecía y presenta la anomalía como un componente previsto del sistema. La persecución de la autopista y la búsqueda del Cerrajero traducen ese conflicto abstracto en movimiento, urgencia y decisiones encadenadas.\n\n- La causalidad organiza tanto el diálogo como la acción.\n- Zion aporta una escala humana al conflicto tecnológico.\n- El amor de Neo por Trinity introduce una variable difícil de reducir a cálculo.\n\nElegir cobra sentido cuando la decisión altera un recorrido que parecía completamente calculado.\nCuaderno Matrix, Lectura editorial de ejemplo\n\nSegundo recurso visual del recorrido.\n\nTráiler oficial de Matrix Reloaded: elegir dentro de un sistema previsto\n\nLa película termina sin cerrar la ecuación. Su mayor aportación es desplazar la lucha desde una oposición simple hacia un sistema que también sabe administrar sus propias excepciones.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.984643'),(4,'8d77ad45-ca06-48f5-bb93-8ebad1a76718',4,1,1,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"d9c5877b-706f-4444-855d-832dc6223a99\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000082\",\"alt\":\"Neo eta Morpheus Matrix Reloaded filmeko gatazkan\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"f6ee6f9b-040a-4f8c-8191-f9731d7ecf39\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zion, kausalitatea eta ezinezko hautua\",\"marks\":[]}]},{\"id\":\"687d7122-1cc1-4cef-9709-42ab504549c3\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Reloadedek kontakizuna Zionerantz zabaltzen du, eta erresistentzia erantzukizunak, desadostasunak eta denbora mugatua dituen komunitate bihurtzen du. Neok ez du bere gaitasunak ulertu nahi soilik: nola erabili erabaki behar du, bide bakoitza aurreko diseinu baten parte dela dirudienean.\",\"marks\":[]}]},{\"id\":\"6636568f-111a-49e4-a7f0-2b35d48db682\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Arkitektoarekin izandako topaketak profezia berrinterpretatzen du, eta anomalia sistemak aurreikusitako osagai gisa aurkezten du. Autobideko jazarpenak eta Giltzariaren bilaketak gatazka abstraktu hori mugimendu, presa eta kateatutako erabaki bihurtzen dute.\",\"marks\":[]}]},{\"id\":\"fd995a8d-e235-45e0-8f87-e855b7f3a7bc\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Kausalitateak elkarrizketa eta akzioa antolatzen ditu.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Zionek giza eskala ematen dio gatazka teknologikoari.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Neok Trinityrekiko duen maitasunak kalkulura murrizten zaila den aldagaia sartzen du.\",\"marks\":[]}]},{\"id\":\"df633e3f-e4a3-4c12-a1c1-c7db6f7d13f3\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Hautuak zentzua hartzen du erabakiak erabat kalkulatuta zirudien ibilbidea aldatzen duenean.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Matrix koadernoa, Adibideko irakurketa editoriala\",\"marks\":[\"em\"]}]},{\"id\":\"92ec43cb-271a-434a-bde7-54b557869096\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo eta Morpheus Matrix Reloaded filmeko gatazkan\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"b31651d4-34d6-4f94-8ecc-337bb7ca95f4\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zmYE3tg26Qc\",\"title\":\"Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea filmaren trailer ofiziala\",\"start_seconds\":0},{\"id\":\"8a298634-e401-4f05-9ff8-100803f41708\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"Filma ekuazioa itxi gabe amaitzen da. Bere ekarpen handiena borroka oposizio sinple batetik salbuespenak ere kudeatzen dakien sistema batera eramatea da.\",\"marks\":[]}]}]}',3065,'d9c6d87f35a8e5374c0dfb670d38794fe201e9cf22069ead3401d402a70a4266','e038264f73490b9e183e70b10d441178ab0ad8ed56a4138a70905a33f28d99b5','2822936978dc193585e16660b4f0465b5de9395571aa6592f0119c78392507bd','Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea','matrix-reloaded-aurreikusitako-sisteman-hautatzea','Matrix Reloaded: hautua, kausalitatea eta arkitektura','Matrix Reloadedek Zion zabaltzen du eta hautua askea ote den planteatzen du sistemak aukera guztiak aurreikusi dituenean.','Bigarren filmak gatazka zabaltzen du, eta matxinada bera ere aurreikusteko gai den kontrol-arkitekturaren aurrean jartzen du Neo.','Artikulurako adibide-irudia.\n\nZion, kausalitatea eta ezinezko hautua\n\nMatrix Reloadedek kontakizuna Zionerantz zabaltzen du, eta erresistentzia erantzukizunak, desadostasunak eta denbora mugatua dituen komunitate bihurtzen du. Neok ez du bere gaitasunak ulertu nahi soilik: nola erabili erabaki behar du, bide bakoitza aurreko diseinu baten parte dela dirudienean.\n\nArkitektoarekin izandako topaketak profezia berrinterpretatzen du, eta anomalia sistemak aurreikusitako osagai gisa aurkezten du. Autobideko jazarpenak eta Giltzariaren bilaketak gatazka abstraktu hori mugimendu, presa eta kateatutako erabaki bihurtzen dute.\n\n- Kausalitateak elkarrizketa eta akzioa antolatzen ditu.\n- Zionek giza eskala ematen dio gatazka teknologikoari.\n- Neok Trinityrekiko duen maitasunak kalkulura murrizten zaila den aldagaia sartzen du.\n\nHautuak zentzua hartzen du erabakiak erabat kalkulatuta zirudien ibilbidea aldatzen duenean.\nMatrix koadernoa, Adibideko irakurketa editoriala\n\nIbilbideko bigarren baliabide bisuala.\n\nMatrix Reloaded: aurreikusitako sistemaren barruan hautatzea filmaren trailer ofiziala\n\nFilma ekuazioa itxi gabe amaitzen da. Bere ekarpen handiena borroka oposizio sinple batetik salbuespenak ere kudeatzen dakien sistema batera eramatea da.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.984643'),(5,'1697210e-bc54-4ca2-b9e0-72acde6e8cc9',5,1,1,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"28e753af-1122-4443-982f-5b6ac7c7368e\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo frente al desenlace de Matrix Revolutions\",\"title\":\"Matrix Revolutions: una tregua para romper el ciclo\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"37d5f8e5-95d2-4470-8a9b-5c31de173dac\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"La defensa de Zion y el precio de la paz\",\"marks\":[]}]},{\"id\":\"6914b645-4271-4a52-a39a-b2d60d08b7c3\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Revolutions concentra la presión en dos frentes. Zion resiste el ataque de las máquinas y Neo avanza hacia una solución que exige reconocer un peligro compartido. La amenaza de Smith desborda la simulación y vuelve posible una negociación antes impensable.\",\"marks\":[]}]},{\"id\":\"c2d53130-c18d-4c61-b1a1-2a9923bea220\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La batalla de Zion muestra la escala material de la guerra, mientras el duelo final reduce el conflicto a dos figuras bajo la lluvia. Ambas líneas hablan de persistencia, sacrificio y límites: vencer ya no significa imponer una eliminación total, sino detener una repetición destructiva.\",\"marks\":[]}]},{\"id\":\"4273476c-aa93-45d0-a974-ffb4f7d0227e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La defensa colectiva de Zion sostiene el coste humano del desenlace.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Smith representa una expansión sin límite ni propósito.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La tregua abre un espacio político que antes no existía.\",\"marks\":[]}]},{\"id\":\"f46241cd-349a-47fd-9f09-8dd3ba6a41e9\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Romper el ciclo requiere una decisión que ninguna de las partes podía imponer por separado.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Cuaderno Matrix, Lectura editorial de ejemplo\",\"marks\":[\"em\"]}]},{\"id\":\"bd3c540d-1c9f-450d-8b54-ee4fdeef42a3\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo frente al desenlace de Matrix Revolutions\",\"title\":\"Matrix Revolutions: una tregua para romper el ciclo\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"6e52841e-d6e6-44a7-9de5-11c65e52164d\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zOh_pjoYTq8\",\"title\":\"Tráiler oficial de Matrix Revolutions: una tregua para romper el ciclo\",\"start_seconds\":0},{\"id\":\"336f62a7-f861-46f5-89c4-e3b6a0d8bb5f\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"El acuerdo final no resuelve todas las tensiones, pero permite imaginar convivencia, memoria y elección. La paz aparece como una construcción frágil que deberá mantenerse más allá de la victoria inmediata.\",\"marks\":[]}]}]}',3093,'c57b00da267ba3abf4ec512d6594db7e7e95296de171047de62e468d689bea64','39302b2600a27b5285acf47815fd271a00c65f008f27809c8e4590461dff77b6','5e95b263588514da7a0007cbe769f2c7f36ea504ffc4b3856e704856a3a5dc17','Matrix Revolutions: una tregua para romper el ciclo','matrix-revolutions-tregua-romper-ciclo','Matrix Revolutions: la tregua que rompe el ciclo','Matrix Revolutions culmina la guerra por Zion y convierte el enfrentamiento entre Neo y Smith en una negociación para romper el ciclo.','La guerra alcanza Zion mientras Neo busca una salida que no depende de destruir por completo a una de las partes.','Imagen de demostración para el artículo.\n\nLa defensa de Zion y el precio de la paz\n\nMatrix Revolutions concentra la presión en dos frentes. Zion resiste el ataque de las máquinas y Neo avanza hacia una solución que exige reconocer un peligro compartido. La amenaza de Smith desborda la simulación y vuelve posible una negociación antes impensable.\n\nLa batalla de Zion muestra la escala material de la guerra, mientras el duelo final reduce el conflicto a dos figuras bajo la lluvia. Ambas líneas hablan de persistencia, sacrificio y límites: vencer ya no significa imponer una eliminación total, sino detener una repetición destructiva.\n\n- La defensa colectiva de Zion sostiene el coste humano del desenlace.\n- Smith representa una expansión sin límite ni propósito.\n- La tregua abre un espacio político que antes no existía.\n\nRomper el ciclo requiere una decisión que ninguna de las partes podía imponer por separado.\nCuaderno Matrix, Lectura editorial de ejemplo\n\nSegundo recurso visual del recorrido.\n\nTráiler oficial de Matrix Revolutions: una tregua para romper el ciclo\n\nEl acuerdo final no resuelve todas las tensiones, pero permite imaginar convivencia, memoria y elección. La paz aparece como una construcción frágil que deberá mantenerse más allá de la victoria inmediata.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.033255'),(6,'9915c7f9-e249-43d6-84f5-1986748ca56a',6,1,1,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"82493402-0fc6-4dee-91ca-3fe451c9dba0\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000083\",\"alt\":\"Neo Matrix Revolutions filmeko amaieraren aurrean\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"bd95d17c-5bbc-422d-bfa3-d12e88955f8e\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Zionen defentsa eta bakearen prezioa\",\"marks\":[]}]},{\"id\":\"fc18d799-1072-47d4-962a-d672943f8e0e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Revolutionsek presioa bi frontetan biltzen du. Zionek makinen erasoa jasaten du, eta Neo arrisku partekatu bat aitortzea eskatzen duen irtenbiderantz doa. Smithen mehatxuak simulazioa gainditzen du, eta lehen pentsaezina zen negoziazioa ahalbidetzen du.\",\"marks\":[]}]},{\"id\":\"d46cc7b6-bed5-4aa3-9fd5-783603e8e073\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Zioneko guduak gerraren eskala materiala erakusten du; azken dueluan, berriz, gatazka euripeko bi figuratara murrizten da. Bi lerroek iraunkortasuna, sakrifizioa eta mugak dituzte ardatz: irabaztea ez da erabateko ezabaketa inposatzea, errepikapen suntsitzailea geldiaraztea baizik.\",\"marks\":[]}]},{\"id\":\"b1931dbe-e2cc-4d61-8dba-2ca434d75c3e\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Zionen defentsa kolektiboak amaieraren giza kostua erakusten du.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Smithek mugarik eta helbururik gabeko hedapena irudikatzen du.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Su-etenak lehen ez zegoen espazio politikoa irekitzen du.\",\"marks\":[]}]},{\"id\":\"8e4dba38-266d-4233-bdee-1f8d55e703c7\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Zikloa hausteko, aldeetako inork bere kabuz inposatu ezin zuen erabakia behar da.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Matrix koadernoa, Adibideko irakurketa editoriala\",\"marks\":[\"em\"]}]},{\"id\":\"093b7721-f0ec-4818-a4cd-1493a8700128\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo Matrix Revolutions filmeko amaieraren aurrean\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"ea0b8948-90d9-4648-8521-e3618d7b4554\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"zOh_pjoYTq8\",\"title\":\"Matrix Revolutions: zikloa hausteko su-etena filmaren trailer ofiziala\",\"start_seconds\":0},{\"id\":\"ce4d9d54-19b4-4c4d-82c3-14430c845888\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"Azken akordioak ez ditu tentsio guztiak konpontzen, baina bizikidetza, memoria eta hautua irudikatzeko aukera ematen du. Bakea garaipenetik harago mantendu beharreko eraikuntza hauskor gisa agertzen da.\",\"marks\":[]}]}]}',3034,'310db2d726826cc2791ec569d12eebe4e7ae39d757b555214ed13c8babca0121','0c1dc564e25bbbe049fdd4560e4388e40d627412c3b4361a4e35176728d31337','a75af5cd44b95f7f82ef683af2f0850a3bed97c005750654e92434288eaf526d','Matrix Revolutions: zikloa hausteko su-etena','matrix-revolutions-zikloa-hausteko-su-etena','Matrix Revolutions: zikloa hausten duen su-etena','Matrix Revolutionsek Zionen aldeko gerra amaitzen du, eta Neo eta Smithen arteko gatazka zikloa hausteko negoziazio bihurtzen du.','Gerra Zionera iristen da, eta Neok aldeetako bat erabat suntsitzean oinarritzen ez den irtenbidea bilatzen du.','Artikulurako adibide-irudia.\n\nZionen defentsa eta bakearen prezioa\n\nMatrix Revolutionsek presioa bi frontetan biltzen du. Zionek makinen erasoa jasaten du, eta Neo arrisku partekatu bat aitortzea eskatzen duen irtenbiderantz doa. Smithen mehatxuak simulazioa gainditzen du, eta lehen pentsaezina zen negoziazioa ahalbidetzen du.\n\nZioneko guduak gerraren eskala materiala erakusten du; azken dueluan, berriz, gatazka euripeko bi figuratara murrizten da. Bi lerroek iraunkortasuna, sakrifizioa eta mugak dituzte ardatz: irabaztea ez da erabateko ezabaketa inposatzea, errepikapen suntsitzailea geldiaraztea baizik.\n\n- Zionen defentsa kolektiboak amaieraren giza kostua erakusten du.\n- Smithek mugarik eta helbururik gabeko hedapena irudikatzen du.\n- Su-etenak lehen ez zegoen espazio politikoa irekitzen du.\n\nZikloa hausteko, aldeetako inork bere kabuz inposatu ezin zuen erabakia behar da.\nMatrix koadernoa, Adibideko irakurketa editoriala\n\nIbilbideko bigarren baliabide bisuala.\n\nMatrix Revolutions: zikloa hausteko su-etena filmaren trailer ofiziala\n\nAzken akordioak ez ditu tentsio guztiak konpontzen, baina bizikidetza, memoria eta hautua irudikatzeko aukera ematen du. Bakea garaipenetik harago mantendu beharreko eraikuntza hauskor gisa agertzen da.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.033255'),(7,'929dccb2-d58e-4766-a967-7ad0d4654b2f',7,1,1,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"b8c6248c-6fce-47a6-b6b9-b176b8ec327a\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo y Trinity vuelven a encontrarse en Matrix Resurrections\",\"title\":\"Matrix Resurrections: recordar para volver a elegir\",\"caption\":\"Imagen de demostración para el artículo.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"d3ee70e0-fb81-4fca-876c-fe2efc7336bb\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"La memoria como mapa de salida\",\"marks\":[]}]},{\"id\":\"d5dea3fa-ddbe-433c-8f24-96f4624b6091\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Resurrections regresa a Thomas Anderson dentro de una simulación que ha convertido su historia en producto cultural. El reconocimiento llega de forma fragmentaria: imágenes, sensaciones y encuentros que contradicen la explicación oficial de su propia vida.\",\"marks\":[]}]},{\"id\":\"3b94d424-e8ea-4585-8920-f00a6b9c4f23\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"La nueva Matrix no se sostiene solo mediante prohibiciones. El Analista administra deseo, miedo y proximidad para mantener a Neo y Trinity separados sin borrar por completo su vínculo. La película reflexiona así sobre nostalgia, repetición y autoría mientras reconstruye su lenguaje visual.\",\"marks\":[]}]},{\"id\":\"e2238132-a0c2-4ee4-b9d6-820aa49782a6\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Recordar permite distinguir experiencia, relato y manipulación.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La conexión entre Neo y Trinity deja de ser secundaria.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"La nueva simulación explota emociones antes que reglas visibles.\",\"marks\":[]}]},{\"id\":\"849ada6d-5590-4c1b-a407-265c62817ccb\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Volver no significa repetir exactamente el pasado, sino recuperar la capacidad de decidir qué hacer con él.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Cuaderno Matrix, Lectura editorial de ejemplo\",\"marks\":[\"em\"]}]},{\"id\":\"9d46d73f-633d-4236-a472-42290322a6a9\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo y Trinity vuelven a encontrarse en Matrix Resurrections\",\"title\":\"Matrix Resurrections: recordar para volver a elegir\",\"caption\":\"Segundo recurso visual del recorrido.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"47f89423-8d30-443b-a02d-8c61bf322f8c\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"9ix7TUGVYIo\",\"title\":\"Tráiler oficial de Matrix Resurrections: recordar para volver a elegir\",\"start_seconds\":0},{\"id\":\"ce96ba35-857f-4a1e-8f28-9d6010b235b1\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"El desenlace entrega la transformación a una relación compartida. Neo y Trinity recuperan margen de acción y proponen rehacer un espacio que hasta entonces había utilizado sus recuerdos para contenerlos.\",\"marks\":[]}]}]}',3126,'ad03e277378edb0bc460935bf8f9acab886ce4546960cfcea7b4016ba5f95c07','5b7477c64fef2c983cbbb3944d42f5e2c6b19b995decfd95b8be41651cdaca3d','32da976a58090b0b4be73ebbcd5cecf5434640a3023db0e677e6ef08b4def217','Matrix Resurrections: recordar para volver a elegir','matrix-resurrections-recordar-volver-elegir','Matrix Resurrections: memoria, vínculo y nueva elección','Matrix Resurrections revisa la memoria de Neo y Trinity, el poder de su vínculo y una simulación que convierte la nostalgia en herramienta de control.','Neo vive dentro de una nueva versión de Matrix donde sus recuerdos parecen ficción hasta que una nueva búsqueda vuelve a ponerlos en movimiento.','Imagen de demostración para el artículo.\n\nLa memoria como mapa de salida\n\nMatrix Resurrections regresa a Thomas Anderson dentro de una simulación que ha convertido su historia en producto cultural. El reconocimiento llega de forma fragmentaria: imágenes, sensaciones y encuentros que contradicen la explicación oficial de su propia vida.\n\nLa nueva Matrix no se sostiene solo mediante prohibiciones. El Analista administra deseo, miedo y proximidad para mantener a Neo y Trinity separados sin borrar por completo su vínculo. La película reflexiona así sobre nostalgia, repetición y autoría mientras reconstruye su lenguaje visual.\n\n- Recordar permite distinguir experiencia, relato y manipulación.\n- La conexión entre Neo y Trinity deja de ser secundaria.\n- La nueva simulación explota emociones antes que reglas visibles.\n\nVolver no significa repetir exactamente el pasado, sino recuperar la capacidad de decidir qué hacer con él.\nCuaderno Matrix, Lectura editorial de ejemplo\n\nSegundo recurso visual del recorrido.\n\nTráiler oficial de Matrix Resurrections: recordar para volver a elegir\n\nEl desenlace entrega la transformación a una relación compartida. Neo y Trinity recuperan margen de acción y proponen rehacer un espacio que hasta entonces había utilizado sus recuerdos para contenerlos.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.074459'),(8,'e1e48423-818b-4d74-b9c9-4ea4a65ddc57',8,1,1,1,'article-cover-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-cover-01\",\"blocks\":[{\"id\":\"8960b9dc-0fee-4b78-9f86-6954073be544\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000084\",\"alt\":\"Neo eta Trinity berriro elkartzen Matrix Resurrections filmean\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko\",\"caption\":\"Artikulurako adibide-irudia.\",\"decorative\":false,\"display\":\"cover\"},{\"id\":\"d091f339-e777-422a-8f89-fb06f5eb4be2\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Memoria irteerako mapa gisa\",\"marks\":[]}]},{\"id\":\"dafbe1ef-beec-4db1-9866-e284f0b355e5\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix Resurrections Thomas Andersonengana itzultzen da, bere historia produktu kultural bihurtu duen simulazio baten barruan. Aitorpena zatika iristen da: bere bizitzaren azalpen ofiziala gezurtatzen duten irudi, sentsazio eta topaketen bidez.\",\"marks\":[]}]},{\"id\":\"fe0729b1-54d2-4cc0-bd60-d566329523b7\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Matrix berria ez da debekuetan soilik oinarritzen. Analistak desira, beldurra eta hurbiltasuna kudeatzen ditu Neo eta Trinity bereizita mantentzeko, haien lotura erabat ezabatu gabe. Filmak nostalgia, errepikapena eta egiletza aztertzen ditu, bere hizkuntza bisuala berreraikitzen duen bitartean.\",\"marks\":[]}]},{\"id\":\"655dbd2b-faa2-4105-afbe-9df11b17a777\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Gogoratzeak esperientzia, kontakizuna eta manipulazioa bereizten laguntzen du.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Neo eta Trinityren arteko lotura ez da bigarren mailakoa.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"- \",\"marks\":[]},{\"type\":\"text\",\"text\":\"Simulazio berriak emozioak ustiatzen ditu ageriko arauak baino lehen.\",\"marks\":[]}]},{\"id\":\"af5eb74d-c665-462d-aa9e-fb0d1598fc28\",\"type\":\"callout\",\"tone\":\"neutral\",\"content\":[{\"type\":\"text\",\"text\":\"Itzultzea ez da iragana berdin errepikatzea, harekin zer egin erabakitzeko gaitasuna berreskuratzea baizik.\",\"marks\":[]},{\"type\":\"break\"},{\"type\":\"text\",\"text\":\"Matrix koadernoa, Adibideko irakurketa editoriala\",\"marks\":[\"em\"]}]},{\"id\":\"79ae5e9f-b7d9-4afe-bdb8-ccdb5050fa82\",\"type\":\"image\",\"media_asset_public_id\":\"ba5e0000-0000-4000-8000-000000000081\",\"alt\":\"Neo eta Trinity berriro elkartzen Matrix Resurrections filmean\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko\",\"caption\":\"Ibilbideko bigarren baliabide bisuala.\",\"decorative\":false,\"display\":\"content\"},{\"id\":\"ae95f5f1-9c71-4b60-835c-f9db5214ca25\",\"type\":\"video\",\"provider\":\"youtube\",\"video_id\":\"9ix7TUGVYIo\",\"title\":\"Matrix Resurrections: gogoratu berriro hautatzeko filmaren trailer ofiziala\",\"start_seconds\":0},{\"id\":\"ed257e3b-e5ac-4d19-8aef-4cd3055a5322\",\"type\":\"callout\",\"tone\":\"info\",\"content\":[{\"type\":\"text\",\"text\":\"Amaierak eraldaketa partekatutako harreman baten esku uzten du. Neok eta Trinityk ekiteko tartea berreskuratzen dute, eta ordura arte haien oroitzapenak eusteko erabili zituen espazioa berreraikitzea proposatzen dute.\",\"marks\":[]}]}]}',3126,'f204bf1a394daed96fb8edf0c4cd1b99ba6d83f7c6a7b69b84e98721a982fae7','db52fd2ffd32445e84d36c3c1684271d52fb989c2fbb0df876ba833025441c2c','9f856cd886891a741ebaba7c30e1a3abedaf903a4456c4a5606bba9d93407de9','Matrix Resurrections: gogoratu berriro hautatzeko','matrix-resurrections-gogoratu-berriro-hautatzeko','Matrix Resurrections: memoria, lotura eta hautu berria','Matrix Resurrectionsek Neo eta Trinityren memoria, haien loturaren indarra eta nostalgia kontrol-tresna bihurtzen duen simulazioa berrikusten ditu.','Neo Matrixen bertsio berri batean bizi da, bere oroitzapenak fikzioa direla dirudien arte; bilaketa berri batek berriro mugiarazten ditu.','Artikulurako adibide-irudia.\n\nMemoria irteerako mapa gisa\n\nMatrix Resurrections Thomas Andersonengana itzultzen da, bere historia produktu kultural bihurtu duen simulazio baten barruan. Aitorpena zatika iristen da: bere bizitzaren azalpen ofiziala gezurtatzen duten irudi, sentsazio eta topaketen bidez.\n\nMatrix berria ez da debekuetan soilik oinarritzen. Analistak desira, beldurra eta hurbiltasuna kudeatzen ditu Neo eta Trinity bereizita mantentzeko, haien lotura erabat ezabatu gabe. Filmak nostalgia, errepikapena eta egiletza aztertzen ditu, bere hizkuntza bisuala berreraikitzen duen bitartean.\n\n- Gogoratzeak esperientzia, kontakizuna eta manipulazioa bereizten laguntzen du.\n- Neo eta Trinityren arteko lotura ez da bigarren mailakoa.\n- Simulazio berriak emozioak ustiatzen ditu ageriko arauak baino lehen.\n\nItzultzea ez da iragana berdin errepikatzea, harekin zer egin erabakitzeko gaitasuna berreskuratzea baizik.\nMatrix koadernoa, Adibideko irakurketa editoriala\n\nIbilbideko bigarren baliabide bisuala.\n\nMatrix Resurrections: gogoratu berriro hautatzeko filmaren trailer ofiziala\n\nAmaierak eraldaketa partekatutako harreman baten esku uzten du. Neok eta Trinityk ekiteko tartea berreskuratzen dute, eta ordura arte haien oroitzapenak eusteko erabili zituen espazioa berreraikitzea proposatzen dute.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.074459');
/*!40000 ALTER TABLE `ls_blog_content_revisions` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_copy_operations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_copy_operations` (
  `request_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `payload_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `actor_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `operation` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `source_post_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `source_locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `destination_locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `expected_lock_version` bigint(20) unsigned NOT NULL,
  `result_post_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `result_locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `completed_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`request_public_id`),
  CONSTRAINT `ls_blog_c_co_request` CHECK (`request_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_co_payload` CHECK (`payload_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_co_actor` CHECK (char_length(`actor_public_id`) = 36),
  CONSTRAINT `ls_blog_c_co_operation` CHECK (`operation` in ('duplicate_post','add_locale')),
  CONSTRAINT `ls_blog_c_co_source` CHECK (char_length(`source_post_public_id`) = 36),
  CONSTRAINT `ls_blog_c_co_locales` CHECK (char_length(`source_locale`) between 2 and 16 and char_length(`destination_locale`) between 2 and 16),
  CONSTRAINT `ls_blog_c_co_version` CHECK (`expected_lock_version` > 0),
  CONSTRAINT `ls_blog_c_co_result` CHECK (`result_post_public_id` is null and `result_locale` is null and `completed_at` is null or `result_post_public_id` is not null and `result_locale` = `destination_locale` and `completed_at` is not null and `completed_at` >= `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_copy_operations` WRITE;
/*!40000 ALTER TABLE `ls_blog_copy_operations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_copy_operations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_editor_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_editor_preferences` (
  `scope_key` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `schema_version` smallint(5) unsigned NOT NULL DEFAULT 1,
  `preferences_json` longtext NOT NULL,
  `preferences_bytes` smallint(5) unsigned NOT NULL,
  `preferences_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `lock_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  `updated_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`scope_key`),
  CONSTRAINT `ls_blog_c_ep_scope` CHECK (`scope_key` = 'global'),
  CONSTRAINT `ls_blog_c_ep_schema` CHECK (`schema_version` = 1),
  CONSTRAINT `ls_blog_c_ep_bytes` CHECK (`preferences_bytes` between 1 and 4096),
  CONSTRAINT `ls_blog_c_ep_hash` CHECK (`preferences_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_ep_lock` CHECK (`lock_version` > 0),
  CONSTRAINT `ls_blog_c_ep_actor` CHECK (`updated_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_ep_time` CHECK (`updated_at` >= `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_editor_preferences` WRITE;
/*!40000 ALTER TABLE `ls_blog_editor_preferences` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_editor_preferences` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_editorial_workspaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_editorial_workspaces` (
  `localization_id` bigint(20) unsigned NOT NULL,
  `draft_revision_id` bigint(20) unsigned DEFAULT NULL,
  `base_publication_version` bigint(20) unsigned NOT NULL DEFAULT 0,
  `created_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `updated_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`localization_id`),
  UNIQUE KEY `ls_blog_ux_ew_revision` (`draft_revision_id`),
  CONSTRAINT `ls_blog_f_ew_localization` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_f_ew_revision` FOREIGN KEY (`draft_revision_id`) REFERENCES `ls_blog_content_revisions` (`id`),
  CONSTRAINT `ls_blog_c_ew_created_actor` CHECK (`created_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_ew_updated_actor` CHECK (`updated_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_ew_time` CHECK (`updated_at` >= `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_editorial_workspaces` WRITE;
/*!40000 ALTER TABLE `ls_blog_editorial_workspaces` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_editorial_workspaces` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_localization_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_localization_tags` (
  `localization_id` bigint(20) unsigned NOT NULL,
  `tag_id` bigint(20) unsigned NOT NULL,
  `assigned_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`localization_id`,`tag_id`),
  KEY `ls_blog_ix_blt_tag` (`tag_id`,`localization_id`),
  CONSTRAINT `ls_blog_f_blt_localization` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_f_blt_tag` FOREIGN KEY (`tag_id`) REFERENCES `ls_blog_tags` (`id`),
  CONSTRAINT `ls_blog_c_blt_actor` CHECK (`assigned_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_localization_tags` WRITE;
/*!40000 ALTER TABLE `ls_blog_localization_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_localization_tags` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_post_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_post_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `post_id` bigint(20) unsigned NOT NULL,
  `category_id` bigint(20) unsigned NOT NULL,
  `assigned_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_blog_post_category_public` (`public_id`),
  UNIQUE KEY `uq_blog_post_category_pair` (`post_id`,`category_id`),
  KEY `idx_blog_post_category_category` (`category_id`,`post_id`),
  CONSTRAINT `ls_blog_f_pc_category` FOREIGN KEY (`category_id`) REFERENCES `ls_blog_categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_f_pc_post` FOREIGN KEY (`post_id`) REFERENCES `ls_blog_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_pc_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_blog_c_pc_actor` CHECK (char_length(`assigned_by_user_public_id`) = 36)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_post_categories` WRITE;
/*!40000 ALTER TABLE `ls_blog_post_categories` DISABLE KEYS */;
INSERT INTO `ls_blog_post_categories` VALUES (11,'727a8a38-73ab-457a-8133-7bd25c5084ca',1,4,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 09:03:00.000000','2026-09-24 09:03:00.000000'),(12,'0e40ecc7-2339-4180-aae6-153f1b333dcf',2,4,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 09:03:00.000000','2026-09-24 09:03:00.000000'),(13,'36d78793-cbee-486a-96bb-8d30ae609d21',3,4,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 09:03:00.000000','2026-09-24 09:03:00.000000'),(14,'39d8c125-f9b2-4775-aa9b-673b14797cd4',4,4,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 09:03:00.000000','2026-09-24 09:03:00.000000');
/*!40000 ALTER TABLE `ls_blog_post_categories` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_post_localizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_post_localizations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `post_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `slug` varchar(190) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `h1` varchar(255) NOT NULL,
  `seo_title` varchar(255) DEFAULT NULL,
  `meta_description` varchar(320) DEFAULT NULL,
  `excerpt` text DEFAULT NULL,
  `body_text` longtext NOT NULL,
  `status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'draft',
  `published_at` datetime(6) DEFAULT NULL,
  `lock_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  `created_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `updated_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_blog_local_public` (`public_id`),
  UNIQUE KEY `uq_blog_post_locale` (`post_id`,`locale`),
  UNIQUE KEY `uq_blog_locale_slug` (`locale`,`slug`),
  KEY `idx_blog_local_state` (`status`,`published_at`),
  CONSTRAINT `ls_blog_f_pl_post` FOREIGN KEY (`post_id`) REFERENCES `ls_blog_posts` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_pl_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_blog_c_pl_locale` CHECK (char_length(`locale`) between 2 and 16 and `locale` = lcase(`locale`) and `locale` = trim(`locale`)),
  CONSTRAINT `ls_blog_c_pl_slug` CHECK (`slug` is null or char_length(trim(`slug`)) > 0 and `slug` = lcase(`slug`) and `slug` = trim(`slug`)),
  CONSTRAINT `ls_blog_c_pl_h1` CHECK (char_length(trim(`h1`)) > 0),
  CONSTRAINT `ls_blog_c_pl_status` CHECK (`status` in ('draft','published')),
  CONSTRAINT `ls_blog_c_pl_publish` CHECK (`status` = 'draft' and `published_at` is null or `status` = 'published' and `published_at` is not null and `slug` is not null and `seo_title` is not null and char_length(trim(`seo_title`)) > 0 and `meta_description` is not null and char_length(trim(`meta_description`)) > 0 and `excerpt` is not null and char_length(trim(`excerpt`)) > 0 and char_length(trim(`body_text`)) > 0),
  CONSTRAINT `ls_blog_c_pl_lock` CHECK (`lock_version` > 0),
  CONSTRAINT `ls_blog_c_pl_created` CHECK (char_length(`created_by_user_public_id`) = 36),
  CONSTRAINT `ls_blog_c_pl_updated` CHECK (char_length(`updated_by_user_public_id`) = 36)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_post_localizations` WRITE;
/*!40000 ALTER TABLE `ls_blog_post_localizations` DISABLE KEYS */;
INSERT INTO `ls_blog_post_localizations` VALUES (1,'c22dca95-1e18-45dd-b727-c0b710436bc8',1,'es','matrix-despertar-realidad-construida','Matrix: despertar frente a una realidad construida','Matrix: el despertar de Neo y la realidad construida','Un recorrido por Matrix, el despertar de Neo, la elección de la píldora roja y las ideas visuales que convirtieron la película en un referente.','Neo descubre que su vida cotidiana es una simulación y debe decidir si acepta una verdad incómoda o permanece dentro del sistema.','Imagen de demostración para el artículo.\n\nEl despertar de Neo cambia las reglas\n\nMatrix presenta a Thomas Anderson como un programador atrapado entre una rutina reconocible y la intuición de que algo no encaja. La aparición de Trinity y Morpheus convierte esa sospecha en una elección concreta: seguir dentro de una realidad cómoda o mirar detrás de su arquitectura.\n\nLa película combina ciencia ficción, acción y filosofía sin separar sus ideas de la puesta en escena. El código verde, los reflejos y los espacios repetidos hacen visible un sistema que parecía invisible. Neo no adquiere respuestas de inmediato; aprende a leer las reglas antes de intentar romperlas.\n\n- La identidad como una construcción que puede cuestionarse.\n- La tecnología como entorno, lenguaje y mecanismo de control.\n- La elección personal como motor del relato y de sus consecuencias.\n\nLa pregunta central no es solo qué es Matrix, sino qué hacemos después de reconocer el sistema.\nCuaderno Matrix, Lectura editorial de ejemplo\n\nSegundo recurso visual del recorrido.\n\nTráiler oficial de Matrix: despertar frente a una realidad construida\n\nSu final funciona como una promesa de transformación: comprender la simulación permite imaginar otras posibilidades, pero también obliga a asumir el coste de actuar.','published','2026-09-24 03:12:14.932473',2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.932473','2026-09-24 03:12:14.932473'),(2,'12bc4abb-d7de-49fe-8d8b-8d23c16342ec',1,'eu','matrix-eraikitako-errealitatearen-aurrean-esnatzea','Matrix: eraikitako errealitate baten aurrean esnatzea','Matrix: Neoren esnatzea eta eraikitako errealitatea','Matrix filmari buruzko ibilbidea: Neoren esnatzea, pilula gorriaren hautua eta filma erreferente bihurtu zuten ideia bisualak.','Neok eguneroko bizitza simulazio bat dela deskubritzen du, eta egia deserosoa onartu edo sistemaren barruan jarraitu erabaki behar du.','Artikulurako adibide-irudia.\n\nNeoren esnatzeak arauak aldatzen ditu\n\nMatrixek Thomas Anderson aurkezten du: errutina ezagun baten eta zerbait ondo ez dagoelako susmoaren artean harrapatutako programatzailea. Trinity eta Morpheus agertzean, susmo hori hautu zehatz bihurtzen da: errealitate erosoaren barruan jarraitu edo haren arkitekturaren atzean begiratu.\n\nFilmak zientzia-fikzioa, akzioa eta filosofia uztartzen ditu, ideiak eszenaratzetik bereizi gabe. Kode berdeak, islek eta espazio errepikatuek ikusezina zirudien sistema agerian uzten dute. Neok ez ditu erantzunak berehala jasotzen; arauak irakurtzen ikasten du hausten saiatu aurretik.\n\n- Nortasuna zalantzan jar daitekeen eraikuntza gisa.\n- Teknologia ingurune, hizkuntza eta kontrol-mekanismo gisa.\n- Hautu pertsonala kontakizunaren eta ondorioen motor gisa.\n\nGaldera nagusia ez da soilik Matrix zer den, sistema ezagutu ondoren zer egiten dugun baizik.\nMatrix koadernoa, Adibideko irakurketa editoriala\n\nIbilbideko bigarren baliabide bisuala.\n\nMatrix: eraikitako errealitate baten aurrean esnatzea filmaren trailer ofiziala\n\nAmaierak eraldaketaren promesa dakar: simulazioa ulertzeak beste aukera batzuk irudikatzeko bidea ematen du, baina jardutearen kostua onartzera ere behartzen du.','published','2026-09-24 03:12:14.932473',2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.932473','2026-09-24 03:12:14.932473'),(3,'cb7818f2-633e-48c8-b8fd-b2e464641001',2,'es','matrix-reloaded-elegir-sistema-previsto','Matrix Reloaded: elegir dentro de un sistema previsto','Matrix Reloaded: elección, causalidad y arquitectura','Matrix Reloaded amplía Zion y plantea si una elección sigue siendo libre cuando el sistema ya ha previsto todas sus alternativas.','La segunda película amplía el conflicto y enfrenta a Neo con una arquitectura de control capaz de anticipar incluso la rebeldía.','Imagen de demostración para el artículo.\n\nZion, causalidad y una elección imposible\n\nMatrix Reloaded abre el relato hacia Zion y convierte la resistencia en una comunidad con responsabilidades, desacuerdos y tiempo limitado. Neo ya no busca únicamente comprender sus capacidades: debe decidir cómo utilizarlas cuando cada camino parece formar parte de un diseño anterior.\n\nEl encuentro con el Arquitecto reformula la profecía y presenta la anomalía como un componente previsto del sistema. La persecución de la autopista y la búsqueda del Cerrajero traducen ese conflicto abstracto en movimiento, urgencia y decisiones encadenadas.\n\n- La causalidad organiza tanto el diálogo como la acción.\n- Zion aporta una escala humana al conflicto tecnológico.\n- El amor de Neo por Trinity introduce una variable difícil de reducir a cálculo.\n\nElegir cobra sentido cuando la decisión altera un recorrido que parecía completamente calculado.\nCuaderno Matrix, Lectura editorial de ejemplo\n\nSegundo recurso visual del recorrido.\n\nTráiler oficial de Matrix Reloaded: elegir dentro de un sistema previsto\n\nLa película termina sin cerrar la ecuación. Su mayor aportación es desplazar la lucha desde una oposición simple hacia un sistema que también sabe administrar sus propias excepciones.','published','2026-09-24 03:12:14.984643',2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.984643','2026-09-24 03:12:14.984643'),(4,'7fa003ab-2899-4b18-b61d-a4da49b97659',2,'eu','matrix-reloaded-aurreikusitako-sisteman-hautatzea','Matrix Reloaded: aurreikusitako sistemaren barruan hautatzea','Matrix Reloaded: hautua, kausalitatea eta arkitektura','Matrix Reloadedek Zion zabaltzen du eta hautua askea ote den planteatzen du sistemak aukera guztiak aurreikusi dituenean.','Bigarren filmak gatazka zabaltzen du, eta matxinada bera ere aurreikusteko gai den kontrol-arkitekturaren aurrean jartzen du Neo.','Artikulurako adibide-irudia.\n\nZion, kausalitatea eta ezinezko hautua\n\nMatrix Reloadedek kontakizuna Zionerantz zabaltzen du, eta erresistentzia erantzukizunak, desadostasunak eta denbora mugatua dituen komunitate bihurtzen du. Neok ez du bere gaitasunak ulertu nahi soilik: nola erabili erabaki behar du, bide bakoitza aurreko diseinu baten parte dela dirudienean.\n\nArkitektoarekin izandako topaketak profezia berrinterpretatzen du, eta anomalia sistemak aurreikusitako osagai gisa aurkezten du. Autobideko jazarpenak eta Giltzariaren bilaketak gatazka abstraktu hori mugimendu, presa eta kateatutako erabaki bihurtzen dute.\n\n- Kausalitateak elkarrizketa eta akzioa antolatzen ditu.\n- Zionek giza eskala ematen dio gatazka teknologikoari.\n- Neok Trinityrekiko duen maitasunak kalkulura murrizten zaila den aldagaia sartzen du.\n\nHautuak zentzua hartzen du erabakiak erabat kalkulatuta zirudien ibilbidea aldatzen duenean.\nMatrix koadernoa, Adibideko irakurketa editoriala\n\nIbilbideko bigarren baliabide bisuala.\n\nMatrix Reloaded: aurreikusitako sistemaren barruan hautatzea filmaren trailer ofiziala\n\nFilma ekuazioa itxi gabe amaitzen da. Bere ekarpen handiena borroka oposizio sinple batetik salbuespenak ere kudeatzen dakien sistema batera eramatea da.','published','2026-09-24 03:12:14.984643',2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.984643','2026-09-24 03:12:14.984643'),(5,'5a1f757c-7e2f-4870-818f-5cb5f09858d0',3,'es','matrix-revolutions-tregua-romper-ciclo','Matrix Revolutions: una tregua para romper el ciclo','Matrix Revolutions: la tregua que rompe el ciclo','Matrix Revolutions culmina la guerra por Zion y convierte el enfrentamiento entre Neo y Smith en una negociación para romper el ciclo.','La guerra alcanza Zion mientras Neo busca una salida que no depende de destruir por completo a una de las partes.','Imagen de demostración para el artículo.\n\nLa defensa de Zion y el precio de la paz\n\nMatrix Revolutions concentra la presión en dos frentes. Zion resiste el ataque de las máquinas y Neo avanza hacia una solución que exige reconocer un peligro compartido. La amenaza de Smith desborda la simulación y vuelve posible una negociación antes impensable.\n\nLa batalla de Zion muestra la escala material de la guerra, mientras el duelo final reduce el conflicto a dos figuras bajo la lluvia. Ambas líneas hablan de persistencia, sacrificio y límites: vencer ya no significa imponer una eliminación total, sino detener una repetición destructiva.\n\n- La defensa colectiva de Zion sostiene el coste humano del desenlace.\n- Smith representa una expansión sin límite ni propósito.\n- La tregua abre un espacio político que antes no existía.\n\nRomper el ciclo requiere una decisión que ninguna de las partes podía imponer por separado.\nCuaderno Matrix, Lectura editorial de ejemplo\n\nSegundo recurso visual del recorrido.\n\nTráiler oficial de Matrix Revolutions: una tregua para romper el ciclo\n\nEl acuerdo final no resuelve todas las tensiones, pero permite imaginar convivencia, memoria y elección. La paz aparece como una construcción frágil que deberá mantenerse más allá de la victoria inmediata.','published','2026-09-24 03:12:15.033255',2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.033255','2026-09-24 03:12:15.033255'),(6,'22d731ec-091d-4650-aefc-5b26eaad9b56',3,'eu','matrix-revolutions-zikloa-hausteko-su-etena','Matrix Revolutions: zikloa hausteko su-etena','Matrix Revolutions: zikloa hausten duen su-etena','Matrix Revolutionsek Zionen aldeko gerra amaitzen du, eta Neo eta Smithen arteko gatazka zikloa hausteko negoziazio bihurtzen du.','Gerra Zionera iristen da, eta Neok aldeetako bat erabat suntsitzean oinarritzen ez den irtenbidea bilatzen du.','Artikulurako adibide-irudia.\n\nZionen defentsa eta bakearen prezioa\n\nMatrix Revolutionsek presioa bi frontetan biltzen du. Zionek makinen erasoa jasaten du, eta Neo arrisku partekatu bat aitortzea eskatzen duen irtenbiderantz doa. Smithen mehatxuak simulazioa gainditzen du, eta lehen pentsaezina zen negoziazioa ahalbidetzen du.\n\nZioneko guduak gerraren eskala materiala erakusten du; azken dueluan, berriz, gatazka euripeko bi figuratara murrizten da. Bi lerroek iraunkortasuna, sakrifizioa eta mugak dituzte ardatz: irabaztea ez da erabateko ezabaketa inposatzea, errepikapen suntsitzailea geldiaraztea baizik.\n\n- Zionen defentsa kolektiboak amaieraren giza kostua erakusten du.\n- Smithek mugarik eta helbururik gabeko hedapena irudikatzen du.\n- Su-etenak lehen ez zegoen espazio politikoa irekitzen du.\n\nZikloa hausteko, aldeetako inork bere kabuz inposatu ezin zuen erabakia behar da.\nMatrix koadernoa, Adibideko irakurketa editoriala\n\nIbilbideko bigarren baliabide bisuala.\n\nMatrix Revolutions: zikloa hausteko su-etena filmaren trailer ofiziala\n\nAzken akordioak ez ditu tentsio guztiak konpontzen, baina bizikidetza, memoria eta hautua irudikatzeko aukera ematen du. Bakea garaipenetik harago mantendu beharreko eraikuntza hauskor gisa agertzen da.','published','2026-09-24 03:12:15.033255',2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.033255','2026-09-24 03:12:15.033255'),(7,'64ff88d3-a4be-451c-9a37-7443407d994a',4,'es','matrix-resurrections-recordar-volver-elegir','Matrix Resurrections: recordar para volver a elegir','Matrix Resurrections: memoria, vínculo y nueva elección','Matrix Resurrections revisa la memoria de Neo y Trinity, el poder de su vínculo y una simulación que convierte la nostalgia en herramienta de control.','Neo vive dentro de una nueva versión de Matrix donde sus recuerdos parecen ficción hasta que una nueva búsqueda vuelve a ponerlos en movimiento.','Imagen de demostración para el artículo.\n\nLa memoria como mapa de salida\n\nMatrix Resurrections regresa a Thomas Anderson dentro de una simulación que ha convertido su historia en producto cultural. El reconocimiento llega de forma fragmentaria: imágenes, sensaciones y encuentros que contradicen la explicación oficial de su propia vida.\n\nLa nueva Matrix no se sostiene solo mediante prohibiciones. El Analista administra deseo, miedo y proximidad para mantener a Neo y Trinity separados sin borrar por completo su vínculo. La película reflexiona así sobre nostalgia, repetición y autoría mientras reconstruye su lenguaje visual.\n\n- Recordar permite distinguir experiencia, relato y manipulación.\n- La conexión entre Neo y Trinity deja de ser secundaria.\n- La nueva simulación explota emociones antes que reglas visibles.\n\nVolver no significa repetir exactamente el pasado, sino recuperar la capacidad de decidir qué hacer con él.\nCuaderno Matrix, Lectura editorial de ejemplo\n\nSegundo recurso visual del recorrido.\n\nTráiler oficial de Matrix Resurrections: recordar para volver a elegir\n\nEl desenlace entrega la transformación a una relación compartida. Neo y Trinity recuperan margen de acción y proponen rehacer un espacio que hasta entonces había utilizado sus recuerdos para contenerlos.','published','2026-09-24 03:12:15.074459',2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.074459','2026-09-24 03:12:15.074459'),(8,'926bcb3e-9fd2-4d19-8310-9ef06c996777',4,'eu','matrix-resurrections-gogoratu-berriro-hautatzeko','Matrix Resurrections: gogoratu berriro hautatzeko','Matrix Resurrections: memoria, lotura eta hautu berria','Matrix Resurrectionsek Neo eta Trinityren memoria, haien loturaren indarra eta nostalgia kontrol-tresna bihurtzen duen simulazioa berrikusten ditu.','Neo Matrixen bertsio berri batean bizi da, bere oroitzapenak fikzioa direla dirudien arte; bilaketa berri batek berriro mugiarazten ditu.','Artikulurako adibide-irudia.\n\nMemoria irteerako mapa gisa\n\nMatrix Resurrections Thomas Andersonengana itzultzen da, bere historia produktu kultural bihurtu duen simulazio baten barruan. Aitorpena zatika iristen da: bere bizitzaren azalpen ofiziala gezurtatzen duten irudi, sentsazio eta topaketen bidez.\n\nMatrix berria ez da debekuetan soilik oinarritzen. Analistak desira, beldurra eta hurbiltasuna kudeatzen ditu Neo eta Trinity bereizita mantentzeko, haien lotura erabat ezabatu gabe. Filmak nostalgia, errepikapena eta egiletza aztertzen ditu, bere hizkuntza bisuala berreraikitzen duen bitartean.\n\n- Gogoratzeak esperientzia, kontakizuna eta manipulazioa bereizten laguntzen du.\n- Neo eta Trinityren arteko lotura ez da bigarren mailakoa.\n- Simulazio berriak emozioak ustiatzen ditu ageriko arauak baino lehen.\n\nItzultzea ez da iragana berdin errepikatzea, harekin zer egin erabakitzeko gaitasuna berreskuratzea baizik.\nMatrix koadernoa, Adibideko irakurketa editoriala\n\nIbilbideko bigarren baliabide bisuala.\n\nMatrix Resurrections: gogoratu berriro hautatzeko filmaren trailer ofiziala\n\nAmaierak eraldaketa partekatutako harreman baten esku uzten du. Neok eta Trinityk ekiteko tartea berreskuratzen dute, eta ordura arte haien oroitzapenak eusteko erabili zituen espazioa berreraikitzea proposatzen dute.','published','2026-09-24 03:12:15.074459',2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.074459','2026-09-24 03:12:15.074459');
/*!40000 ALTER TABLE `ls_blog_post_localizations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_post_tombstones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_post_tombstones` (
  `post_localization_id` bigint(20) unsigned NOT NULL,
  `trashed_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `trashed_at` datetime(6) NOT NULL,
  PRIMARY KEY (`post_localization_id`),
  KEY `idx_blog_post_tombstone_time` (`trashed_at`,`post_localization_id`),
  CONSTRAINT `ls_blog_f_pt_localization` FOREIGN KEY (`post_localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_pt_actor` CHECK (char_length(`trashed_by_user_public_id`) = 36)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_post_tombstones` WRITE;
/*!40000 ALTER TABLE `ls_blog_post_tombstones` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_post_tombstones` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_posts` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_blog_posts_public` (`public_id`),
  KEY `idx_blog_posts_author` (`created_by_user_public_id`),
  CONSTRAINT `ls_blog_c_po_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_blog_c_po_author` CHECK (char_length(`created_by_user_public_id`) = 36)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_posts` WRITE;
/*!40000 ALTER TABLE `ls_blog_posts` DISABLE KEYS */;
INSERT INTO `ls_blog_posts` VALUES (1,'ef89bcb2-c6e7-4e87-b0ae-7816bf92bad4','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.932473','2026-09-24 03:12:14.932473'),(2,'3e51d2f0-b6c2-45fd-9768-87a0004bb208','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.984643','2026-09-24 03:12:14.984643'),(3,'43aabe85-0e26-48bb-be5c-d5fa1fe80aaa','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.033255','2026-09-24 03:12:15.033255'),(4,'437a353d-da5c-4556-ac95-83c65b00ff8b','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.074459','2026-09-24 03:12:15.074459');
/*!40000 ALTER TABLE `ls_blog_posts` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_publication_heads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_publication_heads` (
  `localization_id` bigint(20) unsigned NOT NULL,
  `revision_id` bigint(20) unsigned NOT NULL,
  `publication_version` bigint(20) unsigned NOT NULL,
  `published_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `published_at` datetime(6) NOT NULL,
  PRIMARY KEY (`localization_id`),
  UNIQUE KEY `ls_blog_ux_ph_revision` (`revision_id`),
  CONSTRAINT `ls_blog_f_ph_localization` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_f_ph_revision` FOREIGN KEY (`revision_id`) REFERENCES `ls_blog_content_revisions` (`id`),
  CONSTRAINT `ls_blog_c_ph_version` CHECK (`publication_version` > 0),
  CONSTRAINT `ls_blog_c_ph_actor` CHECK (`published_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_publication_heads` WRITE;
/*!40000 ALTER TABLE `ls_blog_publication_heads` DISABLE KEYS */;
INSERT INTO `ls_blog_publication_heads` VALUES (1,1,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.932473'),(2,2,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.932473'),(3,3,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.984643'),(4,4,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:14.984643'),(5,5,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.033255'),(6,6,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.033255'),(7,7,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.074459'),(8,8,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-24 03:12:15.074459');
/*!40000 ALTER TABLE `ls_blog_publication_heads` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_revision_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_revision_media` (
  `revision_id` bigint(20) unsigned NOT NULL,
  `block_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `media_asset_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `role` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`revision_id`,`block_public_id`,`role`),
  KEY `idx_blog_revision_media_asset` (`media_asset_public_id`),
  CONSTRAINT `ls_blog_f_rm_revision` FOREIGN KEY (`revision_id`) REFERENCES `ls_blog_content_revisions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_rm_block` CHECK (char_length(`block_public_id`) = 36),
  CONSTRAINT `ls_blog_c_rm_asset` CHECK (char_length(`media_asset_public_id`) = 36),
  CONSTRAINT `ls_blog_c_rm_role` CHECK (`role` in ('image','cover','poster'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_revision_media` WRITE;
/*!40000 ALTER TABLE `ls_blog_revision_media` DISABLE KEYS */;
INSERT INTO `ls_blog_revision_media` VALUES (1,'377358f7-48e9-4c90-b7ce-dd8324d0fc13','ba5e0000-0000-4000-8000-000000000082','image','2026-09-24 03:12:14.932473'),(1,'cc396780-c99b-49db-b58f-b70e7b888368','ba5e0000-0000-4000-8000-000000000081','cover','2026-09-24 03:12:14.932473'),(2,'4d783ee7-24e0-46aa-9643-c7b6007a5107','ba5e0000-0000-4000-8000-000000000081','cover','2026-09-24 03:12:14.932473'),(2,'bcb97557-4b6a-461e-aac2-ddf77f4831d2','ba5e0000-0000-4000-8000-000000000082','image','2026-09-24 03:12:14.932473'),(3,'bc9ec40d-1ae6-49be-9475-d3832a93713a','ba5e0000-0000-4000-8000-000000000083','image','2026-09-24 03:12:14.984643'),(3,'d262854b-6b89-46da-afa0-86ac56a14432','ba5e0000-0000-4000-8000-000000000082','cover','2026-09-24 03:12:14.984643'),(4,'92ec43cb-271a-434a-bde7-54b557869096','ba5e0000-0000-4000-8000-000000000083','image','2026-09-24 03:12:14.984643'),(4,'d9c5877b-706f-4444-855d-832dc6223a99','ba5e0000-0000-4000-8000-000000000082','cover','2026-09-24 03:12:14.984643'),(5,'28e753af-1122-4443-982f-5b6ac7c7368e','ba5e0000-0000-4000-8000-000000000083','cover','2026-09-24 03:12:15.033255'),(5,'bd3c540d-1c9f-450d-8b54-ee4fdeef42a3','ba5e0000-0000-4000-8000-000000000084','image','2026-09-24 03:12:15.033255'),(6,'093b7721-f0ec-4818-a4cd-1493a8700128','ba5e0000-0000-4000-8000-000000000084','image','2026-09-24 03:12:15.033255'),(6,'82493402-0fc6-4dee-91ca-3fe451c9dba0','ba5e0000-0000-4000-8000-000000000083','cover','2026-09-24 03:12:15.033255'),(7,'9d46d73f-633d-4236-a472-42290322a6a9','ba5e0000-0000-4000-8000-000000000081','image','2026-09-24 03:12:15.074459'),(7,'b8c6248c-6fce-47a6-b6b9-b176b8ec327a','ba5e0000-0000-4000-8000-000000000084','cover','2026-09-24 03:12:15.074459'),(8,'79ae5e9f-b7d9-4afe-bdb8-ccdb5050fa82','ba5e0000-0000-4000-8000-000000000081','image','2026-09-24 03:12:15.074459'),(8,'8960b9dc-0fee-4b78-9f86-6954073be544','ba5e0000-0000-4000-8000-000000000084','cover','2026-09-24 03:12:15.074459');
/*!40000 ALTER TABLE `ls_blog_revision_media` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_revision_robots`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_revision_robots` (
  `revision_id` bigint(20) unsigned NOT NULL,
  `allow_index` tinyint(3) unsigned NOT NULL,
  `allow_follow` tinyint(3) unsigned NOT NULL,
  `settings_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  PRIMARY KEY (`revision_id`),
  CONSTRAINT `ls_blog_f_rr_revision` FOREIGN KEY (`revision_id`) REFERENCES `ls_blog_content_revisions` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_rr_index` CHECK (`allow_index` in (0,1)),
  CONSTRAINT `ls_blog_c_rr_follow` CHECK (`allow_follow` in (0,1)),
  CONSTRAINT `ls_blog_c_rr_hash` CHECK (`settings_sha256` regexp '^[0-9a-f]{64}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_revision_robots` WRITE;
/*!40000 ALTER TABLE `ls_blog_revision_robots` DISABLE KEYS */;
INSERT INTO `ls_blog_revision_robots` VALUES (1,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(2,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(3,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(4,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(5,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(6,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(7,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(8,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47');
/*!40000 ALTER TABLE `ls_blog_revision_robots` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_robots_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_robots_settings` (
  `localization_id` bigint(20) unsigned NOT NULL,
  `allow_index` tinyint(3) unsigned NOT NULL,
  `allow_follow` tinyint(3) unsigned NOT NULL,
  `settings_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  PRIMARY KEY (`localization_id`),
  CONSTRAINT `ls_blog_f_rs_localization` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_rs_index` CHECK (`allow_index` in (0,1)),
  CONSTRAINT `ls_blog_c_rs_follow` CHECK (`allow_follow` in (0,1)),
  CONSTRAINT `ls_blog_c_rs_hash` CHECK (`settings_sha256` regexp '^[0-9a-f]{64}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_robots_settings` WRITE;
/*!40000 ALTER TABLE `ls_blog_robots_settings` DISABLE KEYS */;
INSERT INTO `ls_blog_robots_settings` VALUES (1,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(2,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(3,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(4,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(5,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(6,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(7,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(8,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47');
/*!40000 ALTER TABLE `ls_blog_robots_settings` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_sitemap_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_sitemap_state` (
  `state_key` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `public_revision` bigint(20) unsigned NOT NULL DEFAULT 1,
  `cache_generation` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`state_key`),
  CONSTRAINT `ls_blog_c_ss_key` CHECK (`state_key` = 'sitemap'),
  CONSTRAINT `ls_blog_c_ss_revision` CHECK (`public_revision` > 0),
  CONSTRAINT `ls_blog_c_ss_generation` CHECK (`cache_generation` is null or char_length(`cache_generation`) = 36 and `cache_generation` = lcase(`cache_generation`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_sitemap_state` WRITE;
/*!40000 ALTER TABLE `ls_blog_sitemap_state` DISABLE KEYS */;
INSERT INTO `ls_blog_sitemap_state` VALUES ('sitemap',1,NULL,'2026-09-10 06:12:45.728294');
/*!40000 ALTER TABLE `ls_blog_sitemap_state` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_tag_assignment_heads`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_tag_assignment_heads` (
  `localization_id` bigint(20) unsigned NOT NULL,
  `assignment_version` bigint(20) unsigned NOT NULL,
  `updated_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`localization_id`),
  CONSTRAINT `ls_blog_f_btah_localization` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_btah_version` CHECK (`assignment_version` > 0),
  CONSTRAINT `ls_blog_c_btah_actor` CHECK (`updated_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_tag_assignment_heads` WRITE;
/*!40000 ALTER TABLE `ls_blog_tag_assignment_heads` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_tag_assignment_heads` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_tag_assignment_workspace_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_tag_assignment_workspace_items` (
  `localization_id` bigint(20) unsigned NOT NULL,
  `tag_id` bigint(20) unsigned NOT NULL,
  `assigned_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL,
  PRIMARY KEY (`localization_id`,`tag_id`),
  KEY `ls_blog_ix_btawi_tag` (`tag_id`,`localization_id`),
  CONSTRAINT `ls_blog_f_btawi_tag` FOREIGN KEY (`tag_id`) REFERENCES `ls_blog_tags` (`id`),
  CONSTRAINT `ls_blog_f_btawi_workspace` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_tag_assignment_workspaces` (`localization_id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_btawi_actor` CHECK (`assigned_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_tag_assignment_workspace_items` WRITE;
/*!40000 ALTER TABLE `ls_blog_tag_assignment_workspace_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_tag_assignment_workspace_items` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_tag_assignment_workspaces`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_tag_assignment_workspaces` (
  `localization_id` bigint(20) unsigned NOT NULL,
  `base_assignment_version` bigint(20) unsigned NOT NULL DEFAULT 0,
  `workspace_version` bigint(20) unsigned NOT NULL,
  `created_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `updated_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`localization_id`),
  CONSTRAINT `ls_blog_f_btaw_localization` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_c_btaw_base` CHECK (`base_assignment_version` >= 0),
  CONSTRAINT `ls_blog_c_btaw_workspace` CHECK (`workspace_version` > 0),
  CONSTRAINT `ls_blog_c_btaw_created_actor` CHECK (`created_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_btaw_updated_actor` CHECK (`updated_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_btaw_time` CHECK (`updated_at` >= `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_tag_assignment_workspaces` WRITE;
/*!40000 ALTER TABLE `ls_blog_tag_assignment_workspaces` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_blog_tag_assignment_workspaces` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_tags` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `slug` varchar(190) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `name` varchar(255) NOT NULL,
  `normalized_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `lock_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  `created_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `updated_by_user_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ls_blog_ux_bt_public` (`public_id`),
  UNIQUE KEY `ls_blog_ux_bt_locale_slug` (`locale`,`slug`),
  UNIQUE KEY `ls_blog_ux_bt_locale_hash` (`locale`,`normalized_sha256`),
  KEY `ls_blog_ix_bt_locale_name` (`locale`,`name`),
  CONSTRAINT `ls_blog_c_bt_public` CHECK (`public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_bt_locale` CHECK (char_length(`locale`) between 2 and 16 and `locale` = lcase(`locale`) and `locale` = trim(`locale`)),
  CONSTRAINT `ls_blog_c_bt_slug` CHECK (char_length(`slug`) between 1 and 190 and `slug` regexp '^[a-z0-9]+(-[a-z0-9]+)*$'),
  CONSTRAINT `ls_blog_c_bt_name` CHECK (char_length(trim(`name`)) between 1 and 64 and octet_length(`name`) <= 255),
  CONSTRAINT `ls_blog_c_bt_hash` CHECK (`normalized_sha256` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_blog_c_bt_lock` CHECK (`lock_version` > 0),
  CONSTRAINT `ls_blog_c_bt_created_actor` CHECK (`created_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_bt_updated_actor` CHECK (`updated_by_user_public_id` regexp '^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$'),
  CONSTRAINT `ls_blog_c_bt_time` CHECK (`updated_at` >= `created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_tags` WRITE;
/*!40000 ALTER TABLE `ls_blog_tags` DISABLE KEYS */;
INSERT INTO `ls_blog_tags` VALUES (1,'ba5e0000-0000-4000-8000-000000000030','es','proyecto','Proyecto','b28ad89a06f3fb2c0ad08d066266b03b65df695e6d7fedfe0601846621bc2425',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:09.000000','2026-09-10 10:00:09.000000'),(2,'ba5e0000-0000-4000-8000-000000000031','es','liquidstack','LiquidStack','e6ec3c77a8a98c6cee67d940471f2ef3be9bdad267b1a4f18f621a8ced480634',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:09.000000','2026-09-10 10:00:09.000000'),(3,'ba5e0000-0000-4000-8000-000000000032','es','primeros-pasos','Primeros pasos','f0f94440d65ff2110367730f823b2553f346301a6afa7e2b7a63abf90ecad1c1',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:09.000000','2026-09-10 10:00:09.000000'),(4,'ba5e0000-0000-4000-8000-000000000034','eu','lehen-urratsak','Lehen urratsak','32a47a6eb556b8b80d279271ae6f0eed4d31b775203dba737ebc9101fcc2c830',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:10.000000','2026-09-10 10:00:10.000000'),(5,'ba5e0000-0000-4000-8000-000000000035','eu','proiektua','Proiektua','7a97482351fb975be4b07a883b15efb448d1df44815abd9e18c3b991c38f2e0b',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:10.000000','2026-09-10 10:00:10.000000'),(6,'ba5e0000-0000-4000-8000-000000000036','eu','liquidstack','LiquidStack','e6ec3c77a8a98c6cee67d940471f2ef3be9bdad267b1a4f18f621a8ced480634',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:10.000000','2026-09-10 10:00:10.000000'),(7,'ba5e0000-0000-4000-8000-000000000062','es','actualizaciones','Actualizaciones','b83ebd9323890a13b5ed0956271fdb0b1e18c83242ac08eb8980893b080e8ee8',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:18.000000','2026-09-10 10:00:18.000000'),(8,'ba5e0000-0000-4000-8000-000000000063','es','personalizacion','Personalización','ed1b217acddedcb845544db68c5229015dcd82143232c986cb289fe0b356d73b',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:18.000000','2026-09-10 10:00:18.000000'),(9,'ba5e0000-0000-4000-8000-000000000065','eu','eguneraketak','Eguneraketak','568cd4107c657a4afeb4acd9a823d1c569a40f0cea4478470e5248ba46d728cc',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:19.000000','2026-09-10 10:00:19.000000'),(10,'ba5e0000-0000-4000-8000-000000000066','eu','pertsonalizazioa','Pertsonalizazioa','6f4d61696cfb07aeb580c9d0fcc0f6eb4a429863bdae4865f7d7d86883905078',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:19.000000','2026-09-10 10:00:19.000000');
/*!40000 ALTER TABLE `ls_blog_tags` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_blog_url_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_blog_url_history` (
  `localization_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `slug` varchar(190) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `state` varchar(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `replacement_localization_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL,
  PRIMARY KEY (`locale`,`slug`),
  KEY `ls_blog_ix_uh_owner` (`localization_id`,`state`),
  KEY `ls_blog_ix_uh_target` (`replacement_localization_id`),
  CONSTRAINT `ls_blog_f_uh_owner` FOREIGN KEY (`localization_id`) REFERENCES `ls_blog_post_localizations` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_blog_f_uh_target` FOREIGN KEY (`replacement_localization_id`) REFERENCES `ls_blog_post_localizations` (`id`),
  CONSTRAINT `ls_blog_c_uh_locale` CHECK (char_length(`locale`) between 2 and 16 and `locale` = lcase(`locale`) and `locale` = trim(`locale`)),
  CONSTRAINT `ls_blog_c_uh_slug` CHECK (char_length(trim(`slug`)) > 0 and `slug` = lcase(`slug`) and `slug` = trim(`slug`)),
  CONSTRAINT `ls_blog_c_uh_state` CHECK (`state` in ('active','temporary_not_found','gone','redirect')),
  CONSTRAINT `ls_blog_c_uh_target_state` CHECK (`state` = 'redirect' and `replacement_localization_id` is not null or `state` <> 'redirect' and `replacement_localization_id` is null),
  CONSTRAINT `ls_blog_c_uh_time` CHECK (`updated_at` >= `created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_url_history` WRITE;
/*!40000 ALTER TABLE `ls_blog_url_history` DISABLE KEYS */;
INSERT INTO `ls_blog_url_history` VALUES (1,'es','matrix-despertar-realidad-construida','active',NULL,'2026-09-24 03:12:14.932473','2026-09-24 03:12:14.932473'),(3,'es','matrix-reloaded-elegir-sistema-previsto','active',NULL,'2026-09-24 03:12:14.984643','2026-09-24 03:12:14.984643'),(7,'es','matrix-resurrections-recordar-volver-elegir','active',NULL,'2026-09-24 03:12:15.074459','2026-09-24 03:12:15.074459'),(5,'es','matrix-revolutions-tregua-romper-ciclo','active',NULL,'2026-09-24 03:12:15.033255','2026-09-24 03:12:15.033255'),(2,'eu','matrix-eraikitako-errealitatearen-aurrean-esnatzea','active',NULL,'2026-09-24 03:12:14.932473','2026-09-24 03:12:14.932473'),(4,'eu','matrix-reloaded-aurreikusitako-sisteman-hautatzea','active',NULL,'2026-09-24 03:12:14.984643','2026-09-24 03:12:14.984643'),(8,'eu','matrix-resurrections-gogoratu-berriro-hautatzeko','active',NULL,'2026-09-24 03:12:15.074459','2026-09-24 03:12:15.074459'),(6,'eu','matrix-revolutions-zikloa-hausteko-su-etena','active',NULL,'2026-09-24 03:12:15.033255','2026-09-24 03:12:15.033255');
/*!40000 ALTER TABLE `ls_blog_url_history` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_attribute_localizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_attribute_localizations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `attribute_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `translation_status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_attribute_locale` (`attribute_id`,`locale`),
  CONSTRAINT `ls_commerce_f_al_attribute` FOREIGN KEY (`attribute_id`) REFERENCES `ls_commerce_attributes` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_c_al_status` CHECK (`translation_status` in ('source','translated','fallback'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_attribute_localizations` WRITE;
/*!40000 ALTER TABLE `ls_commerce_attribute_localizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_attribute_localizations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_attribute_option_localizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_attribute_option_localizations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `option_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `translation_status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_option_locale` (`option_id`,`locale`),
  CONSTRAINT `ls_commerce_f_aol_option` FOREIGN KEY (`option_id`) REFERENCES `ls_commerce_attribute_options` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_c_aol_status` CHECK (`translation_status` in ('source','translated','fallback'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_attribute_option_localizations` WRITE;
/*!40000 ALTER TABLE `ls_commerce_attribute_option_localizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_attribute_option_localizations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_attribute_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_attribute_options` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `attribute_id` bigint(20) unsigned NOT NULL,
  `code` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_options_public` (`public_id`),
  UNIQUE KEY `uq_commerce_options_code` (`attribute_id`,`code`),
  CONSTRAINT `ls_commerce_f_option_attribute` FOREIGN KEY (`attribute_id`) REFERENCES `ls_commerce_attributes` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_attribute_options` WRITE;
/*!40000 ALTER TABLE `ls_commerce_attribute_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_attribute_options` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_attributes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_attributes` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `code` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `type` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `category_id` bigint(20) unsigned DEFAULT NULL,
  `unit` varchar(32) DEFAULT NULL,
  `is_filterable` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_attributes_public` (`public_id`),
  UNIQUE KEY `uq_commerce_attributes_code` (`code`),
  KEY `idx_commerce_attributes_category` (`category_id`,`sort_order`),
  CONSTRAINT `ls_commerce_f_attribute_category` FOREIGN KEY (`category_id`) REFERENCES `ls_commerce_categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ls_commerce_c_attribute_type` CHECK (`type` in ('text','number','boolean','select','multiselect','date')),
  CONSTRAINT `ls_commerce_c_attribute_filter` CHECK (`is_filterable` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_attributes` WRITE;
/*!40000 ALTER TABLE `ls_commerce_attributes` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_attributes` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_basket_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_basket_items` (
  `basket_id` bigint(20) unsigned NOT NULL,
  `product_id` bigint(20) unsigned NOT NULL,
  `quantity` int(10) unsigned NOT NULL DEFAULT 1,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`basket_id`,`product_id`),
  KEY `idx_commerce_bi_product` (`product_id`,`basket_id`),
  CONSTRAINT `ls_commerce_f_bi_basket` FOREIGN KEY (`basket_id`) REFERENCES `ls_commerce_baskets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_f_bi_product` FOREIGN KEY (`product_id`) REFERENCES `ls_commerce_products` (`id`),
  CONSTRAINT `ls_commerce_c_bi_quantity` CHECK (`quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_basket_items` WRITE;
/*!40000 ALTER TABLE `ls_commerce_basket_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_basket_items` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_baskets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_baskets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `token_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'open',
  `expires_at` datetime(6) NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_baskets_public` (`public_id`),
  UNIQUE KEY `uq_commerce_baskets_token` (`token_sha256`),
  KEY `idx_commerce_baskets_expiry` (`status`,`expires_at`),
  CONSTRAINT `ls_commerce_c_basket_status` CHECK (`status` in ('open','submitted','expired'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_baskets` WRITE;
/*!40000 ALTER TABLE `ls_commerce_baskets` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_baskets` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `parent_id` bigint(20) unsigned DEFAULT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `lock_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_categories_public` (`public_id`),
  KEY `idx_commerce_categories_parent` (`parent_id`,`sort_order`,`id`),
  CONSTRAINT `ls_commerce_f_cat_parent` FOREIGN KEY (`parent_id`) REFERENCES `ls_commerce_categories` (`id`),
  CONSTRAINT `ls_commerce_c_cat_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_commerce_c_cat_lock` CHECK (`lock_version` > 0),
  CONSTRAINT `ls_commerce_c_cat_sort` CHECK (`sort_order` <= 10000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_categories` WRITE;
/*!40000 ALTER TABLE `ls_commerce_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_categories` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_category_localizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_category_localizations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `category_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `slug` varchar(190) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `translation_status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `lock_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_category_locale` (`category_id`,`locale`),
  UNIQUE KEY `uq_commerce_category_slug` (`locale`,`slug`),
  CONSTRAINT `ls_commerce_f_cl_category` FOREIGN KEY (`category_id`) REFERENCES `ls_commerce_categories` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_c_cl_status` CHECK (`translation_status` in ('source','translated','fallback')),
  CONSTRAINT `ls_commerce_c_cl_lock` CHECK (`lock_version` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_category_localizations` WRITE;
/*!40000 ALTER TABLE `ls_commerce_category_localizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_category_localizations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_inquiries`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_inquiries` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `operation_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `payload_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `basket_id` bigint(20) unsigned DEFAULT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `contact_name` varchar(255) NOT NULL,
  `email` varchar(320) NOT NULL,
  `phone` varchar(64) DEFAULT NULL,
  `message` text DEFAULT NULL,
  `privacy_version` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_inquiries_public` (`public_id`),
  UNIQUE KEY `uq_commerce_inquiries_operation` (`operation_id`),
  UNIQUE KEY `uq_commerce_inquiries_basket` (`basket_id`),
  KEY `idx_commerce_inquiries_time` (`created_at`),
  CONSTRAINT `ls_commerce_f_inquiry_basket` FOREIGN KEY (`basket_id`) REFERENCES `ls_commerce_baskets` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ls_commerce_c_inquiry_hash` CHECK (`payload_sha256` regexp '^[0-9a-f]{64}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_inquiries` WRITE;
/*!40000 ALTER TABLE `ls_commerce_inquiries` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_inquiries` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_inquiry_lines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_inquiry_lines` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `inquiry_id` bigint(20) unsigned NOT NULL,
  `product_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `sku` varchar(190) DEFAULT NULL,
  `requested_locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `resolved_locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `title` varchar(255) NOT NULL,
  `public_path` varchar(1024) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `cover_media_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `quantity` int(10) unsigned NOT NULL DEFAULT 1,
  `unit_price_minor` bigint(20) unsigned DEFAULT NULL,
  `currency` char(3) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `availability_status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_line_product` (`inquiry_id`,`product_public_id`),
  CONSTRAINT `ls_commerce_f_line_inquiry` FOREIGN KEY (`inquiry_id`) REFERENCES `ls_commerce_inquiries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_c_line_quantity` CHECK (`quantity` > 0),
  CONSTRAINT `ls_commerce_c_line_availability` CHECK (`availability_status` in ('available','reserved','sold','unavailable'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_inquiry_lines` WRITE;
/*!40000 ALTER TABLE `ls_commerce_inquiry_lines` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_inquiry_lines` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_inquiry_outbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_inquiry_outbox` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `inquiry_id` bigint(20) unsigned NOT NULL,
  `audience` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `recipient_email` varchar(320) NOT NULL,
  `template_key` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `payload_json` longtext NOT NULL,
  `status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'pending',
  `attempts` int(10) unsigned NOT NULL DEFAULT 0,
  `available_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `locked_at` datetime(6) DEFAULT NULL,
  `lock_token` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `sent_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_outbox_public` (`public_id`),
  UNIQUE KEY `uq_commerce_outbox_audience` (`inquiry_id`,`audience`),
  KEY `idx_commerce_outbox_dispatch` (`status`,`available_at`),
  CONSTRAINT `ls_commerce_f_outbox_inquiry` FOREIGN KEY (`inquiry_id`) REFERENCES `ls_commerce_inquiries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_c_outbox_audience` CHECK (`audience` in ('requester','admin')),
  CONSTRAINT `ls_commerce_c_outbox_status` CHECK (`status` in ('pending','processing','sent','failed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_inquiry_outbox` WRITE;
/*!40000 ALTER TABLE `ls_commerce_inquiry_outbox` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_inquiry_outbox` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_inquiry_rate_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_inquiry_rate_limits` (
  `action` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `subject_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `attempts` int(10) unsigned NOT NULL DEFAULT 0,
  `window_started_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`action`,`subject_hash`),
  KEY `idx_commerce_rate_updated` (`updated_at`),
  CONSTRAINT `ls_commerce_c_rate_hash` CHECK (`subject_hash` regexp '^[0-9a-f]{64}$'),
  CONSTRAINT `ls_commerce_c_rate_attempts` CHECK (`attempts` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_inquiry_rate_limits` WRITE;
/*!40000 ALTER TABLE `ls_commerce_inquiry_rate_limits` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_inquiry_rate_limits` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_product_attribute_value_options`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_product_attribute_value_options` (
  `value_id` bigint(20) unsigned NOT NULL,
  `option_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`value_id`,`option_id`),
  KEY `idx_commerce_pavo_option` (`option_id`,`value_id`),
  CONSTRAINT `ls_commerce_f_pavo_option` FOREIGN KEY (`option_id`) REFERENCES `ls_commerce_attribute_options` (`id`),
  CONSTRAINT `ls_commerce_f_pavo_value` FOREIGN KEY (`value_id`) REFERENCES `ls_commerce_product_attribute_values` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_product_attribute_value_options` WRITE;
/*!40000 ALTER TABLE `ls_commerce_product_attribute_value_options` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_product_attribute_value_options` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_product_attribute_values`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_product_attribute_values` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) unsigned NOT NULL,
  `attribute_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT '',
  `text_value` text DEFAULT NULL,
  `number_value` decimal(20,6) DEFAULT NULL,
  `boolean_value` tinyint(3) unsigned DEFAULT NULL,
  `date_value` date DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_product_attribute` (`product_id`,`attribute_id`,`locale`),
  KEY `idx_commerce_pav_attribute` (`attribute_id`,`product_id`),
  CONSTRAINT `ls_commerce_f_pav_attribute` FOREIGN KEY (`attribute_id`) REFERENCES `ls_commerce_attributes` (`id`),
  CONSTRAINT `ls_commerce_f_pav_product` FOREIGN KEY (`product_id`) REFERENCES `ls_commerce_products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_c_pav_boolean` CHECK (`boolean_value` is null or `boolean_value` in (0,1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_product_attribute_values` WRITE;
/*!40000 ALTER TABLE `ls_commerce_product_attribute_values` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_product_attribute_values` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_product_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_product_categories` (
  `product_id` bigint(20) unsigned NOT NULL,
  `category_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`product_id`,`category_id`),
  KEY `idx_commerce_pc_category` (`category_id`,`product_id`),
  CONSTRAINT `ls_commerce_f_pc_category` FOREIGN KEY (`category_id`) REFERENCES `ls_commerce_categories` (`id`),
  CONSTRAINT `ls_commerce_f_pc_product` FOREIGN KEY (`product_id`) REFERENCES `ls_commerce_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_product_categories` WRITE;
/*!40000 ALTER TABLE `ls_commerce_product_categories` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_product_categories` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_product_inquiry_stats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_product_inquiry_stats` (
  `product_id` bigint(20) unsigned NOT NULL,
  `inquiry_count` bigint(20) unsigned NOT NULL DEFAULT 0,
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`product_id`),
  CONSTRAINT `ls_commerce_f_stats_product` FOREIGN KEY (`product_id`) REFERENCES `ls_commerce_products` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_product_inquiry_stats` WRITE;
/*!40000 ALTER TABLE `ls_commerce_product_inquiry_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_product_inquiry_stats` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_product_localizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_product_localizations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `title` varchar(255) DEFAULT NULL,
  `slug` varchar(190) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `summary` text DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `seo_title` varchar(255) DEFAULT NULL,
  `seo_description` varchar(320) DEFAULT NULL,
  `translation_status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `public_path` varchar(1024) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `lock_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_product_locale` (`product_id`,`locale`),
  UNIQUE KEY `uq_commerce_product_slug` (`locale`,`slug`),
  UNIQUE KEY `uq_commerce_product_path` (`public_path`(190)),
  CONSTRAINT `ls_commerce_f_pl_product` FOREIGN KEY (`product_id`) REFERENCES `ls_commerce_products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_c_pl_status` CHECK (`translation_status` in ('source','translated','fallback')),
  CONSTRAINT `ls_commerce_c_pl_lock` CHECK (`lock_version` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_product_localizations` WRITE;
/*!40000 ALTER TABLE `ls_commerce_product_localizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_product_localizations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_product_media`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_product_media` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_id` bigint(20) unsigned NOT NULL,
  `media_asset_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `role` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_product_media` (`product_id`,`media_asset_public_id`),
  KEY `idx_commerce_media_asset` (`media_asset_public_id`),
  KEY `idx_commerce_media_order` (`product_id`,`role`,`sort_order`),
  CONSTRAINT `ls_commerce_f_pm_product` FOREIGN KEY (`product_id`) REFERENCES `ls_commerce_products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_c_pm_asset` CHECK (char_length(`media_asset_public_id`) = 36),
  CONSTRAINT `ls_commerce_c_pm_role` CHECK (`role` in ('cover','gallery'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_product_media` WRITE;
/*!40000 ALTER TABLE `ls_commerce_product_media` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_product_media` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_product_media_localizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_product_media_localizations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `media_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `alt_text` varchar(500) DEFAULT NULL,
  `caption` text DEFAULT NULL,
  `translation_status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_media_locale` (`media_id`,`locale`),
  CONSTRAINT `ls_commerce_f_pml_media` FOREIGN KEY (`media_id`) REFERENCES `ls_commerce_product_media` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_c_pml_status` CHECK (`translation_status` in ('source','translated','fallback')),
  CONSTRAINT `ls_commerce_c_pml_content` CHECK (`translation_status` = 'fallback' and `alt_text` is null and `caption` is null or `translation_status` in ('source','translated') and `alt_text` is not null and char_length(trim(`alt_text`)) between 1 and 500 and (`caption` is null or char_length(`caption`) <= 2000))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_product_media_localizations` WRITE;
/*!40000 ALTER TABLE `ls_commerce_product_media_localizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_product_media_localizations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_product_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_product_tags` (
  `product_id` bigint(20) unsigned NOT NULL,
  `tag_id` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`product_id`,`tag_id`),
  KEY `idx_commerce_pt_tag` (`tag_id`,`product_id`),
  CONSTRAINT `ls_commerce_f_pt_product` FOREIGN KEY (`product_id`) REFERENCES `ls_commerce_products` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_f_pt_tag` FOREIGN KEY (`tag_id`) REFERENCES `ls_commerce_tags` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_product_tags` WRITE;
/*!40000 ALTER TABLE `ls_commerce_product_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_product_tags` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `sku` varchar(190) DEFAULT NULL,
  `editorial_status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'draft',
  `availability_status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'available',
  `price_minor` bigint(20) unsigned DEFAULT NULL,
  `currency` char(3) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `canonical_category_id` bigint(20) unsigned DEFAULT NULL,
  `lock_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_products_public` (`public_id`),
  UNIQUE KEY `uq_commerce_products_sku` (`sku`),
  KEY `idx_commerce_products_state` (`editorial_status`,`availability_status`),
  KEY `idx_commerce_products_category` (`canonical_category_id`),
  CONSTRAINT `ls_commerce_f_product_category` FOREIGN KEY (`canonical_category_id`) REFERENCES `ls_commerce_categories` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ls_commerce_c_product_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_commerce_c_product_editorial` CHECK (`editorial_status` in ('draft','active','inactive','archived')),
  CONSTRAINT `ls_commerce_c_product_availability` CHECK (`availability_status` in ('available','reserved','sold','unavailable')),
  CONSTRAINT `ls_commerce_c_product_money` CHECK (`price_minor` is null and `currency` is null or `price_minor` is not null and `currency` regexp '^[A-Z]{3}$'),
  CONSTRAINT `ls_commerce_c_product_lock` CHECK (`lock_version` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_products` WRITE;
/*!40000 ALTER TABLE `ls_commerce_products` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_products` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_tag_localizations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_tag_localizations` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tag_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `slug` varchar(190) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `translation_status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_tag_locale` (`tag_id`,`locale`),
  UNIQUE KEY `uq_commerce_tag_slug` (`locale`,`slug`),
  CONSTRAINT `ls_commerce_f_tl_tag` FOREIGN KEY (`tag_id`) REFERENCES `ls_commerce_tags` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_commerce_c_tl_status` CHECK (`translation_status` in ('source','translated','fallback'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_tag_localizations` WRITE;
/*!40000 ALTER TABLE `ls_commerce_tag_localizations` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_tag_localizations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_tags` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_tags_public` (`public_id`),
  CONSTRAINT `ls_commerce_c_tag_public` CHECK (char_length(`public_id`) = 36)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_tags` WRITE;
/*!40000 ALTER TABLE `ls_commerce_tags` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_tags` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_commerce_url_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_commerce_url_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `product_localization_id` bigint(20) unsigned NOT NULL,
  `old_path` varchar(1024) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `new_path` varchar(1024) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_commerce_url_old` (`old_path`(190)),
  KEY `idx_commerce_url_localization` (`product_localization_id`,`created_at`),
  CONSTRAINT `ls_commerce_f_url_localization` FOREIGN KEY (`product_localization_id`) REFERENCES `ls_commerce_product_localizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_commerce_url_history` WRITE;
/*!40000 ALTER TABLE `ls_commerce_url_history` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_commerce_url_history` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_module_migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_module_migrations` (
  `module_id` varchar(63) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `migration_id` varchar(190) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `checksum` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `scope_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `batch` bigint(20) unsigned NOT NULL,
  `applied_at` datetime(6) NOT NULL,
  PRIMARY KEY (`module_id`,`migration_id`),
  KEY `idx_ls_module_migrations_batch` (`batch`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_module_migrations` WRITE;
/*!40000 ALTER TABLE `ls_module_migrations` DISABLE KEYS */;
INSERT INTO `ls_module_migrations` VALUES ('blog','0001_blog_posts','51cb25e2bc0029ee61decac1810f055543591589a2026fffbe2c04dbc45f9d77','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:44.096695'),('blog','0002_blog_capabilities','09e727d09bce7f0c60306099a15df21b882766f878eb0be4c40aca546791d2e7','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:12:44.105995'),('blog','0003_blog_categories','6a78d00acae0d13d175f2632ccb1598b4f1d53ba9c09f5840ea3f73c88661e97','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:44.717068'),('blog','0004_blog_category_capabilities','c8b6f45611a344342b16f147d0edbe62e765ed6e1a70ebead8793dbc9b846345','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:12:44.723925'),('blog','0005_blog_structured_content','4aca1e340d1a818940173feebeeaf67b5c319b464f8ec67e9b5691542753a4bd','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:45.720329'),('blog','0006_blog_sitemap_publication_state','c9d6b26281a35fe4190db7cc2402fb163d9546387476190d0d7077d2d5d5cad8','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:46.671852'),('blog','0007_blog_post_tombstones','e75445d2c440bb5e0fa17e41c1a36833b48bbdb20258bea6e9a830c039c7ad32','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:47.727023'),('blog','0008_blog_article_delete_capability','a8efddc1fa22ae5ac81dae64d8a950f80550001340e661b667de5a8a419f1a2b','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:12:47.736909'),('blog','0009_blog_analytics','91cfcbcfa7ebba5e77018b924284bb6a07a0b6cb8c00e59f03ed80149e3d73a9','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:48.985469'),('blog','0010_blog_analytics_view_capability','ca2f6a15e58cab0f54cbcd41032a31d7acc796b6d920d2f25e6b59bc9de8d3af','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:12:48.992984'),('blog','0011_blog_layout_editor_v2','12d59ea0546272e00e92350cf380bb6d493c0783fb665878ee501e2cd8c58448','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:50.598421'),('blog','0012_blog_editor_preferences','45cfcd81f3ec2371eae92302da052c46306358aed8d50b34fca7d5af80b23c82','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:52.017478'),('blog','0013_blog_settings_manage_capability','9cf4940e3910162ae9b9efeb94883176d49f92a75ab9ee78ef1b3dd71c3e09fb','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:12:52.025559'),('blog','0014_blog_private_draft_publication','dc2fd2d8aa9bfbb8fc803e711cc5140cc026ae6bc2f443b450b9e82d80d8afda','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:53.724751'),('blog','0015_blog_robots_preferences','27e9b92cdbab9c28538a9f42a91d42e24381ad162d22f13e4ba843de4580666f','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:55.553456'),('blog','0016_blog_url_history','c06ec813029da517e21882b65a848f0632a7fcd93e12668b820ef06ea70ee2ea','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:57.412511'),('blog','0017_blog_dummy_category','9a62a791e33f83ce9932c311dc8e2aff36a5af2b0b916519f22e590b2018ee32','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:57.418799'),('blog','0018_blog_dummy_category_normalization','32730febd8e9a78647f93fe6678448377a4e9a7ba4e0b1301b1c5edafdc3e0c0','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:12:59.183373'),('blog','0019_blog_copy_operation_idempotency','313437bf2e27749b1b7fb0fac3ad655aefa4d367e256c3c0142cd2160b17360a','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:13:00.973451'),('blog','0020_blog_tags','9496020075a17971a658af619f5b984a64248c225aa14435221007e7eb5f966f','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:13:02.800636'),('blog','0021_blog_localization_tags','b1d0e3fd5552d122d1a0dc4056c4e1e9738e19a12aba7034c4d4ef267771463e','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:13:04.881116'),('blog','0022_blog_tag_assignment_heads','25834e1cd01b4dd625144e2afbb13d65845f04caba0ae31120ae4371a75f38cb','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:13:06.941525'),('blog','0023_blog_tag_assignment_workspaces','b4ba7c59190a741abea4ba184157883a68ea86c197bb6db1b1e57b03f0e73328','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:13:09.246565'),('blog','0024_blog_tag_assignment_workspace_items','4730844270de32b68a4f186230cac290e25b303f295def8059e8b358d23da83c','8284f2269291da041214e1d1394260fa9cf9f4eae9b6820716f809c45eb3607f',1,'2026-09-10 06:13:11.436819'),('blog','0025_blog_tag_capabilities','7c44dc5da765c041edcbc470e1512d3e5374a1f672331a792bf7c335f97a90d9','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:13:11.442824'),('commerce','0001_commerce_catalog','b1c432e03897c3c138ef3316e4f7a985a3ba7474543a858b522d61bc80021417','e6de61b89f7cccc9c7b1f8bcdf4885da02002c395c6455dae908faa4fc1d023a',2,'2026-09-21 17:23:50.187029'),('commerce','0002_commerce_inquiries','f5e2dca482423c0ac2000f329826b2ffb2cbc0aa24a200646b59953ddd9cb86b','e6de61b89f7cccc9c7b1f8bcdf4885da02002c395c6455dae908faa4fc1d023a',2,'2026-09-21 17:23:50.266648'),('commerce','0003_commerce_capabilities','d6a26de91849f37608863ac183ed44b75a4fa32ecf486fc0feacda0273c87e3f','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',2,'2026-09-21 17:23:50.270649'),('webadmin','0001_webadmin_identity_and_access','8ae682db1275f779938b247a2bddbe20ecc01bc2e972499fef60104d4d141d27','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:12:42.668189'),('webadmin','0002_webadmin_media_library','2c3595970aa0adfc618dc0437806d955d26dfd05a1e4466d69a44c036524c52e','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:12:42.988778'),('webadmin','0003_webadmin_media_avif_source','ecddd34bd8a1b39be542fc3e47fada4ee79b95927ab7d1e63c6cd15caa7f7048','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:12:43.394030'),('webadmin','0004_webadmin_profile_preferences','32c12ee11814c0ed7cc8f21b7ed9f1009978c7a850caf582b225b1691dc72173','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:12:43.460122'),('webadmin','0005_webadmin_media_quarantine','d252e20d70d50e1919d2cd858017c6d63b66c35d669466b30aaec5c7826ef07d','0e8fe8bee99c8f87e5ee37454b492fa218176dd560c55ce93890e1cb8d085d2d',1,'2026-09-10 06:12:43.871934');
/*!40000 ALTER TABLE `ls_module_migrations` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_action_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_action_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` bigint(20) unsigned NOT NULL,
  `purpose` varchar(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `token_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `auth_version` bigint(20) unsigned NOT NULL,
  `created_by_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `expires_at` datetime(6) NOT NULL,
  `delivered_at` datetime(6) DEFAULT NULL,
  `used_at` datetime(6) DEFAULT NULL,
  `revoked_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wa_action_tokens_hash` (`token_hash`),
  KEY `idx_wa_action_tokens_user` (`user_id`,`purpose`,`expires_at`),
  KEY `idx_wa_action_tokens_creator` (`created_by_user_id`),
  CONSTRAINT `ls_webadmin_f_at_by` FOREIGN KEY (`created_by_user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ls_webadmin_f_at_user` FOREIGN KEY (`user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_webadmin_c_at_purpose` CHECK (`purpose` in ('invite','password_reset')),
  CONSTRAINT `ls_webadmin_c_at_hash` CHECK (char_length(`token_hash`) = 64),
  CONSTRAINT `ls_webadmin_c_at_version` CHECK (`auth_version` > 0),
  CONSTRAINT `ls_webadmin_c_at_expiry` CHECK (`expires_at` > `created_at`),
  CONSTRAINT `ls_webadmin_c_at_terminal` CHECK (`used_at` is null or `revoked_at` is null)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_action_tokens` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_action_tokens` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_webadmin_action_tokens` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_audit_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_audit_log` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `request_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `actor_user_id` bigint(20) unsigned DEFAULT NULL,
  `actor_session_public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `event_code` varchar(96) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `outcome` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `reason_code` varchar(96) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `target_type` varchar(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `target_public_id` varchar(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `metadata_json` longtext DEFAULT NULL,
  `ip_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `user_agent_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `occurred_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  KEY `idx_wa_audit_request` (`request_id`),
  KEY `idx_wa_audit_actor_time` (`actor_user_id`,`occurred_at`),
  KEY `idx_wa_audit_event_time` (`event_code`,`occurred_at`),
  CONSTRAINT `ls_webadmin_f_au_actor` FOREIGN KEY (`actor_user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ls_webadmin_c_au_outcome` CHECK (`outcome` in ('success','failure','denied')),
  CONSTRAINT `ls_webadmin_c_au_request` CHECK (char_length(`request_id`) = 36),
  CONSTRAINT `ls_webadmin_c_au_ip` CHECK (`ip_hash` is null or char_length(`ip_hash`) = 64),
  CONSTRAINT `ls_webadmin_c_au_ua` CHECK (`user_agent_hash` is null or char_length(`user_agent_hash`) = 64)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_audit_log` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_audit_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_webadmin_audit_log` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_capabilities` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `module_id` varchar(63) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `code` varchar(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `label_key` varchar(160) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `is_delegable` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wa_capabilities_code` (`code`),
  KEY `idx_wa_capabilities_module` (`module_id`),
  CONSTRAINT `ls_webadmin_c_ca_delegate` CHECK (`is_delegable` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_capabilities` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_capabilities` DISABLE KEYS */;
INSERT INTO `ls_webadmin_capabilities` VALUES (1,'webadmin','webadmin.access','webadmin.capabilities.access',0,'2026-09-10 06:12:42.526472'),(2,'webadmin','webadmin.profile.manage_self','webadmin.capabilities.profile_manage_self',0,'2026-09-10 06:12:42.526472'),(3,'webadmin','webadmin.users.view','webadmin.capabilities.users_view',1,'2026-09-10 06:12:42.526472'),(4,'webadmin','webadmin.users.invite','webadmin.capabilities.users_invite',0,'2026-09-10 06:12:42.526472'),(5,'webadmin','webadmin.users.suspend','webadmin.capabilities.users_suspend',0,'2026-09-10 06:12:42.526472'),(6,'webadmin','webadmin.users.capabilities.manage','webadmin.capabilities.users_capabilities_manage',0,'2026-09-10 06:12:42.526472'),(7,'webadmin','webadmin.audit.view','webadmin.capabilities.audit_view',0,'2026-09-10 06:12:42.526472'),(8,'webadmin','webadmin.system.diagnose','webadmin.capabilities.system_diagnose',0,'2026-09-10 06:12:42.526472'),(9,'webadmin','webadmin.media.view','webadmin.capabilities.media_view',1,'2026-09-10 06:12:42.702786'),(10,'webadmin','webadmin.media.upload','webadmin.capabilities.media_upload',1,'2026-09-10 06:12:42.702786'),(11,'webadmin','webadmin.media.delete','webadmin.capabilities.media_delete',1,'2026-09-10 06:12:43.482548'),(12,'blog','blog.articles.view','blog.capabilities.articles_view',1,'2026-09-10 06:12:44.098862'),(13,'blog','blog.articles.edit','blog.capabilities.articles_edit',1,'2026-09-10 06:12:44.098862'),(14,'blog','blog.articles.publish','blog.capabilities.articles_publish',1,'2026-09-10 06:12:44.098862'),(15,'blog','blog.categories.view','blog.capabilities.categories_view',1,'2026-09-10 06:12:44.718943'),(16,'blog','blog.categories.edit','blog.capabilities.categories_edit',1,'2026-09-10 06:12:44.718943'),(17,'blog','blog.articles.delete','blog.capabilities.articles_delete',1,'2026-09-10 06:12:47.729943'),(18,'blog','blog.analytics.view','blog.capabilities.analytics_view',1,'2026-09-10 06:12:48.987060'),(19,'blog','blog.settings.manage','blog.capabilities.settings_manage',0,'2026-09-10 06:12:52.018709'),(20,'blog','blog.tags.view','blog.capabilities.tags_view',1,'2026-09-10 06:13:11.438542'),(21,'blog','blog.tags.edit','blog.capabilities.tags_edit',1,'2026-09-10 06:13:11.438542'),(22,'commerce','commerce.products.view','commerce.capabilities.products_view',1,'2026-09-21 17:23:50.267485'),(23,'commerce','commerce.products.edit','commerce.capabilities.products_edit',1,'2026-09-21 17:23:50.267485'),(24,'commerce','commerce.products.publish','commerce.capabilities.products_publish',1,'2026-09-21 17:23:50.267485'),(25,'commerce','commerce.products.archive','commerce.capabilities.products_archive',1,'2026-09-21 17:23:50.267485'),(26,'commerce','commerce.taxonomies.view','commerce.capabilities.taxonomies_view',1,'2026-09-21 17:23:50.267485'),(27,'commerce','commerce.taxonomies.edit','commerce.capabilities.taxonomies_edit',1,'2026-09-21 17:23:50.267485'),(28,'commerce','commerce.inquiries.view','commerce.capabilities.inquiries_view',1,'2026-09-21 17:23:50.267485'),(29,'commerce','commerce.inquiries.manage','commerce.capabilities.inquiries_manage',1,'2026-09-21 17:23:50.267485'),(30,'commerce','commerce.settings.manage','commerce.capabilities.settings_manage',0,'2026-09-21 17:23:50.267485');
/*!40000 ALTER TABLE `ls_webadmin_capabilities` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_credentials` (
  `user_id` bigint(20) unsigned NOT NULL,
  `password_hash` varchar(255) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `password_set_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`user_id`),
  CONSTRAINT `ls_webadmin_f_cr_user` FOREIGN KEY (`user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_webadmin_c_cr_password` CHECK (`password_hash` is null and `password_set_at` is null or `password_hash` is not null and `password_set_at` is not null)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_credentials` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_credentials` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_webadmin_credentials` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_media_assets`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_media_assets` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `label` varchar(120) NOT NULL,
  `source_mime` varchar(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `source_width` int(10) unsigned NOT NULL,
  `source_height` int(10) unsigned NOT NULL,
  `source_bytes` bigint(20) unsigned NOT NULL,
  `source_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_by_user_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wa_media_assets_public` (`public_id`),
  KEY `idx_wa_media_assets_created` (`created_at`,`id`),
  KEY `idx_wa_media_assets_author` (`created_by_user_id`),
  CONSTRAINT `ls_webadmin_f_ma_author` FOREIGN KEY (`created_by_user_id`) REFERENCES `ls_webadmin_users` (`id`),
  CONSTRAINT `ls_webadmin_c_ma_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_webadmin_c_ma_label` CHECK (char_length(`label`) between 1 and 120),
  CONSTRAINT `ls_webadmin_c_ma_dims` CHECK (`source_width` between 1 and 12000 and `source_height` between 1 and 12000 and `source_width` * `source_height` <= 40000000),
  CONSTRAINT `ls_webadmin_c_ma_bytes` CHECK (`source_bytes` between 1 and 12582912),
  CONSTRAINT `ls_webadmin_c_ma_hash` CHECK (char_length(`source_sha256`) = 64),
  CONSTRAINT `ls_webadmin_c_ma_mime` CHECK (`source_mime` in ('image/jpeg','image/png','image/webp','image/avif'))
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_media_assets` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_media_assets` DISABLE KEYS */;
INSERT INTO `ls_webadmin_media_assets` VALUES (1,'ba5e0000-0000-4000-8000-000000000081','Matrix · despertar','image/avif',2560,1600,104521,'0e785cb65e42dc97b6cd3634fad5b2c14f32976b9524b1669db0569725a4b515',2,'2026-09-24 09:01:00.000000'),(2,'ba5e0000-0000-4000-8000-000000000082','Matrix Reloaded · elección','image/avif',2560,1722,102465,'22064e57c31991b32145f13101c0246d87f49fbc5bdec83e0dd993e6a78230ff',2,'2026-09-24 09:01:00.000000'),(3,'ba5e0000-0000-4000-8000-000000000083','Matrix Revolutions · tregua','image/avif',2560,1696,161973,'4f2f037d1d78accea7c50a621ddda05931e17dcdc9bed937c792f41a3a55f92e',2,'2026-09-24 09:01:00.000000'),(4,'ba5e0000-0000-4000-8000-000000000084','Matrix Resurrections · memoria','image/avif',2560,1440,76844,'34ed17b7d23327725599bacae05308c6bdb8aedbee2153e2d898149d4b0f2715',2,'2026-09-24 09:01:00.000000');
/*!40000 ALTER TABLE `ls_webadmin_media_assets` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_media_quarantines`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_media_quarantines` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` bigint(20) unsigned NOT NULL,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `state` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `asset_version` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `original_storage_prefix` varchar(255) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `quarantine_storage_prefix` varchar(255) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `manifest_storage_key` varchar(255) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `manifest_json` text NOT NULL,
  `manifest_sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `request_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `quarantined_by_user_id` bigint(20) unsigned NOT NULL,
  `quarantined_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `lock_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wa_mq_asset` (`asset_id`),
  UNIQUE KEY `uq_wa_mq_public` (`public_id`),
  UNIQUE KEY `uq_wa_mq_quarantine` (`quarantine_storage_prefix`),
  UNIQUE KEY `uq_wa_mq_manifest` (`manifest_storage_key`),
  UNIQUE KEY `uq_wa_mq_request` (`request_id`),
  KEY `idx_wa_mq_actor` (`quarantined_by_user_id`),
  KEY `idx_wa_mq_date` (`quarantined_at`,`id`),
  CONSTRAINT `ls_webadmin_f_mq_actor` FOREIGN KEY (`quarantined_by_user_id`) REFERENCES `ls_webadmin_users` (`id`),
  CONSTRAINT `ls_webadmin_f_mq_asset` FOREIGN KEY (`asset_id`) REFERENCES `ls_webadmin_media_assets` (`id`),
  CONSTRAINT `ls_webadmin_c_mq_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_webadmin_c_mq_state` CHECK (`state` = 'quarantined'),
  CONSTRAINT `ls_webadmin_c_mq_asset_version` CHECK (char_length(`asset_version`) = 64),
  CONSTRAINT `ls_webadmin_c_mq_original` CHECK (char_length(`original_storage_prefix`) between 39 and 255),
  CONSTRAINT `ls_webadmin_c_mq_target` CHECK (char_length(`quarantine_storage_prefix`) between 1 and 255),
  CONSTRAINT `ls_webadmin_c_mq_manifest_key` CHECK (char_length(`manifest_storage_key`) between 1 and 255),
  CONSTRAINT `ls_webadmin_c_mq_manifest_json` CHECK (char_length(`manifest_json`) between 2 and 65535),
  CONSTRAINT `ls_webadmin_c_mq_manifest_hash` CHECK (char_length(`manifest_sha256`) = 64),
  CONSTRAINT `ls_webadmin_c_mq_request` CHECK (char_length(`request_id`) = 36),
  CONSTRAINT `ls_webadmin_c_mq_lock` CHECK (`lock_version` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_media_quarantines` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_media_quarantines` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_webadmin_media_quarantines` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_media_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_media_variants` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `asset_id` bigint(20) unsigned NOT NULL,
  `width` int(10) unsigned NOT NULL,
  `height` int(10) unsigned NOT NULL,
  `bytes` bigint(20) unsigned NOT NULL,
  `sha256` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `storage_key` varchar(255) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `mime` varchar(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wa_media_variants_asset_width` (`asset_id`,`width`),
  UNIQUE KEY `uq_wa_media_variants_storage` (`storage_key`),
  KEY `idx_wa_media_variants_asset` (`asset_id`),
  CONSTRAINT `ls_webadmin_f_mv_asset` FOREIGN KEY (`asset_id`) REFERENCES `ls_webadmin_media_assets` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_webadmin_c_mv_dims` CHECK (`width` between 1 and 2560 and `height` between 1 and 2560),
  CONSTRAINT `ls_webadmin_c_mv_bytes` CHECK (`bytes` > 0),
  CONSTRAINT `ls_webadmin_c_mv_hash` CHECK (char_length(`sha256`) = 64),
  CONSTRAINT `ls_webadmin_c_mv_mime` CHECK (`mime` = 'image/avif'),
  CONSTRAINT `ls_webadmin_c_mv_storage` CHECK (char_length(`storage_key`) between 1 and 255)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_media_variants` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_media_variants` DISABLE KEYS */;
INSERT INTO `ls_webadmin_media_variants` VALUES (1,1,480,300,11322,'70b3701ad86d47c0b2d41f02020b8793ea3e76a6d21bcb9a36d213591735093c','ba/ba5e0000-0000-4000-8000-000000000081/480.avif','image/avif','2026-09-24 09:01:00.000000'),(2,1,900,563,28981,'c171cc8544ab32c8add69dad7939caaa28bb4eafa2b3eddb89b20c1825facede','ba/ba5e0000-0000-4000-8000-000000000081/900.avif','image/avif','2026-09-24 09:01:00.000000'),(3,1,1800,1125,62286,'4fd51b1f2dadb949c2dde48839a91e1bddcb01b774a5cfeba77c6ec1c4c1f599','ba/ba5e0000-0000-4000-8000-000000000081/1800.avif','image/avif','2026-09-24 09:01:00.000000'),(4,1,2560,1600,97109,'e6861b46006b95c4aa342685a8229b07779c189864e85648033d1ac965d90626','ba/ba5e0000-0000-4000-8000-000000000081/2560.avif','image/avif','2026-09-24 09:01:00.000000'),(5,2,480,323,7560,'74e78205b310629d389cd6589fd2bccd1d10f8bce297dabf136f92d38141aa3e','ba/ba5e0000-0000-4000-8000-000000000082/480.avif','image/avif','2026-09-24 09:01:00.000000'),(6,2,899,605,24062,'44700a28fff514559915253b043926cc4ab2dee23670422d4cc66633352221da','ba/ba5e0000-0000-4000-8000-000000000082/899.avif','image/avif','2026-09-24 09:01:00.000000'),(7,2,1800,1211,61590,'a93298d8cfb0c40996abfd82bd754fda62753e065b39096523fb70b162e37c2f','ba/ba5e0000-0000-4000-8000-000000000082/1800.avif','image/avif','2026-09-24 09:01:00.000000'),(8,2,2560,1722,100125,'ed5dbf86795ddb63e9afa09c9803c6082284384847119a54888e92fcf4fd4ac7','ba/ba5e0000-0000-4000-8000-000000000082/2560.avif','image/avif','2026-09-24 09:01:00.000000'),(9,3,480,318,17186,'5a56c07f6ea6a9e75322d275cbf74b9d2c4145566987d66da2d81f60ab2843f7','ba/ba5e0000-0000-4000-8000-000000000083/480.avif','image/avif','2026-09-24 09:01:00.000000'),(10,3,900,596,41497,'506bcb6a2b5b062ffdfec60229d3acd721105e3342e71854c9a2093d8de52bae','ba/ba5e0000-0000-4000-8000-000000000083/900.avif','image/avif','2026-09-24 09:01:00.000000'),(11,3,1800,1193,94869,'b44db10c801f615dd28dcb1bc55ed57bc8285008de03861b8033eeac1d880823','ba/ba5e0000-0000-4000-8000-000000000083/1800.avif','image/avif','2026-09-24 09:01:00.000000'),(12,3,2560,1696,158426,'c3f1c0a981eb0a8ec5b4ad47555ea623f35063d6decb151406e51a2428248c9e','ba/ba5e0000-0000-4000-8000-000000000083/2560.avif','image/avif','2026-09-24 09:01:00.000000'),(13,4,480,270,11772,'e4a28038a7f1ddf1aa89e9de644708f69dfa209a68c545f012f8c8d3a0cfb1c9','ba/ba5e0000-0000-4000-8000-000000000084/480.avif','image/avif','2026-09-24 09:01:00.000000'),(14,4,900,506,20968,'3793b3044c1365dc0813eff46e16111733c9ba012eea609225269fa162e54524','ba/ba5e0000-0000-4000-8000-000000000084/900.avif','image/avif','2026-09-24 09:01:00.000000'),(15,4,1800,1013,44783,'694d6cbea062ad0f05234f6d91cda88804ea6caa5f65f20c356be703d3147999','ba/ba5e0000-0000-4000-8000-000000000084/1800.avif','image/avif','2026-09-24 09:01:00.000000'),(16,4,2560,1440,73948,'36ec1581887818d5616ffe77177bbf16763a1989fea10f9604cc8d990e84ee04','ba/ba5e0000-0000-4000-8000-000000000084/2560.avif','image/avif','2026-09-24 09:01:00.000000');
/*!40000 ALTER TABLE `ls_webadmin_media_variants` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_outbox`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_outbox` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `kind` varchar(32) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `user_id` bigint(20) unsigned NOT NULL,
  `locale` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'pending',
  `attempts` int(10) unsigned NOT NULL DEFAULT 0,
  `available_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `locked_at` datetime(6) DEFAULT NULL,
  `lock_token_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `action_token_id` bigint(20) unsigned DEFAULT NULL,
  `last_error_code` varchar(96) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `sent_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wa_outbox_action_token` (`action_token_id`),
  KEY `idx_wa_outbox_delivery` (`status`,`available_at`),
  KEY `idx_wa_outbox_user` (`user_id`),
  CONSTRAINT `ls_webadmin_f_ob_token` FOREIGN KEY (`action_token_id`) REFERENCES `ls_webadmin_action_tokens` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ls_webadmin_f_ob_user` FOREIGN KEY (`user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_webadmin_c_ob_kind` CHECK (`kind` in ('invite','password_reset')),
  CONSTRAINT `ls_webadmin_c_ob_status` CHECK (`status` in ('pending','processing','sent','failed')),
  CONSTRAINT `ls_webadmin_c_ob_lock` CHECK (`status` = 'processing' and `locked_at` is not null and `lock_token_hash` is not null or `status` <> 'processing' and `locked_at` is null and `lock_token_hash` is null),
  CONSTRAINT `ls_webadmin_c_ob_sent` CHECK (`status` = 'sent' and `sent_at` is not null or `status` <> 'sent' and `sent_at` is null),
  CONSTRAINT `ls_webadmin_c_ob_lock_hash` CHECK (`lock_token_hash` is null or char_length(`lock_token_hash`) = 64)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_outbox` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_outbox` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_webadmin_outbox` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_rate_limits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_rate_limits` (
  `action` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `subject_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `window_started_at` datetime(6) NOT NULL,
  `attempts` int(10) unsigned NOT NULL DEFAULT 0,
  `blocked_until` datetime(6) DEFAULT NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`action`,`subject_hash`),
  KEY `idx_wa_rate_limits_blocked` (`blocked_until`),
  CONSTRAINT `ls_webadmin_c_rl_hash` CHECK (char_length(`subject_hash`) = 64)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_rate_limits` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_rate_limits` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_webadmin_rate_limits` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_role_capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_role_capabilities` (
  `role_id` smallint(5) unsigned NOT NULL,
  `capability_id` bigint(20) unsigned NOT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`role_id`,`capability_id`),
  KEY `idx_wa_role_caps_capability` (`capability_id`),
  CONSTRAINT `ls_webadmin_f_rc_cap` FOREIGN KEY (`capability_id`) REFERENCES `ls_webadmin_capabilities` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_webadmin_f_rc_role` FOREIGN KEY (`role_id`) REFERENCES `ls_webadmin_roles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_role_capabilities` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_role_capabilities` DISABLE KEYS */;
INSERT INTO `ls_webadmin_role_capabilities` VALUES (1,1,'2026-09-10 06:12:42.529080'),(1,2,'2026-09-10 06:12:42.529080'),(1,3,'2026-09-10 06:12:42.529080'),(1,4,'2026-09-10 06:12:42.529080'),(1,5,'2026-09-10 06:12:42.529080'),(1,6,'2026-09-10 06:12:42.529080'),(1,7,'2026-09-10 06:12:42.529080'),(1,8,'2026-09-10 06:12:42.529080'),(1,9,'2026-09-10 06:12:42.703748'),(1,10,'2026-09-10 06:12:42.703748'),(1,11,'2026-09-10 06:12:43.483667'),(1,12,'2026-09-10 06:12:44.100355'),(1,13,'2026-09-10 06:12:44.100355'),(1,14,'2026-09-10 06:12:44.100355'),(1,15,'2026-09-10 06:12:44.719976'),(1,16,'2026-09-10 06:12:44.719976'),(1,17,'2026-09-10 06:12:47.731777'),(1,18,'2026-09-10 06:12:48.988108'),(1,19,'2026-09-10 06:12:52.019719'),(1,20,'2026-09-10 06:13:11.439935'),(1,21,'2026-09-10 06:13:11.439935'),(1,22,'2026-09-21 17:23:50.268348'),(1,23,'2026-09-21 17:23:50.268348'),(1,24,'2026-09-21 17:23:50.268348'),(1,25,'2026-09-21 17:23:50.268348'),(1,26,'2026-09-21 17:23:50.268348'),(1,27,'2026-09-21 17:23:50.268348'),(1,28,'2026-09-21 17:23:50.268348'),(1,29,'2026-09-21 17:23:50.268348'),(1,30,'2026-09-21 17:23:50.268348'),(2,1,'2026-09-10 06:12:42.529080'),(2,2,'2026-09-10 06:12:42.529080'),(2,3,'2026-09-10 06:12:42.529080'),(2,4,'2026-09-10 06:12:42.529080'),(2,5,'2026-09-10 06:12:42.529080'),(2,6,'2026-09-10 06:12:42.529080'),(2,7,'2026-09-10 06:12:42.529080'),(2,9,'2026-09-10 06:12:42.703748'),(2,10,'2026-09-10 06:12:42.703748'),(2,11,'2026-09-10 06:12:43.483667'),(2,12,'2026-09-10 06:12:44.100355'),(2,13,'2026-09-10 06:12:44.100355'),(2,14,'2026-09-10 06:12:44.100355'),(2,15,'2026-09-10 06:12:44.719976'),(2,16,'2026-09-10 06:12:44.719976'),(2,17,'2026-09-10 06:12:47.731777'),(2,18,'2026-09-10 06:12:48.988108'),(2,19,'2026-09-10 06:12:52.019719'),(2,20,'2026-09-10 06:13:11.439935'),(2,21,'2026-09-10 06:13:11.439935'),(2,22,'2026-09-21 17:23:50.268348'),(2,23,'2026-09-21 17:23:50.268348'),(2,24,'2026-09-21 17:23:50.268348'),(2,25,'2026-09-21 17:23:50.268348'),(2,26,'2026-09-21 17:23:50.268348'),(2,27,'2026-09-21 17:23:50.268348'),(2,28,'2026-09-21 17:23:50.268348'),(2,29,'2026-09-21 17:23:50.268348'),(2,30,'2026-09-21 17:23:50.268348'),(3,1,'2026-09-10 06:12:42.529080'),(3,2,'2026-09-10 06:12:42.529080');
/*!40000 ALTER TABLE `ls_webadmin_role_capabilities` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_roles` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `label_key` varchar(128) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `is_protected` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `is_delegable` tinyint(3) unsigned NOT NULL DEFAULT 0,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wa_roles_code` (`code`),
  CONSTRAINT `ls_webadmin_c_ro_protect` CHECK (`is_protected` in (0,1)),
  CONSTRAINT `ls_webadmin_c_ro_delegate` CHECK (`is_delegable` in (0,1))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_roles` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_roles` DISABLE KEYS */;
INSERT INTO `ls_webadmin_roles` VALUES (1,'system_superadmin','webadmin.roles.system_superadmin',1,0,'2026-09-10 06:12:42.524827'),(2,'site_admin','webadmin.roles.site_admin',1,0,'2026-09-10 06:12:42.524827'),(3,'editor','webadmin.roles.editor',0,1,'2026-09-10 06:12:42.524827');
/*!40000 ALTER TABLE `ls_webadmin_roles` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_sessions` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `session_type` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `token_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `csrf_token_hash` char(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `auth_version` bigint(20) unsigned DEFAULT NULL,
  `pending_action_token_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `last_seen_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `idle_expires_at` datetime(6) NOT NULL,
  `absolute_expires_at` datetime(6) NOT NULL,
  `revoked_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wa_sessions_public` (`public_id`),
  UNIQUE KEY `uq_wa_sessions_hash` (`token_hash`),
  KEY `idx_wa_sessions_user` (`user_id`,`revoked_at`),
  KEY `idx_wa_sessions_expiry` (`absolute_expires_at`),
  KEY `idx_wa_sessions_pending_token` (`pending_action_token_id`),
  CONSTRAINT `ls_webadmin_f_se_token` FOREIGN KEY (`pending_action_token_id`) REFERENCES `ls_webadmin_action_tokens` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ls_webadmin_f_se_user` FOREIGN KEY (`user_id`) REFERENCES `ls_webadmin_users` (`id`),
  CONSTRAINT `ls_webadmin_c_se_type` CHECK (`session_type` in ('preauth','authenticated')),
  CONSTRAINT `ls_webadmin_c_se_public` CHECK (char_length(`public_id`) = 36),
  CONSTRAINT `ls_webadmin_c_se_hash` CHECK (char_length(`token_hash`) = 64),
  CONSTRAINT `ls_webadmin_c_se_csrf` CHECK (char_length(`csrf_token_hash`) = 64),
  CONSTRAINT `ls_webadmin_c_se_identity` CHECK (`session_type` = 'preauth' and `user_id` is null and `auth_version` is null or `session_type` = 'authenticated' and `user_id` is not null and `auth_version` is not null),
  CONSTRAINT `ls_webadmin_c_se_expiry` CHECK (`idle_expires_at` > `created_at` and `absolute_expires_at` >= `idle_expires_at`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_sessions` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_sessions` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_webadmin_sessions` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_state`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_state` (
  `state_key` varchar(100) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `value_text` longtext NOT NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`state_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_state` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_state` DISABLE KEYS */;
INSERT INTO `ls_webadmin_state` VALUES ('bootstrap.initial_accounts','pending','2026-09-10 06:14:01.788591'),('media.quota_lock','v1','2026-09-10 06:12:42.705068');
/*!40000 ALTER TABLE `ls_webadmin_state` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_user_capabilities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_user_capabilities` (
  `user_id` bigint(20) unsigned NOT NULL,
  `capability_id` bigint(20) unsigned NOT NULL,
  `assigned_by_user_id` bigint(20) unsigned DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`user_id`,`capability_id`),
  KEY `idx_wa_user_caps_capability` (`capability_id`),
  KEY `idx_wa_user_caps_assigner` (`assigned_by_user_id`),
  CONSTRAINT `ls_webadmin_f_uc_by` FOREIGN KEY (`assigned_by_user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ls_webadmin_f_uc_cap` FOREIGN KEY (`capability_id`) REFERENCES `ls_webadmin_capabilities` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_webadmin_f_uc_user` FOREIGN KEY (`user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_user_capabilities` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_user_capabilities` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_webadmin_user_capabilities` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_user_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_user_profiles` (
  `user_id` bigint(20) unsigned NOT NULL,
  `time_zone` varchar(64) CHARACTER SET ascii COLLATE ascii_bin DEFAULT NULL,
  `lock_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  `updated_by_user_id` bigint(20) unsigned NOT NULL,
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`user_id`),
  KEY `idx_wa_profiles_updater` (`updated_by_user_id`),
  CONSTRAINT `ls_webadmin_f_up_updater` FOREIGN KEY (`updated_by_user_id`) REFERENCES `ls_webadmin_users` (`id`),
  CONSTRAINT `ls_webadmin_f_up_user` FOREIGN KEY (`user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_webadmin_c_up_timezone` CHECK (`time_zone` is null or char_length(`time_zone`) between 1 and 64),
  CONSTRAINT `ls_webadmin_c_up_lock` CHECK (`lock_version` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_user_profiles` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_user_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `ls_webadmin_user_profiles` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_user_roles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_user_roles` (
  `user_id` bigint(20) unsigned NOT NULL,
  `role_id` smallint(5) unsigned NOT NULL,
  `assigned_by_user_id` bigint(20) unsigned DEFAULT NULL,
  `source` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL DEFAULT 'manual',
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `idx_wa_user_roles_role` (`role_id`),
  KEY `idx_wa_user_roles_assigner` (`assigned_by_user_id`),
  CONSTRAINT `ls_webadmin_f_ur_by` FOREIGN KEY (`assigned_by_user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ls_webadmin_f_ur_role` FOREIGN KEY (`role_id`) REFERENCES `ls_webadmin_roles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_webadmin_f_ur_user` FOREIGN KEY (`user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `ls_webadmin_c_ur_source` CHECK (`source` in ('bootstrap','manual','system'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_user_roles` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_user_roles` DISABLE KEYS */;
INSERT INTO `ls_webadmin_user_roles` VALUES (1,1,NULL,'bootstrap','2026-09-10 06:14:01.788591'),(2,2,NULL,'bootstrap','2026-09-10 06:14:01.788591');
/*!40000 ALTER TABLE `ls_webadmin_user_roles` ENABLE KEYS */;
UNLOCK TABLES;
DROP TABLE IF EXISTS `ls_webadmin_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ls_webadmin_users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `public_id` char(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `email_canonical` varchar(254) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `display_name` varchar(120) DEFAULT NULL,
  `status` varchar(16) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
  `auth_version` bigint(20) unsigned NOT NULL DEFAULT 1,
  `created_by_user_id` bigint(20) unsigned DEFAULT NULL,
  `invited_at` datetime(6) DEFAULT NULL,
  `activated_at` datetime(6) DEFAULT NULL,
  `suspended_at` datetime(6) DEFAULT NULL,
  `last_login_at` datetime(6) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  `updated_at` datetime(6) NOT NULL DEFAULT current_timestamp(6),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_wa_users_public` (`public_id`),
  UNIQUE KEY `uq_wa_users_email` (`email_canonical`),
  KEY `idx_wa_users_status` (`status`),
  KEY `idx_wa_users_creator` (`created_by_user_id`),
  CONSTRAINT `ls_webadmin_f_us_creator` FOREIGN KEY (`created_by_user_id`) REFERENCES `ls_webadmin_users` (`id`) ON DELETE SET NULL,
  CONSTRAINT `ls_webadmin_c_us_status` CHECK (`status` in ('invited','active','suspended')),
  CONSTRAINT `ls_webadmin_c_us_auth` CHECK (`auth_version` > 0),
  CONSTRAINT `ls_webadmin_c_us_email` CHECK (`email_canonical` = lcase(`email_canonical`)),
  CONSTRAINT `ls_webadmin_c_us_public` CHECK (char_length(`public_id`) = 36)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_users` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_users` DISABLE KEYS */;
INSERT INTO `ls_webadmin_users` VALUES (1,'2de5da73-e752-43d1-ab21-0c4dd31770ac','aranaz@webda.eus',NULL,'invited',1,NULL,'2026-09-10 06:14:01.788591',NULL,NULL,NULL,'2026-09-10 06:14:01.788591','2026-09-10 06:14:01.788591'),(2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','aranaz@gmail.com',NULL,'invited',1,NULL,'2026-09-10 06:14:01.788591',NULL,NULL,NULL,'2026-09-10 06:14:01.788591','2026-09-10 06:14:01.788591');
/*!40000 ALTER TABLE `ls_webadmin_users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
