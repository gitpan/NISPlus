# $Id: Group.pm,v 1.3 1995/11/09 06:31:43 rik Exp $

require Net::NISPlus;

package Net::NISPlus::Group;

@ISA = qw(Net::NISPlus::Object);

sub new
{
  my($name, $path) = @_;

  $path = Net::NISPlus::nis_local_group() if (! $path)

  bless $self;
}

sub DESTROY
{
}
