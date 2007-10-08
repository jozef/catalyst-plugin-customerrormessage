use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME              => 'Catalyst::Plugin::CustomErrorMessage',
    VERSION_FROM      => 'lib/Catalyst/Plugin/CustomErrorMessage.pm', # finds $VERSION
    PREREQ_PM         => {
		'Class::Data::Inheritable' => 0,
		'Test::More'               => 0,
		'HTML::Entities'           => 0,
		'URI::Escape'              => 0,
		'NEXT'                     => 0,
		'Carp::Clan'               => 0,
	},
	($] >= 5.005 ?     ## Add these new keywords supported since 5.005
		(ABSTRACT_FROM  => 'lib/Catalyst/Plugin/CustomErrorMessage.pm', # retrieve abstract from module
		AUTHOR          => 'Jozef Kutej <jozef@kutej.net>') : ()),
	(MM->can('signature_target') ? (SIGN => 1) : ()),
);
