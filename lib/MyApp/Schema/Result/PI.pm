package MyApp::Schema::Result::PI;
use base qw/DBIx::Class::Core/;
__PACKAGE__->table('ltl_pi');
__PACKAGE__->add_columns(qw/ 
    id
    alias
    name
    firstname
    lastname
    REST
    CCNAME
    DBNAME
    GCORE_NAME
    SGNAME
    SGNAME_PUTATIVE
    account
    code
    email
    email2
    career
    sort
    dref
    affiliation
    ltlname
    department
    FL
    LTL
    HTL
    GEN
    HISCAN
    SOLID
    _454
    use_FL
    use_GEN
    use_HTL
    NOBIC
    update_time
    /);
__PACKAGE__->set_primary_key('id');
__PACKAGE__->has_many(requests => 'MyApp::Schema::Result::Request', 'pi_id');
1;

