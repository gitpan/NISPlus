# $Id: NISPlus.pm,v 1.5 1996/11/25 22:04:22 rik Exp $

package Net::NISPlus;

require Exporter;
require DynaLoader;
require AutoLoader;

@ISA = qw(Exporter DynaLoader);
# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.
@EXPORT = qw(
);

#sub AUTOLOAD {
#    # This AUTOLOAD is used to 'autoload' constants from the constant()
#    # XS function.  If a constant is not found then control is passed
#    # to the AUTOLOAD in AutoLoader.
#
#    local($constname);
#    ($constname = $AUTOLOAD) =~ s/.*:://;
#    $val = constant($constname, @_ ? $_[0] : 0);
#    if ($! != 0) {
#	if ($! =~ /Invalid/) {
#	    $AutoLoader::AUTOLOAD = $AUTOLOAD;
#	    goto &AutoLoader::AUTOLOAD;
#	}
#	else {
#	    ($pack,$file,$line) = caller;
#	    die "Your vendor has not defined $pack macro $constname, used at $file line $line.
#";
#	}
#    }
#    eval "sub $AUTOLOAD { $val }";
#    goto &$AUTOLOAD;
#}

bootstrap Net::NISPlus;

# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.

$Debug = 0;

sub rights2str
{
  my($val) = pack("N", $_[0]);
  my($ret)="";
  my(@a)=split(//, "rmcdrmcdrmcdrmcd");
  my(@b)=(split(//, (unpack("b32", $val))))[0..3,8..11,16..19,24..27];
  foreach $i ($[..$#b)
  {
    $ret.= $b[$i] ? $a[$i] : "-";
  }
  $ret;
}

sub rights2cmdstr
{
  my($val) = pack("N", shift);
  my($type) = shift;
  my($ret)="$type=";
  my(@a)=split(//, "rmcdrmcdrmcdrmcd");
  my(@b);
  if ($type eq "n") { @b = (split(//, (unpack("b32", $val))))[0..3]; };
  if ($type eq "o") { @b = (split(//, (unpack("b32", $val))))[8..11]; };
  if ($type eq "g") { @b = (split(//, (unpack("b32", $val))))[16..19]; };
  if ($type eq "w") { @b = (split(//, (unpack("b32", $val))))[24..27]; };
  
  foreach $i ($[..$#b)
  {
    $ret .= $b[$i] ? $a[$i] : "";
  }
  $ret;
}

sub ttl2str
{
  my($val) = shift;
  my($h, $m, $s);
  
  $h = int($val / 3600);
  $m = int(($val % 3600) / 60);
  $s = int($val % 60);
  return "$h:$m:$s";
}

sub flags2str
{
  my($val) = shift;
  my(@ret);

  unless ($val & &Net::NISPlus::TA_BINARY) { push(@ret, "TEXTUAL DATA"); };
  if ($val & &Net::NISPlus::TA_SEARCHABLE)
  {
    unshift(@ret, "SEARCHABLE");
    if ($val & &Net::NISPlus::TA_CASE) { push(@ret, "CASE INSENSITIVE"); }
    else { push(@ret, "CASE SENSITIVE"); };
  };
#  if ($val & &Net::NISPlus::TA_CRYPT) { push(@ret, "CRYPT"); };
  if ($val & &Net::NISPlus::TA_XDR) { push(@ret, "XDR"); };
  if ($val & &Net::NISPlus::TA_MODIFIED) { push(@ret, "MODIFIED"); };
  if ($val & &Net::NISPlus::TA_ASN1) { push(@ret, "ASN1"); };

  if ($#ret >= 0)
  {
    return("(". join(", ", @ret) . ")");
  }
  return "";
}

sub type
{
  my($val) = shift;
  foreach (nis_getnames($val))
  {
#    print "  $_ (", obj_type($_), ")\n";
    if (obj_type($_) == &TABLE_OBJ) { return "TABLE"; };
    if (obj_type($_) == &ENTRY_OBJ) { return "ENTRY"; };
    if (obj_type($_) == &DIRECTORY_OBJ) { return "DIRECTORY"; };
    if (obj_type($_) == &NO_OBJ) { return "NO"; };
    if (obj_type($_) == &GROUP_OBJ) { return "GROUP"; };
    if (obj_type($_) == &LINK_OBJ) { return "LINK"; };
    if (obj_type($_) == &PRIVATE_OBJ) { return "PRIVATE"; };
  }
  return "UNKNOWN";
}

1;
__END__
