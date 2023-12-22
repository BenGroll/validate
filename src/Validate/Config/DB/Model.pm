package Validate::Config::DB::Model;

use strict;
use warnings;
use Data::Dumper;



sub new {
    my $class = shift;
    my $self = {
        id => shift,
        title => shift,
        minimum_length => shift,
        use_minimum_length => shift,
        expected_number_count => shift,
        use_expected_number_count => shift,
        valid_characters => shift,
        use_valid_characters => shift,
        expected_specialcharacter_count => shift,
        use_expected_specialcharacter_count => shift,
        special_characters => shift,
        use_special_characters => shift,
        minimum_username_length => shift,
        use_minimum_username_length => shift,
        active_configuration => shift
    };
    bless($self, $class);
}

sub toJsonConfig {
    my $self = shift;
    
    my $templateConfig = Validate::Config::Json->template();
    my $jsonconfig = {};
    foreach my $key (keys %$templateConfig) {
        my $data = {};
        $data->{use} = $self->{'use_' . $key};
        $data->{inputType} = $templateConfig->{$key}->{inputType};
        $data->{value} = $self->{$key};
        $jsonconfig->{$key} = $data;
    }
    return $jsonconfig;
}

1;