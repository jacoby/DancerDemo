package MyApp::Schema::Result::Password;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('passwords');
__PACKAGE__->add_columns(qw/ name password role /);
__PACKAGE__->set_primary_key('name');
1;

__DATA__

+----------+--------------+------+-----+---------+-------+
| Field    | Type         | Null | Key | Default | Extra |
+----------+--------------+------+-----+---------+-------+
| name     | varchar(32)  | NO   | PRI | NULL    |       |
| password | varchar(128) | NO   |     | NULL    |       |
+----------+--------------+------+-----+---------+-------+
+----------+----------+
| name     | password |
+----------+----------+
| djacoby  | password |
| parkerpe | password |
| pmiguel  | password |
| test     | test     |
| westerm  | password |
+----------+----------+

DROP TABLE IF EXISTS passwords ;
CREATE TABLE passwords (
  name      varchar(32)     NOT NULL,
  password  varchar(128)    NOT NULL,
  role      varchar(32)     NOT NULL DEFAULT 'user',
  PRIMARY KEY ( name )
) 
    ENGINE=InnoDB 
    CHARACTER SET = utf8 COLLATE utf8_general_ci
    COMMENT='password table' ;

INSERT INTO passwords 
    ( name ,       role , password ) VALUES
    ( 'djacoby'  , 'admin' , 'password' ) ,
    ( 'pmiguel'  , 'admin' , 'password' ) ,
    ( 'westerm'  , 'admin' , 'password' ) ,
    ( 'parkerpe' , 'genomics' , 'password' ) ,
    ( 'ajsorg'   , 'genomics' , 'password' ) ,
    ( 'test'     , 'customer' , 'test' ) ,
    ( 'bdilkes'  , 'customer' , 'password' ) ;

# PROBABLY BETTER TO USE FOREIGN KEYS