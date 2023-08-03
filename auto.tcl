# Perhitungan untuk NAMD
# Load trajectory

mol new  step3_input.psf type psf
mol addfile step5_production.dcd type dcd first 0 last -1 step 1 waitfor all

# wrap a trajectory to avoid RMSD calculation errors

pbc wrap -centersel "protein" -center com -compound residue -all

## Align to first frame

# the frame being compared

set reference [atomselect top "protein and backbone" frame 0]
		
# the frame to be  compared
set compare [atomselect top "protein and backbone"]

#get the number of frames of the trajectory 

set num_steps [molinfo top get numframes]

# get the correct num as the trajectory start from zero

set outfile [open rmsd.dat w]

for {set frame 0} {$frame < $num_steps} {incr frame} {
		# get the correct frame
		$compare frame $frame
		# compute the 4*4 matrix transformation that takes one set of coordinates onto the other 
		set trans_mat [measure fit $compare $reference]
		
		# do the alignment
		$compare move $trans_mat
		# compute the RMSD
		set rmsd [measure rmsd $compare $reference ]
		# print the RMSD
   puts $outfile "$frame    $rmsd"
}
close $outfile

#RMSF Calculation 

set num [expr {$num_steps - 1}]
# RMSF calculation
set outfile [open rmsf.dat w]
set sel [atomselect top "protein and name CA"]
set rmsf [measure rmsf $sel first 0 last $num step 1]
for {set i 0} {$i < [$sel num]} {incr i} {
  puts $outfile "[expr {$i+1}] [lindex $rmsf $i]"
} 
close $outfile

# Salt bridges
file mkdir saltbridges
package require saltbr

saltbr -sel [atomselect top protein] -frames all -log saltbridges.log -outdir ./saltbridges


## H-bonds
package require hbonds
hbonds -sel1 [atomselect top protein] -writefile yes -plot no


#Options:
# -sel2 <atom selection> (default: none)
#-writefile <yes|no> (default: no)
# -upsel <yes|no> (update atom selections every frame? default: yes)
# -frames <begin:end> or <begin:step:end> or all or now (default: all)
#-dist <cutoff distance between donor and acceptor> (default: 3.0)
# -ang <angle cutoff> (default: 20)
#-plot <yes|no> (plot with MultiPlot, default: yes)
# -outdir <output directory> (default: current)
# -log <log filename> (default: none)
# -writefile <yes|no> (default: no)
# -outfile <dat filename> (default: hbonds.dat)
#-polar <yes|no> (consider only polar atoms (N, O, S, F)? default: no)
# -DA <D|A|both> (sel1 is the donor (D), acceptor (A), or donor and acceptor (both))
#Only valid when used with two selections, default: both)
#-type: (default: none)
#none--no detailed bonding information will be calculated
#all--hbonds in the same residue pair type are all counted
#pair--hbonds in the same residue pair type are counted once
#unique--hbonds are counted according to the donor-acceptor atom pair type
#-detailout <details output file> (default: stdout)
  
## SASA 
# selection
set sel [atomselect top "protein"]
set n [molinfo top get numframes]
set output [open "SASA.dat" w]
# sasa calculation loop
for {set i 0} {$i < $n} {incr i} {
	molinfo top set frame $i
	set sasa [measure sasa 1.4 $sel -restrict $sel]
	puts "\t \t progress: $i/$n"
	puts $output "$i $sasa"
}
puts "\t \t progress: $n/$n"
puts "Done."	
puts "output file: SASA.dat"
close $output  
