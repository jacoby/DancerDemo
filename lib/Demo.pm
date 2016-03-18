package Demo;
use feature qw{ say state } ;
use strict ;
use warnings ;

use FindBin ;
use Data::Dumper ;

use Dancer2 ;
use Dancer2::Plugin::DBIC qw(schema resultset rset) ;
use Dancer2::Plugin::Auth::Extensible ;

our $VERSION = '0.1' ;

set session => "Simple" ;

# hook before => sub {
#     if ( !session('user') && request->dispatch_path !~ m{^/login} ) {
#         forward '/login', { requested_path => request->dispatch_path } ;
#         }
#     } ;

sub login_page_handler {
    template 'login';
    }

sub permission_denied_page_handler {
    template 'denied';
    }

get '/' => sub {
    template 'index';
};

get '/dashboard' => require_role admin => sub {
    template 'index';
};

get '/kiddiepool' => require_role user => sub {
    template 'index';
};

get '/users' => require_role admin => sub  {
    my @users = schema->resultset('User')->all ;
    template 'users', { users => \@users } ;
    } ;

post '/login' => sub {
    my ($success, $realm) = authenticate_user(
        params->{username}, params->{password}
    );
    if ($success) {
        session logged_in_user => params->{username};
        session logged_in_user_realm => $realm;
        # other code here
    } else {
        # authentication failed
        session->destroy;
    }
};
 
any '/logout' => sub {
    session->destroy;
};

true;
