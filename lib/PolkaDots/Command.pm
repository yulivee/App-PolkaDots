package PolkaDots::Command;
use App::Cmd::Setup -command;
use strict;
use warnings;
use Class::Inspector;
use Env::Path qw( PATH );

=head1 NAME
 
PolkaDots::Command - global options for tools
 
=head1 DESCRIPTION
 
Following the instructions from the L<App::Cmd::Tutorial> we create this module
to be a superclass of every pdots tool, in that way we can have global
options to every pdots tool:
 
  pdots <tool> --help
  pdots <tool> --usage
 
Any pdots tool should implement B<validate()>, method which is called by
B<validate_args()> implemented here. See L<App::Cmd::Command> for details about
B<validate_args()>.
 
=cut

sub validate_args {
  my ($self, $opt, $args) = @_;
  if ($self->app->global_options->version) {
    $self->usage_error("Invalid option: --version");
  }
  elsif ($self->app->global_options->usage) {
    print $self->app->usage, "\n", $self->usage;
    exit 0;
  }
  $self->validate($opt, $args);
}
 
sub version_information {
  my ($self) = @_;
  sprintf("%s version %s", $self->app->arg0, $PolkaDots::VERSION);
}
 
sub show_manpage {
  my ($self, $package, $command_name) = @_;
  my $version_information = $self->version_information;
  my $file = Class::Inspector->resolved_filename($package);
  if (scalar PATH->Whence('man')) {
    exec("pod2man --name='pdots-$command_name' --release='$version_information' --center='PolkaDots documentation' '$file' | man -l -");
  }
  elsif (scalar PATH->Whence('less')) {
    exec("pod2text '$file' | less");
  }
  elsif (scalar PATH->Whence('more')) {
    exec("pod2text '$file' | more");
  }
  else {
    exec("pod2text '$file'");
  }
}

1;

=head1 COPYRIGHT AND AUTHORS
 
See B<pdots(1)>.
 
=cut
