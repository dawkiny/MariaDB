-- MySQL dump 10.14  Distrib 10.0.8-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: test
-- ------------------------------------------------------
-- Server version	10.0.8-MariaDB-1~saucy-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `documents` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `date_added` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `title` varchar(256) DEFAULT NULL,
  `content` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `documents`
--

LOCK TABLES `documents` WRITE;
/*!40000 ALTER TABLE `documents` DISABLE KEYS */;
INSERT INTO `documents` VALUES 
    (1,'2009-02-13 23:31:30','Getting Started with MariaDB','This chapter is all about getting us up and running with MariaDB,  basic recipes which provide the foundation for the others in this book.\n    The first three recipes are the most basic of all and cover installing MariaDB on the Windows, Linux, and Mac OS X operating systems. We\'ll then cover a couple of common configuration options and some common maintenance tasks.\n    We\'ll finish the chapter with a recipe on the progress reporting feature of the mysql client application.'),
    (2,'2009-02-13 23:31:40','Diving Deep into MariaDB','Now that we\'ve gotten our feet wet with MariaDB in the previous chapter, it\'s time to dive deeper and experiment with some useful features of MariaDB.'),
    (3,'2009-02-13 23:31:50','MariaDB Optimization and Tuning','This chapter contains recipes for configuring and using various optimization and tuning-related features of MariaDB. This chapter is not meant as a complete or even partial MariaDB optimization and tuning guide, only that it contains recipes related to the topic.'),
    (4,'2009-02-13 23:32:00','TokuDB Storage Engine','TokuDB is a high-performance storage engine for MariaDB optimized for write-intensive workloads. It is highly scalable and uses a storage technology the developer, Tokutek, calls Fractal Tree Indexes. It can be used with no application or code changes instead of (and along-side)  MyISAM, Aria, and InnoDB/XtraDB tables. It is ACID and MVCC compliant.\n  (\n    ACID compliance means that TokuDB transactions have Atomicity, Consistency, Isolation, and Durability. More information on ACID is available at: http://en.wikipedia.org/wiki/ACID '),
    (5,'2009-02-13 23:32:10','CONNECT Storage Engine','In this chapter, we explore some of the features of the CONNECT storage engine. This storage engine allows us to access data in various different file formats such as XML,  CSV, and other types of files stored on our host system. It is a very handy tool for bringing various pieces of our infrastructure together.\n  It\'s purpose is to connect MariaDB to these various data types and so CONNECT storage engine tables are not tables in the traditional sense (they may not even physically exist). With that in mind there are some things we need to realize when working with this storage engine.\n  Firstly, DROP TABLE does not delete content the way we are used to with MyISAM, InnoDB, and other tables. CONNECT tables are definitions of where the data we want to access is located and what format it is in. For example, an XML file stored in a user\'s home directory. When we DROP a CONNECT table, we are dropping this where-and-what definition, not the data itself.\n  Secondly, indexing behaves differently for CONNECT tables.     Most (but not all) of the CONNECT data types which connect to files support indexing, but only so long as there are no NULL values. Virtual CONNECT tables which are connecting to a source of information like another database, the file system, or the operating system, cannot be indexed because data from these sources is unknown until we access it.\n  More about indexing CONNECT tables is at: https://mariadb.com/kb/en/using-connect-indexing/\n  Full documentation of the CONNECT storage engine is at: https://mariadb.com/kb/en/connect/'),
    (6,'2009-02-13 23:32:20','Replication in MariaDB','Replication is what allows MariaDB to scale to thousands of servers, millions of users, and petabytes of data. But let\'s not get ahead of ourselves. Replication on a small scale is a great way to grow the number of users our application can support with minimal effort. As we gain users we can grow the number of replication servers to match.\n    There are many different ways to set up how we do replication. In this chapter we\'ll only touch on a couple basic ones: a single master to multiple slaves, and multiple masters to a single slave.\n    Historically, replication source servers have been called MASTERS and replication target servers have been called SLAVES. To avoid confusion we\'ll be using these names but they are unfortunate.'),
    (7,'2009-02-13 23:32:30','Replication with MariaDB Galera Cluster','Two of the primary reasons for replicating data between MariaDB servers are to provide greater performance and more redundancy. The traditional master-slave replication covered in chapter 6, Replication in MariaDB, provides for great read performance by having several read-only slave servers. However, it only partially solves the redundancy issue. In classic replication there is only one master server node, and if it fails then one of the slave server nodes must be promoted to become a master server node for the others. Getting this to work correctly in an automated way is difficult.\n    An easier way to configure replication would be if every node was a master server node. Reads and writes could happen to any of the nodes and the replication component would make sure everything just works.\n    MariaDB Galera Cluster makes this sort of replication easy to set up and use. Every node in a Galera cluster is equal, so if any single node fails it is all right. The cluster will continue running and we can repair or replace the faulty node without worrying about whether it is a master or slave server.\n    MariaDB Galera Cluster is only available on Linux-based operating systems, so all the recipes in this chapter are Linux-only.'),
    (8,'2009-02-13 23:32:40','Performance and Usage Statistics','There are several ways of tracking and measuring our usage of MariaDB. Some, like the MariaDB Audit Plugin, come from third parties. Others, like the Performance Schema, are built in. All help us know what is happening on our server so that we can better track our current usage, analyze long term performance trends, and plan for our future needs.\n    The recipes in this chapter introduce several auditing and tracking features that we can enable in MariaDB.'),
    (9,'2009-02-13 23:32:50','Searching Data with Sphinx','There are several ways of tracking and measuring our usage of MariaDB. Some, like the MariaDB Audit Plugin, come from third parties. Others, like the Performance Schema, are built in. All help us know what is happening on our server so that we can better track our current usage, analyze long term performance trends, and plan for our future needs.\n    The recipes in this chapter introduce several auditing and tracking features that we can enable in MariaDB.'),
    (10,'2009-02-13 23:33:00','NoSQL in MariaDB','A recent trend in the database world has been the development and use of so-called NoSQL databases. This trend arose from a realization that relational database servers that use SQL, such as MariaDB, are not always the right tool for the job. Sometimes non-relational, specialized, scalable, clustered key-value databases work better for specific tasks.\n    The MariaDB developers see the value in such non-traditional databases and have implemented features in MariaDB that help it bridge some of the gap between relational and non-relational or NoSQL databases. The recipes in this chapter cover three such features in MariaDB: Dynamic Columns, Virtual Columns, and HandlerSocket.\n    This chapter includes several syntax diagrams and data type definitions. The parts of these diagrams and definitions in square brackets [] are optional. Also, a series of three dots ... (also called an ellipsis) means that the previous bracketed part can be repeated.'),
    (11,'2009-02-13 23:33:10','NoSQL with HandlerSocket','A recent trend in the database world has been the development and use of so-called NoSQL databases. This trend arose from a realization that relational database servers that use SQL, such as MariaDB, are not always the right tool for the job. Sometimes non-relational, specialized, scalable, clustered key-value databases work better for specific tasks.\n    The MariaDB developers see the value in such non-traditional databases and have implemented features in MariaDB that help it bridge some of the gap between relational and non-relational or NoSQL databases. The recipes in this chapter cover three such features in MariaDB: Dynamic Columns, Virtual Columns, and HandlerSocket.\n    This chapter includes several syntax diagrams and data type definitions. The parts of these diagrams and definitions in square brackets [] are optional. Also, a series of three dots ... (also called an ellipsis) means that the previous bracketed part can be repeated.'),
    (12,'2009-02-13 23:33:20','NoSQL with the Cassandra Storage Engine','One unique feature in MariaDB is the Cassandra Storage Engine. This is a specialized storage engine, similar to the Connect Storage Engine featured in Chapter 5. Like Connect it allows us to access data stored outside of MariaDB. Unlike Connect, the Cassandra Storage Engine is specific to a certain type of data. Namely, it lets us connect MariaDB to a Cassandra Cluster.\n    In this chapter are recipes on installing and configuring the Cassandra Storage Engine, defining tables that use the storage engine, on inserting, updating, and deleting, and on querying data.\n  The Cassandra Storage Engine in MariaDB is built and packaged only for Linux-based operating systems. As such, the recipes in this chapter assume we are using a variant of Linux as we complete them.'),
    (13,'2009-02-13 23:33:30','MariaDB Security','Security is important, but because the value of the data in a given database ranges from worthless to billions of dollars, deciding on how much and what type of security to employ varies greatly. The recipes in this chapter focus on a few common ways to enhance MariaDB\'s default security, but they really only scratch the surface of the topic.');
/*!40000 ALTER TABLE `documents` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-02-18 23:13:28
