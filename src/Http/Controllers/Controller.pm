package Validate::Http::Controllers::Controller;

use strict;
use warnings;

use CGI::Carp qw (warningsToBrowser fatalsToBrowser);
use Cwd;
use Cwd 'abs_path';
use Data::Dumper;
use File::Basename;
use Foundation::Appify;
use HTML::Template;
use JSON;
use lib dirname(__FILE__) . '/../../';
# use Validate::Validator;
# use Validate::Config::Table;
# use Validate::Config::Json;
# use Validate::Config::DB;


sub new {
    my $class = shift;

    bless {mode => "json"}, $class;
}


sub welcome {
    my $self = shift;
    my $request = shift;
    die;
    my $configSaveMode = $request->{configSaveMode};
    my $params = \%{$request->Vars};
    delete($params->{__route__});
    if(scalar (keys %$params) > 1) {
        return $self->configPOST($request, $params);
    }
    
    my $configData = $configSaveMode->active();
    my $table = Validate::Config::Table->new($configData);


    my $template = &_::template('validationService::config', {configtable => $table->render});

    return $template->output;
}

sub configPOST {
    my $self = shift;
    my $request = shift;
    my $params = shift;
    my $configSaveMode = $request->{configSaveMode};

    my $newConfig = Validate::Validator->validateConfig($params);
    $configSaveMode->setAsActive($newConfig);   

    my $configData = $configSaveMode->active();
    my $table = Validate::Config::Table->new($configData);


    my $template = &_::template('validationService::config', {configtable => $table->render});

    return $template->output;

}


sub getFolder {
    return join ('/', splice(@{[split(/\//, __FILE__)]},
        0, 
        scalar @{[split(/\//, __FILE__)]} -1)) . "/";
}

1;
