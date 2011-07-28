#!C:\Perl\bin\perl.exe

###############
#
# Filename:        skype2google.pl
# Project:         skype2google
# Number of Files: 1
# Language:        Perl
# Platform:        Windows
# Summary:         Convert a Skype contact file into the format of a Google
#                  Contacts CSV file.
#
###############

use strict;

my $csv = "Name,E-mail,Notes,Section 1 - Description,Section 1 - Email,"
   . "Section 1 - IM,Section 1 - Phone,Section 1 - Mobile,"
   . "Section 1 - Pager,Section 1 - Fax,Section 1 - Company,"
   . "Section 1 - Title,Section 1 - Other,Section 1 - Address,"
   . "Section 2 - Description,Section 2 - Email,Section 2 - IM,"
   . "Section 2 - Phone,Section 2 - Mobile,Section 2 - Pager,"
   . "Section 2 - Fax,Section 2 - Company,Section 2 - Title,"
   . "Section 2 - Other,Section 2 - Address,Section 3 - Description,"
   . "Section 3 - Email,Section 3 - IM,Section 3 - Phone,"
   . "Section 3 - Mobile,Section 3 - Pager,Section 3 - Fax,"
   . "Section 3 - Company,Section 3 - Title,Section 3 - Other,"
   . "Section 3 - Address";

if( $#ARGV != 0 ) {
   print "Usage: skype2google [vCard filename]";
   exit;
}
if( ! -e $ARGV[0] ) {
   print "vCard doesn't exist";
   exit;
}
open( FILE, "<" . $ARGV[0] );
my $blurb = "";
my @contacts;
while( my $temp = <FILE> ) {
   if( $temp ne "\n" ) {
      $blurb .= $temp;
   }
   if( $temp =~ m/END:VCARD/xms ) {
      push(@contacts, $blurb);
      $blurb = "";
   }
}

foreach my $value (@contacts) {
   my $phone, my $name, my $skype;
   if( $value =~ /X-SKYPE-PSTNNUMBER:(\+\d+)/xms ) {
      $phone = $1;
   }
   if( $value =~ /X-SKYPE-DISPLAYNAME:(\S+\s*\S*)/xms ) {
      $name = $1;
   }
   if( $value =~ /X-SKYPE-USERNAME:(\S+)/xms ) {
      $skype = $1;
   }
   if( $name && $name ne "Skype Test" ) {
      if( $skype ) {
         $csv .= "$name,,,Other,,SKYPE: $skype,,,,,,,,,"
	    . "Personal,,,,$phone,,,,,,\n";
      } else {
	 $csv .= "$name,,,Personal,,,,$phone,,,,,,\n";
      }
   }
}
open( CSV, ">contacts.csv" );
print CSV $csv;
