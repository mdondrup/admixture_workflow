### Make the required directory structure and index the input data

rule setup:  
    input: 
        admixtools= "misc/.admixtools_installed",
        admixbayes="tools/AdmixtureBayes",
        sweed="tools/sweed"
    output:
        setup="misc/.setup_complete",   
    shell:
        """
        mkdir -p misc tools logs
        mkdir -p results/TreeMix/bootstrap results/TreeMix/plots \
              results/admixtools/plots results/admixbayes/plots      
        touch {output.setup}       
        """

rule install_admixtools2:
    conda: "../envs/admixtools.yaml"
    output: "misc/.admixtools_installed"
    message: "Installing dependency Admixtools2"        
    shell:        
        r"""

pushd .
TMP=$(mktemp -d)
cd $TMP
git clone https://github.com/uqrmaie1/admixtools.git
R CMD INSTALL admixtools/                
popd
touch {output}        
rm -r $TMP
        
        """



rule install_admixturebayes:
    conda: "../envs/admixturebayes.yaml"
    output: directory('tools/AdmixtureBayes')
    params: revision="7b1433f"
    message: "Installing dependency AdmixtureBayes"        
        
    shell:
        """
        cd tools
        git clone https://github.com/avaughn271/AdmixtureBayes
        cd AdmixtureBayes/
        git checkout {params.revision}
        pip install graphviz
        
        """


rule install_sweed:
    conda: "../envs/bedtools.yaml"
    output: directory("tools/sweed")
    params: revision="5f7e176"
    message: "Installing and building SweeD"
             
    shell:
        r"""
        cd tools
        git clone https://github.com/alachins/sweed
        cd sweed
        git checkout {params.revision}
        make -f Makefile.PTHREADS.gcc
        #make -f Makefile.gcc # fallback
        
        """    
