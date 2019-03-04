# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.20)
# Database: OnlineExam
# Generation Time: 2019-03-01 11:10:17 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table admin_portal_answer
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_portal_answer`;

CREATE TABLE `admin_portal_answer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `is_correct` tinyint(1) NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `question_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_portal_answer_question_id_48f2c3c3_fk_admin_por` (`question_id`),
  CONSTRAINT `admin_portal_answer_question_id_48f2c3c3_fk_admin_por` FOREIGN KEY (`question_id`) REFERENCES `admin_portal_question` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `admin_portal_answer` WRITE;
/*!40000 ALTER TABLE `admin_portal_answer` DISABLE KEYS */;

INSERT INTO `admin_portal_answer` (`id`, `description`, `is_correct`, `created_at`, `updated_at`, `question_id`)
VALUES
	(1,'12345678',0,'2017-11-25 14:48:12.035653',NULL,1),
	(2,'java',0,'2017-11-25 14:55:58.221049',NULL,2),
	(3,'javacmp',0,'2017-11-25 14:55:58.221106',NULL,2),
	(4,'javac',0,'2017-11-25 14:55:58.221158',NULL,2),
	(5,'jcompile',0,'2017-11-25 14:55:58.221201',NULL,2),
	(6,'25%',0,'2017-11-25 14:57:47.877795',NULL,3),
	(7,'$@#%#$%#$%#$%#',0,'2017-11-25 15:03:19.548119',NULL,4),
	(8,'check1',0,'2017-11-25 14:55:58.221201',NULL,5),
	(9,'check2',0,'2017-11-25 14:55:58.221201',NULL,5),
	(10,'check3',0,'2017-11-25 14:55:58.221201',NULL,5),
	(11,'check4',0,'2017-11-25 14:55:58.221201',NULL,5);

/*!40000 ALTER TABLE `admin_portal_answer` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_portal_college
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_portal_college`;

CREATE TABLE `admin_portal_college` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `logo` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contact` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `code` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `admin_portal_college` WRITE;
/*!40000 ALTER TABLE `admin_portal_college` DISABLE KEYS */;

INSERT INTO `admin_portal_college` (`id`, `name`, `logo`, `contact`, `email`, `code`, `token`, `created_at`, `updated_at`)
VALUES
	(1,'PSNA',NULL,'9677399178','psna@gmail.com',NULL,'523bf7afbf754b17bb191b09a25ff2f3','2017-11-25 14:05:40.128447',NULL),
	(2,'SRM',NULL,'9677399178','srm@gmail.com',NULL,'cd9a3702c0274ee39aac603d1f4bf3cb','2017-11-25 14:06:58.225586',NULL),
	(3,'SRM',NULL,'9677399178','srm@gmail.com',NULL,'59c8ee28807e46ea811b710ede82726c','2017-11-29 10:18:52.305065',NULL);

/*!40000 ALTER TABLE `admin_portal_college` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_portal_question
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_portal_question`;

CREATE TABLE `admin_portal_question` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(1500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `question_type` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `admin_portal_question` WRITE;
/*!40000 ALTER TABLE `admin_portal_question` DISABLE KEYS */;

INSERT INTO `admin_portal_question` (`id`, `description`, `question_type`, `created_at`, `updated_at`)
VALUES
	(1,'Please write the first eight triangular numbers.','fill_up','2017-11-25 14:48:12.027987',NULL),
	(2,'Which of the following is the default java compiler binary?','objective','2017-11-25 14:55:58.214897',NULL),
	(3,'How big is a 12” pizza, when compared to a 9” pizza? Express in percentage.','fill_up','2017-11-25 14:57:47.870670',NULL),
	(4,'When t = \'Yes\' and s = \'Minister\', what would <code>{ while ((*s++ = *t++) != \'0\') } return?<code>','code','2017-11-25 15:03:19.541697',NULL),
	(5,'Check the following which all are correct.','checkbox','2017-11-25 14:55:58.214897',NULL);

