package MyApp::Schema::Result::CD;
use base qw/DBIx::Class::Core/;
__PACKAGE__->load_components(qw/InflateColumn::DateTime/);
__PACKAGE__->table('cds');
__PACKAGE__->add_columns(qw/ cdid artistid title year /);
__PACKAGE__->set_primary_key('cdid');
__PACKAGE__->belongs_to(artist => 'MyApp::Schema::Result::Artist', 'artistid');
1;
