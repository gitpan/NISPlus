# $Id: Directory.pm,v 1.3 1995/11/09 06:31:43 rik Exp $

require Net::NISPlus;

package Net::NISPlus::Directory;

@ISA = qw(Net::NISPlus::Object);

sub new
{
  my($name, $path) = @_;

  $path = Net::NISPlus::nis_local_directory() if (! $path);

  $path !~ /^org_dir\./ && do { $path = "org_dir.$path"; };

#  if (! Net::NISPlus::is_valid_dir($path))
#  {
#    warn("$path is not valid\n");
#  }

  $self->{'full_path'} = $path;

  bless $self;
}


sub list
{
  my($me) = shift;
  my($ret, @res);

  ($ret, @res) = Net::NISPlus::name_list($me->{'full_path'});
  if ($ret != 0)
  {
    print "error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n";
    return ();
  }
  else
  {
    return @res;
  }
}


sub add
{
}


sub delete
{
}


sub create
{
}


sub DESTROY
{
}

1;
__END__
