package MyApp::Schema::Result::UserRole ;
use base qw/DBIx::Class::Core/ ;
__PACKAGE__->table('user_roles') ;
__PACKAGE__->add_columns(
    user_id => { data_type => 'integer' },
    role_id => { data_type => 'integer' },
    ) ;
__PACKAGE__->set_primary_key( 'user_id', 'role_id' ) ;
__PACKAGE__->belongs_to( user => "MyApp::Schema::Result::User", "user_id" ) ;
__PACKAGE__->belongs_to( role => "MyApp::Schema::Result::Role", "role_id" ) ;
1 ;

__DATA__
DROP TABLE IF EXISTS user_roles ;
CREATE TABLE user_roles (
    user_id int UNSIGNED NOT NULL ,
    role_id int UNSIGNED NOT NULL ,
    PRIMARY KEY ( user_id,role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Connects users to roles' ;
