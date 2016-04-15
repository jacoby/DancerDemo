#!/usr/bin/env perl 

use feature qw{ say state } ;
use strict ;
use warnings ;
use utf8 ;
use Data::Dumper ;

use lib '/home/vagrant/dev/Demo/lib' ;
use MyApp::Schema ;

# Under normal circumstances, a no-no, but this is demo only
my $dbn   = 'dbi:mysql:database=dancer_demo' ;
my $login = 'dancer' ;
my $pass  = 'password' ;
my $schema
    = MyApp::Schema->connect( $dbn, $login, $pass, { AutoCommit => 1 }, ) ;

add_user_role( 'test', 'tech' ) ;
list_user_roles() ;
remove_user_role( 'test', 'tech' ) ;
list_user_roles() ;

sub add_user_role {
    my ( $username, $rolename ) = @_ ;
    my $user = _get_user($username) ;
    my $role = _get_role($rolename) ;
    say $username ;
    say $rolename ;
    say join ':', $user->username, $user->id ;
    say join ':', $role->rolename, $role->id ;
    my @user_roles = $schema->resultset('UserRole')->search(
        {   user_id => $user->id,
            role_id => $role->id,
            },
        {}
        ) ;
    unless ( scalar @user_roles ) {
        $schema->resultset('UserRole')->create(
            {   user_id => $user->id,
                role_id => $role->id,
                }
            ) ;
        }
    }

sub remove_user_role {
    my ( $username, $rolename ) = @_ ;
    my $user = _get_user($username) ;
    my $role = _get_role($rolename) ;
    say $username ;
    say $rolename ;
    say join ':', $user->username, $user->id ;
    say join ':', $role->rolename, $role->id ;
    my @user_roles = $schema->resultset('UserRole')->search(
        {   user_id => $user->id,
            role_id => $role->id,
            },
        {}
        ) ;
    if ( scalar @user_roles ) {
        for my $user_role ( @user_roles ) {
            $user_role->delete ;
            }
        }
    }

sub _get_user {
    my ($username) = @_ ;
    my @users = $schema->resultset('User')
        ->search( { 'me.username' => $username }, {}, ) ;
    return shift @users ;
    }

sub _get_role {
    my ($rolename) = @_ ;
    my @roles = $schema->resultset('Role')
        ->search( { 'me.rolename' => $rolename }, {}, ) ;
    return shift @roles ;
    }

sub list_user_roles {
    my @user_roles = $schema->resultset('UserRole')->search(
        {},
        {   join     => qw{ user role },
            prefetch => qw{ user role },
            }
        ) ;
    for my $ur ( sort { $a->user->name cmp $b->user->name } @user_roles ) {
        say join "\t", '', $ur->user->username, $ur->role->rolename, ;
        }
    }

exit ;

say 'USER ROLES ' . '-' x 69 ;
my @user_roles = $schema->resultset('UserRole')->search(
    { user_id => 3 },
    {   join     => qw{ user role },
        prefetch => qw{ user role },
        }
    ) ;
for my $ur ( sort { $a->user->name cmp $b->user->name } @user_roles ) {
    say join "\t", '',
        $ur->user->username,
        $ur->user->name,
        $ur->user->lastlogin || 'null',
        $ur->role->rolename,
        ;
    }

say 'ROLES ' . '-' x 74 ;
my @roles = $schema->resultset('Role')
    ->search( {}, { prefetch => { 'user_roles' => 'user' } } ) ;
for my $role (@roles) {
    my @user_roles = $role->user_roles ;
    say join "\t", '', $role->id, $role->rolename ;
    for my $ur (@user_roles) {
        say "\t\t" . $ur->user->name ;
        }
    }

say 'USERS ' . '-' x 74 ;
my @users = $schema->resultset('User')
    ->search( {}, { prefetch => { 'user_roles' => 'role' } }, ) ;
for my $user (@users) {
    my @user_roles = $user->user_roles ;

    # if ( ! defined $user->lastlogin ) {
    #     $user->update({ lastlogin => \'NOW()' }) ;
    #     }
    say join "\t", '',
        $user->id,
        $user->name,
        $user->username,
        $user->lastlogin || 'null',
        $user->email,
        ;
    for my $ur (@user_roles) {
        say "\t\t" . $ur->role->rolename ;
        }
    }

# { prefetch => {
#     'user_roles' => 'role'
#     } } ) ;
__DATA__
my $alias = q{dilkes} ;

# my @runs = $schema->resultset( 'Run' )->search( { run_id => 225 } ) ;

my @pis = $schema->resultset('Primary_Investigator')->search(
        { 'me.alias' => $alias },
        {   join     => qw{ more users },
            prefetch => qw{ more users },
            } ,
        ) ;

my $pi = shift @pis ;
say $pi->name ;
say $pi->more->career ;

my @users = $pi->users->all ;
for my $user ( @users ) {
    say '  + ' . $user->alias ;
    }

