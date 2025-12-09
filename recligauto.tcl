# Load trajectory
mol new step3_input.psf type psf waitfor all
mol addfile step5_production.dcd type dcd first 0 last -1 step 1 waitfor all

# Wrap the trajectory to avoid RMSD calculation errors
pbc wrap -centersel "segname PROA HETA" -center com -compound residue -all

## H-bonds Calculation

# Intermolecular H-bonds between PROA and HETA, search for 'all', with detailed output
package require hbonds
hbonds -sel1 [atomselect top "segname PROA"] -sel2 [atomselect top "segname HETA"] -writefile yes -plot no -type all -detailout Intermolecular_hbonds_details.dat -outfile Intermolecular_hbonds.dat -dist 3.0 -ang 20

# Intramolecular H-bonds within PROA
hbonds -sel1 [atomselect top "segname PROA"] -writefile yes -plot no -outfile Intramolecular_hbonds_receptor.dat -dist 3.0 -ang 20

# Intramolecular H-bonds within HETA
hbonds -sel1 [atomselect top "segname HETA"] -writefile yes -plot no -outfile Intramolecular_hbonds_ligand.dat -dist 3.0 -ang 20

# Options:
# -sel2 <atom selection> (default: none)
# -writefile <yes|no> (default: no)
# -upsel <yes|no> (update atom selections every frame? default: yes)
# -frames <begin:end> or <begin:step:end> or all or now (default: all)
# -dist <cutoff distance between donor and acceptor> (default: 3.0)
# -ang <angle cutoff> (default: 20)
# -plot <yes|no> (plot with MultiPlot, default: yes)
# -outdir <output directory> (default: current)
# -log <log filename> (default: none)
# -writefile <yes|no> (default: no)
# -outfile <dat filename> (default: hbonds.dat)
# -polar <yes|no> (consider only polar atoms (N, O, S, F)? default: no)
# -DA <D|A|both> (sel1 is the donor (D), acceptor (A), or donor and acceptor (both))
# -type: (default: none)
# none--no detailed bonding information will be calculated
# all--hbonds in the same residue pair type are all counted
# pair--hbonds in the same residue pair type are counted once
# unique--hbonds are counted according to the donor-acceptor atom pair type

## RMSD Calculation

# RMSD for PROA and HETA combined
set reference_receptor_ligand [atomselect top "segname PROA HETA and backbone" frame 0]
set compare_receptor_ligand [atomselect top "segname PROA HETA and backbone"]

# RMSD for PROA only
set reference_receptor [atomselect top "segname PROA and backbone" frame 0]
set compare_receptor [atomselect top "segname PROA and backbone"]

# Get the number of frames of the trajectory
set num_steps [molinfo top get numframes]

# Output files for RMSD
set rmsd_outfile_receptor_ligand [open RMSD_receptor-ligand.dat w]
set rmsd_outfile_receptor [open RMSD_receptor.dat w]

for {set frame 0} {$frame < $num_steps} {incr frame} {
    # RMSD for PROA and HETA combined
    $compare_receptor_ligand frame $frame
    set trans_mat_rl [measure fit $compare_receptor_ligand $reference_receptor_ligand]
    $compare_receptor_ligand move $trans_mat_rl
    set rmsd_rl [measure rmsd $compare_receptor_ligand $reference_receptor_ligand]
    puts $rmsd_outfile_receptor_ligand "$frame    $rmsd_rl"

    # RMSD for PROA only
    $compare_receptor frame $frame
    set trans_mat_r [measure fit $compare_receptor $reference_receptor]
    $compare_receptor move $trans_mat_r
    set rmsd_r [measure rmsd $compare_receptor $reference_receptor]
    puts $rmsd_outfile_receptor "$frame    $rmsd_r"
}
close $rmsd_outfile_receptor_ligand
close $rmsd_outfile_receptor

## RMSF Calculation

# RMSF for PROA and HETA combined
set rmsf_outfile_receptor_ligand [open RMSF_receptor-ligand.dat w]
set sel_receptor_ligand [atomselect top "segname PROA HETA and name CA"]

