# $Id: Table.pm,v 1.3 1995/11/09 06:31:43 rik Exp $

require Net::NISPlus;

package Net::NISPlus::Table;

@ISA = qw(Net::NISPlus::Object);

sub new
{
  my($name, $path) = @_;

  $self->{'full_path'} = $path;

  bless $self;
}

sub list
{
  my($me) = shift;
  my($ret, @res);

  ($ret, @res) = Net::NISPlus::entry_list($me->{'full_path'});
  if ($ret != 0)
  {
    warn("error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return ();
  }
  else
  {
    return @res;
  }
}

sub colnames
{
  my($me) = shift;
  my($ret, $res);

  ($ret, $res) = Net::NISPlus::table_info($me->{'full_path'});
  if ($ret != 0)
  {
    warn("error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return ();
  }
  else
  {
    return(@{$res->{'ta_cols'}});
  }
}

sub info
{
  my($me) = shift;
  my($ret, $res);

  ($ret, $res) = Net::NISPlus::table_info($me->{'full_path'});
  if ($ret != 0)
  {
    warn("error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return ();
  }
  else
  {
    return $res;
  }
}

# Add an entry to the table.  Any columns not specified will be set to
# null strings.
#
# $table->add('key1' => 'value1', 'key2' => 'value2');
#
sub add
{
  my($me, %data) = @_;
  my($ret, $res);

  ($ret, $res) = Net::NISPlus::nis_add_entry($me->{'full_path'}, \%data);
  if ($ret != 0)
  {
    warn("error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return ();
  }
  else
  {
    return $res;
  }
}

# Remove a single entry from the table.  If the key/value pairs match
# more that one entry, an error occurs, and no entries are removed.  Use
# removem to remove multiple entries with a single command.
#
# $table->remove('key1' => 'value1', 'key2' => 'value2');
#
sub remove
{
  my($me, %data) = @_;
  my($ret);

  my($name) = "[";
  foreach (keys %data) { $name .= "$_=$data{$_},"; }
  substr($name, -1, 1) = "],$me->{'full_path'}";
print "name=|$name|\n";
  ($ret) = Net::NISPlus::nis_remove_entry($name, 0);
  if ($ret != 0)
  {
    warn("error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return 0;
  }
  else
  {
    return 1;
  }
}

# Remove one or more entries from the table. All entries which match the
# key/value pairs will be removed. Use removem to remove a single entry.
#
# $table->removem('key1' => 'value1', 'key2' => 'value2');
#
sub removem
{
  my($me, %data) = @_;
  my($ret);

  ($ret) = Net::NISPlus::nis_remove_entry($me->{'full_path'}, \%data, 1);
  if ($ret != 0)
  {
    warn("error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return 0;
  }
  else
  {
    return 1;
  }
}

# Remove all entries from the table
#
# $table->clear();
#
sub clear
{
  my($me) = @_;
  my($ret);

  ($ret) = Net::NISPlus::nis_remove_entry($me->{'full_path'}, 1);
  if ($ret != 0)
  {
    warn("error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return 0;
  }
  else
  {
    return 1;
  }
}

sub modify
{
}

sub chmod
{
}

sub chown
{
}


sub DESTROY
{
}

1;
__END__
