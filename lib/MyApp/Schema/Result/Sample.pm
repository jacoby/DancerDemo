package MyApp::Schema::Result::Sample;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('sequence_sample');
__PACKAGE__->add_columns(qw/ 
    id
    run_id
    region
    barcode
    accession_id
    date_time
    portion
    well
    version
    hide
    /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to( run => 'MyApp::Schema::Result::Run', 'run_id');
__PACKAGE__->belongs_to( accession => 'MyApp::Schema::Result::Accession', 'accession_id');
1;
__DATA__

+--------------+------------------+------+-----+-------------------+----------------+
| Field        | Type             | Null | Key | Default           | Extra          |
+--------------+------------------+------+-----+-------------------+----------------+
| id           | int(10)          | NO   | PRI | NULL              | auto_increment |
| run_id       | int(10)          | YES  | MUL | NULL              |                |
| region       | int(10)          | YES  |     | NULL              |                |
| barcode      | varchar(255)     | YES  |     | NULL              |                |
| accession_id | varchar(10)      | YES  | MUL | NULL              |                |
| date_time    | timestamp        | NO   |     | CURRENT_TIMESTAMP |                |
| portion      | float            | YES  |     | NULL              |                |
| well         | varchar(5)       | YES  |     | NULL              |                |
| version      | int(10) unsigned | YES  |     | NULL              |                |
| hide         | tinyint(1)       | NO   |     | 0                 |                |
+--------------+------------------+------+-----+-------------------+----------------+