exit ;


if (0) {
    # DEMONSTRATES getting sub-data for a table
    my @artists ;

    @artists = $schema->resultset('Artist')->all() ;
    for my $artist (@artists) {
        say $artist->name ;
        }
    say '-' x 30 ;

    @artists = $schema->resultset('Artist')->search(
        {},
        {   join     => 'cds',
            prefetch => 'cds',
            order_by => 'cds.year',
            }
        ) ;

    for my $artist (@artists) {
        say $artist->name ;

        my @cds = $artist->cds->all ;
        for my $cd (@cds) {
            my $title = $cd->title ;
            my $year  = $cd->year ;
            say qq{\t$title ($year)} ;
            }
        }
    say '-' x 30 ;
    }

if (0) {
    my @departments = $schema->resultset('Department')->search(
        {}, # 'all()' but allowing us to grab the rest
        {   join     => 'users',
            prefetch => 'users',
            order_by => 'users.name',
            }
        ) ;
    for my $department (@departments) {
        my @users = $department->users->all ;
        next unless scalar @users ;
        # print "\t" . scalar @users ;
        # print "\t" . $department->id ;
        say $department->department ;
        # print "\t" . $department->school ;

        for my $user (@users) {
            say join "\t" , 
                '' ,
                $user->name ,
                $user->alias ,
                ;
            }
        say '' ;
        }
    }

if (1) {
    my @pis = $schema->resultset('Primary_Investigator')->search(
        { }, # 'all()' but allowing us to grab the rest
        {   join     => 'users',
            prefetch => 'users',
            order_by => 'users.name',
            }
        ) ;
    for my $pi ( 
            sort { 
                ( scalar $a->users->all ) 
                    <=>
                ( scalar $b->users->all ) 
                } 
            @pis) {
        my @users = $pi->users->all ;
        next unless scalar @users ;
        say uc $pi->name . ' - ' . scalar @users ;

        for my $user (@users) {
            say join "\t" , 
                '' ,
                uc $user->name ,
                $user->alias ,
                ;
            }
        say '' ;
        }
    }



__DATA__
my @departments = $schema->resultset('Department')
    ->search( undef, 
    { join      => 'users',
      order_by  => ['users.alias'],
    }
     ) ;
if (1) {
    my $c = 1 ;
    for my $d (@departments) {
        say join "\t", $d->school, $d->department ;
        {
            my @users = $d->users->all ;
            my $scalar = scalar @users ;
            say qq{($scalar)} ;
            for my $u (@users) {
                say join "\t", '', $u->alias ;
                }
            say "\n" ;
            }
        say '-' x 10 ;
        {
            # my @users = $schema->resultset('User')
            #     ->search( { dept_id => $d->id } ) ;
            # for my $u (@users) {
            #     say join "\t", '', $u->alias ;
            #     }
            say "\n" ;
            }
        exit ;
        }
    }

my @pis = $schema->resultset('Primary_Investigator')->all ;
if (0) {
    for my $pi (@pis) {
        my @users
            = $schema->resultset('User')->search( { pi => $pi->alias } ) ;
        my $scalar = scalar @users ;
        next unless $scalar ;
        say uc $pi->alias ;
        say '-' x length $pi->alias ;
        say $scalar ;
        say join "|", map { $_->alias } @users ;
        say "" ;
        }
    }

my @users = $schema->resultset('User')->all ;
if (0) {
    my $c = 1 ;
    for my $user ( @users ) {

        # next if $user
        say join "\t", ( $c++ ), $user->alias, $user->department,,

            # $user->name,
            # $user->pi->name,
            ;
        }
    }

if (0) {

    #     my ($jkzhu)
    #         = $schema->resultset('Primary_Investigator')
    #         ->search( { alias => 'jkzhu' } ) ;
    #     my @jkzhu_users = $jkzhu->search_related('users')->all ;
    #     say $jkzhu->name ;
    #     say $jkzhu->alias ;
    #     say $jkzhu->email ;
    #     say scalar @jkzhu_users ;
    #     for my $user (@jkzhu_users) {
    #         say $user->name ;
    #         }
    }

if (0) {
    for my $pi (@pis) {
        my @users = $pi->users( undef, { order_by => 'alias' } ) ;
        next if 0 == scalar @users ;
        say $pi->name ;
        for my $user (@users) {
            say 'OK' ;
            }
        }
    }

exit ;

__DATA__

# Query for all artists and put them in an array,
# or retrieve them as a result set object.
# $schema->resultset returns a DBIx::Class::ResultSet
my @all_artists    = $schema->resultset('Artist')->all ;
my $all_artists_rs = $schema->resultset('Artist') ;

