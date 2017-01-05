
use strict;
use warnings;
use vars qw($VERSION %IRSSI);

use Irssi;

# Script info
$VERSION = '0.1';
%IRSSI = (
    authors     => 'Bas Stottelaar',
    contact     => 'basstottelaar@gmail.com',
    name        => 'tmux-notify',
    description => 'Notify tmux of IRC activity',
    license     => 'MIT',
);

# Handlers
sub sig_notify
{
    system('$HOME/scripts/tmux-notify.sh');
}

# Register handlers
Irssi::signal_add('message public', \&sig_notify);
Irssi::signal_add('message private', \&sig_notify);
Irssi::signal_add('message invite', \&sig_notify);
Irssi::signal_add('message kick', \&sig_notify);
