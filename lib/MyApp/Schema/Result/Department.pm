package MyApp::Schema::Result::Department;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('departments');
__PACKAGE__->add_columns(qw/ 
    id
    department
    school
    /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(users=> 'MyApp::Schema::Result::User', 'dept_id');

#__PACKAGE__->has_many(
#   name_in_this_object=> 'PATH::TO::Package', 
#   'column_in_Package_corresponding_to_my_primary_key' );

1;


__DATA__
 departments | CREATE TABLE `departments` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `department` varchar(128) NOT NULL,
  `school` varchar(128) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8 COMMENT='List of Purdue Schools and Departments'