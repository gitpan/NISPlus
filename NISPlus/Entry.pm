# $Id: Entry.pm,v 1.2 1996/11/25 22:04:43 rik Exp $

require Net::NISPlus::Object;

package Net::NISPlus::Entry;

@ISA = qw(Net::NISPlus::Object);

sub new
{
  my($name, $table) = @_;
  my($self) = {};

  bless $self;
}

sub remove
{
}

sub modify
{
}

sub info
{
  my($me) = shift;
 
  return { %$me };
}

sub setinfo
{
  my($me) = shift;

  my($info) = shift;
  my($ret, $res, $srchstring);
 
  @colnames = $me->{'table'}->colnames();
  $srchstring = "[";
  foreach $key ($[..$#colnames)
  {
    $srchstring .= "," unless length($srchstring) == 1;
    $srchstring .= "$colnames[$key]=$me->{'values'}->[$key]";
  }
  $srchstring .= "],$me->{'name'}.$me->{'domain'}";
 
  ($ret, $res) = Net::NISPlus::table_setinfo($srchstring, $info);
  if ($ret != 0)
  {
    warn("setinfo error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return ();
  }
  else
  {
    return $res;
  }
}

sub DESTROY
{
}
