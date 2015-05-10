#!/usr/local/bin/perl
#20 Questions
#Information Retrieval and Web Agents(600.466)
#Final Project
#By Sindhuula Selvaraju
&main_loop;

sub init_input_filenames {
  local($type) = @_;
	$DIR = "C:/Users/Sindhuula/Desktop/MS";
    $country_list   ="$DIR/countries.txt";
    $city_list      ="$DIR/cities.txt";
    $fictional_person ="$DIR/fictional.txt";
    $real_person   ="$DIR/real.txt";
 	$outfile   ="$DIR/thought_of.txt";   
  }
sub main_loop {
&init_input_filenames;
print "Filenames initialized";
 print "

                   ==========================================================
                   ==       Welcome to the 600.466 Final Project
                   == 		By Sindhuula Selvaraju
                   == 		Game of 20 Questions
		   ===========================================================
Choose an Option:
1. Begin Game!
2. Instructions
3. Quit
";
$option = <STDIN>;
$op = 1;
while($op==1)
{
if ($option == 1)
{
print "
                   ==============================================================================
                   ==       Let us Begin Playing 20 Questions!!!
                   == 		Think of a country, city or a famous person(real or fictional)
                   == 		Thought of it?
                   ==		Good! Now let me guess what you are thinking about.
                   ==       Remember always answer in yes or no
                   ==============================================================================";
$question_no = 0;
print "\nAre you thinking of a place?\t:";
$question_no = $question_no + 1;
$answer=<STDIN>;
printf ("Your answers is %s", $answer);
$yes = "yes";
$no = "no";
chomp $answer;
if($answer eq $yes)
{
$question_no = $question_no + 1;
	print "So you are thinking of a place.\n";
	print "Are you thinking of a country?\t:";
	$answer = <STDIN>;
	chomp $answer;
	if($answer eq $yes)
	{
		$thinking = "country";
		&initialize_country_datas;
		&find_term_vector;
		&ask_questions;
	}
	elsif($answer eq $no)
	{
		&initialize_city_datas;
	}	
	else
	{
	print "Sorry wrong option.";
	}
}
elsif($answer eq $no)
{
$question_no = $question_no + 1;
	print "So you are thinking of a person.\n";
	print "Are you thinking of a real person?\t:";
	$answer = <STDIN>;
	chomp $answer;
	if($answer eq $yes)
	{
		&initialize_real_datas;
	}
	elsif($answer eq $no)
	{
		&initialize_fictional_datas;
	}
	else
	{
		print "Sorry wrong option.\n";		
	}
}
else
{
	print "Sorry wrong option.\n";
}
}
elsif ($option == 2)
{
print "
                   ============================================================================================
                   ==       Game of 20 Questions is a simple guessing game.
                   == 		You think of a country, city 
                   ==       or a famous person(real like Albert Einstein or fictional like Tom Sawyer)
                   == 		I will then ask you a series of questions to try and think what you are thinking
                   ==       You only need to answer in yes or no
                   == 		If I can guess what/who you are thinking about in 20 questions or less then I win
                   ==		Otherwise you win.
                   ============================================================================================"
}
else
{
exit(1);
}
print "
What do you want to do now?:
1. Play
2. Quit
";
$op = <STDIN>;
}
exit(1);
}

# Let us make vector from country file
sub initialize_country_datas
{
	print "Let us find that country now shall we?\n";
#	printf ("I still have %d questions left.", 20 - $question_no);
	$j=-1;my $m=0;
	$docn=0;
	open(DOCSFREQ,$country_list) || die "Can't open this file $country_list : $!problem \n";
	while (<DOCSFREQ>) {
    chop;
	$line = $_;
	if ($line =~ /^[.]I /)
	{
		$j++;
		$docline_l[$j]= $line;
    #	$list_of_possible[$j] = $line;
	#	@split = split ' ',$docline_l[$j];
		
	#	$terms = ;
		$m=0; 
	}
	else
	{
		$docline[$j]{$m}=$line;
		$m++;
		$doc_len[$j]=$m;
	}
	}
	$docn = $j+1;
	printf ("Countries file read. Found %d countries\n",($docn));
}

