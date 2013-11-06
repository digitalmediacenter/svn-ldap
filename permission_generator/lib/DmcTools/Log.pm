###########################################################
#### Package definition                                 ####
############################################################

package DmcTools::Log;

use strict;
use warnings;
use utf8;
use POSIX qw(strftime);

my $rootlogger = undef;

# This method enables file-logging
# @param : int : 0 => Only log to STDERR
#                1 => Enable file logging
#                2 => Enable file logging and STDERR output
sub setLog($$){
  my ( $self, $parm) = @_;
  $self->{"loglevel"} = $parm;
}

# This method logs debugging messages to stderr or to a file.
# The implementation is a bit ugly, because of the low usage frequency
# of these tools, this does not harm.:w
# (In context of a cgi-call this logmessage is written to the errorlog)
# @param: <string> : a logmessage

sub log($$){
  my ( $self, $msg) = @_;

  if (($self->{"loglevel"} == 1) || ($self->{"loglevel"} == 2)){
    open(FILE , ">>".$self->{"logfile"})
     or die "Unable to open logfile: '".$self->{"logfile"}."'";
    if ($self->{"loglevel"} == 2){
       print STDERR strftime("%Y-%m-%d %H:%M:%S",localtime(time()))." : ".$msg."\n";
    }
    print FILE strftime("%Y-%m-%d %H:%M:%S",localtime(time()))." : ".$msg."\n";
    close(FILE);
  }
  else{
    print STDERR $msg."\n";
  }
}


sub new($;$){
    my ($class,$logfile) = @_;
    my $self = {};
    if (defined $logfile){
       $self->{"logfile"} = $logfile;
    }else{
       $self->{"logfile"} = "/tmp/default.log";
       print STDERR "INFO: Using loglevel with file logging without defining a logfile, using ".$self->{"logfile"}."\n";
    }
    $self->{"loglevel"} = 0;
    bless $self;
    return $self;
}

sub getLogger(){
   my ($class,$logfile) = @_;
   if (!defined $rootlogger){
      $rootlogger = DmcTools::Log->new($logfile);
   }
   return $rootlogger;
}

# convention
1;