/*!40000 ALTER TABLE `admin_portal_question` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table admin_portal_questionset
# ------------------------------------------------------------

DROP TABLE IF EXISTS `admin_portal_questionset`;

CREATE TABLE `admin_portal_questionset` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question_arr` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `time_limit` int(11) DEFAULT NULL,
  `created_at` datetime(6) NOT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `college_id` int(11) DEFAULT NULL,
  `identifier` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `admin_portal_questio_college_id_e3c05f4e_fk_admin_por` (`college_id`),
  CONSTRAINT `admin_portal_questio_college_id_e3c05f4e_fk_admin_por` FOREIGN KEY (`college_id`) REFERENCES `admin_portal_college` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `admin_portal_questionset` WRITE;
/*!40000 ALTER TABLE `admin_portal_questionset` DISABLE KEYS */;

INSERT INTO `admin_portal_questionset` (`id`, `question_arr`, `time_limit`, `created_at`, `updated_at`, `college_id`, `identifier`, `name`)
VALUES
	(54,'[1, 2, 3, 4,5]',40,'2017-11-25 23:43:59.295321',NULL,1,'c40fa915','Version 2'),
	(55,NULL,30,'2017-11-25 23:46:35.545701',NULL,NULL,'2beb3d91','Version 1'),
	(56,NULL,30,'2017-11-25 23:47:31.632503',NULL,NULL,'8b508764','Version 1'),
	(57,NULL,30,'2017-11-25 23:48:02.289865',NULL,NULL,'6f650138','Version 1'),
	(58,NULL,30,'2017-11-25 23:48:49.555729',NULL,NULL,'690406fd','Version 1'),
	(59,NULL,30,'2017-11-25 23:48:58.360633',NULL,NULL,'eed2c3bb','Version 1'),
	(60,NULL,30,'2017-11-25 23:49:24.521697',NULL,NULL,'0d72748e','Version 1'),
	(61,NULL,30,'2017-11-25 23:52:00.437675',NULL,NULL,'55b5a386','Version 1'),
	(62,'[1, 2, 3, 4]',30,'2017-11-25 23:52:21.611746',NULL,NULL,'6717af25','Version 1'),
	(63,'[1, 2, 3, 4]',30,'2017-11-25 23:52:34.553474',NULL,NULL,'6d85f405','Version 1');

