package MyApp::Schema::Result::Request;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('requests');
__PACKAGE__->add_columns(qw/ 
    id
    request_id
    request_name
    pi_id
    analysis_type
    barcode
    biocore
    blast_db
    created
    genetic_code
    kit_type
    lab_director
    lib_class
    library_type
    num_lanes
    processed_location
    raw_location
    read_length
    read_length_1
    read_length_2
    sample_type
    sequence_engine
    sequence_engine_version
    source
    species
    wiki_page
    /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->belongs_to( pi => 'MyApp::Schema::Result::PI', 'pi_id');
__PACKAGE__->has_many(accessions => 'MyApp::Schema::Result::Accession', 'request_id');
1;
