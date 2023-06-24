#!/usr/bin/env perl
#
# This file is part of moses.  Its use is licensed under the GNU Lesser General
# Public License version 2.1 or, at your option, any later version.

# $Id: clean-corpus-n.perl 3633 2010-10-21 09:49:27Z phkoehn $
use warnings;
use strict;
use Getopt::Long;

my $help;
my $lc = 0;
my $ignore_ratio = 0;
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

if (scalar(@ARGV) < 7 || $help) {
    print "syntax: clean-corpus-n.perl [-ratio n] corpus l1 l2 l3 clean-corpus min max [lines retained file]\n";
    exit;
}

my $corpus = $ARGV[0];
my $l1 = $ARGV[1];
my $l2 = $ARGV[2];
my $l3 = $ARGV[3];
my $out = $ARGV[4];
my $min = $ARGV[5];
my $max = $ARGV[6];

my $linesRetainedFile = "";
if (scalar(@ARGV) > 7) {
    $linesRetainedFile = $ARGV[7];
    open(LINES_RETAINED,">$linesRetainedFile") or die "Can't write $linesRetainedFile";
}

print STDERR "clean-corpus.perl: processing $corpus.$l1, .$l2 & .$l3 to $out, cutoff $min-$max, ratio $ratio\n";

my $opn = undef;
my $l1input = "$corpus.$l1";
if (-e $l1input) {
  $opn = $l1input;
} elsif (-e $l1input.".gz") {
  $opn = "gunzip -c $l1input.gz |";
} else {
    die "Error: $l1input does not exist";
}
open(F,$opn) or die "Can't open '$opn'";

$opn = undef;
my $l2input = "$corpus.$l2";
if (-e $l2input) {
  $opn = $l2input;
} elsif (-e $l2input.".gz") {
  $opn = "gunzip -c $l2input.gz |";
} else  {
 die "Error: $l2input does not exist";
}
open(E,$opn) or die "Can't open '$opn'";

$opn = undef;
my $l3input = "$corpus.$l3";
if (-e $l3input) {
  $opn = $l3input;
} elsif (-e $l3input.".gz") {
  $opn = "gunzip -c $l3input.gz |";
} else  {
 die "Error: $l3input does not exist";
}
open(G,$opn) or die "Can't open '$opn'";

open(FO,">$out.$l1") or die "Can't write $out.$l1";
open(EO,">$out.$l2") or die "Can't write $out.$l2";
open(GO,">$out.$l3") or die "Can't write $out.$l3";

my $binmode;
if ($enc eq "utf8") {
  $binmode = ":utf8";
} else {
  $binmode = ":encoding($enc)";
}
binmode(F, $binmode);
binmode(E, $binmode);
binmode(G, $binmode);
binmode(FO, $binmode);
binmode(EO, $binmode);
binmode(GO, $binmode);

my $innr = 0;
my $outnr = 0;
my $factored_flag;
while(my $f = <F>) {
  $innr++;
  print STDERR "." if $innr % 10000 == 0;
  print STDERR "($innr)" if $innr % 100000 == 0;
  my $e = <E>;
  die "$corpus.$l2 is too short!" if !defined $e;
  my $g = <G>;
  die "$corpus.$l3 is too short!" if !defined $g;
  
  chomp($e);
  chomp($f);
  chomp($g);
  
  if ($innr == 1) {
    $factored_flag = ($e =~ /\|/ || $f =~ /\|/ || $g =~ /\|/);
  }
  if ($lc) {
    $e = lc($e);
    $f = lc($f);
    $g = lc($g);
  }

  $e =~ s/\|//g unless $factored_flag;
  $e =~ s/\s+/ /g;
  $e =~ s/^ //;
  $e =~ s/ $//;
  $f =~ s/\|//g unless $factored_flag;
  $f =~ s/\s+/ /g;
  $f =~ s/^ //;
  $f =~ s/ $//;
  $g =~ s/\|//g unless $factored_flag;
  $g =~ s/\s+/ /g;
  $g =~ s/^ //;
  $g =~ s/ $//;
  
  next if $f eq '';
  next if $e eq '';
  next if $g eq '';

  my $ec = &word_count($e);
  my $fc = &word_count($f);
  my $gc = &word_count($g);
  
  next if $ec > $max;
  next if $fc > $max;
  next if $gc > $max;
  next if $ec < $min;
  next if $fc < $min;
  next if $gc < $min;
  
  next if !$ignore_ratio && $ec/$fc > $ratio;
  next if !$ignore_ratio && $fc/$ec > $ratio;
  next if !$ignore_ratio && $gc/$fc > $ratio;
  next if !$ignore_ratio && $fc/$gc > $ratio;
  
  my $max_word_length_plus_one = $max_word_length + 1;
  next if $e =~ /[^\s\|]{$max_word_length_plus_one}/;
  next if $f =~ /[^\s\|]{$max_word_length_plus_one}/;
  next if $g =~ /[^\s\|]{$max_word_length_plus_one}/;

  die "There is a blank factor in $corpus.$l1 on line $innr: $f"
    if $f =~ /[ \|]\|/;
  die "There is a blank factor in $corpus.$l2 on line $innr: $e"
    if $e =~ /[ \|]\|/;
  die "There is a blank factor in $corpus.$l3 on line $innr: $g"
    if $g =~ /[ \|]\|/;

  $outnr++;
  print FO $f."\n";
  print EO $e."\n";
  print GO $g."\n";

  if ($linesRetainedFile ne "") {
    print LINES_RETAINED $innr."\n";
  }
}

if ($linesRetainedFile ne "") {
  close LINES_RETAINED;
}

print STDERR "\n";
my $e = <E>;
die "$corpus.$l2 is too long!" if defined $e;
my $g = <G>;
die "$corpus.$l3 is too long!" if defined $g;

print STDERR "Input sentences: $innr  Output sentences:  $outnr\n";

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