/*!40000 ALTER TABLE `admin_portal_questionset` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table auth_group
# ------------------------------------------------------------

DROP TABLE IF EXISTS `auth_group`;

CREATE TABLE `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table auth_group_permissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `auth_group_permissions`;

CREATE TABLE `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table auth_permission
# ------------------------------------------------------------

DROP TABLE IF EXISTS `auth_permission`;

CREATE TABLE `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`),
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `auth_permission` WRITE;
/*!40000 ALTER TABLE `auth_permission` DISABLE KEYS */;

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`)
VALUES
	(1,'Can add log entry',1,'add_logentry'),
	(2,'Can change log entry',1,'change_logentry'),
	(3,'Can delete log entry',1,'delete_logentry'),
	(4,'Can add group',2,'add_group'),
	(5,'Can change group',2,'change_group'),
	(6,'Can delete group',2,'delete_group'),
	(7,'Can add permission',3,'add_permission'),
	(8,'Can change permission',3,'change_permission'),
	(9,'Can delete permission',3,'delete_permission'),
	(10,'Can add user',4,'add_user'),
	(11,'Can change user',4,'change_user'),
	(12,'Can delete user',4,'delete_user'),
	(13,'Can add content type',5,'add_contenttype'),
	(14,'Can change content type',5,'change_contenttype'),
	(15,'Can delete content type',5,'delete_contenttype'),
	(16,'Can add session',6,'add_session'),
	(17,'Can change session',6,'change_session'),
	(18,'Can delete session',6,'delete_session'),
	(19,'Can add student answer',7,'add_studentanswer'),
	(20,'Can change student answer',7,'change_studentanswer'),
	(21,'Can delete student answer',7,'delete_studentanswer'),
	(22,'Can add student',8,'add_student'),
	(23,'Can change student',8,'change_student'),
	(24,'Can delete student',8,'delete_student'),
	(25,'Can add question',9,'add_question'),
	(26,'Can change question',9,'change_question'),
	(27,'Can delete question',9,'delete_question'),
	(28,'Can add college',10,'add_college'),
	(29,'Can change college',10,'change_college'),
	(30,'Can delete college',10,'delete_college'),
	(31,'Can add question set',11,'add_questionset'),
	(32,'Can change question set',11,'change_questionset'),
	(33,'Can delete question set',11,'delete_questionset'),
	(34,'Can add answer',12,'add_answer'),
	(35,'Can change answer',12,'change_answer'),
	(36,'Can delete answer',12,'delete_answer'),
	(37,'Can add college question set',13,'add_collegequestionset'),
	(38,'Can change college question set',13,'change_collegequestionset'),
	(39,'Can delete college question set',13,'delete_collegequestionset');

/*!40000 ALTER TABLE `auth_permission` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table auth_user
# ------------------------------------------------------------

DROP TABLE IF EXISTS `auth_user`;

CREATE TABLE `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) COLLATE utf8_unicode_ci NOT NULL,
  `first_name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `last_name` varchar(30) COLLATE utf8_unicode_ci NOT NULL,
  `email` varchar(254) COLLATE utf8_unicode_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table auth_user_groups
# ------------------------------------------------------------

DROP TABLE IF EXISTS `auth_user_groups`;

CREATE TABLE `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`),
  CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table auth_user_user_permissions
# ------------------------------------------------------------

DROP TABLE IF EXISTS `auth_user_user_permissions`;

CREATE TABLE `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`),
  CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table django_admin_log
# ------------------------------------------------------------

DROP TABLE IF EXISTS `django_admin_log`;

CREATE TABLE `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext COLLATE utf8_unicode_ci,
  `object_repr` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext COLLATE utf8_unicode_ci NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`),
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`),
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table django_content_type
# ------------------------------------------------------------

DROP TABLE IF EXISTS `django_content_type`;

