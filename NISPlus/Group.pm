# $Id: Group.pm,v 1.4 1996/03/13 12:58:32 rik Exp $

require Net::NISPlus::Object;

package Net::NISPlus::Group;

@ISA = qw(Net::NISPlus::Object);

sub new
{
  my($name, $path) = @_;
  my($self) = {};

  $path = Net::NISPlus::nis_local_group() if (! $path)

  bless $self;
}

sub DESTROY
{
}
