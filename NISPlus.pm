# $Id: NISPlus.pm,v 1.3 1995/10/15 05:22:04 rik Exp $

package Net::NISPlus;

require Exporter;
require AutoLoader;
require DynaLoader;
@ISA = qw(Exporter AutoLoader DynaLoader);
# Items to export into callers namespace by default
# (move infrequently used names to @EXPORT_OK below)
@EXPORT = qw( 
);
# Other items we are prepared to export if requested
@EXPORT_OK = qw(
);

bootstrap Net::NISPlus;

# Preloaded methods go here.  Autoload methods go after __END__, and are
# processed by the autosplit program.

sub rights2str
{
  my($val) = pack("N", $_[0]);
  my($ret)="";
  my(@a)=split(//, "rmcdrmcdrmcdrmcd");
  my(@b)=(split(//, (unpack("b32", $val))))[0..3,8..11,16..19,24..29];
  foreach $i ($[..$#b)
  {
    $ret.= $b[$i] ? $a[$i] : "-";
  }
  $ret;
}

1;
__END__
