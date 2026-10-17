use strict;
use warnings;
use utf8;

$|=1;

print "hello from stdout\n";
print STDERR "hello from stderr\n";

for(1..3) {
  print "Test ",$_,"\n";
  sleep(1);
}


print "test completed!\n";
