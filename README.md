# sync-elasticsearch-mariadb
Using Logstash to synchronize MariaDB data with ElasticSearch.

```
DROP TABLE IF EXISTS `article`;
CREATE TABLE `article` (
  `article_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
  `title` VARCHAR(200) DEFAULT NULL,
  `content` TEXT DEFAULT NULL,
  PRIMARY KEY (`article_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

```
DROP TABLE IF EXISTS `article_journal`;
CREATE TABLE `article_journal` (
  `journal_id` BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE,
  `article_id` BIGINT UNSIGNED NOT NULL,
  `action_type` enum('create','update','delete') DEFAULT NULL,
  `action_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`journal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```
## PHPMYADMIN
http://ipaddress:8080

Datenbank: mariadb
Benutzername: root
Passwort: 123456

```
INSERT INTO `article` (`title`, `content`) VALUES
('Das ist ein Testartikel 1','Hierbei handelt es sich um einen einfachen Testartikel für die Synchronisation zwischen einer mariadb und ElasticSearch.'),
('Die Welt steht Kopf','Das ist ein weiterer Testartikel zum einfachen Test.');
```

```
INSERT INTO `article_journal` (`article_id`, `action_type`, `action_time`) VALUES (1,'create', NOW());
INSERT INTO `article_journal` (`article_id`, `action_type`, `action_time`) VALUES (2,'create', NOW());
```

## ElasticSearch Node
http://ipaddress:9200/_cat/nodes?v&pretty

## Kibana
http://ipaddress:5601/app/dev_tools#/console

```
GET /article/_search
{
  "query": {
    "multi_match": {
      "query": "Testartike",
      "analyzer": "standard",
      "fields": [ "title", "content" ],
      "fuzziness": "AUTO"
    }
  }
}
