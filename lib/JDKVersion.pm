package JDKVersion;

sub new {
    my $class = shift;
    my %args = @_ == 1 ? %{$_[0]} : @_;
    bless \%args, $class;
}

sub is_valid {
    my $version_name = shift;
    if ($version_name =~ /^JDK\du(\d+)$/) {
        my $num = $1;
        if (&_is_zero_ume($num)) {
            return 0;
        } else {
            return 1;
        }
    } else {
        return 0;
    }
}

sub _is_zero_ume {
    my $num = shift;
    if( length $num != length int $num ) {
        return 1;
    } else {
        return 0;
    }
}

1;
