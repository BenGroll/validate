package Validate::Validator;

use strict;
use warnings;

use Cwd;
use Cwd 'abs_path';
use Data::Dumper;
use lib;
use JSON;

sub new {
    my $class = shift;
    my $configHandler = shift or die "Must specify Config handler for Validator (e.g 'Validate::Config::Json')";

    my $self = {
        errors => [],
        config => $configHandler->new()->active(),
    };

    return bless($self, $class);
}

sub errors {
    my $self = shift;
    my $args = shift;
    if ($args) {
        $self->{errors} = $args;
        return $self;
    }
    return $self->{errors};
}


sub fetchErrorsForStack {
    my $self = shift;
    
    my $errors = $self->{errors};
    
    my @errorData = ();
    foreach my $error (@$errors) {
        push(@errorData, {message => $error});
    }
    return \@errorData;
}

sub validate {
    my $self = shift,
    my @stringToValidate = split(//, shift());
    my $config = $self->{config};
    foreach my $validation (sort(keys %$config)) {
        if($config->{$validation} && $config->{$validation}->{use}) {
            my $subroutineName = "validate_" . $validation;
            unless ($self->can($subroutineName)) {
                die "No method $subroutineName";
            }
            my $result = $self->$subroutineName($config->{$validation}->{value}, \@stringToValidate);
            if ($result) {
                my $errors = $self->{errors};
                my @buffer = @$errors;
                push(@buffer, $result);
                $self->{errors} = \@buffer;
            }
        }
    }
    return $self;
}

sub validate_minimum_length {
    my $self = shift;
    my $length = shift;
    my $stringToValidate = shift;
    
    if (scalar @$stringToValidate < $length) {
        return "Must be at least $length characters long.";
    }
}

sub validate_special_characters {
    #Nothing to validate, just has to be defined for code simplicity
}

sub validate_expected_specialcharacter_count {
    my $self = shift;
    my $characterCount = shift;
    my $stringToValidate = shift;

    my @specialCharacters = split //, $self->{config}->{specialCharacters}->{value};
    foreach my $char (@$stringToValidate) {
        $char = $char eq '?' ? '\?' : $char;
        if (grep /$char/, @specialCharacters) {
            $characterCount -= 1;
        }
        # die $char . $characterCount;
    }
    if ($characterCount > 0) {
        return "Must contain $characterCount more special Character(s) (" . join ('', @specialCharacters) . ").";
    }

}

sub validate_valid_characters {
    my $self = shift;
    my @validChars = split //, shift 
        # Include special characters and numbers
        . $self->{config}->{specialCharacters}->{value}
        . "1234567890";
    my $stringToValidate = shift;

    my @invalidChars = ();
    foreach my $char (@$stringToValidate) {
        $char = $char eq '?' ? '\?' : $char;
        unless (grep /$char/, @validChars) {
            push(@invalidChars, $char);
        }
    }
    if (scalar @invalidChars > 0) {
        return "Contains invalid Char(s): " . join ('', @invalidChars) . ".";
    }
}

sub validate_expected_number_count {
    my $self = shift;
    my $characterCount = shift;
    my $stringToValidate = shift;

    foreach my $char (@$stringToValidate) {
        $char = $char eq '?' ? '\?' : $char;
        if (grep /$char/, split(//, "0123456789")) {
            $characterCount -= 1;
        }
    }
    if ($characterCount > 0) {
        return "Must contain $characterCount more number(s).";
    }
}

sub validate_config {
    my $self = shift;
    my $configParams = shift;
    
    return Validate::Config::Json->fromHttpParams($configParams);
    
}

1;