# $Id: Makefile.PL,v 1.4 1995/10/15 05:22:04 rik Exp $
use ExtUtils::MakeMaker;

WriteMakefile(
	'LIBS' => '-lnisdb -lnsl',
	'INC' => '',
	'DISTNAME' => 'NISPlus',
	'NAME' => 'Net::NISPlus',
	'VERSION' => 'a2',
	'PMLIBDIRS' => [ 'NISPlus' ],
);
