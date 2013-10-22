package JDKVersion;

sub parse {
    my $class = shift;
    my $version = shift;
    die 'parse error!' unless is_valid($version);

    my ($family_number, $update_number) = _get_family_and_update_number($version);
    bless {
        version => $version,
        family_number => $family_number,
        update_number => $update_number,
    }, $class;
}

sub family_number {
    my $class = shift;
    $class->{family_number};
}

sub update_number {
    my $class = shift;
    $class->{update_number};
}

sub lt {
    my $class = shift;
    my $version_object = shift;
    return 1;
}

sub is_valid {
    my $version_name = shift;
    if ($version_name =~ /^JDK\du(\d+)$/) {
        my $num = $1;
        return if _is_zero_ume($num);
        return 1;
    }
    return;
}

sub _get_family_and_update_number {
    my $version = shift;
    $version =~ /^JDK(?<family_number>\d+)u(?<update_number>\d+)$/;
    return ($+{family_number}, $+{update_number});
}

sub _is_zero_ume {
    my $num = shift;
    length $num != length int $num;
}

1;
