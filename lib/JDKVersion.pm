package JDKVersion;

use Data::Dump qw/dump/;

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
    my $self = shift;
    $self->{family_number};
}

sub update_number {
    my $self = shift;
    $self->{update_number};
}

sub lt {
    my $self = shift;
    my $version_object = shift;
    if ($self->family_number < $version_object->family_number) {
        return 1;
    } elsif ($self->family_number > $version_object->family_number) {
        return 0;
    } else {
        if ($self->update_number < $version_object->update_number) {
            return 1;
        }
    }
    return 0;
}

sub gt {
    my $self = shift;
    my $version_object = shift;
    if ($self->family_number > $version_object->family_number) {
        return 1;
    } elsif ($self->family_number < $version_object->family_number) {
        return 0;
    } else {
        if ($self->update_number > $version_object->update_number) {
            return 1;
        }
    }
    return 0;
}

sub eq {
    my $self = shift;
    my $version_object = shift;
    $self->family_number.$self->update_number == $version_object->family_number.$version_object->update_number ? 1 : 0;
}

sub next_limited_udpate {
    my $self = shift;
    $self->{update_number} = 20 * (int($self->{update_number}/20) + 1);
    return $self;
}

sub next_critical_patch_update {
    my $self = shift;
    $self->{update_number} = 5 * (int($self->{update_number}/5) + 1);
    $self->{update_number}++ if $self->{update_number} % 2 == 0;
    return $self;
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
