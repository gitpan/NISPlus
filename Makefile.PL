# $Id: Makefile.PL,v 1.6 1996/05/12 08:10:25 rik Exp $
use ExtUtils::MakeMaker;

WriteMakefile(
	'LIBS' => '-lnisdb -lnsl',
	'INC' => '',
	'DISTNAME' => 'NISPlus',
	'NAME' => 'Net::NISPlus',
	'VERSION' => '0.04-alpha',
	'PMLIBDIRS' => [ 'NISPlus' ],
);
