
##################################################################
#	    Setting the Default Parameters			 #
##################################################################

set val(chan)		Channel/WirelessChannel
set val(prop)		Propagation/TwoRayGround
set val(netif)		Phy/WirelessPhy
set val(mac)            Mac/802_11

set val(ifq)		Queue/DropTail/PriQueue

#set val(ifq) 		CMUPriQueue; # Interface queue type 

set val(ll)		LL
set val(ant)            Antenna/OmniAntenna
set val(x)		500	
set val(y)		500	
set val(ifqlen)		50		
set val(nn)		7		
set val(stop)		102.0		
set val(rp)             AODV       

##################################################################
#	    Creating New Instance of a Scheduler		 #
##################################################################

set ns_		[new Simulator]

##################################################################
#		Creating Trace files				 #
##################################################################

set tracefd	[open 002udp.tr w]
$ns_ trace-all $tracefd

##################################################################
#	        Creating NAM Trace files			 #
##################################################################

set namtrace [open 002udp.nam w]
$ns_ namtrace-all-wireless $namtrace $val(x) $val(y)

set prop	[new $val(prop)]

set topo	[new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

##################################################################
#	                 802.11b Settings			 #
##################################################################

Phy/WirelessPhy set freq_ 2.4e+9
Mac/802_11 set dataRate_ 11.0e6 

##################################################################
#	                 802.11g Settings			 #
##################################################################

#Phy/WirelessPhy set freq_ 2.4e+9
#Mac/802_11 set dataRate_ 54.0e6                   
        
##################################################################
#		Node Configuration				 #
##################################################################

        $ns_ node-config -adhocRouting $val(rp) \
			 -llType $val(ll) \
			 -macType $val(mac) \
			 -ifqType $val(ifq) \
			 -ifqLen $val(ifqlen) \
			 -antType $val(ant) \
			 -propType $val(prop) \
			 -phyType $val(netif) \
			 -channelType $val(chan) \
			 -topoInstance $topo \
			 -agentTrace ON \
			 -routerTrace ON \
			 -macTrace ON

##################################################################
#		Creating Nodes					 #
##################################################################

for {set i 0} {$i < $val(nn) } {incr i} {
     set node_($i) [$ns_ node]	
     $node_($i) random-motion 0	
}

##################################################################
#		Initial Positions of Nodes			 #
##################################################################

for {set i 0} {$i < $val(nn)} {incr i} {
	$ns_ initial_node_pos $node_($i) 40
}

##################################################################
#		Topology Design				 	 #
##################################################################

$ns_ at 2.0 "$node_(0) setdest 10.0 10.0 20.0"
$ns_ at 2.0 "$node_(6) setdest 310.0 10.0 20.0"
$ns_ at 2.0 "$node_(1) setdest 10.0 160.0 20.0"
$ns_ at 2.0 "$node_(4) setdest 160.0 160.0 20.0"
$ns_ at 2.0 "$node_(2) setdest 10.0 310.0 20.0"
$ns_ at 2.0 "$node_(5) setdest 310.0 310.0 20.0"
$ns_ at 2.0 "$node_(3) setdest 10.0 460.0 20.0"

##################################################################
#		Generating Traffic UDP and CBR			 #
##################################################################

set udp0 [new Agent/UDP]
set sink0 [new Agent/Null]
$ns_ attach-agent $node_(0) $udp0
$ns_ attach-agent $node_(5) $sink0
$ns_ connect $udp0 $sink0
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0
$ns_ at 10.0 "$cbr0 start" 
$ns_ at 98.0 "$cbr0 stop"

set udp1 [new Agent/UDP]
set sink1 [new Agent/Null]
$ns_ attach-agent $node_(1) $udp1
$ns_ attach-agent $node_(5) $sink1
$ns_ connect $udp1 $sink1
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$ns_ at 10.0 "$cbr1 start" 
$ns_ at 48.0 "$cbr1 stop"
$ns_ at 60.0 "$cbr1 start" 
$ns_ at 90.0 "$cbr1 stop"

set udp2 [new Agent/UDP]
set sink2 [new Agent/Null]
$ns_ attach-agent $node_(2) $udp2
$ns_ attach-agent $node_(6) $sink2
$ns_ connect $udp2 $sink2
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp2
$ns_ at 10.0 "$cbr2 start" 
$ns_ at 98.0 "$cbr2 stop"

set udp3 [new Agent/UDP]
set sink3 [new Agent/Null]
$ns_ attach-agent $node_(3) $udp3
$ns_ attach-agent $node_(6) $sink3
$ns_ connect $udp3 $sink3
set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp3
$ns_ at 10.0 "$cbr3 start" 
$ns_ at 98.0 "$cbr3 stop"

set udp4 [new Agent/UDP]
set sink4 [new Agent/Null]
$ns_ attach-agent $node_(4) $udp4
$ns_ attach-agent $node_(6) $sink4
$ns_ connect $udp4 $sink4
set cbr4 [new Application/Traffic/CBR]
$cbr4 attach-agent $udp4
$ns_ at 10.0 "$cbr4 start" 
$ns_ at 98.0 "$cbr4 stop"

set udp5 [new Agent/UDP]
set sink5 [new Agent/Null]
$ns_ attach-agent $node_(5) $udp5
$ns_ attach-agent $node_(6) $sink5
$ns_ connect $udp5 $sink5
set cbr5 [new Application/Traffic/CBR]
$cbr5 attach-agent $udp5
$ns_ at 10.0 "$cbr5 start" 
$ns_ at 98.0 "$cbr5 stop"

set udp6 [new Agent/UDP]
set sink6 [new Agent/Null]
$ns_ attach-agent $node_(6) $udp6
$ns_ attach-agent $node_(5) $sink6
$ns_ connect $udp6 $sink6
set cbr6 [new Application/Traffic/CBR]
$cbr6 attach-agent $udp6
$ns_ at 10.0 "$cbr6 start" 
$ns_ at 98.0 "$cbr6 stop"

#$ns_ at 100.0 "$cbr6 produce 3" 

##################################################################
#		Simulation Termination				 #
##################################################################

for {set i 0} {$i < $val(nn) } {incr i} {
    $ns_ at $val(stop) "$node_($i) reset";
}
$ns_ at $val(stop) "puts \"NS EXITING...\" ; $ns_ halt"

puts "Starting Simulation..."

$ns_ run
