# $Id: Object.pm,v 1.4 1996/03/13 12:58:32 rik Exp $

require Net::NISPlus;

package Net::NISPlus::Object;

sub print
{
  my($me) = shift;

  Net::NISPlus::nis_print_object($me->object);
}

sub object
{
  my($me) = shift;

  if (! $me->{'object'})
  {
    if ( !($me->{'object'} = Net::NISPlus::nis_lookup($me->{'full_path'})))
    {
      die "can't look up object $me->{'full_path'}: ",
        Net::NISPlus::nis_sperrno(Net::NISPlus::last_error);
    }
  }
  $me->{'object'};
}

sub type
{
  my ($me) = shift;

  Net::NISPlus::obj_type($me->object);
}
