###########################################################
#### Package definition                                 ####
############################################################

package DmcAd::AdManagement;

use strict;
use warnings;
use utf8;
use POSIX qw(strftime);

sub new($$$){
    my ($class,$global,$directory) = @_;
    my $self = {};
    $self->{"global"} = $global;
    $self->{"directory"} = $directory;
    $self->{"logger"} = DmcTools::Log->getLogger();
    bless $self;
    return $self;
}


sub checkLDAP($$){
   my ($self, $mesg) = @_;

   if (!defined $mesg){
     $self->log("unknown ldap error occurred");
     return 0;
   }
   elsif ($mesg->code != 0){
     $self->log("LDAP ERROR: DN           : ",$mesg->dn);
     $self->log("LDAP ERROR: Return code  : ".$mesg->code);
     $self->log("LDAP ERROR: Message Name : ".$mesg->error_name);
     $self->log("LDAP ERROR: Message Text : ".$mesg->error_text);
     $self->log("LDAP ERROR: MessageID    : ",$mesg->mesg_id);
     return 0;
   }else{
     return 1;
   }
}

#########################################################
##
## Fetch a array which contains user information

sub getADUsers($$$){
   my ($self,$query, $attrs) = @_;
	my @result;

	eval 'require Net::LDAP;';
	die "Could not load Net::LDAP: $@\n" if $@;

	my $ldap = Net::LDAP->new($self->{"directory"}->{"hostname"}, port => $self->{"directory"}->{"port"}) or
		die "Could not contact LDAP server ".$self->{"directory"}->{"hostname"}.":".$self->{"directory"}->{"port"};
	$ldap->bind($self->{"directory"}->{"mgrdn"}, password=> $self->{"directory"}->{"mgrpass"}) or die 'Could not bind';

	my $mesg = $ldap->search(base => $self->{"directory"}->{"basedn"}, filter => "$query") or die 'Failed search';
	foreach my $entry ($mesg->entries) {
		my $tsh = {};
		foreach my $attr(@{$attrs}){
        if ($attr eq "dn"){
			$tsh->{$attr} = $entry->dn;
        }
   	  my @tmp = $entry->get($attr);
		  if (scalar(@tmp) > 0){
			$tsh->{$attr} = $entry->get($attr);
		  }
		}
		push(@result,$tsh);
	}

	$ldap->unbind;
	return @result;
}


#########################################################
##
## Fetch a array which contains user information

sub getADUnixGroups($$$){
   my ($self,$query, $attrs) = @_;
	my @result;

	eval 'require Net::LDAP;';
	die "Could not load Net::LDAP: $@\n" if $@;

	my $ldap = Net::LDAP->new($self->{"directory"}->{"hostname"}, port => $self->{"directory"}->{"port"}) or
		die "Could not contact LDAP server ".$self->{"directory"}->{"hostname"}.":".$self->{"directory"}->{"port"};
	$ldap->bind($self->{"directory"}->{"mgrdn"}, password=> $self->{"directory"}->{"mgrpass"}) or die 'Could not bind';

	my @results = ();

	my $mesg = $ldap->search(base => $self->{"directory"}->{"group-basedn"}, filter => "$query") or die 'Failed search';
	foreach my $entry ($mesg->entries) {
		my $tsh = {};
		foreach my $attr(@{$attrs}){
        if ($attr eq "dn"){
			$tsh->{$attr} = $entry->dn;
        }
   	  my @tmp = $entry->get($attr);
		  if (scalar(@tmp) > 0){
			$tsh->{$attr} = $entry->get($attr);
		  }
		}
		push(@result,$tsh);
	}

	$ldap->unbind;
	return @result;
}

sub modifyADUnixGroup($$$){
   my ($self, $dn, $attr, @values) = @_;
	my @result;

	eval 'require Net::LDAP;';
	die "Could not load Net::LDAP: $@\n" if $@;

	my $ldap = Net::LDAP->new($self->{"directory"}->{"hostname"}, port => $self->{"directory"}->{"port"}) or
		die "Could not contact LDAP server ".$self->{"directory"}->{"hostname"}.":".$self->{"directory"}->{"port"};
	$ldap->bind($self->{"directory"}->{"mgrdn"}, password=> $self->{"directory"}->{"mgrpass"}) or die 'Could not bind';

	my @results = ();

   my $mesg = $ldap->modify( $dn ,
                          "replace" => {
                          "$attr" => @values
                          }
                        );

   if ($self->checkLDAP($mesg) == 0){
	          $ldap->unbind;
             return 0;
   }

	$ldap->unbind;
	return 1
}

sub getsAMAccountNameforGroup($$){
   my ($self,$dn) = @_;
	my @result;

	eval 'require Net::LDAP;';
	die "Could not load Net::LDAP: $@\n" if $@;

	my $ldap = Net::LDAP->new($self->{"directory"}->{"hostname"}, port => $self->{"directory"}->{"port"}) or
		die "Could not contact LDAP server ".$self->{"directory"}->{"hostname"}.":".$self->{"directory"}->{"port"};
	$ldap->bind($self->{"directory"}->{"mgrdn"}, password=> $self->{"directory"}->{"mgrpass"}) or die 'Could not bind';

	my $mesg = $ldap->search(base => $self->{"directory"}->{"basedn"}, filter => "(memberOf=$dn)") or die 'Failed search';
	foreach my $entry ($mesg->entries) {
      		push(@result,@{$entry->get("sAMAccountName")}[0]);
	}

	$ldap->unbind;
	return @result;
}

# convention
1;
