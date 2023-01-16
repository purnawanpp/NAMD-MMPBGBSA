# NAMD-on-Google-Colab
This script to running NAMD Molecular Dynamics in Google Colab

# Perhitungan MMGBSA

1. Complex: vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args protein,or,resname,JZ4 "step5_production.dcd" "complex" step3_input.psf step3_input.pdb
2. Protein: vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args protein "step5_production.dcd" "protein" step3_input.psf step3_input.pdb
3. Ligand: vmd -dispdev text -psf "step1_pdbreader.psf" -e stripDCD.vmd -args resname,JZ4 "step5_production.dcd" "ligand" step1_pdbreader.psf step1_pdbreader.pdb
4. MMGBSA Calculation: molaical.exe -mmgbsa -c "complex.log" -r "protein.log" -l "ligand.log"
