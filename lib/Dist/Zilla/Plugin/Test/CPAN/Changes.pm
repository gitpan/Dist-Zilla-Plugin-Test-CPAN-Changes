package Dist::Zilla::Plugin::Test::CPAN::Changes;
use strict;
use warnings;
# ABSTRACT: release tests for your changelog
our $VERSION = '0.003'; # VERSION

use Moose;
extends 'Dist::Zilla::Plugin::InlineFiles';
with    'Dist::Zilla::Role::FileMunger';


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

__PACKAGE__->meta->make_immutable;
no Moose;



=pod

=encoding utf-8

=head1 NAME

Dist::Zilla::Plugin::Test::CPAN::Changes - release tests for your changelog

=head1 VERSION

version 0.003

=head1 SYNOPSIS

In C<dist.ini>:

    [ChangesTests]

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following file:

    xt/release/cpan-changes.t - a standard Test::CPAN::Changes test

See L<Test::CPAN::Changes> for what this test does.

You should use this plugin instead of L<Dist::Zilla::Plugin::CPANChangesTests>
because this one lets you cheat on the filename.

=head2 Alternate changelog filenames

L<CPAN::Changes::Spec> specifies that the changelog will be called 'Changes' -
if you want to use a different filename for whatever reason, do:

    [ChangesTests]
    changelog = CHANGES

and that file will be tested instead.

=for Pod::Coverage munge_file

=head1 AVAILABILITY

The latest version of this module is available from the Comprehensive Perl
Archive Network (CPAN). Visit L<http://www.perl.com/CPAN/> to find a CPAN
site near you, or see L<http://search.cpan.org/dist/Dist-Zilla-Plugin-Test-CPAN-Changes/>.

The development version lives at L<http://github.com/doherty/Dist-Zilla-Plugin-Test-CPAN-Changes>
and may be cloned from L<git://github.com/doherty/Dist-Zilla-Plugin-Test-CPAN-Changes.git>.
Instead of sending patches, please fork this project using the standard
git and github infrastructure.

=head1 SOURCE

The development version is on github at L<http://github.com/doherty/Dist-Zilla-Plugin-Test-CPAN-Changes>
and may be cloned from L<git://github.com/doherty/Dist-Zilla-Plugin-Test-CPAN-Changes.git>

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests through the web interface at
L<http://github.com/doherty/Dist-Zilla-Plugin-Test-CPAN-Changes/issues>.

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
eval 'use Test::CPAN::Changes';
plan skip_all => 'Test::CPAN::Changes required for this test' if $@;
changes_ok();
done_testing();
