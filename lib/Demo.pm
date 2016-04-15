
##
##   ####
##   ## ##   ###  # ## ##   ###     # ##  # ## ##
##   ##  ## ## ## ## ## ## ## ##    ## ## ## ## ##
##   ##  ## ## ## ## ## ## ## ##    ## ## ## ## ##
##   ##  ## ##### ## ## ## ## ##    ## ## ## ## ##
##   ## ##  ##    ## ## ## ## ## ## ## ## ## ## ##
##   ####    #### ## ## ##  ###  ## ####  ## ## ##
##                                  ##
                                    ##

# This is meant to be the "core" of the page, handing just the 
# login, logout, index page and '404' pages.

# Consider dropping the "user" role, and using require_login instead.

package Demo ;
use feature qw{ say state } ;
use strict ;
use warnings ;

use Data::Dumper ;
use FindBin ;
use Try::Tiny ;

use Dancer2 ;
use Dancer2::Plugin::DBIC qw(schema resultset rset) ;
use Dancer2::Plugin::Auth::Extensible ;

use Demo::Work ;
use Demo::User ;

our $VERSION = '0.1' ;

set session => "YAML" ;

prefix undef ;

## THIS CODE IS FOR MAKING SURE ONLY LOGGED-IN USERS SEE MORE THAN
## /login. NOT THE CURRENT GAME PLAN.

# hook before => sub {
#     if ( !session('user') && request->dispatch_path !~ m{^/login} ) {
#         forward '/login', { requested_path => request->dispatch_path } ;
#         }
#     } ;


##                          ## ##
##   ##  ##                 ## ##
##   ##  ##  ###   # ##   #### ##  ###  ## #  ###
##   ##  ##    ##  ## ## ## ## ## ## ## #### ##
##   ######  ####  ## ## ## ## ## ## ## ##   ###
##   ##  ## ## ##  ## ## ## ## ## ##### ##    ###
##   ##  ## ## ##  ## ## ## ## ## ##    ##     ##
##   ##  ##  ## ## ## ##  ## # ##  #### ##   ###
##


sub login_page_handler {
    template 'login' ;
    }

sub permission_denied_page_handler {
    template 'denied' ;
    }


##                   ##           ##             ##
##   ##    ##                     ## ##          ##
##   ###  ###  ###   ## # ##     ##  ## # ##   ####  ###  ## #
##   #### ###    ##  ## ## ##    ##  ## ## ## ## ## ## ## ## #
##   # ### ##  ####  ## ## ##   ##   ## ## ## ## ## ## ##  ##
##   #  #  ## ## ##  ## ## ##  ##    ## ## ## ## ## #####  ##
##   #  #  ## ## ##  ## ## ##  ##    ## ## ## ## ## ##    # ##
##   #     ##  ## ## ## ## ## ##     ## ## ##  ## #  #### # ##
##                            ##


get '' => sub {
    template 'index' ;
    } ;
get '/' => sub {
    template 'index' ;
    } ;

get '/dashboard' => require_role admin => sub {
    template 'index' ;
    } ;

get '/about' => sub {
    template 'index' ;
    } ;


##                     ##           ##
##   ##                             ## ##                             ##
##   ##     ###   #### ## # ##     ##  ##     ###   ####  ###  ## ## ####
##   ##    ## ## ## ## ## ## ##    ##  ##    ## ## ## ## ## ## ## ##  ##
##   ##    ## ## ## ## ## ## ##   ##   ##    ## ## ## ## ## ## ## ##  ##
##   ##    ## ## ## ## ## ## ##  ##    ##    ## ## ## ## ## ## ## ##  ##
##   ##    ## ## ## ## ## ## ##  ##    ##    ## ## ## ## ## ## ## ##  ##
##   #####  ###   #### ## ## ## ##     #####  ###   ####  ###   ## #   ##
##                  ##          ##                    ##
                 ####                              ####

get 'signup' => sub {
    template 'index' ;
    } ;

post '/login' => sub {
    my ( $success, $realm )
        = authenticate_user( params->{username}, params->{password} ) ;
    if ($success) {
        session logged_in_user       => params->{username} ;
        session logged_in_user_realm => $realm ;
        }
    else {
        # authentication failed
        session->destroy ;
        }
    } ;

any '/logout' => sub {
    template 'index' ;
    session->destroy ;
    } ;


##
##   ####
##   ## ##  ## ## # ## ##  # ##
##   ##  ## ## ## ## ## ## ## ##
##   ##  ## ## ## ## ## ## ## ##
##   ##  ## ## ## ## ## ## ## ##
##   ## ##  ## ## ## ## ## ## ##
##   ####    ## # ## ## ## ####
##                         ##
                           ##

post '/dump' => sub {
	my $params = params ;
	my $dump = Dumper $params ;
    template 'dump' , { dump => $dump } ;
    } ;


##
##      ##   ####     ##    ####
##     ###  ##  ##   ###    ## ##  ###    ####  ###
##    # ##  ##  ##  # ##    ## ##    ##  ## ## ## ##
##   #  ##  ##  ## #  ##    ####   ####  ## ## ## ##
##   ###### ##  ## ######   ##    ## ##  ## ## #####
##      ##  ##  ##    ##    ##    ## ##  ## ## ##
##      ##   ####     ##    ##     ## ##  ####  ####
##                                          ##
                                         ####

any qr{.*} => sub {
    template 'index' ;
    # status 'not found' ;
    # return '404 Page Not Found' ;
    } ;

true ;
