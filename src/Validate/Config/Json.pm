package Validate::Config::Json;
# Works with Json Data instead of relational

use strict;
use warnings;

use Data::Dumper;
use JSON;

sub new {
    my $class = shift;

    bless ({}, $class);
}

sub active {
    my $self = shift;

    my $json_text = do {
        open(my $json_fh, "<", getFolder() . "JSON/activeConfig.json")
            or die("Can't open active config: $!\n");
        local $/;
        <$json_fh>
    };
    my $data = JSON->new()->decode($json_text);
    return $data;
}

sub setAsActive {
    my $self = shift;
    my $data = shift;

    open my $fh, ">", getFolder() . "JSON/activeConfig.json";
    print $fh encode_json($data);
    close $fh;
}

sub template {
    my $self = shift;
    my $path = shift;

    my $json_text = do {
        open(my $json_fh, "<", getFolder() . "JSON/configurations/template.json")
            or die("Can't open template config: $!\n");
        local $/;
        <$json_fh>
    };
    my $data = JSON->new()->decode($json_text);
    return $data;
}

sub fromHttpParams {
    my $self = shift;
    my $params = shift;
    my $templateConfig = $self->template();

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