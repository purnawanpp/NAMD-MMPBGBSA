proc contactFreq { {sel1} {sel2} {percent 0} {outFile stdout} {mol top} } {
  if { $outFile != "stdout" } { 
     set outFile [open $outFile w]
  } 
  puts $outFile "[clock format [clock scan now]] Search started."

  set allAtoms {}
  set allCount {}
  set numberOfFrames [molinfo $mol get numframes]
  for { set i 0 } { $i < $numberOfFrames } { incr i } {
      molinfo $mol set frame $i

      set frameCount {}
      set frameAtoms [atomselect $mol "$sel1 and noh and within 4 of ($sel2 and noh)"]
      foreach {segid} [$frameAtoms get segid] {resname} [$frameAtoms get resname] {resid} [$frameAtoms get resid] {name} [$frameAtoms get name] {
	  set atom [list $resid $resname $segid]
	  if {[lsearch $frameCount $atom] != -1} continue
	  lappend frameCount $atom
	  set loc [lsearch $allAtoms $atom]
          if { $loc == -1 } {
             lappend allAtoms $atom
             lappend allCount 1
          } else {
             lset allCount $loc [expr { [lindex $allCount $loc] + 1 } ]
          }
     }
     $frameAtoms delete
  }

  puts $outFile "[clock format [clock scan now]] Search finished."

  puts $outFile "Find interactions:"
  puts $outFile "Residue \t\tfraction" 
  #print count after sorting
  set outData {}
  foreach { a } $allAtoms { c } $allCount {
      lappend outData [concat $c $a]
  }
  foreach { data } [lsort -integer -index 1 $outData] {
      set c [lindex $data 0]
      set fraction [expr { 100*$c/($numberOfFrames+0.0) }]
      if { $fraction >= $percent } {
	 puts $outFile [format "%s-%s-%s \t\t %.2f%%" [lindex $data 3] [lindex $data 2] [lindex $data 1] $fraction]
      }
      #set beta according to the fraction, this is optional
      set atom [atomselect $mol "segid [lindex $data 3] and resname [lindex $data 2] and resid [lindex $data 1]"]
      $atom set beta $fraction
      $atom delete
  }

  if { $outFile != "stdout" } {
      close $outFile
  }

}

