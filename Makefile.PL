# $Id: Makefile.PL,v 1.7 1996/11/25 22:04:22 rik Exp $
use ExtUtils::MakeMaker;

WriteMakefile(
	'LIBS' => '-lnisdb -lnsl',
	'INC' => '',
	'DISTNAME' => 'NISPlus',
	'NAME' => 'Net::NISPlus',
	'VERSION' => '0.05-alpha',
	'PMLIBDIRS' => [ 'NISPlus' ],
	'dist' => { COMPRESS => 'gzip -9' }
);
