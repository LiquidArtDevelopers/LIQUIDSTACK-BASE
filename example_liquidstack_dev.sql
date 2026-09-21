
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_categories` WRITE;
/*!40000 ALTER TABLE `ls_blog_categories` DISABLE KEYS */;
INSERT INTO `ls_blog_categories` VALUES (1,'00000000-0000-4000-8000-000000000017','00000000-0000-4000-8000-000000000001','2026-09-10 06:12:57.414198','2026-09-10 06:12:57.414198'),(2,'ba5e0000-0000-4000-8000-000000000001','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:00.000000','2026-09-10 10:00:01.000000'),(3,'ba5e0000-0000-4000-8000-000000000006','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:02.000000','2026-09-10 10:00:03.000000');
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
INSERT INTO `ls_blog_category_assignment_heads` VALUES (1,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:11.000000'),(2,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:20.000000');
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_category_locales` WRITE;
/*!40000 ALTER TABLE `ls_blog_category_locales` DISABLE KEYS */;
INSERT INTO `ls_blog_category_locales` VALUES (1,'00000000-0000-4000-8000-000000000117',1,'und','dummy','Dummy (interno)',1,'00000000-0000-4000-8000-000000000001','00000000-0000-4000-8000-000000000001','2026-09-10 06:12:57.415598','2026-09-10 06:12:57.415598'),(2,'ba5e0000-0000-4000-8000-000000000002',2,'es','novedades','Novedades',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:00.000000','2026-09-10 10:00:00.000000'),(3,'ba5e0000-0000-4000-8000-000000000004',2,'eu','berriak','Berriak',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:01.000000','2026-09-10 10:00:01.000000'),(4,'ba5e0000-0000-4000-8000-000000000007',3,'es','guias','Guías',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:02.000000','2026-09-10 10:00:02.000000'),(5,'ba5e0000-0000-4000-8000-000000000009',3,'eu','gidak','Gidak',1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:03.000000','2026-09-10 10:00:03.000000');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_content_docs` WRITE;
/*!40000 ALTER TABLE `ls_blog_content_docs` DISABLE KEYS */;
INSERT INTO `ls_blog_content_docs` VALUES (1,'ba5e0000-0000-4000-8000-000000000022',1,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000011\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Una base preparada para publicar\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000012\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Este artículo neutro confirma que Blog y WebAdmin están conectados y que el shell público pertenece al proyecto.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000013\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Sustituye este contenido, la identidad visual y los metadatos por los datos reales antes de publicar el sitio.\",\"marks\":[]}]}]}',698,'c2b7b56bd07f91f525b147b5e150b3ffafc52bda55ace6661ff7ec61ccb3d29a','183079d439bec14cd7257d0f91905cbbe5648877e674e9d7cbbfc8b6b2992d25','9dcae8d7d91a9f8fea2f1d37b2778f057b36b583937e47f7de4250288373de72','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:06.000000','2026-09-10 10:00:11.000000'),(2,'ba5e0000-0000-4000-8000-000000000025',2,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000014\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Argitaratzeko prestatutako oinarria\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000015\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Artikulu neutro honek Blog eta WebAdmin konektatuta daudela eta shell publikoa proiektuarena dela egiaztatzen du.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000016\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Ordeztu eduki hau, ikusizko nortasuna eta metadatuak benetako datuekin webgunea argitaratu aurretik.\",\"marks\":[]}]}]}',689,'3157231318293d2150a1c490a3372e598f1550f96e38e763f84fa8189aecb5cf','f6e97eef6ac1d5211105be5610ddb078ff0bed68d5b587f5515f550963574846','d9136d1789d02cabf6c6b05462e12b2d67b795693d986830b73287c20d51f756','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:07.000000','2026-09-10 10:00:12.000000'),(3,'ba5e0000-0000-4000-8000-000000000054',3,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000043\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Separa lo común de lo que pertenece al proyecto\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000044\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"CORE mantiene la parte compartida y BASE conserva las decisiones propias de cada web: rutas, estilos, copy, dominio y configuración.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000045\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Revisa siempre el diff de Composer y versiona el manifiesto gestionado para que las siguientes sincronizaciones distingan una copia canónica de una personalización.\",\"marks\":[]}]}]}',788,'7f218e763d1d85775ed00d403f513aa80816dc4af1dd44a4306309c118abe529','58de5160cf84052fb17e3dd5c9339fa908e7cd0b8784b6bd146a8ee16742723d','19bb2a2489ef5959b0fe3b60c6773a3157e1ed003a34a350257e3dec033b6400','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:15.000000','2026-09-10 10:00:20.000000'),(4,'ba5e0000-0000-4000-8000-000000000057',4,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000046\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Bereizi osagai komunak eta proiektuaren erabakiak\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000047\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"COREk parte partekatua mantentzen du; BASEk, berriz, webgune bakoitzaren ibilbideak, estiloak, testuak, domeinua eta konfigurazioa gordetzen ditu.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000048\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Berrikusi beti Composerren diff-a eta bertsionatu manifestu kudeatua hurrengo sinkronizazioek kopia kanonikoa eta pertsonalizazioa bereiz ditzaten.\",\"marks\":[]}]}]}',783,'34159a37ca2b192fae8401e684967737296c4e149e96775a2bab523145c08e50','52bf0f2f4725493697900ee37dfe2e3d93bc187c59f2ac628bbde3824667e3f8','df85482c68b2f40f3eeae6e6854aed14f6a85617d03f4eb706455486a5271cbc','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:16.000000','2026-09-10 10:00:21.000000');
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
INSERT INTO `ls_blog_content_layout_docs` VALUES (1,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"f8854431-510d-4e80-a81d-d2daa5e2902a\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000011\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Una base preparada para publicar\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000012\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Este artículo neutro confirma que Blog y WebAdmin están conectados y que el shell público pertenece al proyecto.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000013\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Sustituye este contenido, la identidad visual y los metadatos por los datos reales antes de publicar el sitio.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1080,'174dc63cbe15663b8ab16a8140702bf69c9f8e0de339b3254ad3ede32c684385','0bb7696df4f4d6a2b441bfa8cee2c5becdfb458a894336ca7af9c2a600ef39fa'),(2,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"271e10d6-a897-4298-be81-afbac15522b0\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000014\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Argitaratzeko prestatutako oinarria\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000015\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Artikulu neutro honek Blog eta WebAdmin konektatuta daudela eta shell publikoa proiektuarena dela egiaztatzen du.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000016\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Ordeztu eduki hau, ikusizko nortasuna eta metadatuak benetako datuekin webgunea argitaratu aurretik.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1071,'f46cc081cebd1ad913e68c617d30fc83261a1527561f5678c542cfb23663ecfc','49a8ae0dad9e5fd6a22c1ada95f79a2ea197e90c5dfe59dc59218097f2243f14'),(3,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"6949d553-3353-41e3-bc81-f8a87bef498e\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000043\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Separa lo común de lo que pertenece al proyecto\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000044\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"CORE mantiene la parte compartida y BASE conserva las decisiones propias de cada web: rutas, estilos, copy, dominio y configuración.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000045\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Revisa siempre el diff de Composer y versiona el manifiesto gestionado para que las siguientes sincronizaciones distingan una copia canónica de una personalización.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1170,'c430a79ba35685a5c96531a5a72ce60cd227bf9c226e15400b8b5536bc5340ab','f72a320b30921e6660ae4776d389ce2b503a17e40ffed586a2c88b6ae0ca9ab4'),(4,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"e029e2ee-b06d-480e-91ec-353639f510e4\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000046\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Bereizi osagai komunak eta proiektuaren erabakiak\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000047\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"COREk parte partekatua mantentzen du; BASEk, berriz, webgune bakoitzaren ibilbideak, estiloak, testuak, domeinua eta konfigurazioa gordetzen ditu.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000048\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Berrikusi beti Composerren diff-a eta bertsionatu manifestu kudeatua hurrengo sinkronizazioek kopia kanonikoa eta pertsonalizazioa bereiz ditzaten.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1165,'8be7e04e3b4e916d63b5d94b796f1b57a8ba160ea684efa169abfc93e557822b','82ff75e4cd446157ce73b03315804ec094c0f512008760e3d5426c46105129f8');
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
INSERT INTO `ls_blog_content_layout_revisions` VALUES (1,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"f8854431-510d-4e80-a81d-d2daa5e2902a\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000011\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Una base preparada para publicar\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000012\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Este artículo neutro confirma que Blog y WebAdmin están conectados y que el shell público pertenece al proyecto.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000013\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Sustituye este contenido, la identidad visual y los metadatos por los datos reales antes de publicar el sitio.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1080,'174dc63cbe15663b8ab16a8140702bf69c9f8e0de339b3254ad3ede32c684385','0bb7696df4f4d6a2b441bfa8cee2c5becdfb458a894336ca7af9c2a600ef39fa'),(2,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"271e10d6-a897-4298-be81-afbac15522b0\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000014\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Argitaratzeko prestatutako oinarria\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000015\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Artikulu neutro honek Blog eta WebAdmin konektatuta daudela eta shell publikoa proiektuarena dela egiaztatzen du.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000016\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Ordeztu eduki hau, ikusizko nortasuna eta metadatuak benetako datuekin webgunea argitaratu aurretik.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1071,'f46cc081cebd1ad913e68c617d30fc83261a1527561f5678c542cfb23663ecfc','49a8ae0dad9e5fd6a22c1ada95f79a2ea197e90c5dfe59dc59218097f2243f14'),(3,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"f8854431-510d-4e80-a81d-d2daa5e2902a\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000011\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Una base preparada para publicar\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000012\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Este artículo neutro confirma que Blog y WebAdmin están conectados y que el shell público pertenece al proyecto.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000013\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Sustituye este contenido, la identidad visual y los metadatos por los datos reales antes de publicar el sitio.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1080,'174dc63cbe15663b8ab16a8140702bf69c9f8e0de339b3254ad3ede32c684385','0bb7696df4f4d6a2b441bfa8cee2c5becdfb458a894336ca7af9c2a600ef39fa'),(4,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"271e10d6-a897-4298-be81-afbac15522b0\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000014\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Argitaratzeko prestatutako oinarria\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000015\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Artikulu neutro honek Blog eta WebAdmin konektatuta daudela eta shell publikoa proiektuarena dela egiaztatzen du.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000016\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Ordeztu eduki hau, ikusizko nortasuna eta metadatuak benetako datuekin webgunea argitaratu aurretik.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1071,'f46cc081cebd1ad913e68c617d30fc83261a1527561f5678c542cfb23663ecfc','49a8ae0dad9e5fd6a22c1ada95f79a2ea197e90c5dfe59dc59218097f2243f14'),(5,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"6949d553-3353-41e3-bc81-f8a87bef498e\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000043\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Separa lo común de lo que pertenece al proyecto\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000044\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"CORE mantiene la parte compartida y BASE conserva las decisiones propias de cada web: rutas, estilos, copy, dominio y configuración.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000045\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Revisa siempre el diff de Composer y versiona el manifiesto gestionado para que las siguientes sincronizaciones distingan una copia canónica de una personalización.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1170,'c430a79ba35685a5c96531a5a72ce60cd227bf9c226e15400b8b5536bc5340ab','f72a320b30921e6660ae4776d389ce2b503a17e40ffed586a2c88b6ae0ca9ab4'),(6,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"e029e2ee-b06d-480e-91ec-353639f510e4\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000046\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Bereizi osagai komunak eta proiektuaren erabakiak\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000047\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"COREk parte partekatua mantentzen du; BASEk, berriz, webgune bakoitzaren ibilbideak, estiloak, testuak, domeinua eta konfigurazioa gordetzen ditu.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000048\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Berrikusi beti Composerren diff-a eta bertsionatu manifestu kudeatua hurrengo sinkronizazioek kopia kanonikoa eta pertsonalizazioa bereiz ditzaten.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1165,'8be7e04e3b4e916d63b5d94b796f1b57a8ba160ea684efa169abfc93e557822b','82ff75e4cd446157ce73b03315804ec094c0f512008760e3d5426c46105129f8'),(7,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"6949d553-3353-41e3-bc81-f8a87bef498e\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000043\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Separa lo común de lo que pertenece al proyecto\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000044\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"CORE mantiene la parte compartida y BASE conserva las decisiones propias de cada web: rutas, estilos, copy, dominio y configuración.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000045\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Revisa siempre el diff de Composer y versiona el manifiesto gestionado para que las siguientes sincronizaciones distingan una copia canónica de una personalización.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1170,'c430a79ba35685a5c96531a5a72ce60cd227bf9c226e15400b8b5536bc5340ab','f72a320b30921e6660ae4776d389ce2b503a17e40ffed586a2c88b6ae0ca9ab4'),(8,2,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":2,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"e029e2ee-b06d-480e-91ec-353639f510e4\",\"type\":\"section\",\"children\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000046\",\"type\":\"paragraph\",\"content\":[{\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Bereizi osagai komunak eta proiektuaren erabakiak\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000047\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"COREk parte partekatua mantentzen du; BASEk, berriz, webgune bakoitzaren ibilbideak, estiloak, testuak, domeinua eta konfigurazioa gordetzen ditu.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}},{\"id\":\"ba5e0000-0000-4000-8000-000000000048\",\"type\":\"paragraph\",\"content\":[{\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Berrikusi beti Composerren diff-a eta bertsionatu manifestu kudeatua hurrengo sinkronizazioek kopia kanonikoa eta pertsonalizazioa bereiz ditzaten.\",\"marks\":[]}]}],\"presentation\":{\"width\":\"full\",\"align\":\"start\",\"text_align\":\"start\"}}]}]}',1165,'8be7e04e3b4e916d63b5d94b796f1b57a8ba160ea684efa169abfc93e557822b','82ff75e4cd446157ce73b03315804ec094c0f512008760e3d5426c46105129f8');
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
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_content_revisions` WRITE;
/*!40000 ALTER TABLE `ls_blog_content_revisions` DISABLE KEYS */;
INSERT INTO `ls_blog_content_revisions` VALUES (1,'ba5e0000-0000-4000-8000-000000000023',1,1,2,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000011\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Una base preparada para publicar\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000012\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Este artículo neutro confirma que Blog y WebAdmin están conectados y que el shell público pertenece al proyecto.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000013\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Sustituye este contenido, la identidad visual y los metadatos por los datos reales antes de publicar el sitio.\",\"marks\":[]}]}]}',698,'c2b7b56bd07f91f525b147b5e150b3ffafc52bda55ace6661ff7ec61ccb3d29a','183079d439bec14cd7257d0f91905cbbe5648877e674e9d7cbbfc8b6b2992d25','9dcae8d7d91a9f8fea2f1d37b2778f057b36b583937e47f7de4250288373de72','Bienvenido al blog de tu nuevo proyecto','bienvenido-blog-nuevo-proyecto','Bienvenido al blog del proyecto de ejemplo','Artículo demostrativo de LiquidStack BASE para comprobar un blog bilingüe, sus categorías, etiquetas y publicación pública.','Un primer contenido neutro para validar la instalación del blog.','Una base preparada para publicar\n\nEste artículo neutro confirma que Blog y WebAdmin están conectados y que el shell público pertenece al proyecto.\n\nSustituye este contenido, la identidad visual y los metadatos por los datos reales antes de publicar el sitio.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:06.000000'),(2,'ba5e0000-0000-4000-8000-000000000026',2,1,2,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000014\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Argitaratzeko prestatutako oinarria\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000015\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Artikulu neutro honek Blog eta WebAdmin konektatuta daudela eta shell publikoa proiektuarena dela egiaztatzen du.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000016\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Ordeztu eduki hau, ikusizko nortasuna eta metadatuak benetako datuekin webgunea argitaratu aurretik.\",\"marks\":[]}]}]}',689,'3157231318293d2150a1c490a3372e598f1550f96e38e763f84fa8189aecb5cf','f6e97eef6ac1d5211105be5610ddb078ff0bed68d5b587f5515f550963574846','d9136d1789d02cabf6c6b05462e12b2d67b795693d986830b73287c20d51f756','Ongi etorri zure proiektu berriaren blogera','ongi-etorri-proiektu-berriaren-blogera','Ongi etorri adibideko proiektuaren blogera','LiquidStack BASEren demo-artikulua, blog elebiduna, kategoriak, etiketak eta argitalpen publikoa egiaztatzeko.','Blogaren instalazioa egiaztatzeko lehen eduki neutroa.','Argitaratzeko prestatutako oinarria\n\nArtikulu neutro honek Blog eta WebAdmin konektatuta daudela eta shell publikoa proiektuarena dela egiaztatzen du.\n\nOrdeztu eduki hau, ikusizko nortasuna eta metadatuak benetako datuekin webgunea argitaratu aurretik.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:07.000000'),(3,'ba5e0000-0000-4000-8000-000000000038',1,2,3,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000011\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Una base preparada para publicar\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000012\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Este artículo neutro confirma que Blog y WebAdmin están conectados y que el shell público pertenece al proyecto.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000013\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Sustituye este contenido, la identidad visual y los metadatos por los datos reales antes de publicar el sitio.\",\"marks\":[]}]}]}',698,'c2b7b56bd07f91f525b147b5e150b3ffafc52bda55ace6661ff7ec61ccb3d29a','183079d439bec14cd7257d0f91905cbbe5648877e674e9d7cbbfc8b6b2992d25','9dcae8d7d91a9f8fea2f1d37b2778f057b36b583937e47f7de4250288373de72','Bienvenido al blog de tu nuevo proyecto','bienvenido-blog-nuevo-proyecto','Bienvenido al blog del proyecto de ejemplo','Artículo demostrativo de LiquidStack BASE para comprobar un blog bilingüe, sus categorías, etiquetas y publicación pública.','Un primer contenido neutro para validar la instalación del blog.','Una base preparada para publicar\n\nEste artículo neutro confirma que Blog y WebAdmin están conectados y que el shell público pertenece al proyecto.\n\nSustituye este contenido, la identidad visual y los metadatos por los datos reales antes de publicar el sitio.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:11.000000'),(4,'ba5e0000-0000-4000-8000-000000000041',2,2,3,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000014\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Argitaratzeko prestatutako oinarria\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000015\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Artikulu neutro honek Blog eta WebAdmin konektatuta daudela eta shell publikoa proiektuarena dela egiaztatzen du.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000016\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Ordeztu eduki hau, ikusizko nortasuna eta metadatuak benetako datuekin webgunea argitaratu aurretik.\",\"marks\":[]}]}]}',689,'3157231318293d2150a1c490a3372e598f1550f96e38e763f84fa8189aecb5cf','f6e97eef6ac1d5211105be5610ddb078ff0bed68d5b587f5515f550963574846','d9136d1789d02cabf6c6b05462e12b2d67b795693d986830b73287c20d51f756','Ongi etorri zure proiektu berriaren blogera','ongi-etorri-proiektu-berriaren-blogera','Ongi etorri adibideko proiektuaren blogera','LiquidStack BASEren demo-artikulua, blog elebiduna, kategoriak, etiketak eta argitalpen publikoa egiaztatzeko.','Blogaren instalazioa egiaztatzeko lehen eduki neutroa.','Argitaratzeko prestatutako oinarria\n\nArtikulu neutro honek Blog eta WebAdmin konektatuta daudela eta shell publikoa proiektuarena dela egiaztatzen du.\n\nOrdeztu eduki hau, ikusizko nortasuna eta metadatuak benetako datuekin webgunea argitaratu aurretik.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:12.000000'),(5,'ba5e0000-0000-4000-8000-000000000055',3,1,2,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000043\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Separa lo común de lo que pertenece al proyecto\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000044\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"CORE mantiene la parte compartida y BASE conserva las decisiones propias de cada web: rutas, estilos, copy, dominio y configuración.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000045\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Revisa siempre el diff de Composer y versiona el manifiesto gestionado para que las siguientes sincronizaciones distingan una copia canónica de una personalización.\",\"marks\":[]}]}]}',788,'7f218e763d1d85775ed00d403f513aa80816dc4af1dd44a4306309c118abe529','58de5160cf84052fb17e3dd5c9339fa908e7cd0b8784b6bd146a8ee16742723d','19bb2a2489ef5959b0fe3b60c6773a3157e1ed003a34a350257e3dec033b6400','Cómo personalizar BASE sin perder actualizaciones','personalizar-base-sin-perder-actualizaciones','Personalizar LiquidStack BASE con seguridad','Guía de ejemplo para separar recursos comunes y personalizaciones al actualizar un proyecto creado con LiquidStack BASE.','Una guía breve para adaptar el starter manteniendo actualizable el núcleo.','Separa lo común de lo que pertenece al proyecto\n\nCORE mantiene la parte compartida y BASE conserva las decisiones propias de cada web: rutas, estilos, copy, dominio y configuración.\n\nRevisa siempre el diff de Composer y versiona el manifiesto gestionado para que las siguientes sincronizaciones distingan una copia canónica de una personalización.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:15.000000'),(6,'ba5e0000-0000-4000-8000-000000000058',4,1,2,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000046\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Bereizi osagai komunak eta proiektuaren erabakiak\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000047\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"COREk parte partekatua mantentzen du; BASEk, berriz, webgune bakoitzaren ibilbideak, estiloak, testuak, domeinua eta konfigurazioa gordetzen ditu.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000048\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Berrikusi beti Composerren diff-a eta bertsionatu manifestu kudeatua hurrengo sinkronizazioek kopia kanonikoa eta pertsonalizazioa bereiz ditzaten.\",\"marks\":[]}]}]}',783,'34159a37ca2b192fae8401e684967737296c4e149e96775a2bab523145c08e50','52bf0f2f4725493697900ee37dfe2e3d93bc187c59f2ac628bbde3824667e3f8','df85482c68b2f40f3eeae6e6854aed14f6a85617d03f4eb706455486a5271cbc','Nola pertsonalizatu BASE eguneraketak galdu gabe','base-pertsonalizatu-eguneraketak-galdu-gabe','LiquidStack BASE modu seguruan pertsonalizatzea','Adibideko gida, LiquidStack BASE proiektu bat eguneratzean osagai komunak eta pertsonalizazioak bereizteko.','Starterra egokitzeko eta nukleoa eguneragarri mantentzeko gida laburra.','Bereizi osagai komunak eta proiektuaren erabakiak\n\nCOREk parte partekatua mantentzen du; BASEk, berriz, webgune bakoitzaren ibilbideak, estiloak, testuak, domeinua eta konfigurazioa gordetzen ditu.\n\nBerrikusi beti Composerren diff-a eta bertsionatu manifestu kudeatua hurrengo sinkronizazioek kopia kanonikoa eta pertsonalizazioa bereiz ditzaten.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:16.000000'),(7,'ba5e0000-0000-4000-8000-000000000068',3,2,3,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000043\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Separa lo común de lo que pertenece al proyecto\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000044\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"CORE mantiene la parte compartida y BASE conserva las decisiones propias de cada web: rutas, estilos, copy, dominio y configuración.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000045\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Revisa siempre el diff de Composer y versiona el manifiesto gestionado para que las siguientes sincronizaciones distingan una copia canónica de una personalización.\",\"marks\":[]}]}]}',788,'7f218e763d1d85775ed00d403f513aa80816dc4af1dd44a4306309c118abe529','58de5160cf84052fb17e3dd5c9339fa908e7cd0b8784b6bd146a8ee16742723d','19bb2a2489ef5959b0fe3b60c6773a3157e1ed003a34a350257e3dec033b6400','Cómo personalizar BASE sin perder actualizaciones','personalizar-base-sin-perder-actualizaciones','Personalizar LiquidStack BASE con seguridad','Guía de ejemplo para separar recursos comunes y personalizaciones al actualizar un proyecto creado con LiquidStack BASE.','Una guía breve para adaptar el starter manteniendo actualizable el núcleo.','Separa lo común de lo que pertenece al proyecto\n\nCORE mantiene la parte compartida y BASE conserva las decisiones propias de cada web: rutas, estilos, copy, dominio y configuración.\n\nRevisa siempre el diff de Composer y versiona el manifiesto gestionado para que las siguientes sincronizaciones distingan una copia canónica de una personalización.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:20.000000'),(8,'ba5e0000-0000-4000-8000-000000000071',4,2,3,1,'article-basic-01','{\"schema\":\"liquidstack.blog.document\",\"version\":1,\"template\":\"article-basic-01\",\"blocks\":[{\"id\":\"ba5e0000-0000-4000-8000-000000000046\",\"type\":\"heading\",\"level\":2,\"content\":[{\"type\":\"text\",\"text\":\"Bereizi osagai komunak eta proiektuaren erabakiak\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000047\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"COREk parte partekatua mantentzen du; BASEk, berriz, webgune bakoitzaren ibilbideak, estiloak, testuak, domeinua eta konfigurazioa gordetzen ditu.\",\"marks\":[]}]},{\"id\":\"ba5e0000-0000-4000-8000-000000000048\",\"type\":\"paragraph\",\"content\":[{\"type\":\"text\",\"text\":\"Berrikusi beti Composerren diff-a eta bertsionatu manifestu kudeatua hurrengo sinkronizazioek kopia kanonikoa eta pertsonalizazioa bereiz ditzaten.\",\"marks\":[]}]}]}',783,'34159a37ca2b192fae8401e684967737296c4e149e96775a2bab523145c08e50','52bf0f2f4725493697900ee37dfe2e3d93bc187c59f2ac628bbde3824667e3f8','df85482c68b2f40f3eeae6e6854aed14f6a85617d03f4eb706455486a5271cbc','Nola pertsonalizatu BASE eguneraketak galdu gabe','base-pertsonalizatu-eguneraketak-galdu-gabe','LiquidStack BASE modu seguruan pertsonalizatzea','Adibideko gida, LiquidStack BASE proiektu bat eguneratzean osagai komunak eta pertsonalizazioak bereizteko.','Starterra egokitzeko eta nukleoa eguneragarri mantentzeko gida laburra.','Bereizi osagai komunak eta proiektuaren erabakiak\n\nCOREk parte partekatua mantentzen du; BASEk, berriz, webgune bakoitzaren ibilbideak, estiloak, testuak, domeinua eta konfigurazioa gordetzen ditu.\n\nBerrikusi beti Composerren diff-a eta bertsionatu manifestu kudeatua hurrengo sinkronizazioek kopia kanonikoa eta pertsonalizazioa bereiz ditzaten.','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:21.000000');
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
INSERT INTO `ls_blog_localization_tags` VALUES (1,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:11.000000'),(1,2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:11.000000'),(1,3,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:11.000000'),(2,4,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:12.000000'),(2,5,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:12.000000'),(2,6,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:12.000000'),(3,2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:20.000000'),(3,7,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:20.000000'),(3,8,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:20.000000'),(4,6,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:21.000000'),(4,9,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:21.000000'),(4,10,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:21.000000');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_post_categories` WRITE;
/*!40000 ALTER TABLE `ls_blog_post_categories` DISABLE KEYS */;
INSERT INTO `ls_blog_post_categories` VALUES (1,'ba5e0000-0000-4000-8000-000000000039',1,2,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:11.000000','2026-09-10 10:00:11.000000'),(2,'ba5e0000-0000-4000-8000-000000000069',2,3,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:20.000000','2026-09-10 10:00:20.000000');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_post_localizations` WRITE;
/*!40000 ALTER TABLE `ls_blog_post_localizations` DISABLE KEYS */;
INSERT INTO `ls_blog_post_localizations` VALUES (1,'ba5e0000-0000-4000-8000-000000000018',1,'es','bienvenido-blog-nuevo-proyecto','Bienvenido al blog de tu nuevo proyecto','Bienvenido al blog del proyecto de ejemplo','Artículo demostrativo de LiquidStack BASE para comprobar un blog bilingüe, sus categorías, etiquetas y publicación pública.','Un primer contenido neutro para validar la instalación del blog.','Una base preparada para publicar\n\nEste artículo neutro confirma que Blog y WebAdmin están conectados y que el shell público pertenece al proyecto.\n\nSustituye este contenido, la identidad visual y los metadatos por los datos reales antes de publicar el sitio.','published','2026-09-10 10:00:11.000000',3,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:04.000000','2026-09-10 10:00:11.000000'),(2,'ba5e0000-0000-4000-8000-000000000020',1,'eu','ongi-etorri-proiektu-berriaren-blogera','Ongi etorri zure proiektu berriaren blogera','Ongi etorri adibideko proiektuaren blogera','LiquidStack BASEren demo-artikulua, blog elebiduna, kategoriak, etiketak eta argitalpen publikoa egiaztatzeko.','Blogaren instalazioa egiaztatzeko lehen eduki neutroa.','Argitaratzeko prestatutako oinarria\n\nArtikulu neutro honek Blog eta WebAdmin konektatuta daudela eta shell publikoa proiektuarena dela egiaztatzen du.\n\nOrdeztu eduki hau, ikusizko nortasuna eta metadatuak benetako datuekin webgunea argitaratu aurretik.','published','2026-09-10 10:00:12.000000',3,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:05.000000','2026-09-10 10:00:12.000000'),(3,'ba5e0000-0000-4000-8000-000000000050',2,'es','personalizar-base-sin-perder-actualizaciones','Cómo personalizar BASE sin perder actualizaciones','Personalizar LiquidStack BASE con seguridad','Guía de ejemplo para separar recursos comunes y personalizaciones al actualizar un proyecto creado con LiquidStack BASE.','Una guía breve para adaptar el starter manteniendo actualizable el núcleo.','Separa lo común de lo que pertenece al proyecto\n\nCORE mantiene la parte compartida y BASE conserva las decisiones propias de cada web: rutas, estilos, copy, dominio y configuración.\n\nRevisa siempre el diff de Composer y versiona el manifiesto gestionado para que las siguientes sincronizaciones distingan una copia canónica de una personalización.','published','2026-09-10 10:00:20.000000',3,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:13.000000','2026-09-10 10:00:20.000000'),(4,'ba5e0000-0000-4000-8000-000000000052',2,'eu','base-pertsonalizatu-eguneraketak-galdu-gabe','Nola pertsonalizatu BASE eguneraketak galdu gabe','LiquidStack BASE modu seguruan pertsonalizatzea','Adibideko gida, LiquidStack BASE proiektu bat eguneratzean osagai komunak eta pertsonalizazioak bereizteko.','Starterra egokitzeko eta nukleoa eguneragarri mantentzeko gida laburra.','Bereizi osagai komunak eta proiektuaren erabakiak\n\nCOREk parte partekatua mantentzen du; BASEk, berriz, webgune bakoitzaren ibilbideak, estiloak, testuak, domeinua eta konfigurazioa gordetzen ditu.\n\nBerrikusi beti Composerren diff-a eta bertsionatu manifestu kudeatua hurrengo sinkronizazioek kopia kanonikoa eta pertsonalizazioa bereiz ditzaten.','published','2026-09-10 10:00:21.000000',3,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:14.000000','2026-09-10 10:00:21.000000');
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_blog_posts` WRITE;
/*!40000 ALTER TABLE `ls_blog_posts` DISABLE KEYS */;
INSERT INTO `ls_blog_posts` VALUES (1,'ba5e0000-0000-4000-8000-000000000017','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:04.000000','2026-09-10 10:00:12.000000'),(2,'ba5e0000-0000-4000-8000-000000000049','7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:13.000000','2026-09-10 10:00:21.000000');
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
INSERT INTO `ls_blog_publication_heads` VALUES (1,3,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:11.000000'),(2,4,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:12.000000'),(3,7,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:20.000000'),(4,8,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:21.000000');
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
INSERT INTO `ls_blog_robots_settings` VALUES (1,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(2,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(3,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47'),(4,1,1,'10eaff3d0866fb93d64420fcadd2a45adcc604941367bd31bcc28a6c80b43d47');
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
INSERT INTO `ls_blog_tag_assignment_heads` VALUES (1,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:11.000000'),(2,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:12.000000'),(3,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:20.000000'),(4,1,'7ca1c44d-4dad-40dd-beb2-d23b1ef71304','2026-09-10 10:00:21.000000');
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
INSERT INTO `ls_blog_url_history` VALUES (1,'es','bienvenido-blog-nuevo-proyecto','active',NULL,'2026-09-10 10:00:11.000000','2026-09-10 10:00:11.000000'),(3,'es','personalizar-base-sin-perder-actualizaciones','active',NULL,'2026-09-10 10:00:20.000000','2026-09-10 10:00:20.000000'),(4,'eu','base-pertsonalizatu-eguneraketak-galdu-gabe','active',NULL,'2026-09-10 10:00:21.000000','2026-09-10 10:00:21.000000'),(2,'eu','ongi-etorri-proiektu-berriaren-blogera','active',NULL,'2026-09-10 10:00:12.000000','2026-09-10 10:00:12.000000');
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_media_assets` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_media_assets` DISABLE KEYS */;
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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

LOCK TABLES `ls_webadmin_media_variants` WRITE;
/*!40000 ALTER TABLE `ls_webadmin_media_variants` DISABLE KEYS */;
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