# RMSF for PROA only
set rmsf_outfile_receptor [open RMSF_receptor.dat w]
set sel_receptor [atomselect top "segname PROA and name CA"]

# RMSF calculation for both PROA and HETA
set num [expr {$num_steps - 1}]
set rmsf_receptor_ligand [measure rmsf $sel_receptor_ligand first 0 last $num step 1]
set rmsf_receptor [measure rmsf $sel_receptor first 0 last $num step 1]

for {set i 0} {$i < [$sel_receptor_ligand num]} {incr i} {
    puts $rmsf_outfile_receptor_ligand "[expr {$i+1}] [lindex $rmsf_receptor_ligand $i]"
}
for {set i 0} {$i < [$sel_receptor num]} {incr i} {
    puts $rmsf_outfile_receptor "[expr {$i+1}] [lindex $rmsf_receptor $i]"
}
close $rmsf_outfile_receptor_ligand
close $rmsf_outfile_receptor

## SASA Calculation
# Selection
set sasa_sel_receptor_ligand [atomselect top "segname PROA HETA"]
set sasa_sel_receptor [atomselect top "segname PROA"]
set sasa_sel_ligand [atomselect top "segname HETA"]

# Get the number of frames
set sasa_n [molinfo top get numframes]

# Output files for SASA
set sasa_outfile_receptor_ligand [open SASA_receptor-ligand.dat w]
set sasa_outfile_receptor [open SASA_receptor.dat w]
set sasa_outfile_ligand [open SASA_ligand.dat w]
set sasa_outfile_delta [open SASA_delta.dat w]

# Check if SASA selection is empty
if { [$sasa_sel_receptor_ligand num] == 0 || [$sasa_sel_receptor num] == 0 || [$sasa_sel_ligand num] == 0 } {
    puts "Error: No atoms selected for SASA calculation. Check your segment names and atom selections."
    exit
}

for {set i 0} {$i < $sasa_n} {incr i} {
    molinfo top set frame $i
    
    # SASA for PROA and HETA combined (the complex)
    set sasa_receptor_ligand [measure sasa 1.4 $sasa_sel_receptor_ligand -restrict $sasa_sel_receptor_ligand]
    puts $sasa_outfile_receptor_ligand "$i $sasa_receptor_ligand"
    
    # SASA for PROA only
    set sasa_receptor [measure sasa 1.4 $sasa_sel_receptor -restrict $sasa_sel_receptor]
    puts $sasa_outfile_receptor "$i $sasa_receptor"
    
    # SASA for HETA only
    set sasa_ligand [measure sasa 1.4 $sasa_sel_ligand -restrict $sasa_sel_ligand]
    puts $sasa_outfile_ligand "$i $sasa_ligand"
    
    # Calculate ΔSASA (change in SASA) with updated formula
    set sasa_delta [expr {$sasa_receptor_ligand - ($sasa_receptor + $sasa_ligand)}]
    puts $sasa_outfile_delta "$i $sasa_delta"
    
    puts "\\t \\t progress: $i/$sasa_n"
}
puts "\\t \\t progress: $sasa_n/$sasa_n"
puts "Done."
puts "output files: SASA_receptor-ligand.dat, SASA_receptor.dat, SASA_ligand.dat, SASA_delta.dat"
close $sasa_outfile_receptor_ligand
close $sasa_outfile_receptor
close $sasa_outfile_ligand
close $sasa_outfile_delta

## Salt Bridges between PROA and HETA
file mkdir saltbridges
package require saltbr
saltbr -sel1 [atomselect top "segname PROA"] -sel2 [atomselect top "segname HETA"] -frames all -log saltbridges.log -outdir ./saltbridges

# Convert the log data to saltbridge.dat file
set saltbridges_outfile [open saltbridge.dat w]
set logdata [open "saltbridges/saltbridges.log" r]
while { [gets $logdata line] >= 0 } {
    puts $saltbridges_outfile $line
}
close $logdata
close $saltbridges_outfile


