#!/usr/bin/env perl
use warnings;
use strict;
use Getopt::Long;
my $help;
my $lc = 0;
my $ignore_ratio = 1;
my $ignore_xml = 0;
my $enc = "utf8";
my $max_word_length = 1000;
my $ratio = 9;

GetOptions(
  "help" => \$help,
  "lowercase|lc" => \$lc,
  "encoding=s" => \$enc,
  "ratio=f" => \$ratio,
  "ignore-ratio" => \$ignore_ratio,
  "ignore-xml" => \$ignore_xml,
  "max-word-length|mwl=s" => \$max_word_length
) or exit(1);

if (scalar(@ARGV) < 4 || $help) {
    print "syntax: clean-corpus-n.perl corpus lang clean-corpus min max [lines retained file]\n";
    exit;
}

my $corpus = $ARGV[0];
my $lang = $ARGV[1];
my $out = $ARGV[2];
my $min = $ARGV[3];
my $max = $ARGV[4];

my $linesRetainedFile = "";
if (scalar(@ARGV) > 5) {
    $linesRetainedFile = $ARGV[5];
    open(LINES_RETAINED,">$linesRetainedFile") or die "Can't write $linesRetainedFile";
}

print STDERR "clean-corpus.perl: processing $corpus.$lang to $out, cutoff $min-$max, ratio $ratio\n";

my $opn = undef;
my $langInput = "$corpus.$lang";
if (-e $langInput) {
  $opn = $langInput;
} elsif (-e $langInput.".gz") {
  $opn = "gunzip -c $langInput.gz |";
} else {
    die "Error: $langInput does not exist";
}
open(F,$opn) or die "Can't open '$opn'";

open(FO,">$out.$lang") or die "Can't write $out.$lang";

my $binmode;
if ($enc eq "utf8") {
  $binmode = ":utf8";
} else {
  $binmode = ":encoding($enc)";
}
binmode(F, $binmode);
binmode(FO, $binmode);

my $innr = 0;
my $outnr = 0;
my $factored_flag;
while(my $f = <F>) {
  $innr++;
  print STDERR "." if $innr % 10000 == 0;
  print STDERR "($innr)" if $innr % 100000 == 0;
  chomp($f);
  if ($innr == 1) {
    $factored_flag = ($f =~ /\|/);
  }

  if ($lc) {
    $f = lc($f);
  }

  $f =~ s/\|//g unless $factored_flag;
  $f =~ s/\s+/ /g;
  $f =~ s/^ //;
  $f =~ s/ $//;
  next if $f eq '';

  my $fc = &word_count($f);
  next if $fc > $max;
  next if $fc < $min;

  my $max_word_length_plus_one = $max_word_length + 1;
  next if $f =~ /[^\s|]{$max_word_length_plus_one}/;

die "There is a blank factor in $corpus.$lang on line $innr: $f"
if $f =~ /[ |]|/;

$outnr++;
print FO $f."\n";

if ($linesRetainedFile ne "") {
print LINES_RETAINED $innr."\n";
}
}

if ($linesRetainedFile ne "") {
close LINES_RETAINED;
}

print STDERR "\n";

print STDERR "Input sentences: $innr Output sentences: $outnr\n";

sub word_count {
my ($line) = @_;
if ($ignore_xml) {
$line =~ s/<\S[^>]*\S>/ /g;
$line =~ s/\s+/ /g;
$line =~ s/^ //g;
$line =~ s/ $//g;
}
my @w = split(/ /,$line);
return scalar @w;
}