# Output all artists names
# $artist here is a DBIx::Class::Row, which has accessors
# for all its columns. Rows are also subclasses of your Result class.
foreach my $artist ( reverse sort { $a->name cmp $b->name } @all_artists ) {
    say '+ ' . $artist->name ;
    # my @all_artist_cds = 
    #     $schema->resultset( 'CD' )->search( {
    #         artistid => $artist->artistid 
    #         } ) ;
    # for my $cd (@all_artist_cds) {
    #     say '  - ' , $cd->title , ' (' , $cd->year , ')' ;
    #     }
    # say '' ;
    # my @all = $artist->search_related('cds')->all ;

    my @all = $artist->cds( undef, { order_by => 'year' } ) ;
    for my $cd (@all) {
        say '  - ' , $cd->title , ' (' , $cd->year , ')' ;
        }
    }
     
exit;
my @all_recordings    = $schema->resultset('CD')->all ;
for my $cd ( sort { $a->year <=> $b->year } @all_recordings ) {
    say join '' , 
        $cd->artist->name , ", \t" , '_' , $cd->title , '_' ,
        "\t" , '(' , $cd->year , ')' ,
        ;
    }



exit ;
__DATA__
# Create a result set to search for artists.
# This does not query the DB.
my $johns_rs = $schema->resultset('Artist')->search(
    # Build your WHERE using an SQL::Abstract structure:
    { name => { like => 'John%' } }
    ) ;

# Execute a joined query to get the cds.
my @all_john_cds = $johns_rs->search_related('cds')->all ;

# Fetch the next available row.
my $first_john = $johns_rs->next ;

# Specify ORDER BY on the query.
my $first_john_cds_by_title_rs
    = $first_john->cds( undef, { order_by => 'title' } ) ;

# Create a result set that will fetch the artist data
# at the same time as it fetches CDs, using only one query.
my $millennium_cds_rs = $schema->resultset('CD')
    ->search( { year => 1983 }, { prefetch => 'artist' } ) ;

my $cd = $millennium_cds_rs->next ;    # SELECT ... FROM cds JOIN artists ...
my $cd_artist_name
    = $cd->artist->name ;              # Already has the data so no 2nd query

say '-' x 20 ;
say $cd->artist->name ;
say $cd->title ;
say '-' x 20 ;

exit ;

# new() makes a Result object but doesnt insert it into the DB.
# create() is the same as new() then insert().
my $new_cd = $schema->resultset('CD')->new(
    {   title => 'David Live',
        year  => 1974,
        }
    ) ;
$new_cd->artist( $cd->artist ) ;

# $new_cd->insert; # Auto-increment primary key filled in after INSERT
say '-' x 20 ;

$schema->txn_do( sub { $new_cd->update } )
    ;    # Runs the update in a transaction

# change the year of all the millennium CDs at once
$millennium_cds_rs->update( { year => 2002 } ) ;

exit ;

__DATA__

my_itap

DROP TABLE IF EXISTS artists ;
  CREATE TABLE artists (
    artistid INTEGER AUTO_INCREMENT PRIMARY KEY ,
    name TEXT NOT NULL 
  );

DROP TABLE IF EXISTS cds ;
  CREATE TABLE cds (
    cdid INTEGER AUTO_INCREMENT PRIMARY KEY,
    artistid INTEGER NOT NULL REFERENCES artist(artistid),
    year YEAR(4) NOT NULL,
    title TEXT NOT NULL
  );


INSERT INTO artists ( artistid , name ) VALUES 
    (1,'John Lennon') ,
    (2,'John Legend') ,
    (3,'Motorhead') ,
    (4,'Metallica') ,
    (5,'David Bowie') ,
    (6,'Tin Machine') ;

INSERT INTO cds ( cdid , artistid , year, title ) VALUES 
    ( 1,1, 1980, 'Double Fantasy') ,
    ( 2,1, 1971, 'Imagine') ,
    ( 3,1, 1970, 'Plastic Ono Band') ,
    ( 4,2, 2004 ,'Get Lifted') ,
    ( 5,3, 1980, 'Ace of Spades') ,
    ( 6,4, 1984, 'Ride The Lightning') ,
    ( 7,4, 1986, 'Master of Puppets') ,
    ( 8,4, 1988, '...And Justice For All') ,
    ( 9,5, 1977, '"Heroes"') ,
    (10,5, 1983, 'Let\'s Dance' ) ,
    (11,5, 1973, 'Alladin Sane') ,
    (12,6, 1989, 'Tin Machine') ;

exit;
clear ;
my_itap -e 'select * from artists ; select * from cds'

clear && ~/webserver/perl/bin/perl -MDBIx::Class::Schema::Loader=make_schema_at,dump_to_dir:~/db -e 'make_schema_at("Breadcrumbs::Schema", { debug => 1 }, [         "DBI:mysql:database=djacoby;host=mydb.ics.purdue.edu;port=3306", "djacoby", "derv1sh" ])'


  This will create a file for each database table (in


SELECT  a.name 
    ,   c.title
    ,   c.year
FROM artists a , cds c
WHERE a.artistid = c.artistid
ORDER BY a.name , c.year 








