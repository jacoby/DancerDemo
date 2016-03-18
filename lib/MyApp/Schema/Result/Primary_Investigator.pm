package MyApp::Schema::Result::Primary_Investigator;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('primary_investigators');
__PACKAGE__->add_columns(qw/ 
    alias
    affiliation
    career
    code
    dref
    email
    name
    update_time
    /);
__PACKAGE__->set_primary_key('alias');
__PACKAGE__->has_many(users=> 'MyApp::Schema::Result::User', 'pi');
__PACKAGE__->has_one(more=> 'MyApp::Schema::Result::Primary_Investigator_old', 'alias');
1;

__DATA__
 CREATE TABLE `primary_investigators` (
  `alias` varchar(32) NOT NULL COMMENT 'Lab alias for PI',
  `affiliation` varchar(60) NOT NULL,
  `career` varchar(60) DEFAULT NULL COMMENT 'Purdue Career Account; null for off campus',
  `code` varchar(60) DEFAULT NULL COMMENT 'Affiliation code compatible with account_Codes',
  `dref` varchar(60) NOT NULL COMMENT 'Department Reference, for billing',
  `email` varchar(60) NOT NULL COMMENT 'primary email address',
  `name` varchar(120) NOT NULL COMMENT 'full name in LAST,FIRST format',
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`alias`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Contains crucial info about PIs' 