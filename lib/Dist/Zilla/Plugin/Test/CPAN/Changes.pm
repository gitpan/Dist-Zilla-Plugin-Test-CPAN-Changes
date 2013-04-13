package Dist::Zilla::Plugin::Test::CPAN::Changes;
use strict;
use warnings;
# ABSTRACT: release tests for your changelog
our $VERSION = '0.006'; # VERSION

use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with    'Dist::Zilla::Role::FileMunger';
with    'Dist::Zilla::Role::PrereqSource';


has changelog => (
    is      => 'ro',
    isa     => 'Str',
    predicate => 'has_changelog',
);


sub munge_file {
    my $self = shift;
    my $file = shift;
    return unless $file->name eq 'xt/release/cpan-changes.t';

    if ($self->has_changelog) {
        my $content = $file->content;
        my $changelog = $self->changelog;
        $content =~ s{\Qchanges_ok();\E}{changes_file_ok('$changelog');};
        $file->content($content);
    }
    return;
}

# Register the release test prereq as a "develop requires"
# so it will be listed in "dzil listdeps --author"
sub register_prereqs {
  my ($self) = @_;

  $self->zilla->register_prereqs(
    {
      type  => 'requires',
      phase => 'develop',
    },
    # Latest known release of Test::CPAN::Changes
    # because CPAN authors must use the latest if we want
    # this check to be relevant
    'Test::CPAN::Changes'     => '0.19',
  );
}





__PACKAGE__->meta->make_immutable;
no Moose;

=pod

=encoding utf-8

=head1 NAME

Dist::Zilla::Plugin::Test::CPAN::Changes - release tests for your changelog

=head1 VERSION

version 0.006

=head1 SYNOPSIS

In C<dist.ini>:

    [Test::CPAN::Changes]

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following file:

    xt/release/cpan-changes.t - a standard Test::CPAN::Changes test

See L<Test::CPAN::Changes> for what this test does.

=head2 Alternate changelog filenames

L<CPAN::Changes::Spec> specifies that the changelog will be called 'Changes' -
if you want to use a different filename for whatever reason, do:

    [Test::CPAN::Changes]
    changelog = CHANGES

and that file will be tested instead.

=for test_synopsis 1;
__END__

=for Pod::Coverage munge_file register_prereqs

=head1 AVAILABILITY

The project homepage is L<http://p3rl.org/Dist::Zilla::Plugin::Test::CPAN::Changes>.

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see L<https://metacpan.org/module/Dist::Zilla::Plugin::Test::CPAN::Changes/>.

=head1 SOURCE

The development version is on github at L<http://github.com/doherty/Dist-Zilla-Plugin-Test-CPAN-Changes>
and may be cloned from L<git://github.com/doherty/Dist-Zilla-Plugin-Test-CPAN-Changes.git>

=head1 BUGS AND LIMITATIONS

You can make new bug reports, and view existing ones, through the
web interface at L<https://github.com/doherty/Dist-Zilla-Plugin-Test-CPAN-Changes/issues>.

=head1 AUTHOR

Mike Doherty <doherty@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Mike Doherty.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

__DATA__
__[ xt/release/cpan-changes.t ]__
#!perl

use Test::More;
use_ok('Test::CPAN::Changes');
changes_ok();
done_testing();