# Let us make vector from city file
sub initialize_city_datas
{
	print "Let us find that city now shall we?\n";
	printf ("I still have %d questions left.", 20 - $question_no);
}
# Let us make vector from real people file
sub initialize_real_datas
{
	print "Let us find that real person now shall we?\n";
	printf ("I still have %d questions left.", 20 - $question_no);
}

# Let us make vector from fictional people file
sub initialize_fictional_datas
{
	print "Let us find that fictional person now shall we?\n";
	printf ("I still have %d questions left.", 20 - $question_no);
}
# This will create a hash of terms and assign weight to it 
sub find_term_vector
{
	print "Finding term vectors.\n";
	$count = 0;
	for($outer = 0; $outer<$docn;$outer++)
	{
		for($inner = 0; $inner < $doc_len[$outer]; $inner ++)
		{
			if(exists $term_vector{$docline[$outer]{$inner}})
			{
			$term_vector{$docline[$outer]{$inner}} += 1;
			}
			else
			{
			$term_vector{$docline[$outer]{$inner}} = 1;
			$count ++;
			}
		}
	}
	for($outer = 0;$outer<$docn;$outer++)
	{
	$new_terms{$outer} = $outer;
	}
	$check = $docn;
	@temp_doc = @docline_l;
}
# This will create a hash of terms sorted by wieght.
sub sort_them
{
	@sorted = ();
	while (my ($key,$value) = each %term_vector)
	{
		push @sorted,[$key,$value];
	}
	@sorted = sort {$b->[1] <=> $a->[1]} @sorted;
	for($loop = 0; $loop < $count; $loop++)
	{
		$sorted_terms{$sorted[$loop][0]} = $sorted[$loop][1];
	}
}	
# Will create a hash of document numbers where the term is present
sub construct_new_term
{
%new_terms2 = ();
%temp = ();
$loop = 0;
$checks = $check;
@temp_doc = ();
	for($outer = 0; $outer<$docn;$outer++)
	{
		for($inner = 0; $inner < $doc_len[$outer]; $inner ++)
		{
			if($docline[$outer]{$inner} eq $sorted[0][0])
				{
				$new_terms2{$loop} = $outer;
				$temp_doc[$loop] = $docline_l[$outer];
				$loop ++;
				}
		}
	}
	for($i = 0; $i < $check; $i++)
	{
		$flag =0;
		foreach my $term (values %new_terms2)
			{
			if ($new_terms{$i} == $term)
			{
				$flag = 1;
			}
			}
			if ($flag == 0)
			{
				delete $new_terms{$i};
				$checks = $checks - 1;
			}
	}
	$check = $checks;
foreach $doc (@temp_doc)
{
	print "$doc\n";
}

}
# Will create a hash of document numbers where the term is not present
sub construct_new_minus
{
%new_minus = ();
%temp = ();
$loop = 0;
$flag = 0;
$count = 0;
@temp_doc2 = ();
$checks = $check;
	for($outer = 0; $outer<$docn;$outer++)
	{
		for($inner = 0; $inner < $doc_len[$outer]; $inner ++)
		{
			if($docline[$outer]{$inner} eq $sorted[0][0])
				{
				$new_minus{$loop} = $outer;
				$temp_doc2[$loop] = $docline_l[$outer];
				$loop ++;
				}
		}		
	}
	for($i = 0; $i < $check; $i++)
	{
		$flag =0;
		foreach my $term (values %new_minus)
			{
			if ($new_terms{$i} == $term)
			{
				$flag = 1;
			}
			}
			if ($flag == 1)
			{
				delete $new_terms{$i};
				$checks = $checks - 1;
			}
	}
my @temponly;
my %seen;
foreach my $elem (@temp_doc2) {
    $seen{$elem} = 1;
}

# find elements present only in @array1
foreach my $elem (@temp_doc) {
    push @temponly, $elem unless $seen{$elem};
}
@temp_doc = ();
@temp_doc = @temponly;
foreach $doc (@temp_doc)
{
	print "$doc\n";
}

$check = $checks;
}
# Will re-create the term_vector based on document set
sub remake_terms_vector
{
	%term_vector2 =();
	%temp_vector = ();
	foreach $outer (values %new_terms)
	{
		for($inner = 0; $inner < $doc_len[$outer]; $inner ++)
		{
			if(exists $term_vector2{$docline[$outer]{$inner}})
			{
			$term_vector2{$docline[$outer]{$inner}} += 1;
			}
			else
			{
			$term_vector2{$docline[$outer]{$inner}} = 1;
			$count ++;
			}
		}
	}
	foreach my $term (keys %term_vector2)
	{
	if(exists $term_vector{$term})
	{
	$temp_vector{$term} = $term_vector2{$term}
	}
	}
	%term_vector = ();
	foreach $term (keys %temp_vector)
	{
	$term_vector{$term} = $temp_vector{$term};
	}	
}
#this function will keep asking questions till a result is found
sub ask_questions
{
	@prev_largest =();
	while ($check != 1)
	{
	if($question_no == 19)
	{
	print "Seems like I'm running out of questions.";
	print "You are thinking about $docline_l[$new_terms{0}]\n Am I right?\t:";
	$answer = <STDIN>;
	if ($answer == $yes)
	{
		print "Yippie I win.";
		printf ("I still have %d questions left.", 20 - $question_no);
	}
	else
	{
		print "Wow! You win.\nCan you please tell me what you were thinking about?\t:";
		$answer = <STDIN>;
		open (FILE,">> $outfile")||die "Problem opening $outfile\n";
		print FILE $answer;
		print FILE "\n";
		close(FILE);		
	}
	&main_loop;
	}
	else
	{
	&keep_asking;
	}
	}
	
}
sub keep_asking
{
	if($check ==1)
	{
	&check_if
	}
	%prev_check = ();
	foreach $term (keys %new_terms)
	{
	$prev_check{$term} = $new_terms{$term};
	}
	print "\n";
	$question_no = $question_no + 1;
	&sort_them;
	print "Get ready for your next question.\n";
	printf ("Does your %s have anything to do with %s\t:",$thinking,$sorted[0][0]);
	$answer = <STDIN>;
	chomp $answer;
	if ($answer eq $yes)
	{		
	&sort_them;
	&construct_new_term;
	&remake_terms_vector;
	push (@prev_largest,$sorted[0][0]);
	for ($i = 0;$i <= $#prev_largest; $i++)
	{	
	delete $term_vector{$prev_largest[$i]};
	}
	&sort_them;
	if($check ==1)
	{
	&check_if
	}
	}
	elsif($answer eq $no)
	{
	print "Ok let me try again";
	&construct_new_minus;
	&remake_terms_vector;
	&sort_them;
	push (@prev_largest,$sorted[0][0]);
	for ($i = 0;$i <= $#prev_largest; $i++)
	{	
	delete $term_vector{$prev_largest[$i]};
	}
	&sort_them;
	if($check ==1)
	{
	&check_if
	}
	}
	else
	{
	print "Invalid option. Begin again";
	&main_loop;
	}
}
sub check_if
{
	print "You are thinking about $temp_doc[0]\n Am I right?\t:";
	$answer = <STDIN>;
	chomp $answer;
	if ($answer eq $yes)
	{
		print "Yippie I win.";
		printf ("I still have %d questions left.", 20 - $question_no);
	}	
	else
	{
		print "Hmmm! Let me see.";
		$question_no = $question_no + 1;
		foreach my $term (keys %prev_check)
		{
			$question_no = $question_no + 1;
			if($term ne $new_terms{0})
			{
				print "You are thinking about $docline_l[$term]\n Am I right?\t:";
				$answer = <STDIN>;
				chomp $answer;
				if ($answer eq $yes)
				{
				print "Yippie I win.";
				printf ("I still have %d questions left.", 20 - $question_no);
				&main_loop;
				}	
			}
			else
			{
			print "Wow! You win.\nCan you please tell me what you were thinking about?\t:";
			$answer = <STDIN>;
			chomp $answer;
			open (FILE,">> $outfile")||die "Problem opening $outfile\n";
			print FILE $answer;
			print FILE "\n";
			close(FILE);		
			}
		}
	}
}
