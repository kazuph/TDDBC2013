package JDKVersion;

sub parse {
    my $class = shift;
    my $versions = shift;
    die 'parse error!' unless is_valid($versions);
    bless { versions => $versions }, $class;
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

sub _is_zero_ume {
    my $num = shift;
    length $num != length int $num;
}

1;
