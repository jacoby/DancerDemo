
##                                                          ##
##   ####                              ##     ##            ##
##   ## ##   ###  # ## ##   ###  ## ## ##  #  ##  ###  ## # ##  #
##   ##  ## ## ## ## ## ## ## ## ## ## ##  #  ## ## ## #### ## #
##   ##  ## ## ## ## ## ## ## ##        ## ## #  ## ## ##   ###
##   ##  ## ##### ## ## ## ## ##        ## ## #  ## ## ##   ####
##   ## ##  ##    ## ## ## ## ## ## ##   ## ##   ## ## ##   ## ##
##   ####    #### ## ## ##  ###  ## ##   ## ##    ###  ##   ##  ##
##

package Demo::Work ;
use feature qw{ say state } ;
use strict ;
use warnings ;

# this handles user settings.

use Dancer2 appname => 'Demo' ;
use Dancer2::Plugin::DBIC qw(schema resultset rset) ;
use Dancer2::Plugin::Auth::Extensible ;

my $prefix = '/work' ;
prefix $prefix ;


##                     ##
##   ####          ##  ##
##   ## ##  ###   #### ## #   ###
##   ## ##    ##   ##  ##### ##
##   ####   ####   ##  ## ## ###
##   ##    ## ##   ##  ## ##  ###
##   ##    ## ##   ##  ## ##   ##
##   ##     ## ##   ## ## ## ###
##


get '' => sub { forward $prefix . '/' } ;

get '/' => require_role user => sub {
    my @users = schema->resultset('User')->all ;
    template 'users', { users => \@users } ;
    } ;

get '/test' => require_role user => sub {
    my @users = schema->resultset('User')->all ;
    template 'users', { users => \@users } ;
    } ;

get '/:user' => require_role user => sub {
    # my @users = schema->resultset('User')->all ;
    # template 'users', { users => \@users } ;
    } ;

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


id              - not changable
username        - changable by admin only
password        - changable by user, admin
name            - changable by user, admin
email           - changable by user, admin
deleted         - changable by admin only
lastlogin       - changable only by system
pw_changed      - changable only by system
pw_reset_code   - changable only by system

user_roles      - settable by admin only
