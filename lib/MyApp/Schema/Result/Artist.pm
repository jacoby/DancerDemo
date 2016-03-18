package MyApp::Schema::Result::Artist;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('artists');
__PACKAGE__->add_columns(qw/ artistid name /);
__PACKAGE__->set_primary_key('artistid');
__PACKAGE__->has_many(cds => 'MyApp::Schema::Result::CD', 'artistid');
1;
