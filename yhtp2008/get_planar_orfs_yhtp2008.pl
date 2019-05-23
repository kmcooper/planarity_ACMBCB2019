#!/usr/bin/perl

my $planarComplexFile = "complex_planar.tab";
my $sourceFile = "yhtp2008complex.tab";

#
# open the file that has complexes and true or false in it
#
open(IN,$planarComplexFile);
my @planars = <IN>;
close IN;

#
# put the planar complexes into a hash
#
my %planar_hash = ();
foreach(@planars){
	my $x = $_;
	if($x =~ m/(.*)\t(.*)\n/gi){
		my $complex = $1;
		my $planar = $2;
		if($planar =~ m/TRUE/gi){
			if(exists $planar_hash{$complex}){
				die "Collision in hash\n";
			}else{
				$planar_hash{$complex} = 1;
			}
		}
	}else{
		die "Check your regex again you silly!"
	}
}

#
# read in the list of orfs for each complex
# print out each orf as a planar or non planar orf
#
open(IN,$sourceFile);
my @orfs = <IN>;
close IN;

my @planar_orfs = ();
my @nonplanar_orfs = ();

my $curr_cluster = "no cluster";
foreach(@orfs){
	my $x = $_;
	if($x =~ m/^(\d+)\t(.*)\t(.*)\n/gi){
		my $complex = $1;
		my $orf = $2;
		$curr_cluster = $complex;		
	#	print "orf is :: $orf :: and complex is :: $complex ::\n";
		if(exists $planar_hash{$complex}){
			@planar_orfs = (@planar_orfs, $orf);
		}else{
			@nonplanar_orfs = (@nonplanar_orfs, $orf);
		}
	}elsif($x =~ m/^\t(.*)\t.*\n/gi){
		$complex = $curr_cluster;
		$orf = $1;
	#	print "orf is :: $orf :: and complex is :: $complex ::\n";
		if(exists $planar_hash{$complex}){
			@planar_orfs = (@planar_orfs, $orf);
		}else{
			@nonplanar_orfs = (@nonplanar_orfs, $orf);
		}
	}else{
		die "Check your regex you doofus\n";
	}
}

foreach(@planar_orfs){
	print $_ . "\tISPLANAR\n";
}

foreach(@nonplanar_orfs){
	print $_ . "\tNONPLANAR\n";
}
