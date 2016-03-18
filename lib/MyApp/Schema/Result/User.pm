package MyApp::Schema::Result::User ;
use base qw/DBIx::Class::Core/ ;
__PACKAGE__->table('users') ;
__PACKAGE__->add_columns(
    id       => { data_type => 'integer' },
    username => { data_type => 'varchar', size => 32 },
    password => { data_type => 'varchar', size => 40, is_nullable => 1 },
    name     => { data_type => 'varchar', size => 128, is_nullable => 1 },
    email    => { data_type => 'varchar', size => 255, is_nullable => 1 },
    deleted    => { data_type => 'boolean',  default_value => 0 },
    lastlogin  => { data_type => 'datetime', is_nullable   => 1 },
    pw_changed => { data_type => 'datetime', is_nullable   => 1 },
    pw_reset_code => { data_type => 'varchar', size => 255, is_nullable => 1 },
    ) ;
__PACKAGE__->set_primary_key('id') ;
__PACKAGE__->has_many(
    user_roles => "MyApp::Schema::Result::UserRole",
    "user_id"
    ) ;
1 ;
__DATA__
DROP TABLE IF EXISTS users ;
CREATE TABLE users (
    id            INT UNSIGNED NOT NULL PRIMARY KEY  ,
    username    VARCHAR(  32 ) NOT NULL,
    password    VARCHAR(  40 ) ,
    name          VARCHAR( 128 ) ,
    email         VARCHAR( 255 ) ,
    deleted       BOOLEAN NOT NULL DEFAULT 0 ,
    lastlogin     DATETIME ,
    pw_changed    DATETIME ,
    pw_reset_code VARCHAR( 255 )
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='User Info' ;
