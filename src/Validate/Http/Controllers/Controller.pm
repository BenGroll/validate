package Validate::Http::Controllers::Controller;

use strict;
use warnings;

use Foundation::Appify;

my $folder = getFolder();
# unshift @INC, $folder . '../../Validate';
use Data::Dumper;
use JSON;
use Validate::Config::Json;
use Validate::Config::DB;
use Validate::Config::Table;


sub new {
    my $class = shift;

    my $self = {};
    bless $self, $class;

    return $self;
}

sub welcome {
    my $self = shift;
    my $request = shift;

    my $configcontroller = $request->{configcontroller};
    
    my $params = \%{$request->Vars};
    my $folder = getFolder();

    my $configData = $configcontroller->new()->active();

    my $index = Validate::Config::Table->new($configData);

    my $table = $index->render();
    my $template = &_::template('validate::config', {configtable => $table});
    
    return $template->output;
}

sub test {
    my $self = shift;
    my $request = shift;

    my $configcontroller = $request->{configcontroller};
    # die $configcontroller;
    
    my $params = \%{$request->Vars};
    my $folder = getFolder();

    my $configData = $configcontroller->new()->active();
    # die Dumper($configData);

    # app()->pushToStack('scripts', servicePath('validationService') . '/script.js');

    my $form = &_::template('validate::welcome', paramsForFormSite($configData));

    return $form->output;
}

sub paramsForFormSite {
    my $configData = shift;
    return {
        config => encode_json($configData),
        unamelength => $configData->{"minimum_username_length"}->{value},
        pwordlength => $configData->{"minimum_length"}->{value}
    };
}

sub showMessage {
    my $self = shift;
    my $request = shift;

    # TODO: Do something useful.

    return $self->welcome($request);
}


sub getFolder {
    return join ('/', splice(@{[split(/\//, __FILE__)]},
        0, 
        scalar @{[split(/\//, __FILE__)]} -1)) . "/";
}

1;
