package MyApp::Schema::Result::Accession;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('accessions');
__PACKAGE__->add_columns(qw/ 
    id
    request_id
    accession_id
    processed_location
    library_name
    amount
    slide_format
    species
    sample_type
    control
    need_reference
    distance
    std_dev
    genetic_code
    version
    datetime
    hide
 /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to( request => 'MyApp::Schema::Result::Request', 'request_id');
1;
__DATA__

+--------------------+------------------+------+-----+-------------------+----------------+
| Field              | Type             | Null | Key | Default           | Extra          |
+--------------------+------------------+------+-----+-------------------+----------------+
| id                 | int(10)          | NO   | PRI | NULL              | auto_increment |
| request_id         | varchar(10)      | YES  | MUL | NULL              |                |
| accession_id       | varchar(10)      | YES  | MUL | NULL              |                |
| processed_location | varchar(255)     | YES  |     | NULL              |                |
| library_name       | varchar(255)     | YES  |     | NULL              |                |
| amount             | varchar(255)     | YES  |     | NULL              |                |
| slide_format       | int(10)          | YES  |     | NULL              |                |
| species            | varchar(255)     | YES  |     | NULL              |                |
| sample_type        | varchar(10)      | YES  |     | NULL              |                |
| control            | tinyint(1)       | YES  |     | NULL              |                |
| need_reference     | tinyint(1)       | YES  |     | NULL              |                |
| distance           | int(11)          | YES  |     | NULL              |                |
| std_dev            | int(11)          | YES  |     | NULL              |                |
| genetic_code       | int(10)          | YES  |     | NULL              |                |
| version            | int(10) unsigned | NO   |     | 1                 |                |
| datetime           | timestamp        | NO   |     | CURRENT_TIMESTAMP |                |
| hide               | tinyint(1)       | NO   |     | 0                 |                |
+--------------------+------------------+------+-----+-------------------+----------------+
