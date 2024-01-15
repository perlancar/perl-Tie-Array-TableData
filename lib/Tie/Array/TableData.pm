package Tie::Array::TableData;

use 5.010001;
use strict;
use warnings;

# AUTHORITY
# DATE
# DIST
# VERSION

sub TIEARRAY {
    require Module::Load::Util;

    my $class = shift;
    my ($tabledata, $row_as_hashref) = @_;

    die "Please specify a TableData module to instantiate (string or 2-element array)" unless $tabledata;
    my $tdobj = Module::Load::Util::instantiate_class_with_optional_args($tabledata);

    unless ($tdobj->can("get_item_at_pos")) {
        warn "TableData does not support get_item_at_pos(), applying the inefficient implementation";
        require Role::Tiny;
        Role::Tiny->apply_roles_to_object($tdobj, "TableDataRole::Util::GetRowByPos");
    }

    return bless {
        _tdobj => $tdobj,
        _row_as_hashref => $row_as_hashref,
    }, $class;
}

sub FETCH {
    my ($self, $index) = @_;
    $self->{_row_as_hashref} ? $self->{_tdobj}->get_row_at_pos_hashref($index) : $self->{_tdobj}->get_item_at_pos($index);
}

sub STORE {
    my ($self, $index, $value) = @_;
    die "Not supported";
}

sub FETCHSIZE {
    my $self = shift;
    $self->{_tdobj}->get_row_count;
}

sub STORESIZE {
    my ($self, $count) = @_;
    die "Not supported";
}

# sub EXTEND this, count

# sub EXISTS this, key

# sub DELETE this, key

sub PUSH {
    my $self = shift;
    die "Not supported";
}

sub POP {
    my $self = shift;
    die "Not supported";
}

sub UNSHIFT {
    my $self = shift;
    die "Not supported";
}

sub SHIFT {
    my $self = shift;
    die "Not supported";
}

sub SPLICE {
    my $self   = shift;
    die "Not supported";
}

1;
# ABSTRACT: Access TableData object as a tied array

=for Pod::Coverage ^(.+)$

=head1 SYNOPSIS

 use Tie::Array::TableData;

  tie my @ary, 'Tie::Array::TableData', 'Example::DeNiro'   ; # access rows as arrayref
 #tie my @ary, 'Tie::Array::TableData', 'Example::DeNiro', 1; # access rows as hashref

 # get the second row
 my $row = $ary[1];


=head1 DESCRIPTION


=head1 SEE ALSO

L<TableData>

=cut
