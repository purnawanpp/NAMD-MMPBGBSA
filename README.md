# Free Energy Calculation using NAMD #
This script to running NAMD Molecular Dynamics in Google Colab, and free energy calculation using MMPBSA and MMGBSA.
This tutorial using preperation input file using CHARMM-GUI, with PDB ID: 3HTB. Protein and Ligand using CHARMM36M Force Field and water model was TIP3P

# MMGBSA Calculation using MolAICal https://molaical.github.io/
Installation MolAICal
1. Download linux version: https://drive.google.com/file/d/1k_UESTx8FZHYmmuXIFra7_dyvq9e4j3d/view?usp=share_link
2. Extract file 
3. Run with this command: chmod +x install.sh
4. Run this command: ./install.sh
5. If error replace this molaical.exe file in installation folder https://github.com/purnawanpp/NAMD-on-Google-Colab/blob/main/molaical.exe

Seperation complex, protein, ligand
1. vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args protein,or,resname,JZ4 "step5_production.dcd" "complex" step3_input.psf step3_input.pdb
2. vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args protein "step5_production.dcd" "protein" step3_input.psf step3_input.pdb
3. vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args resname,JZ4 "step5_production.dcd" "ligand" step3_input.psf step3_input.pdb

Running NAMD3 to get file complex.log, protein.log and ligand.log and calculation mmgbsa using MolAICal
1. namd3 complex.conf > complex.log
2. namd3 protein.conf > protein.log
3. namd3 ligand.conf > ligand.log
4. molaical.exe -mmgbsa -c "complex.log" -r "protein.log" -l "ligand.log"

Running MolAICal in google colab
1. Please open this file and running in your google colab: https://github.com/purnawanpp/NAMD-on-Google-Colab/blob/main/MMGBSA_NAMD.ipynb


# MMPBSA using CAFE https://github.com/HuiLiuCode
Preparation complex and ligand
1. Complex using come from step3_input.psf file and step5_production.dcd
2. Preparation ligand and water model using this command: *vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args water,or,resname,JZ4 "step5_production.dcd" "ligand" step3_input.psf step3_input.pdb*

Calculation free energy using MMPBSA
1. *vmd -dispdev text -eofexit < mmpbsa.vmd > vmd_mmpbsa.log*

Calculation free energy using Linear Interaction Energy (LIE)
1. *vmd -dispdev text -eofexit < lie.vmd > vmd_lie.log*