CREATE TABLE `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `model` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `django_content_type` WRITE;
/*!40000 ALTER TABLE `django_content_type` DISABLE KEYS */;

INSERT INTO `django_content_type` (`id`, `app_label`, `model`)
VALUES
	(1,'admin','logentry'),
	(12,'admin_portal','answer'),
	(10,'admin_portal','college'),
	(13,'admin_portal','collegequestionset'),
	(9,'admin_portal','question'),
	(11,'admin_portal','questionset'),
	(2,'auth','group'),
	(3,'auth','permission'),
	(4,'auth','user'),
	(5,'contenttypes','contenttype'),
	(8,'portal','student'),
	(7,'portal','studentanswer'),
	(6,'sessions','session');

/*!40000 ALTER TABLE `django_content_type` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table django_migrations
# ------------------------------------------------------------

DROP TABLE IF EXISTS `django_migrations`;

CREATE TABLE `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `django_migrations` WRITE;
/*!40000 ALTER TABLE `django_migrations` DISABLE KEYS */;

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`)
VALUES
	(1,'contenttypes','0001_initial','2017-11-24 21:24:42.835452'),
	(2,'auth','0001_initial','2017-11-24 21:24:43.251159'),
	(3,'admin','0001_initial','2017-11-24 21:24:43.336199'),
	(4,'admin','0002_logentry_remove_auto_add','2017-11-24 21:24:43.376955'),
	(5,'admin_portal','0001_initial','2017-11-24 21:24:43.655678'),
	(6,'contenttypes','0002_remove_content_type_name','2017-11-24 21:24:43.731125'),
	(7,'auth','0002_alter_permission_name_max_length','2017-11-24 21:24:43.761062'),
	(8,'auth','0003_alter_user_email_max_length','2017-11-24 21:24:43.797088'),
	(9,'auth','0004_alter_user_username_opts','2017-11-24 21:24:43.808901'),
	(10,'auth','0005_alter_user_last_login_null','2017-11-24 21:24:43.843091'),
	(11,'auth','0006_require_contenttypes_0002','2017-11-24 21:24:43.845664'),
	(12,'auth','0007_alter_validators_add_error_messages','2017-11-24 21:24:43.863818'),
	(13,'auth','0008_alter_user_username_max_length','2017-11-24 21:24:43.900686'),
	(14,'portal','0001_initial','2017-11-24 21:24:44.066001'),
	(15,'sessions','0001_initial','2017-11-24 21:24:44.106411'),
	(16,'portal','0002_auto_20171124_2206','2017-11-24 22:06:51.323556'),
	(17,'admin_portal','0002_auto_20171124_2206','2017-11-24 22:06:51.463063'),
	(18,'admin_portal','0003_questionset_name','2017-11-25 12:39:27.221294'),
	(19,'admin_portal','0004_auto_20171125_2014','2017-11-25 20:14:52.640494'),
	(20,'admin_portal','0005_auto_20171125_2015','2017-11-25 20:15:29.023205'),
	(21,'admin_portal','0006_auto_20171125_2107','2017-11-25 21:07:44.861294'),
	(22,'admin_portal','0007_auto_20171128_1047','2017-11-28 10:47:36.852528'),
	(23,'portal','0003_student_question_set','2017-11-28 10:47:36.979242'),
	(24,'portal','0004_remove_student_question_set','2017-11-28 16:57:05.034449'),
	(25,'portal','0005_auto_20171128_2012','2017-11-28 20:12:47.594152'),
	(26,'portal','0006_student_last_submitted_at','2017-11-29 14:05:33.057850'),
	(27,'portal','0007_student_time_left','2017-12-06 15:23:57.965101'),
	(28,'portal','0008_auto_20171207_1121','2017-12-07 05:51:33.514825'),
	(29,'admin_portal','0008_auto_20171208_1628','2017-12-08 10:58:29.643943');

/*!40000 ALTER TABLE `django_migrations` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table django_session
# ------------------------------------------------------------

DROP TABLE IF EXISTS `django_session`;

CREATE TABLE `django_session` (
  `session_key` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
  `session_data` longtext COLLATE utf8_unicode_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;



# Dump of table portal_student
# ------------------------------------------------------------

DROP TABLE IF EXISTS `portal_student`;

CREATE TABLE `portal_student` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `reg_no` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `department` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `college_name` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `website` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `github_url` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `resume` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `token` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `college_id` int(11) NOT NULL,
  `exam_started_at` datetime(6) DEFAULT NULL,
  `last_submitted_at` datetime(6) DEFAULT NULL,
  `time_left` double DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `portal_student_college_id_963587fb_fk_admin_portal_college_id` (`college_id`),
  CONSTRAINT `portal_student_college_id_963587fb_fk_admin_portal_college_id` FOREIGN KEY (`college_id`) REFERENCES `admin_portal_college` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `portal_student` WRITE;
/*!40000 ALTER TABLE `portal_student` DISABLE KEYS */;

INSERT INTO `portal_student` (`id`, `name`, `reg_no`, `department`, `college_name`, `gender`, `email`, `phone`, `dob`, `website`, `github_url`, `resume`, `token`, `college_id`, `exam_started_at`, `last_submitted_at`, `time_left`)
VALUES
	(97,'Maheshkumar','456','MCA','Maheshkumar','male','mahesh9415@gmail.com','+919787048984','2017-11-30',NULL,NULL,NULL,'mEiul5WHFHUeP8OH5HNq5UW98butWOZKk0HGD2NfD5w',1,'2017-12-11 06:00:59.112777','2017-12-11 12:53:29.552259',39.04),
	(98,'Maheshkumar','789','MCA','Maheshkumar','male','mahesh9415@gmail.com','+919787048984','2017-12-13',NULL,NULL,NULL,'jpp2LNavHm7hJOTR9XpUhfMWQUfsTXZrxWqLpEBMtNs',1,'2017-12-11 07:01:11.565617','2017-12-11 07:12:22.157421',26.18),
	(99,'Maheshkumar','123','MCA','Maheshkumar','male','mahesh9415@gmail.com','+919787048984','2017-12-14',NULL,NULL,NULL,'m6SeOmzRmoh6UtN4KEQ4pdVJ16PDQr7H6KgTRSD5znY',1,'2017-12-11 07:13:16.308525','2017-12-11 07:13:32.358092',36.63),
	(100,'Maheshkumar','921314698','MCA','Maheshkumar','male','mahesh9415@gmail.com','+919787048984','2017-12-20',NULL,NULL,NULL,'SjXvjKuCpsrMDLh7jZ6zRCwiRG5ucbr9d2PgqBMyxa4',1,'2017-12-11 07:22:51.140719',NULL,40),
	(101,'Maheshkumar','12','BE','Maheshkumar','male','mahesh9415@gmail.com','+919787048984','2017-12-14',NULL,NULL,NULL,'tZKzJweQeAew62OTPFSkz7G30HBDwNpmCpsqllYZteI',1,'2017-12-11 07:45:53.817909',NULL,40);

/*!40000 ALTER TABLE `portal_student` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table portal_studentanswer
# ------------------------------------------------------------

DROP TABLE IF EXISTS `portal_studentanswer`;

CREATE TABLE `portal_studentanswer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `description` varchar(900) COLLATE utf8_unicode_ci DEFAULT NULL,
  `submitted_at` datetime(6) DEFAULT NULL,
  `question_id` int(11) NOT NULL,
  `question_set_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `portal_studentanswer_question_id_e7150738_fk_admin_por` (`question_id`),
  KEY `portal_studentanswer_student_id_9c12eda4_fk_portal_student_id` (`student_id`),
  KEY `portal_studentanswer_question_set_id_acbe9f5b_fk_admin_por` (`question_set_id`),
  CONSTRAINT `portal_studentanswer_question_id_e7150738_fk_admin_por` FOREIGN KEY (`question_id`) REFERENCES `admin_portal_question` (`id`),
  CONSTRAINT `portal_studentanswer_question_set_id_acbe9f5b_fk_admin_por` FOREIGN KEY (`question_set_id`) REFERENCES `admin_portal_questionset` (`id`),
  CONSTRAINT `portal_studentanswer_student_id_9c12eda4_fk_portal_student_id` FOREIGN KEY (`student_id`) REFERENCES `portal_student` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

LOCK TABLES `portal_studentanswer` WRITE;
/*!40000 ALTER TABLE `portal_studentanswer` DISABLE KEYS */;

INSERT INTO `portal_studentanswer` (`id`, `description`, `submitted_at`, `question_id`, `question_set_id`, `student_id`)
VALUES
	(32,'1,2,3,4','2017-12-11 06:44:38.997093',1,54,97),
	(33,'javacmp','2017-12-11 12:53:29.522859',2,54,97),
	(34,NULL,NULL,3,54,97),
	(35,NULL,NULL,4,54,97),
	(36,'[\'check1\', \'check2\']','2017-12-11 12:53:29.547462',5,54,97),
	(37,NULL,NULL,1,54,98),
	(38,NULL,NULL,2,54,98),
	(39,NULL,NULL,3,54,98),
	(40,NULL,NULL,4,54,98),
	(41,'[\'check1\', \'check2\']',NULL,5,54,98),
	(42,NULL,'2017-12-11 07:13:23.902531',1,54,99),
	(43,'javacmp','2017-12-11 07:13:32.324106',2,54,99),
	(44,'dcd','2017-12-11 07:13:32.334145',3,54,99),
	(45,'dcd','2017-12-11 07:13:32.342387',4,54,99),
	(46,'[\'check1\', \'check2\']',NULL,5,54,99);

/*!40000 ALTER TABLE `portal_studentanswer` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
