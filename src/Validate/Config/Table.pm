package Validate::Config::Table;

use strict;
use warnings;

use CGI::Carp qw (warningsToBrowser fatalsToBrowser);
use Cwd;
use Cwd 'abs_path';
use Data::Dumper;
use Validate::Config::Show;

sub new {
    my $class = shift;
    my $config = shift or die "No Config provided!";

    bless ({config => $config}, $class);
}

sub render {
    my $self = shift;

    my $config = $self->{config};
    my @rows = ();
    foreach my $param (sort(keys %$config)) {
        my $show = Validate::Config::Show->new($param, $config->{$param});
        my $row = $show->render();
        push(@rows, {row => $row});
    }
    my $path = getFolder();
    my $table = HTML::Template->new(filename => $path . "templates/configtable.tmpl");
    $table->param(
        rows => \@rows
    );
    return $table->output();
}

sub getFolder {
    return join ('/', splice(@{[split(/\//, __FILE__)]},
        0, 
        scalar @{[split(/\//, __FILE__)]} -1)) . "/";
}

1;