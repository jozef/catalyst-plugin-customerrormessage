package Catalyst::Plugin::CustomErrorMessage;

=head1 NAME

Catalyst::Plugin::CustomErrorMessage - Catalyst plugin to have more "cute" error message.

=head1 SYNOPSIS

	use Catalyst qw( CustomErrorMessage );
	
	# optional
	__PACKAGE__->config->{'custome-error-messsage'}->{'uri-for-not-found'} = '/not_found_error';
	__PACKAGE__->config->{'custome-error-messsage'}->{'error-template'}    = 'error.tt2';

=head1 DESCRIPTION

You can use this module if you want to get rid of:

	(en) Please come back later
	(fr) SVP veuillez revenir plus tard
	(de) Bitte versuchen sie es spaeter nocheinmal
	(at) Konnten's bitt'schoen spaeter nochmal reinschauen
	(no) Vennligst prov igjen senere
	(dk) Venligst prov igen senere
	(pl) Prosze sprobowac pozniej

What it does is that it inherites finalize_error to $c object.

See finalize_error() function. 

=cut

use base qw{ Class::Data::Inheritable };

use HTML::Entities;
use URI::Escape qw{ uri_escape_utf8 };
use NEXT;

use strict;
use warnings;

our $VERSION = "0.01";


=head1 FUNCTIONS

=head2 finalize_error

In debug mode this function is skipped and user sees the original Catalyst error page in debug mode.

In "production" (non debug) mode it will return page with template set in

	$c->config->{'custome-error-messsage'}->{'error-template'}
	||
	'error.tt2'

$c->stash->{'finalize_error'} will be set to contain the error message.

For non existing resources (like misspelled url-s) if will do http redirect to

	$c->uri_for(
		$c->config->{'custome-error-messsage'}->{'uri-for-not-found'}
		||
		'/'
	)

$c->flash->{'finalize_error'} will be set to contain the error message.

This works if you are using Template Toolkit and the view is named "TT".
The "tutorial" way. If you want it the different way just copy this module, place it
to the lib/Catalyst/Plugin folder and edit out for your needs. If we can improve
this example by some config switch, so that it will be more universal, then please let
me know and i'll put it there. 

=cut

sub finalize_error {
	my $c = shift;
	
	# in debug mode return the original "page" 
	if ( $c->debug ) {
		$c->NEXT::finalize_error;
		return;
	}
	
	# create error string out of error array
	my $error = join '', map { encode_entities($_).'<br/> ' } @{ $c->error };
	$error ||= 'No output';

	# for wrong url that has no action associated do redirect
	if (not defined $c->action) {
		$c->flash->{'finalize_error'} = $error."<br/>";
		$c->_save_flash(); # hack but must be called otherwise the flash data will be lost
		$c->response->redirect($c->uri_for(
			$c->config->{'custome-error-messsage'}->{'uri-for-not-found'}
			||
			'/'
		));

		return;
	}
	
	# render the template
	my $action_name = $c->action->reverse;
	$c->stash->{'finalize_error'} = $action_name.': '.$error;
	$c->response->content_type('text/html; charset=utf-8');
	$c->response->body($c->view('TT')->render($c,
		$c->config->{'custome-error-messsage'}->{'error-template'}
		||
		'error.tt2'
	));
	$c->response->status(500);
}

1;

=head1 AUTHOR

Jozef Kutej - E<lt>jozef@kutej.netE<gt>

Authorization and Accounting contributed by Rubio Vaughan E<lt>rubio@passim.netE<gt>

=head1 TODO

More universal? Looking forward for your suggestions.

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Jozef Kutej

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.4 or,
at your option, any later version of Perl 5 you may have available.

=cut
