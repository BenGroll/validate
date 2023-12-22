package Validate::Config::Show;

use strict;
use warnings;

use CGI::Carp qw (warningsToBrowser fatalsToBrowser);
use Cwd;
use Cwd 'abs_path';
use Data::Dumper;
use Switch;

sub new {
    my $class = shift;
    my $configname = shift or die "Need to supply parameter name and config.";
    my $configData = shift or die "Supply single config Hash (parameter and 'use').";
    $configData->{paramName} = $configname;

    bless({configData => $configData}, $class);
}

sub render {
    my $self = shift;

    
    my $data = $self->{configData};
    my $type = inputTypeFromConfig($data);
    
    my $path = getFolder();
    my $template = HTML::Template->new(filename => $path . "templates/configrow.tmpl");
    my $paramnamepolished = $data->{paramName};
    $paramnamepolished =~ s/_/ /g;

    $template->param(
        paramname => $data->{paramName},
        inputType => $type,
        paramnamepolished => ucfirst($paramnamepolished),
        value => $data->{value},
        usevalue => $data->{use},
    );
    return $template->output;

}

sub inputTypeFromConfig {
    my $paramvalue = shift or die "No Parameter supplied for value in inputTypeFromvalue.";
    #replace with automatic inputType from ref
    return $paramvalue->{inputType};
}

sub getFolder {
    return join ('/', splice(@{[split(/\//, __FILE__)]},
        0, 
        scalar @{[split(/\//, __FILE__)]} -1)) . "/";
}


1;