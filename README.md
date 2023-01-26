# Free Energy Calculation using NAMD
This script to running NAMD Molecular Dynamics in Google Colab, and free energy calculation using MMPBSA and MMGBSA

# Installation MolAICal
1. Download linux version: https://drive.google.com/file/d/1k_UESTx8FZHYmmuXIFra7_dyvq9e4j3d/view?usp=share_link
2. Extract file 
3. Run with this command: chmod +x install.sh
4. Run this command: ./install.sh
5. If error replace this molaical.exe file in installation folder https://github.com/purnawanpp/NAMD-on-Google-Colab/blob/main/molaical.exe

# MMGBSA Calculation in NAMD3 https://github.com/purnawanpp/NAMD-on-Google-Colab/blob/main/MMGBSA_NAMD.ipynb

1. vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args protein,or,resname,JZ4 "step5_production.dcd" "complex" step3_input.psf step3_input.pdb
2. vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args protein "step5_production.dcd" "protein" step3_input.psf step3_input.pdb
3. vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args resname,JZ4 "step5_production.dcd" "ligand" step3_input.psf step3_input.pdb
4. molaical.exe -mmgbsa -c "complex.log" -r "protein.log" -l "ligand.log"


# MMPBSA using CAFE https://github.com/HuiLiuCode
#Pisahkan dengan perintah complex dan ligand dengan perintah.
1. Tetap menggunakan air, solvasi dan garam dll sesuai tutorial
2. Untuk memisahkan ligand dengan solvasinya jalankan perintah berikut: *vmd -dispdev text -psf "step3_input.psf" -e stripDCD.vmd -args water,or,resname,JZ4 "step5_production.dcd" "ligand" step3_input.psf step3_input.pdb*

# Perhitungan MMPBSA
1. *vmd -dispdev text -eofexit < mmpbsa.vmd > vmd_mmpbsa.log*

# Perhitungan LIE
1. *vmd -dispdev text -eofexit < lie.vmd > vmd_lie.log*
