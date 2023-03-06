# Free Energy Calculation With NAMD #
This script to running NAMD Molecular Dynamics in Google Colab, and free energy calculation using Linear Interaction Energy (LIE), Molecular Mechanics Poisson-Boltzmann Surface Area (MMPBSA) and Molecular Mechanics Generalized Born Surface Area (MMGBSA).
This tutorial uses a preparation input file using CHARMM-GUI https://www.charmm-gui.org/, with PDB ID: 3HTB. Protein and Ligand using CHARMM36M Force Field and water model was TIP3P and one ns simulation. We simulated the protein and ligand using the CUDA-integrated version of NAMD3 https://www.ks.uiuc.edu/Research/namd/alpha/3.0alpha/download/NAMD_3.0alpha13_Linux-x86_64-multicore-CUDA-SingleNode.tar.gz

# Video Tutorial
1. MMGBSA Calculation using MolAICal https://youtu.be/7BbPMqIe3io
2. MMPBSA and Linear Interaction Energy (LIE) Calculation using CaFE https://youtu.be/IANeNzOiKuM

# MMGBSA Calculation using MolAICal https://molaical.github.io/
Installation MolAICal
1. Download the Linux version: https://drive.google.com/file/d/1k_UESTx8FZHYmmuXIFra7_dyvq9e4j3d/view?usp=share_link or https://molaical.github.io/
2. Extract the file 
3. Run with this command: ```chmod +x install.sh```
4. Run this command: ```./install.sh```
5. Make a path for running molaical.exe
6. If there is an error, replace this molaical.exe file in the installation folder https://github.com/purnawanpp/NAMD-on-Google-Colab/blob/main/molaical.exe
7. Tutorial installation https://molaical.github.io/install.html

Separation complex, protein, ligand
1. ```vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args protein,or,resname,JZ4 "step5_production.dcd" "complex" step3_input.psf step3_input.pdb```
2. ```vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args protein "step5_production.dcd" "protein" step3_input.psf step3_input.pdb```
3. ```vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args resname,JZ4 "step5_production.dcd" "ligand" step3_input.psf step3_input.pdb```

Running NAMD3 to get file complex.log, protein.log and ligand.log and calculation mmgbsa using MolAICal
1. ```namd3 complex.conf > complex.log```
2. ```namd3 protein.conf > protein.log```
3. ```namd3 ligand.conf > ligand.log```
4. ```molaical.exe -mmgbsa -c "complex.log" -r "protein.log" -l "ligand.log"```

Optional-Running MolAICal in google colab
1. Please open this file and running in your google colab [![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/github/purnawanpp/NAMD-on-Google-Colab/blob/main/MMGBSA_NAMD.ipynb#scrollTo=osCb8g67qpVT)


# MMPBSA and Linear Interaction Energy (LIE) Calculation using CaFE https://github.com/HuiLiuCode/CaFE_Plugin
Required software:
1. NAMD 2.14 multicore non CUDA https://www.ks.uiuc.edu/Research/namd/2.14/download/946183/NAMD_2.14_Linux-x86_64-multicore.tar.gz
2. Adaptive Poisson-Boltzmann Solver (apbs) Linux version https://github.com/Electrostatics/apbs/releases/download/v3.4.1/APBS-3.4.1.Linux.zip
3. Installation CAFE please read this tutorial https://github.com/purnawanpp/NAMD-MMPBGBSA/blob/main/manual_CAFE.pdf
4. Don't forget to make a path NAMD 2.14 and apbs

Preparation complex and ligand
1. Complex use comes from step3_input.psf file and step5_production.dcd
2. Preparation ligand and water model using this command: ```vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args water,or,resname,JZ4 "step5_production.dcd" "ligand" step3_input.psf step3_input.pdb```

Calculation-free energy using MMPBSA
1. ```vmd -dispdev text -eofexit < mmpbsa.vmd > vmd_mmpbsa.log```

Calculation free energy using Linear Interaction Energy (LIE)
1. ```vmd -dispdev text -eofexit < lie.vmd > vmd_lie.log```

# Binding Free-Energy Estimator 2 (BFEE2) https://github.com/fhh2626/BFEE2
1. Read this tutorial: https://github.com/purnawanpp/NAMD-MMPBGBSA/blob/main/BFEE2.pdf
2. Read this article: https://github.com/purnawanpp/NAMD-MMPBGBSA/blob/main/BFEE2_NAMD.pdf
