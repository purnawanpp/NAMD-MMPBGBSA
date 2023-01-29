# Free Energy Calculation With NAMD #
This script to running NAMD Molecular Dynamics in Google Colab, and free energy calculation using MMPBSA and MMGBSA.
This tutorial using preperation input file using CHARMM-GUI, with PDB ID: 3HTB. Protein and Ligand using CHARMM36M Force Field and water model was TIP3P and 1 ns simulation

# MMGBSA Calculation using MolAICal https://molaical.github.io/
Installation MolAICal
1. Download linux version: https://drive.google.com/file/d/1k_UESTx8FZHYmmuXIFra7_dyvq9e4j3d/view?usp=share_link or https://molaical.github.io/
2. Extract file 
3. Run with this command: *chmod +x install.sh*
4. Run this command: *./install.sh*
5. Make a path for running molaical.exe
6. If error replace this molaical.exe file in installation folder https://github.com/purnawanpp/NAMD-on-Google-Colab/blob/main/molaical.exe
7. Tutorial installation https://molaical.github.io/install.html

Separation complex, protein, ligand
1. *vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args protein,or,resname,JZ4 "step5_production.dcd" "complex" step3_input.psf step3_input.pdb*
2. *vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args protein "step5_production.dcd" "protein" step3_input.psf step3_input.pdb*
3. *vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args resname,JZ4 "step5_production.dcd" "ligand" step3_input.psf step3_input.pdb*

Running NAMD3 to get file complex.log, protein.log and ligand.log and calculation mmgbsa using MolAICal
1. *namd3 complex.conf > complex.log*
2. *namd3 protein.conf > protein.log*
3. *namd3 ligand.conf > ligand.log*
4. *molaical.exe -mmgbsa -c "complex.log" -r "protein.log" -l "ligand.log"*

Optional-Running MolAICal in google colab
1. Please open this file and running in your google colab [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/purnawanpp/NAMD-on-Google-Colab/blob/main/MMGBSA_NAMD.ipynb#scrollTo=osCb8g67qpVT)


# MMPBSA and Linear Interaction Energy (LIE) Calculation using CAFE https://github.com/HuiLiuCode
Software installation
1. NAMD 2.14 multicore non CUDA https://www.ks.uiuc.edu/Research/namd/2.14/download/946183/NAMD_2.14_Linux-x86_64-multicore.tar.gz
2. apbs linux version https://github.com/Electrostatics/apbs/releases/download/v3.4.1/APBS-3.4.1.Linux.zip
3. Installation CAFE please read this tutorial https://github.com/purnawanpp/NAMD-MMPBGBSA/blob/main/manual_CAFE.pdf
4. Dont forget to make a path NAMD 2.14 and apbs

Preparation complex and ligand
1. Complex using come from step3_input.psf file and step5_production.dcd
2. Preparation ligand and water model using this command: *vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args water,or,resname,JZ4 "step5_production.dcd" "ligand" step3_input.psf step3_input.pdb*

Calculation free energy using MMPBSA
1. *vmd -dispdev text -eofexit < mmpbsa.vmd > vmd_mmpbsa.log*

Calculation free energy using Linear Interaction Energy (LIE)
1. *vmd -dispdev text -eofexit < lie.vmd > vmd_lie.log*
