use strict;
use warnings;
use utf8;

use MenuHelper ();
my $npp = MenuHelper->new();

$|=1;

print "NppMenuScripts Perl Helper test\n";

for(1..3) {
  print "Test ",$_,"\n";
  sleep(1);
}


my $file_name = $npp->getFileName();
print "Current file: $file_name\n";

my $cursor = $npp->getCursor();
printf "Cursor: line %d, column %d\n", $cursor->{line}, $cursor->{column};

my $selection = $npp->getSelection();
print $npp->hasSelection()
    ? "Selected text: $selection\n"
    : "No text is selected.\n";

my $name = $npp->prompt('Enter your name:', 'Perl');
if (defined $name) {
    print "Hello, $name!\n";
    if ($npp->confirm('Set a message in the Notepad++ status bar?')) {
        $npp->setStatusBarText("Hello, $name!");
    }
}

$npp->alert('Perl Helper API test completed.');
