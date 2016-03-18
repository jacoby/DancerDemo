package MyApp::Schema::Result::Run;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('sequence_run');
__PACKAGE__->add_columns(qw/ 
    id
    run_id
    max_regions
    run_name
    sequence_engine
    date_time
    location
    flow_cell_id
    operator
    machine_dir
    recipe
    only_generate_fastq
    min_q_score
    adapter
    filter_pcr_duplicates
    read_length_1
    read_length_2
    has_directory
    ack_error
    /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(samples => 'MyApp::Schema::Result::Sample', 'run_id');
1;
