package MyApp::Schema::Result::Role ;
use base qw/DBIx::Class::Core/ ;
__PACKAGE__->table('roles') ;
__PACKAGE__->add_columns(
    id       => { data_type => 'integer' },
    rolename => { data_type => 'varchar', size => 32 },
    ) ;
__PACKAGE__->set_primary_key('id') ;
__PACKAGE__->has_many(
    user_roles => "MyApp::Schema::Result::UserRole",
    "role_id"
    ) ;
1 ;

__DATA__
DROP TABLE IF EXISTS roles ;
CREATE TABLE roles (
    id int UNSIGNED NOT NULL PRIMARY KEY  ,
    rolename varchar(32) not null
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Roles for users' ;
