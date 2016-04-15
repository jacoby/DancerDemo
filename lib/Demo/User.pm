
##
##   ####                              ##  ##
##   ## ##   ###  # ## ##   ###  ## ## ##  ##  ###  ###  ## #
##   ##  ## ## ## ## ## ## ## ## ## ## ##  ## ##   ## ## ####
##   ##  ## ## ## ## ## ## ## ##       ##  ## ###  ## ## ##
##   ##  ## ##### ## ## ## ## ##       ##  ##  ### ##### ##
##   ## ##  ##    ## ## ## ## ## ## ## ##  ##   ## ##    ##
##   ####    #### ## ## ##  ###  ## ##  ####  ###   #### ##
##


package Demo::User ;
use feature qw{ say state } ;
use strict ;
use warnings ;

use Data::Dumper ;
use Dancer2 appname => 'Demo' ;
use Dancer2::Plugin::DBIC qw(schema resultset rset) ;
use Dancer2::Plugin::Auth::Extensible ;
use Dancer2::Plugin::Email ;

my $prefix = '/user' ;
prefix $prefix ;


##                    ##
##    ####  ##        ##
##   ##    #### ## ## ####   ###
##   ###    ##  ## ## ## ## ##
##    ###   ##  ## ## ## ## ###
##     ###  ##  ## ## ## ##  ###
##      ##  ##  ## ## ## ##   ##
##   ####    ##  ## # ####  ###
##


# these functions are in preparation/hope for similarly-named functions to
# be added to Dancer2::Plugin::Auth::Extensible 

# takes a username and role. If user and role exist, creates
# a user_role 
sub add_user_role {
    my ( $username, $rolename ) = @_ ;
    my $user = _get_user($username) ;
    my $role = _get_role($rolename) ;
    return undef unless $user->id ;
    return undef unless $role->id ;
    my @user_roles = schema->resultset('UserRole')->search(
        {   user_id => $user->id,
            role_id => $role->id,
            },
        {}
        ) ;
    unless ( scalar @user_roles ) {
        schema->resultset('UserRole')->create(
            {   user_id => $user->id,
                role_id => $role->id,
                }
            ) ;
        }
    }

