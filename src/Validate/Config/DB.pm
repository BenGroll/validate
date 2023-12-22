package Validate::Config::DB;

use strict;
use warnings;

use Data::Dumper;
use DBI;
use JSON;
use Validate::Config::DB::Model;
use Validate::Config::Json;

sub new {
    my $class = shift;
    
    my @driver_names = DBI->available_drivers;
    my $driver = "mysql";
    my $database = "cs_bens_database";
    my $dsn = "DBI:$driver:database=$database";
    my $db = DBI->connect($dsn, 'root', 'admin') or die $DBI::errstr;
    my $self = {controller => $db};


    bless ($self, $class);
}

sub active {
    my $self = shift;

    my $db = $self->{controller};

    my $query = "SELECT * FROM validation_configurations WHERE active_configuration = 1;";
    my $sth = $db->prepare($query);
    $sth->execute();
    my $row = $sth->fetchrow_arrayref();

    my $model = Validate::Config::DB::Model->new(@$row);

    return $model->toJsonConfig();
}

sub setAsActive {
    my $self = shift;
    my $data = shift;
}

sub template {
    my $self = shift;
    my $path = shift;

    
}

sub fromHttpParams {
    my $self = shift;
    my $params = shift;
    my $templateConfig = $self->template();

    die Dumper($params);


    foreach my $param (keys %$params) {
        my $useFlag = 0;
        unless (grep /$param/, keys %$templateConfig) {
            if (index($param, "use") == 0) {
                my @splitparam = split(/use/, $param);
                my $paramName = @splitparam[1];
                $templateConfig->{$paramName}->{use} = $params->{$param} eq 'on' ? 1 : 0;
                $useFlag = 1;
            } else {
                die "Wrong Parameter: $param";  
            }
        } else {
            $templateConfig->{$param}->{value} = $params->{$param};
        }

    }
    return $templateConfig;
}

sub getFolder {
    return join ('/', splice(@{[split(/\//, __FILE__)]},
        0, 
        scalar @{[split(/\//, __FILE__)]} -1)) . "/";
}
1;

1;
