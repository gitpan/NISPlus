# $Id: Table.pm,v 1.6 1996/05/12 13:51:15 rik Exp $

require Net::NISPlus::Object;

package Net::NISPlus::Table;

@ISA = qw(Net::NISPlus::Object);

sub new
{
  my($name, $path) = @_;
  my($self) = {};

  foreach (Net::NISPlus::nis_getnames($path))
  {
    my($type) = Net::NISPlus::obj_type($_);
    if (defined($type) && $type == &Net::NISPlus::TABLE_OBJ)
    {
      $self->{'full_path'} = $_;
      last;
    }
  };

  bless $self;
}

sub lookup
{
  my($me) = shift;
  my($ret, @res);

  my($colnames, @colnames);
  my($srchstring);
  $colnames = $me->colnames;
  @colnames = $me->colnames;

  if ($#_ == 0)
  {
    $srchstring = shift;
# ensure the full path is added
    $srchstring =~ s/,.*/",".$me->{'full_path'}/e;
  }
  else
  {
    my(%srch) = @_;
    $srchstring = "[";

    foreach $key (keys %srch)
    {
      die "$key does not exist in $me->{'full_path'}\n"
        unless defined($colnames->{$key});
      $srchstring .= "," unless length($srchstring) == 1;
      $srchstring .= "$key=$srch{$key}";
    }

    $srchstring .= "],$me->{'full_path'}";
  }

#print "lookup up $srchstring\n";
  ($ret, @res) = Net::NISPlus::entry_list($srchstring);
  if ($ret != 0)
  {
    warn("lookup $srchstring error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return ();
  }
  else
  {
    foreach $entry (@res)
    {
      my($new) = {};
      foreach $field ($[..$#{@{$entry}})
      {
        $new->{$colnames[$field]} = $entry->[$field];
      }
      $entry = $new;
    }
    return @res;
  }
}

sub list
{
  my($me) = shift;
  my($ret, @res);

  ($ret, @res) = Net::NISPlus::entry_list($me->{'full_path'});
  if ($ret != 0)
  {
    warn("list error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return ();
  }
  else
  {
    return @res;
  }
}

=head2 colnames

colnames returns the column headings for the NIS+ table.  If called in
an array context, it returns an array containing the column names in
the order in which they appear in the table.  If called in a scalar
context, it returns a reference to a hash with keys being column names,
and values being an integer representing the column's position.

e.g.

$table = Net::NISPLus::Table('hosts.org_dir');
$cols = $table->colnames;

will end up with $cols being:

$cols->{'cname'} = 0;
$cols->{'name'} = 1;
$cols->{'addr'} = 2;
$cols->{'comment'} = 3;

and

$table = Net::NISPLus::Table('hosts.org_dir');
@cols = $table->colnames;

will end up with @cols being:

@cols = ('cname', 'name', 'addr', 'comment')

NOTE: as the colnames method behaves differently depending on what
context it is called in, it may not always behave as you expect.  For
example, the following two code fragments are not equivalent:

my($colnames) = $table->colnames;

and

my($colnames);
$colnames = $table->colnames;

The first calls colnames in an array context, and the second in a
scalar context.

=cut

sub colnames
{
  my($me) = shift;
  my($ret, $res);

  if (!defined($me->{'colnames'}))
  {
    ($ret, $res) = Net::NISPlus::table_info($me->{'full_path'});
    if ($ret != 0)
    {
      warn("colnames error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
      return ();
    }
    else
    {
      $me->{'colnamesarr'} = $res->{'ta_cols'};
      foreach ($[..$#{@{$me->{'colnamesarr'}}})
      {
        $me->{'colnameshash'}->{$me->{'colnamesarr'}->[$_]} = $_;
      }
    }
  }
  return(@{$me->{'colnamesarr'}}) if wantarray;
  return($me->{'colnameshash'});
}

sub info
{
  my($me) = shift;
  my($ret, $res);

  ($ret, $res) = Net::NISPlus::table_info($me->{'full_path'});
  if ($ret != 0)
  {
    warn("info error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return ();
  }
  else
  {
    return $res;
  }
}

=head2 add

Add an entry to the table.  Any columns not specified will be set to
null strings.

$table->add('key1' => 'value1', 'key2' => 'value2');

=cut

sub add
{
  my($me, %data) = @_;
  my($ret, $res);

  ($ret, $res) = Net::NISPlus::nis_add_entry($me->{'full_path'}, \%data);
  if ($ret != 0)
  {
    warn("add error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return ();
  }
  else
  {
    return $res;
  }
}

=head2 remove

Remove a single entry from the table.  If the key/value pairs match
more that one entry, an error occurs, and no entries are removed.  Use
removem to remove multiple entries with a single command.

$table->remove('key1' => 'value1', 'key2' => 'value2');

=cut

sub remove
{
  my($me, %data) = @_;
  my($ret);

  my($name) = "[";
  foreach (keys %data) { $name .= "$_=$data{$_},"; }
  $name =~ s/,$//;
  $name .= "],$me->{'full_path'}";
print "name=|$name|\n";
  ($ret) = Net::NISPlus::nis_remove_entry($name, 0);
  if ($ret != 0)
  {
    warn("remove error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return 0;
  }
  else
  {
    return 1;
  }
}

=head2 removem

Remove one or more entries from the table. All entries which match the
key/value pairs will be removed. Use removem to remove a single entry.

$table->removem('key1' => 'value1', 'key2' => 'value2');

=cut

sub removem
{
  my($me, %data) = @_;
  my($ret);

  my($name) = "[";
  foreach (keys %data) { $name .= "$_=$data{$_},"; }
  $name =~ s/,$//;
  $name .= "],$me->{'full_path'}";
print "name=|$name|\n";
  ($ret) = Net::NISPlus::nis_remove_entry($name, 1);
  if ($ret != 0)
  {
    warn("removem error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return 0;
  }
  else
  {
    return 1;
  }
}

=head2 clear

Remove all entries from the table

$table->clear();

=cut

sub clear
{
  my($me) = @_;
  my($ret);

  ($ret) = Net::NISPlus::nis_remove_entry($me->{'full_path'},
    &Net::NISPlus::REM_MULTIPLE);
  if ($ret != 0)
  {
    warn("clear error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return 0;
  }
  else
  {
    return 1;
  }
}

sub modify
{
  my($me, $search, $replace) = @_;
  my($ret);

  my($name) = "[";
  foreach (keys %{$search}) { $name .= "$_=$search->{$_},"; }
  $name =~ s/,$//;
  $name .= "],$me->{'full_path'}";
print "name=|$name|\n";
  ($ret) = Net::NISPlus::nis_modify_entry($name, $replace, 0);
  if ($ret != 0)
  {
    warn("modify error: ", Net::NISPlus::nis_sperrno($ret), " ($ret)\n");
    return 0;
  }
  else
  {
    return 1;
  }
}

sub chmod
{
}

sub chown
{
}

sub export
{
  my($me) = shift;
  my($filename) = shift;

  open(DUMP, ">$filename") || die "can't open $filename\n";
  $info = $me->info();
  print DUMP "table_name ", $me->{'full_path'};
  print DUMP "name $info->{'name'}\n";
  print DUMP "owner $info->{'owner'}\n";
  print DUMP "group $info->{'group'}\n";
  print DUMP "domain $info->{'domain'}\n";
  print DUMP "access $info->{'access'}\n";
  print DUMP "ttl $info->{'ttl'}\n";
  print DUMP "type $info->{'type'}\n";
  print DUMP "ta_type $info->{'ta_type'}\n";
  print DUMP "ta_maxcol $info->{'ta_maxcol'}\n";
  print DUMP "ta_sep $info->{'ta_sep'}\n";
  print DUMP "ta_patch $info->{'ta_path'}\n";
  @cols = @{$info->{'ta_cols'}};
  foreach $col ($[..$#cols)
  {
    print DUMP "col $cols[$col] $info->{'ta_cols_flags'}->{$cols[$col]} ";
    print DUMP "$info->{'ta_cols_rights'}->{$cols[$col]}\n";
  }
  foreach $ent ($me->list())
  {
    print DUMP "entry\n";
#    $info
    foreach $col ($[..$#cols)
    {
      print DUMP "field $cols[$col] ", length($ent->[$col]), "\n";
      print DUMP "$ent->[$col]\n";
    }
  }
  close(DUMP);
}

#sub import
#{
#  my($me) = shift;
#  my($filename) = shift;
#
#  open(DUMP, "$filename") || die "can't open $filename\n";
#  $info = $me->info();
#  print "table_name ", $me->{'full_path'};
#  print "name $info->{'name'}\n";
#  print "owner $info->{'owner'}\n";
#  print "group $info->{'group'}\n";
#  print "domain $info->{'domain'}\n";
#  print "access $info->{'access'}\n";
#  print "ttl $info->{'ttl'}\n";
#  print "type $info->{'type'}\n";
#  print "ta_type $info->{'ta_type'}\n";
#  print "ta_maxcol $info->{'ta_maxcol'}\n";
#  print "ta_sep $info->{'ta_sep'}\n";
#  print "ta_patch $info->{'ta_path'}\n";
#  @cols = @{$info->{'ta_cols'}};
#  foreach $col ($[..$#cols)
#  {
#    print "col $cols[$col] $info->{'ta_cols_flags'}->{$cols[$col]} ";
#    print "$info->{'ta_cols_rights'}->{$cols[$col]}\n";
#  }
#  foreach $ent ($table->list())
#  {
#    print "entry\n";
#    foreach $col ($[..$#cols)
#    {
#      print "field $cols[$col] ", length($ent->[$col]), "\n";
#      print "$ent->[$col]\n";
#    }
#  }
#  close(DUMP);
#}

sub DESTROY
{
}

1;
__END__