# takes a username and role. If user and role exist, removes
# the user_role 
sub remove_user_role {
    my ( $username, $rolename ) = @_ ;
    my $user = _get_user($username) ;
    my $role = _get_role($rolename) ;
    return undef unless $user->id ;
    return undef unless $role->id ;
    my @user_roles = schema->resultset('UserRole')->search(
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

# returns a full user object from a username
sub _get_user {
    my ($username) = @_ ;
    my @users = schema->resultset('User')
        ->search( { 'me.username' => $username }, {}, ) ;
    return shift @users ;
    }

# returns a full role object from a rolename
sub _get_role {
    my ($rolename) = @_ ;
    my @roles = schema->resultset('Role')
        ->search( { 'me.rolename' => $rolename }, {}, ) ;
    return shift @roles ;
    }

##  
##  ##
##  ####          ##  ##
##  ## ##  ###   #### ## #   ###
##  ## ##    ##   ##  ##### ##
##  ####   ####   ##  ## ## ###
##  ##    ## ##   ##  ## ##  ###
##  ##    ## ##   ##  ## ##   ##
##  ##     ## ##   ## ## ## ###

# web/user becomes web/user/
get '' => sub { forward $prefix . '/' } ;

get '/' => require_role user => sub {

    # as Admin or Tech, user gives a list of users with links to
    # edit or create user profiles
    if ( user_has_role('admin') || user_has_role('tech') ) {
        my $is_admin = user_has_role('admin') ? 1 : 0 ;
        my $is_tech  = user_has_role('tech')  ? 1 : 0 ;
        my @users    = schema->resultset('User')->search(
            {},
            {   prefetch => { 'user_roles' => 'role' },
                order_by => 'me.username',
                },
            ) ;
        my $dump = Dumper \@users ;
        template 'users',
            {
            users    => \@users,
            dump     => $dump,
            is_admin => $is_admin,
            is_tech  => $is_tech,
            } ;
        }

    # otherwise,
    else {
        my $user     = logged_in_user ;
        my $username = $user->{username} ;
        my @users    = schema->resultset('User')->search(
            { username => $username },
            { prefetch => { 'user_roles' => 'role' }, },
            ) ;
        template 'user',
            {
            user     => $user,
            username => $username,
            users    => \@users,
            } ;
        }
    } ;

post '/' => require_role user => sub {

    if ( user_has_role('admin') || user_has_role('tech') ) {
        redirect '/user/' ;
        }
    else {
        my $user     = logged_in_user ;
        my $username = $user->{username} ;
        my $email    = params->{user_email} ;
        my $id       = params->{user_id} ;
        my $name     = params->{user_name} ;
        my $password = params->{user_password} ;
        if ( $name && $name ne $user->{name} ) {
            update_current_user name => $name ;
            }
        if ( $email && $name ne $user->{email} ) {
            update_current_user email => $email ;
            }
        if ( $password && $password ne '' ) {
            user_password new_password => $password ;
            }
        redirect '/user/' ;
        }
    } ;

## 'new' has to be handled in here, and thus there cannot be a user
## named 'new'
get '/:username' => require_any_role [qw{ admin tech }] => sub {
    my $username = params->{username} ;
    my $is_admin = user_has_role('admin') ? 1 : 0 ;
    my $is_tech  = user_has_role('tech') ? 1 : 0 ;
    my $is_new   = $username eq 'new' ? 1 : 0 ;
    my $user     = get_user_details $username ;
    my $dump     = Dumper $user ;

    template 'user', {
        username => $username,

        # dump     => $dump,
        is_admin => $is_admin,
        is_tech  => $is_tech,
        is_new   => $is_new,
        user     => $user,
        } ;

# tests needed:
#       tech  -> new  : empty fields, has "username" field, says 'new', shows fields
#       admin -> new  : empty fields, has "username" field, says 'new', can change fields
#       tech  -> edit : filled fields, hidden "username" field, says 'edit', shows fields
#       admin -> edit : filled fields, hidden "username" field, says 'edit', can change fields
    } ;

post '/:username' => require_any_role [qw{ admin tech }] => sub {

    # what this does:
    #   + tech creates new user
    #   + admin creates new user
    #   + tech edits non-admin user
    #   + admin edits any user
    # what this doesn't do:
    #   + password quality checking
    #   + adding/removing roles

    my $username_old = params->{username} ;
    my $username     = params->{user_username} ;
    my $user         = get_user_details $username_old ;
    my $email        = params->{user_email} ;
    my $id           = params->{user_id} ;
    my $name         = params->{user_name} ;
    my $password     = params->{user_password} ;
    my $is_new       = params->{is_new} ;

    # user is admin, not tech
    if ( user_has_role 'admin' ) {

        # admin can create new users
        if ($is_new) {
            create_user
                username => $username,
                email    => $email,
                name     => $name,
                ;
            user_password $username , new_password => $password ;
            }

        # admin can modify all users
        else {
            if ( $name && $name ne $user->{name} ) {
                update_user $username_old , name => $name ;
                }
            if ( $email && $name ne $user->{email} ) {
                update_user $username_old , email => $email ;
                }
            if ( $username && $username ne $user->{username} ) {
                update_user $username_old , username => $username ;
                }
            if ( $password && $password ne '' ) {
                user_password $username_old , new_password => $password ;
                }
            }
        }
    else {

        # tech cannot touch admin accounts
        if ( !user_has_role $username , 'admin' ) {

            # tech can create new non-admin users
            if ($is_new) {
                create_user
                    username => $username,
                    email    => $email,
                    name     => $name,
                    ;
                user_password $username , new_password => $password ;
                }
            # tech can change some non-admin users
            else {
                if ( $name && $name ne $user->{name} ) {
                    update_user $username , name => $name ;
                    }
                if ( $email && $name ne $user->{email} ) {
                    update_user $username , email => $email ;
                    }
                if ( $password && $password ne '' ) {
                    user_password $username , new_password => $password ;
                    }
                }
            }
        }
    redirect '/user/' ;
    } ;


##                         ## ## ##                                     ## ##
##  ##  ##                 ## ##                  #####                    ##
##  ##  ##  ###   # ##   #### ## ## # ##   ####   ##    # ## ##   ###   ## ##
##  ##  ##    ##  ## ## ## ## ## ## ## ## ## ##   ##    ## ## ##    ##  ## ##
##  ######  ####  ## ## ## ## ## ## ## ## ## ##   ####  ## ## ##  ####  ## ##
##  ##  ## ## ##  ## ## ## ## ## ## ## ## ## ##   ##    ## ## ## ## ##  ## ##
##  ##  ## ## ##  ## ## ## ## ## ## ## ## ## ##   ##    ## ## ## ## ##  ## ##
##  ##  ##  ## ## ## ##  ## # ## ## ## ##  ####   ##### ## ## ##  ## ## ## ##
##                                           ##
##                                        ####

# any '/email' => require_role admin => sub {
#     my $body = '
# This plugin tries to make sending emails from Dancer2 applications as simple
# as possible. It uses Email::Sender under the hood. In a lot of cases, no
# configuration is required. For example, if your app is hosted on a unix-like
# server with sendmail installed, calling email() will just do the right thing.

# IMPORTANT: Version 1.x of this module is not backwards compatible with the 0.x
# versions. This module was originally built on Email::Stuff which was built on
# Email::Send which has been deprecated in favor of Email::Sender. Versions 1.x
# and on have be refactored to use Email::Sender. I have tried to keep the
# interface the same as much as possible. The main difference is the configuration.
# If there are features missing that you were using in older versions, then please
# let me know by creating an issue on github.
# ';

#     try {
#         # Unsure when we will want to send email, but we certainly
#         # can do it when needed.
#         email {
#             from    => 'djacoby@purdue.edu',
#             to      => 'djacoby@purdue.edu',
#             subject => 'test',
#             type    => 'plain',
#             headers => {
#                 "X-Mailer"          => 'Purdue Genomics Core Lab',
#                 "X-Accept-Language" => 'en',
#                 },
#             body => $body ,
#             } ;
#         }
#     catch {
#         error qq{Could not send email: $_} ;
#         } ;
#     redirect '/' ;
#     } ;

1 ;

__DATA__


##
##                 ####     ##   ######   ##
##                 ## ##    ##     ##     ##
##                 ##  ##  # ##    ##    # ##
##                 ##  ##  # ##    ##    # ##
##                 ##  ## ######   ##   ######
##                 ## ##  #   ##   ##   #   ##
##                 ####   #   ##   ##   #   ##
##   ###### ######                             ###### ######



A user is defined by the following fields
    id
    username
    password
    name
    email
    deleted
    lastlogin
    pw_changed
    pw_reset_code
and other fields as we ad later.

lastlogin should update for each user on every login. it's a configuration
setting.

users can change password, name, email and deleted (which is to close account)
for themselves only. they cannot see other users.

techs can create new users (with role 'user', not 'dev', 'tech', 'admin')
and change the same fields as users can, but for all users, but not devs, 
techs and admins. they can view all users.

admins can create new users, techs, devs, and admins. They can change any
field for any user, tech, dev or admin, and can view all users.

now, to implement.
