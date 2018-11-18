package PolkaDots;
use App::Cmd::Setup -app;
use strict;
use warnings;
use local::lib;
 
our $VERSION = '0.1.0';
 
=head1 NAME
 
pdots - dotfile manager so awesome it makes your dotfiles dance!
 
=head1 USAGE
 
  pdots <tool> [tool-options] <toolargs> [<tool-args> ...]
  pdots <option>
     
=cut

 
sub global_opt_spec {
  return (
    [ 'help',    'displays the help (full manpage)' ],
    [ 'usage',   'displays the usage of the command' ],
    [ 'version', 'displays version information' ],
  );
}
 
sub config {
  my ($self) = @_;
  $self->{config} ||= (-e '.pdots'
    ? YAML::XS::LoadFile('.pdots')
    : {}
  );
}
 
sub load_command_options {
  my ($self, $command) = @_;
  if ($command && $self->config->{$command}) {
    split(/\s+/, $self->config->{$command});
  }
  else {
    ();
  }
}
 
sub prepare_args {
  my ($self) = @_;
  if (@ARGV) {
    my $command = shift @ARGV;
    my @options = $self->load_command_options($command);
    unshift @ARGV, $command, @options;
  }
  (@ARGV);
}
 
1;

__END__

=head1 DESCRIPTION
 
 pdots is a suite of source code analysis tools, aimed at being
 language-independent and extensible. The 'pdots' program is a wrapper for the
 pdots tools, which do the real work, so most of the time you'll be using one
 specific tool among the available ones. See TOOLS below for more information.
  
=head1 TOOLS
 
 pdots has several individual tools that share a core infrastructure, but do
 different analysis and produce different output. They are normally invoked like
 this:
  
    pdots <tool> [tool-options] <tool-args> [<tool-args> ...]
     
 Although you can invoke pdots tools against one or few files inside a project,
 normally it only makes sense to run it against the entire source tree (e.g.
 passing "." or "./src" as input directories).
      
 The options and output are specific to each tool, so make sure to read the
 corresponding manual for the tool(s) you want.
       
 Run B<pdots> withtout any command line arguments to see the list of available
 tools.
        
=head1 OPTIONS
 
 The following are the options for the wrapper pdots script. The options for
 each tools are documented in the respective tool's manual page.
  
=over
 
=item --version
 
 Displays version information and exits.
  
=item --help
 
 Displays the manpage for the 'pdots' script or any pdots 'tool'.
  
=item --usage
 
 Displays the only usage of the named tool, instead of display its manpage.
  
=back
 
=head1 CONFIGURATION FILE
 
 pdots can be configured in a per-project way by means of a file called
 I<.pdots> in the current directory. The syntax for this file is: one line per
 tool, each line has the tool name, a colon and one or more command line
 options:
  
    <tool-name>: OPTIONS
     
     When you run an pdots tool from inside that directory, it will load
     I<.pdots> and act as if the options specified there were actually passed to
     it in the command line. Note that options in the command line will override any
     options in configuration files, though.
      
      Example:
       
         metrics: --language cpp
           graph: --modules
            
            You can store a file like that in the root directory of your project. Every
            time you run B<pdots metrics> from that directory, it will only consider C++
            code. When you run B<pdots graph> from that directory  it will use the
            I<--modules> option.
             
=head1 HISTORY
 
 pdots started as a modified version of egypt, by Andreas Gustafsson
 (available at http://www.gson.org/egypt/ as of the time this is being written).
 But since then so many features were added (and removed) that at some point
 during October 2009 it felt like it wasn't egypt anymore, and a new name was
 needed. The project was then renamed to pdots, which means "analysis" in
 Esperanto.
  
  It was also relicensed under the GPL version 3. This relicensing was possible
  because the license of the original egypt allows that: "the same terms as Perl
  itself" mean either Artistic License or GPL version 1 or later.
   
=head1 COPYRIGHT
 
=over
 
=item Copyright (c) 1994-2006 Andreas Gustafsson
 
=item Copyright (c) 2008-2010 Antonio Terceiro
 
=item Copyright (c) 2014-2017 Joenio Costa
 
=back
 
 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.
  
=head1 AUTHORS
 
 Andreas Gustafsson wrote the original version of pdots. Since them several
 people contributed to pdots's development. See the AUTHORS file for a complete
 list.
  
=cut
